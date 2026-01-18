"""
LEGION (https://shanewilliamscott.com)
Copyright (c) 2024 Shane Scott

    This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
    License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later
    version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
    warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
    details.

    You should have received a copy of the GNU General Public License along with this program.
    If not, see <http://www.gnu.org/licenses/>.

Author(s): Shane Scott (sscott@shanewilliamscott.com), Dmitriy Dubson (d.dubson@gmail.com)
"""
import sys
from time import time

from PyQt6 import QtCore

from app.actions.updateProgress import AbstractUpdateProgressObservable
from app.logging.legionLog import getAppLogger
from db.entities.host import hostObj
from db.entities.l1script import l1ScriptObj
from db.entities.nmapSession import nmapSessionObj
from db.entities.note import note
from db.entities.os import osObj
from db.entities.port import portObj
from db.entities.service import serviceObj
from db.repositories.HostRepository import HostRepository
from parsers.Parser import parseNmapReport, MalformedXmlDocumentException

appLog = getAppLogger()

class NmapImporter(QtCore.QThread):
    tick = QtCore.pyqtSignal(int, name="changed")
    done = QtCore.pyqtSignal(name="done")
    schedule = QtCore.pyqtSignal(object, bool, name="schedule")
    log = QtCore.pyqtSignal(str, name="log")

    def __init__(self, updateProgressObservable: AbstractUpdateProgressObservable, hostRepository: HostRepository):
        QtCore.QThread.__init__(self, parent=None)
        self.output = ''
        self.updateProgressObservable = updateProgressObservable
        self.hostRepository = hostRepository

    def tsLog(self, msg):
        self.log.emit(str(msg))

    def setDB(self, db):
        self.db = db

    def setHostRepository(self, hostRepository: HostRepository):
        self.hostRepository = hostRepository

    def setFilename(self, filename):
        self.filename = filename

    def setOutput(self, output):
        self.output = output

    def run(self):
        try:
            self.updateProgressObservable.start()
            session = self.db.session()
            self.tsLog("Parsing nmap xml file: " + self.filename)
            startTime = time()

            try:
                nmapReport = parseNmapReport(self.filename)
            except MalformedXmlDocumentException as e:
                self.tsLog('Giving up on import due to previous errors.')
                appLog.error(f"NMAP xml report is likely malformed: {e}")
                self.updateProgressObservable.finished()
                self.done.emit()
                return

            self.tsLog('nmap xml report read successfully!')
            self.db.dbsemaphore.acquire()
            s = nmapReport.getSession()
            if s:
                n = nmapSessionObj(self.filename, s.startTime, s.finish_time, s.nmapVersion, s.scanArgs, s.totalHosts,
                                   s.upHosts, s.downHosts)
                session.add(n)
                session.commit()

            allHosts = nmapReport.getAllHosts()
            hostCount = len(allHosts)
            if hostCount == 0:
                hostCount = 1

            createProgress = 0
            createOsNodesProgress = 0
            createPortsProgress = 0
            createDbScriptsProgress = 0
            updateObjectsRunScriptsProgress = 0

            self.updateProgressObservable.updateProgress(int(createProgress), 'Adding hosts...')

            for h in allHosts:
                db_host = self.hostRepository.getHostInformation(h.ip)
                if not db_host:
                    hid = hostObj(osMatch='', osAccuracy='', ip=h.ip, ipv4=h.ipv4, ipv6=h.ipv6, macaddr=h.macaddr,
                                  status=h.status, hostname=h.hostname, vendor=h.vendor, uptime=h.uptime,
                                  lastboot=h.lastboot, distance=h.distance, state=h.state, count=h.count)
                    self.tsLog("Adding db_host")
                    session.add(hid)
                    session.commit()
                    t_note = note(h.ip, 'Added by nmap')
                    session.add(t_note)
                    session.commit()
                else:
                    self.tsLog("Found db_host already in db")

                createProgress += (100.0 / hostCount)
                self.updateProgressObservable.updateProgress(int(createProgress), 'Adding hosts...')

            self.updateProgressObservable.updateProgress(int(createOsNodesProgress), 'Creating Service, Port and OS children...')

            for h in allHosts:
                self.tsLog("Processing h {ip}".format(ip=h.ip))
                db_host = self.hostRepository.getHostInformation(h.ip)
                if not db_host:
                    self.tsLog("Did not find db_host during os/ports/service processing")
                    self.tsLog("A host that should have been found was not. Save your session and report a bug.")
                    self.tsLog("Include your nmap file, sanitized if needed.")
                    continue
                else:
                    self.tsLog("Found db_host during os/ports/service processing")
                os_nodes = h.getOs()
                self.tsLog("    'os_nodes' to process: {os_nodes}".format(os_nodes=str(len(os_nodes))))
                for os in os_nodes:
                    self.tsLog("    Processing os obj {os}".format(os=str(os.name)))
                    db_os = session.query(osObj).filter_by(hostId=db_host.id).filter_by(name=os.name).filter_by(
                        family=os.family).filter_by(generation=os.generation).filter_by(osType=os.osType).filter_by(
                        vendor=os.vendor).first()
                    if not db_os:
                        t_osObj = osObj(os.name, os.family, os.generation, os.osType, os.vendor, os.accuracy,
                                        db_host.id)
                        session.add(t_osObj)
                        session.commit()

                createOsNodesProgress += (100.0 / hostCount)
                self.updateProgressObservable.updateProgress(int(createOsNodesProgress), 'Creating Service, Port and OS children...')

                self.updateProgressObservable.updateProgress(int(createPortsProgress), 'Processing ports...')

                all_ports = h.all_ports()
                self.tsLog("    'ports' to process: {all_ports}".format(all_ports=str(len(all_ports))))
                for p in all_ports:
                    self.tsLog("        Processing port obj {port}".format(port=str(p.portId)))
                    s = p.getService()
                    if s is not None:
                        self.tsLog("            Processing service result *********** name={0} prod={1} ver={2} extra={3} fing={4}"
                                   .format(s.name, s.product, s.version, s.extrainfo, s.fingerprint))
                        db_service = session.query(serviceObj).filter_by(hostId=db_host.id)\
                            .filter_by(name=s.name).filter_by(product=s.product).filter_by(version=s.version)\
                            .filter_by(extrainfo=s.extrainfo).filter_by(fingerprint=s.fingerprint).first()
                        if not db_service:
                            self.tsLog("            Did not find service *********** name={0} prod={1} ver={2} extra={3} fing={4}"
                                       .format(s.name, s.product, s.version, s.extrainfo, s.fingerprint))
                            db_service = serviceObj(s.name, db_host.id, s.product, s.version, s.extrainfo,
                                                    s.fingerprint)
                            session.add(db_service)
                            session.commit()
                    else:
                        db_service = None
                    db_port = session.query(portObj).filter_by(hostId=db_host.id).filter_by(portId=p.portId)\
                        .filter_by(protocol=p.protocol).first()
                    if not db_port:
                        self.tsLog("            Did not find port *********** portid={0} proto={1}".format(p.portId, p.protocol))
                        if db_service:
                            db_port = portObj(p.portId, p.protocol, p.state, db_host.id, db_service.id)
                        else:
                            db_port = portObj(p.portId, p.protocol, p.state, db_host.id, '')
                        session.add(db_port)
                        session.commit()
                createPortsProgress += (100.0 / hostCount)
                self.updateProgressObservable.updateProgress(createPortsProgress, 'Processing ports...')

            self.updateProgressObservable.updateProgress(createDbScriptsProgress, 'Creating script objects...')

            for h in allHosts:
                db_host = self.hostRepository.getHostInformation(h.ip)
                for p in h.all_ports():
                    for scr in p.getScripts():
                        self.tsLog("        Processing script obj {scr}".format(scr=str(scr)))
                        db_port = session.query(portObj).filter_by(hostId=db_host.id)\
                            .filter_by(portId=p.portId).filter_by(protocol=p.protocol).first()
                        db_script = session.query(l1ScriptObj).filter_by(scriptId=scr.scriptId)\
                            .filter_by(portId=db_port.id).first()
                        if db_script is not None:
                            if scr.output not in ('', None):
                                db_script.output = scr.output
                            session.add(db_script)
                            session.commit()
                        else:
                            t_l1ScriptObj = l1ScriptObj(scr.scriptId, scr.output, db_port.id, db_host.id)
                            session.add(t_l1ScriptObj)
                            session.commit()
                for hs in h.getHostScripts():
                    db_script = session.query(l1ScriptObj).filter_by(scriptId=hs.scriptId)\
                        .filter_by(hostId=db_host.id).first()
                    if not db_script:
                        t_l1ScriptObj = l1ScriptObj(hs.scriptId, hs.output, None, db_host.id)
                        session.add(t_l1ScriptObj)
                        session.commit()
                createDbScriptsProgress += (100.0 / hostCount)
                self.updateProgressObservable.updateProgress(createDbScriptsProgress, 'Creating script objects...')

            self.updateProgressObservable.updateProgress(updateObjectsRunScriptsProgress, 'Update objects and run scripts...')

            for h in allHosts:
                db_host = self.hostRepository.getHostInformation(h.ip)
                if not db_host:
                    self.tsLog("            A host that should have been found was not. Something is wrong. Save your session and report a bug.")
                    self.tsLog("            Include your nmap file, sanitized if needed.")

                if db_host.ipv4 == '' and h.ipv4 != '':
                    db_host.ipv4 = h.ipv4
                if db_host.ipv6 == '' and h.ipv6 != '':
                    db_host.ipv6 = h.ipv6
                if db_host.macaddr == '' and h.macaddr != '':
                    db_host.macaddr = h.macaddr
                if h.status != '':
                    db_host.status = h.status
                if db_host.hostname == '' and h.hostname != '':
                    db_host.hostname = h.hostname
                if db_host.vendor == '' and h.vendor != '':
                    db_host.vendor = h.vendor
                if db_host.uptime == '' and h.uptime != '':
                    db_host.uptime = h.uptime
                if db_host.lastboot == '' and h.lastboot != '':
                    db_host.lastboot = h.lastboot
                if db_host.distance == '' and h.distance != '':
                    db_host.distance = h.distance
                if db_host.state == '' and h.state != '':
                    db_host.state = h.state
                if db_host.count == '' and h.count != '':
                    db_host.count = h.count
                session.add(db_host)
                session.commit()

                tmp_name = ''
                tmp_accuracy = '0'
                os_nodes = h.getOs()
                for os in os_nodes:
                    db_os = session.query(osObj).filter_by(hostId=db_host.id).filter_by(name=os.name)\
                        .filter_by(family=os.family).filter_by(generation=os.generation)\
                        .filter_by(osType=os.osType).filter_by(vendor=os.vendor).first()
                    db_os.osAccuracy = os.accuracy
                    if os.name != '':
                        if os.accuracy > tmp_accuracy:
                            tmp_name = os.name
                            tmp_accuracy = os.accuracy
                if os_nodes:
                    if tmp_name != '' and tmp_accuracy != '0':
                        db_host.osMatch = tmp_name
                        db_host.osAccuracy = tmp_accuracy
                session.add(db_host)
                session.commit()

                for scr in h.getHostScripts():
                    self.tsLog("-----------------------Host SCR: {0}".format(scr.scriptId))
                    db_host = self.hostRepository.getHostInformation(h.ip)
                    scrProcessorResults = scr.scriptSelector(db_host)
                    for scrProcessorResult in scrProcessorResults:
                        session.add(scrProcessorResult)
                        session.commit()

                for scr in h.getScripts():
                    self.tsLog("-----------------------SCR: {0}".format(scr.scriptId))
                    db_host = self.hostRepository.getHostInformation(h.ip)
                    scrProcessorResults = scr.scriptSelector(db_host)
                    for scrProcessorResult in scrProcessorResults:
                        session.add(scrProcessorResult)
                        session.commit()

                for p in h.all_ports():
                    s = p.getService()
                    if s is not None:
                        db_service = session.query(serviceObj).filter_by(hostId=db_host.id)\
                            .filter_by(name=s.name).filter_by(product=s.product)\
                            .filter_by(version=s.version).filter_by(extrainfo=s.extrainfo)\
                            .filter_by(fingerprint=s.fingerprint).first()
                    else:
                        db_service = None
                    db_port = session.query(portObj).filter_by(hostId=db_host.id).filter_by(portId=p.portId)\
                        .filter_by(protocol=p.protocol).first()
                    if db_port:
                        if db_port.state != p.state:
                            db_port.state = p.state
                            session.add(db_port)
                            session.commit()
                        if db_service is not None and db_port.serviceId != db_service.id:
                            db_port.serviceId = db_service.id
                            session.add(db_port)
                            session.commit()
                    for scr in p.getScripts():
                        db_script = session.query(l1ScriptObj).filter_by(scriptId=scr.scriptId)\
                            .filter_by(portId=db_port.id).first()
                        if db_script is not None:
                            if scr.output not in ('', None):
                                db_script.output = scr.output
                            session.add(db_script)
                            session.commit()
                        else:
                            t_l1ScriptObj = l1ScriptObj(scr.scriptId, scr.output, db_port.id, db_host.id)
                            session.add(t_l1ScriptObj)
                            session.commit()

                updateObjectsRunScriptsProgress += (100.0 / hostCount)
                self.updateProgressObservable.updateProgress(updateObjectsRunScriptsProgress, 'Update objects and run scripts...')

            self.updateProgressObservable.updateProgress(100, 'Almost done...')
            session.commit()
            self.db.dbsemaphore.release()
            self.tsLog(f"Finished in {str(time() - startTime)} seconds.")
            self.updateProgressObservable.finished()
            self.done.emit()
            self.schedule.emit(nmapReport, self.output == '')

        except Exception as e:
            self.tsLog('Something went wrong when parsing the nmap file..')
            self.tsLog("Unexpected error: {0}".format(sys.exc_info()[0]))
            self.tsLog(e)
            self.updateProgressObservable.finished()
            self.done.emit()
            raise
