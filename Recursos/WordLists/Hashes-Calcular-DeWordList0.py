#!/usr/bin/env python3

# 
# Ejecución remota:
#   python3 <(curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/WordLists/Hashes-Calcular-DeWordList0.py) -- rockyou.txt

import argparse
import hashlib
import importlib.util
import os
import struct
import sys
from pathlib import Path


def fTieneModulo(vNombre: str) -> bool:
  return importlib.util.find_spec(vNombre) is not None


def fImprimirFaltantes(aFaltantes: list[dict]) -> None:
  print("Faltan dependencias para ejecutar el script:", file=sys.stderr)
  for vF in aFaltantes:
    vLinea = f"  - {vF['modulo']}"
    if vF.get("debian"):
      vLinea += f" | Debian: apt install {vF['debian']}"
    if vF.get("pip"):
      vLinea += f" | pip: python3 -m pip install {vF['pip']} --break-system-packages"
    print(vLinea, file=sys.stderr)


def fComprobarDependencias(vNecesitaChecklist: bool, vQuiereGPU: bool) -> int:
  aFaltantes = []

  # Checklist (curses)
  if vNecesitaChecklist:
    if not sys.stdin.isatty() or not sys.stdout.isatty():
      print("Error: el checklist interactivo requiere un TTY.", file=sys.stderr)
      print("Solución: usa --algos md5,sha1,... o ejecuta desde una terminal real.", file=sys.stderr)
      return 3
    if not fTieneModulo("curses"):
      aFaltantes.append({
        "modulo": "curses",
        "debian": "python3-curses",
        "pip": None
      })

  # GPU (opcional, solo si el usuario la pide)
  if vQuiereGPU:
    if not fTieneModulo("numpy"):
      aFaltantes.append({
        "modulo": "numpy",
        "debian": "python3-numpy",
        "pip": "numpy"
      })

    # Para CUDA (NVIDIA) intentaremos cupy si está. Para OpenCL intentaremos pyopencl.
    # No obligamos a ambos, pero sí a tener al menos uno.
    vTieneCuPy = fTieneModulo("cupy")
    vTieneOpenCL = fTieneModulo("pyopencl")

    if (not vTieneCuPy) and (not vTieneOpenCL):
      aFaltantes.append({
        "modulo": "cupy o pyopencl",
        "debian": None,
        "pip": "cupy-cuda12x (NVIDIA)  /  pyopencl (OpenCL)"
      })

  if len(aFaltantes) > 0:
    fImprimirFaltantes(aFaltantes)
    return 2

  return 0


def fMD4(vDatos: bytes) -> bytes:
  # Implementación MD4 (RFC 1320) en puro Python (sin dependencias externas).
  def fRotl(vX, vN):
    return ((vX << vN) | (vX >> (32 - vN))) & 0xFFFFFFFF

  def fF(vX, vY, vZ):
    return (vX & vY) | (~vX & vZ)

  def fG(vX, vY, vZ):
    return (vX & vY) | (vX & vZ) | (vY & vZ)

  def fH(vX, vY, vZ):
    return vX ^ vY ^ vZ

  vLongitudEnBits = (len(vDatos) * 8) & 0xFFFFFFFFFFFFFFFF
  vDatos = vDatos + b"\x80"
  while (len(vDatos) % 64) != 56:
    vDatos = vDatos + b"\x00"
  vDatos = vDatos + struct.pack("<Q", vLongitudEnBits)

  vA = 0x67452301
  vB = 0xEFCDAB89
  vC = 0x98BADCFE
  vD = 0x10325476

  for vOffset in range(0, len(vDatos), 64):
    aX = list(struct.unpack("<16I", vDatos[vOffset:vOffset + 64]))
    vAA, vBB, vCC, vDD = vA, vB, vC, vD

    # Ronda 1
    aS = [3, 7, 11, 19]
    for vI in range(16):
      vK = vI
      vS = aS[vI % 4]
      if vI % 4 == 0:
        vA = fRotl((vA + fF(vB, vC, vD) + aX[vK]) & 0xFFFFFFFF, vS)
      elif vI % 4 == 1:
        vD = fRotl((vD + fF(vA, vB, vC) + aX[vK]) & 0xFFFFFFFF, vS)
      elif vI % 4 == 2:
        vC = fRotl((vC + fF(vD, vA, vB) + aX[vK]) & 0xFFFFFFFF, vS)
      else:
        vB = fRotl((vB + fF(vC, vD, vA) + aX[vK]) & 0xFFFFFFFF, vS)

    # Ronda 2
    aS = [3, 5, 9, 13]
    aK = [0, 4, 8, 12, 1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15]
    for vI in range(16):
      vK = aK[vI]
      vS = aS[vI % 4]
      if vI % 4 == 0:
        vA = fRotl((vA + fG(vB, vC, vD) + aX[vK] + 0x5A827999) & 0xFFFFFFFF, vS)
      elif vI % 4 == 1:
        vD = fRotl((vD + fG(vA, vB, vC) + aX[vK] + 0x5A827999) & 0xFFFFFFFF, vS)
      elif vI % 4 == 2:
        vC = fRotl((vC + fG(vD, vA, vB) + aX[vK] + 0x5A827999) & 0xFFFFFFFF, vS)
      else:
        vB = fRotl((vB + fG(vC, vD, vA) + aX[vK] + 0x5A827999) & 0xFFFFFFFF, vS)

    # Ronda 3
    aS = [3, 9, 11, 15]
    aK = [0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15]
    for vI in range(16):
      vK = aK[vI]
      vS = aS[vI % 4]
      if vI % 4 == 0:
        vA = fRotl((vA + fH(vB, vC, vD) + aX[vK] + 0x6ED9EBA1) & 0xFFFFFFFF, vS)
      elif vI % 4 == 1:
        vD = fRotl((vD + fH(vA, vB, vC) + aX[vK] + 0x6ED9EBA1) & 0xFFFFFFFF, vS)
      elif vI % 4 == 2:
        vC = fRotl((vC + fH(vD, vA, vB) + aX[vK] + 0x6ED9EBA1) & 0xFFFFFFFF, vS)
      else:
        vB = fRotl((vB + fH(vC, vD, vA) + aX[vK] + 0x6ED9EBA1) & 0xFFFFFFFF, vS)

    vA = (vA + vAA) & 0xFFFFFFFF
    vB = (vB + vBB) & 0xFFFFFFFF
    vC = (vC + vCC) & 0xFFFFFFFF
    vD = (vD + vDD) & 0xFFFFFFFF

  return struct.pack("<4I", vA, vB, vC, vD)


def fHashNTLM(vLinea: bytes, vEncoding: str) -> str:
  try:
    vTexto = vLinea.decode(vEncoding)
  except UnicodeDecodeError:
    vTexto = vLinea.decode("latin-1")
  vUtf16 = vTexto.encode("utf-16le")
  return fMD4(vUtf16).hex()


def fHashSHA256NTLM(vLinea: bytes, vEncoding: str) -> str:
  vNtlmHex = fHashNTLM(vLinea, vEncoding)
  vNtlmBytes = bytes.fromhex(vNtlmHex)
  return hashlib.sha256(vNtlmBytes).hexdigest()


def fListaAlgoritmosHashlib() -> list[str]:
  aPreferidos = [
    "md5", "sha1", "sha224", "sha256", "sha384", "sha512",
    "sha3_224", "sha3_256", "sha3_384", "sha3_512",
    "blake2b", "blake2s",
    "ripemd160",
  ]
  aDisponibles = set(hashlib.algorithms_available)
  aResultado = []
  for vA in aPreferidos:
    if vA in aDisponibles:
      aResultado.append(vA)
  return aResultado


def fCrearMapaAlgoritmos(vEncoding: str) -> dict:
  vMapa = {}

  for vAlgo in fListaAlgoritmosHashlib():
    def fFactory(vNombre):
      def fH(vLinea: bytes) -> str:
        return hashlib.new(vNombre, vLinea).hexdigest()
      return fH
    vMapa[vAlgo] = {
      "nombre": vAlgo,
      "fHash": fFactory(vAlgo),
      "gpu": (vAlgo == "md5"),
      "usa_encoding": False
    }

  vMapa["ntlm"] = {
    "nombre": "ntlm",
    "fHash": lambda vLinea: fHashNTLM(vLinea, vEncoding),
    "gpu": False,
    "usa_encoding": True
  }
  vMapa["sha256ntlm"] = {
    "nombre": "sha256ntlm",
    "fHash": lambda vLinea: fHashSHA256NTLM(vLinea, vEncoding),
    "gpu": False,
    "usa_encoding": True
  }

  return vMapa


def fChecklistCurses(aOpciones: list[str]) -> list[str]:
  import curses

  aMarcadas = [False] * len(aOpciones)
  vIdx = 0

  def fUI(vStdScr):
    nonlocal vIdx
    curses.curs_set(0)
    vStdScr.nodelay(False)

    while True:
      vStdScr.erase()
      vStdScr.addstr(0, 0, "Elige algoritmos (SPACE marca/desmarca, ENTER confirma, q cancela)")
      for vI, vO in enumerate(aOpciones):
        vSel = ">" if vI == vIdx else " "
        vChk = "[x]" if aMarcadas[vI] else "[ ]"
        vStdScr.addstr(2 + vI, 0, f"{vSel} {vChk} {vO}")
      vStdScr.refresh()

      vK = vStdScr.getch()
      if vK in (ord("q"), ord("Q")):
        return []
      if vK in (curses.KEY_UP, ord("k")):
        vIdx = (vIdx - 1) % len(aOpciones)
      elif vK in (curses.KEY_DOWN, ord("j")):
        vIdx = (vIdx + 1) % len(aOpciones)
      elif vK == ord(" "):
        aMarcadas[vIdx] = not aMarcadas[vIdx]
      elif vK in (curses.KEY_ENTER, 10, 13):
        aSel = [aOpciones[vI] for vI, vM in enumerate(aMarcadas) if vM]
        return aSel

  return curses.wrapper(fUI)


def fDetectarGPU() -> dict:
  aVendors = {
    "0x10de": "nvidia",
    "0x1002": "amd",
    "0x1022": "amd",
    "0x8086": "intel"
  }

  vBase = Path("/sys/class/drm")
  if not vBase.exists():
    return {"hay_gpu": False, "gpus": []}

  aGPUs = []
  for vP in vBase.glob("card*/device/vendor"):
    try:
      vVendorId = vP.read_text().strip().lower()
    except Exception:
      continue
    vTipo = aVendors.get(vVendorId, "otra")
    aGPUs.append({
      "vendor_id": vVendorId,
      "tipo": vTipo,
      "ruta": str(vP.parent)
    })

  return {"hay_gpu": (len(aGPUs) > 0), "gpus": aGPUs}


def fInicializarMD5GPU(vInfoGPU: dict) -> dict:
  vTipo = "desconocida"
  if vInfoGPU.get("hay_gpu") and len(vInfoGPU.get("gpus", [])) > 0:
    vTipo = vInfoGPU["gpus"][0].get("tipo", "desconocida")

  if vTipo == "nvidia":
    if fTieneModulo("cupy"):
      return {"ok": True, "backend": "cuda_cupy"}

  if fTieneModulo("pyopencl"):
    return {"ok": True, "backend": "opencl"}

  return {"ok": False, "backend": None}


def fMD5PadSingleBlock(vLinea: bytes) -> bytes | None:
  if len(vLinea) > 55:
    return None
  aBloque = bytearray(64)
  aBloque[0:len(vLinea)] = vLinea
  aBloque[len(vLinea)] = 0x80
  aBloque[56:64] = struct.pack("<Q", len(vLinea) * 8)
  return bytes(aBloque)


def fMD5GPU_CUDA_CuPy(aLineas: list[bytes]) -> dict[int, str]:
  import numpy as np
  import cupy as cp

  aIdx = []
  aBloques = []
  for vI, vLinea in enumerate(aLineas):
    vBlk = fMD5PadSingleBlock(vLinea)
    if vBlk is None:
      continue
    aIdx.append(vI)
    aBloques.append(vBlk)

  if len(aIdx) == 0:
    return {}

  vN = len(aIdx)
  aU32 = np.frombuffer(b"".join(aBloques), dtype=np.uint32).reshape(vN, 16)
  vIn = cp.asarray(aU32)
  vOut = cp.zeros((vN, 4), dtype=cp.uint32)

  vKernel = r'''
  extern "C" __global__
  void md5_singleblock(const unsigned int* __restrict__ in16,
                       unsigned int* __restrict__ out4,
                       const int n)
  {
    int idx = (int)(blockDim.x * blockIdx.x + threadIdx.x);
    if (idx >= n) return;

    const unsigned int* x = in16 + (idx * 16);

    unsigned int a = 0x67452301u;
    unsigned int b = 0xefcdab89u;
    unsigned int c = 0x98badcfeu;
    unsigned int d = 0x10325476u;

    #define F(x,y,z) ((x & y) | (~x & z))
    #define G(x,y,z) ((x & z) | (y & ~z))
    #define H(x,y,z) (x ^ y ^ z)
    #define I(x,y,z) (y ^ (x | ~z))
    #define ROTL(x,n) ((x << n) | (x >> (32 - n)))
    #define STEP(f,a,b,c,d,x,t,s) a = b + ROTL((a + f(b,c,d) + x + t), s)

    unsigned int aa=a, bb=b, cc=c, dd=d;

    STEP(F,a,b,c,d,x[0], 0xd76aa478u, 7);
    STEP(F,d,a,b,c,x[1], 0xe8c7b756u, 12);
    STEP(F,c,d,a,b,x[2], 0x242070dbu, 17);
    STEP(F,b,c,d,a,x[3], 0xc1bdceeeu, 22);
    STEP(F,a,b,c,d,x[4], 0xf57c0fafu, 7);
    STEP(F,d,a,b,c,x[5], 0x4787c62au, 12);
    STEP(F,c,d,a,b,x[6], 0xa8304613u, 17);
    STEP(F,b,c,d,a,x[7], 0xfd469501u, 22);
    STEP(F,a,b,c,d,x[8], 0x698098d8u, 7);
    STEP(F,d,a,b,c,x[9], 0x8b44f7afu, 12);
    STEP(F,c,d,a,b,x[10],0xffff5bb1u, 17);
    STEP(F,b,c,d,a,x[11],0x895cd7beu, 22);
    STEP(F,a,b,c,d,x[12],0x6b901122u, 7);
    STEP(F,d,a,b,c,x[13],0xfd987193u, 12);
    STEP(F,c,d,a,b,x[14],0xa679438eu, 17);
    STEP(F,b,c,d,a,x[15],0x49b40821u, 22);

    STEP(G,a,b,c,d,x[1], 0xf61e2562u, 5);
    STEP(G,d,a,b,c,x[6], 0xc040b340u, 9);
    STEP(G,c,d,a,b,x[11],0x265e5a51u, 14);
    STEP(G,b,c,d,a,x[0], 0xe9b6c7aau, 20);
    STEP(G,a,b,c,d,x[5], 0xd62f105du, 5);
    STEP(G,d,a,b,c,x[10],0x02441453u, 9);
    STEP(G,c,d,a,b,x[15],0xd8a1e681u, 14);
    STEP(G,b,c,d,a,x[4], 0xe7d3fbc8u, 20);
    STEP(G,a,b,c,d,x[9], 0x21e1cde6u, 5);
    STEP(G,d,a,b,c,x[14],0xc33707d6u, 9);
    STEP(G,c,d,a,b,x[3], 0xf4d50d87u, 14);
    STEP(G,b,c,d,a,x[8], 0x455a14edu, 20);
    STEP(G,a,b,c,d,x[13],0xa9e3e905u, 5);
    STEP(G,d,a,b,c,x[2], 0xfcefa3f8u, 9);
    STEP(G,c,d,a,b,x[7], 0x676f02d9u, 14);
    STEP(G,b,c,d,a,x[12],0x8d2a4c8au, 20);

    STEP(H,a,b,c,d,x[5], 0xfffa3942u, 4);
    STEP(H,d,a,b,c,x[8], 0x8771f681u, 11);
    STEP(H,c,d,a,b,x[11],0x6d9d6122u, 16);
    STEP(H,b,c,d,a,x[14],0xfde5380cu, 23);
    STEP(H,a,b,c,d,x[1], 0xa4beea44u, 4);
    STEP(H,d,a,b,c,x[4], 0x4bdecfa9u, 11);
    STEP(H,c,d,a,b,x[7], 0xf6bb4b60u, 16);
    STEP(H,b,c,d,a,x[10],0xbebfbc70u, 23);
    STEP(H,a,b,c,d,x[13],0x289b7ec6u, 4);
    STEP(H,d,a,b,c,x[0], 0xeaa127fau, 11);
    STEP(H,c,d,a,b,x[3], 0xd4ef3085u, 16);
    STEP(H,b,c,d,a,x[6], 0x04881d05u, 23);
    STEP(H,a,b,c,d,x[9], 0xd9d4d039u, 4);
    STEP(H,d,a,b,c,x[12],0xe6db99e5u, 11);
    STEP(H,c,d,a,b,x[15],0x1fa27cf8u, 16);
    STEP(H,b,c,d,a,x[2], 0xc4ac5665u, 23);

    STEP(I,a,b,c,d,x[0], 0xf4292244u, 6);
    STEP(I,d,a,b,c,x[7], 0x432aff97u, 10);
    STEP(I,c,d,a,b,x[14],0xab9423a7u, 15);
    STEP(I,b,c,d,a,x[5], 0xfc93a039u, 21);
    STEP(I,a,b,c,d,x[12],0x655b59c3u, 6);
    STEP(I,d,a,b,c,x[3], 0x8f0ccc92u, 10);
    STEP(I,c,d,a,b,x[10],0xffeff47du, 15);
    STEP(I,b,c,d,a,x[1], 0x85845dd1u, 21);
    STEP(I,a,b,c,d,x[8], 0x6fa87e4fu, 6);
    STEP(I,d,a,b,c,x[15],0xfe2ce6e0u, 10);
    STEP(I,c,d,a,b,x[6], 0xa3014314u, 15);
    STEP(I,b,c,d,a,x[13],0x4e0811a1u, 21);
    STEP(I,a,b,c,d,x[4], 0xf7537e82u, 6);
    STEP(I,d,a,b,c,x[11],0xbd3af235u, 10);
    STEP(I,c,d,a,b,x[2], 0x2ad7d2bbu, 15);
    STEP(I,b,c,d,a,x[9], 0xeb86d391u, 21);

    a += aa; b += bb; c += cc; d += dd;

    unsigned int* o = out4 + (idx * 4);
    o[0] = a; o[1] = b; o[2] = c; o[3] = d;
  }
  '''

  vRaw = cp.RawKernel(vKernel, "md5_singleblock")
  vThreads = 256
  vBlocks = (vN + vThreads - 1) // vThreads
  vRaw((vBlocks,), (vThreads,), (vIn, vOut, vN))
  aRes = cp.asnumpy(vOut)

  vMapa = {}
  for vJ, vI in enumerate(aIdx):
    vDigest = struct.pack("<4I", int(aRes[vJ, 0]), int(aRes[vJ, 1]), int(aRes[vJ, 2]), int(aRes[vJ, 3])).hex()
    vMapa[vI] = vDigest
  return vMapa


def fMD5GPU_OpenCL(aLineas: list[bytes]) -> dict[int, str]:
  import numpy as np
  import pyopencl as cl

  aIdx = []
  aBloques = []
  for vI, vLinea in enumerate(aLineas):
    vBlk = fMD5PadSingleBlock(vLinea)
    if vBlk is None:
      continue
    aIdx.append(vI)
    aBloques.append(vBlk)

  if len(aIdx) == 0:
    return {}

  vN = len(aIdx)
  aU32 = np.frombuffer(b"".join(aBloques), dtype=np.uint32).reshape(vN, 16)
  aOut = np.zeros((vN, 4), dtype=np.uint32)

  vPlataformas = cl.get_platforms()
  aDispositivos = []
  for vP in vPlataformas:
    try:
      aDispositivos.extend(vP.get_devices(device_type=cl.device_type.GPU))
    except Exception:
      pass
  if len(aDispositivos) == 0:
    for vP in vPlataformas:
      try:
        aDispositivos.extend(vP.get_devices())
      except Exception:
        pass
  if len(aDispositivos) == 0:
    return {}

  vCtx = cl.Context(devices=[aDispositivos[0]])
  vQueue = cl.CommandQueue(vCtx)

  vKernel = r'''
  __kernel void md5_singleblock(__global const uint *in16,
                                __global uint *out4,
                                const int n)
  {
    int idx = (int)get_global_id(0);
    if (idx >= n) return;

    __global const uint *x = in16 + (idx * 16);

    uint a = 0x67452301u;
    uint b = 0xefcdab89u;
    uint c = 0x98badcfeu;
    uint d = 0x10325476u;

    #define F(x,y,z) ((x & y) | (~x & z))
    #define G(x,y,z) ((x & z) | (y & ~z))
    #define H(x,y,z) (x ^ y ^ z)
    #define I(x,y,z) (y ^ (x | ~z))
    #define ROTL(x,n) rotate(x, (uint)n)
    #define STEP(f,a,b,c,d,x,t,s) a = b + ROTL((a + f(b,c,d) + x + t), s)

    uint aa=a, bb=b, cc=c, dd=d;

    STEP(F,a,b,c,d,x[0], 0xd76aa478u, 7);
    STEP(F,d,a,b,c,x[1], 0xe8c7b756u, 12);
    STEP(F,c,d,a,b,x[2], 0x242070dbu, 17);
    STEP(F,b,c,d,a,x[3], 0xc1bdceeeu, 22);
    STEP(F,a,b,c,d,x[4], 0xf57c0fafu, 7);
    STEP(F,d,a,b,c,x[5], 0x4787c62au, 12);
    STEP(F,c,d,a,b,x[6], 0xa8304613u, 17);
    STEP(F,b,c,d,a,x[7], 0xfd469501u, 22);
    STEP(F,a,b,c,d,x[8], 0x698098d8u, 7);
    STEP(F,d,a,b,c,x[9], 0x8b44f7afu, 12);
    STEP(F,c,d,a,b,x[10],0xffff5bb1u, 17);
    STEP(F,b,c,d,a,x[11],0x895cd7beu, 22);
    STEP(F,a,b,c,d,x[12],0x6b901122u, 7);
    STEP(F,d,a,b,c,x[13],0xfd987193u, 12);
    STEP(F,c,d,a,b,x[14],0xa679438eu, 17);
    STEP(F,b,c,d,a,x[15],0x49b40821u, 22);

    STEP(G,a,b,c,d,x[1], 0xf61e2562u, 5);
    STEP(G,d,a,b,c,x[6], 0xc040b340u, 9);
    STEP(G,c,d,a,b,x[11],0x265e5a51u, 14);
    STEP(G,b,c,d,a,x[0], 0xe9b6c7aau, 20);
    STEP(G,a,b,c,d,x[5], 0xd62f105du, 5);
    STEP(G,d,a,b,c,x[10],0x02441453u, 9);
    STEP(G,c,d,a,b,x[15],0xd8a1e681u, 14);
    STEP(G,b,c,d,a,x[4], 0xe7d3fbc8u, 20);
    STEP(G,a,b,c,d,x[9], 0x21e1cde6u, 5);
    STEP(G,d,a,b,c,x[14],0xc33707d6u, 9);
    STEP(G,c,d,a,b,x[3], 0xf4d50d87u, 14);
    STEP(G,b,c,d,a,x[8], 0x455a14edu, 20);
    STEP(G,a,b,c,d,x[13],0xa9e3e905u, 5);
    STEP(G,d,a,b,c,x[2], 0xfcefa3f8u, 9);
    STEP(G,c,d,a,b,x[7], 0x676f02d9u, 14);
    STEP(G,b,c,d,a,x[12],0x8d2a4c8au, 20);

    STEP(H,a,b,c,d,x[5], 0xfffa3942u, 4);
    STEP(H,d,a,b,c,x[8], 0x8771f681u, 11);
    STEP(H,c,d,a,b,x[11],0x6d9d6122u, 16);
    STEP(H,b,c,d,a,x[14],0xfde5380cu, 23);
    STEP(H,a,b,c,d,x[1], 0xa4beea44u, 4);
    STEP(H,d,a,b,c,x[4], 0x4bdecfa9u, 11);
    STEP(H,c,d,a,b,x[7], 0xf6bb4b60u, 16);
    STEP(H,b,c,d,a,x[10],0xbebfbc70u, 23);
    STEP(H,a,b,c,d,x[13],0x289b7ec6u, 4);
    STEP(H,d,a,b,c,x[0], 0xeaa127fau, 11);
    STEP(H,c,d,a,b,x[3], 0xd4ef3085u, 16);
    STEP(H,b,c,d,a,x[6], 0x04881d05u, 23);
    STEP(H,a,b,c,d,x[9], 0xd9d4d039u, 4);
    STEP(H,d,a,b,c,x[12],0xe6db99e5u, 11);
    STEP(H,c,d,a,b,x[15],0x1fa27cf8u, 16);
    STEP(H,b,c,d,a,x[2], 0xc4ac5665u, 23);

    STEP(I,a,b,c,d,x[0], 0xf4292244u, 6);
    STEP(I,d,a,b,c,x[7], 0x432aff97u, 10);
    STEP(I,c,d,a,b,x[14],0xab9423a7u, 15);
    STEP(I,b,c,d,a,x[5], 0xfc93a039u, 21);
    STEP(I,a,b,c,d,x[12],0x655b59c3u, 6);
    STEP(I,d,a,b,c,x[3], 0x8f0ccc92u, 10);
    STEP(I,c,d,a,b,x[10],0xffeff47du, 15);
    STEP(I,b,c,d,a,x[1], 0x85845dd1u, 21);
    STEP(I,a,b,c,d,x[8], 0x6fa87e4fu, 6);
    STEP(I,d,a,b,c,x[15],0xfe2ce6e0u, 10);
    STEP(I,c,d,a,b,x[6], 0xa3014314u, 15);
    STEP(I,b,c,d,a,x[13],0x4e0811a1u, 21);
    STEP(I,a,b,c,d,x[4], 0xf7537e82u, 6);
    STEP(I,d,a,b,c,x[11],0xbd3af235u, 10);
    STEP(I,c,d,a,b,x[2], 0x2ad7d2bbu, 15);
    STEP(I,b,c,d,a,x[9], 0xeb86d391u, 21);

    a += aa; b += bb; c += cc; d += dd;

    __global uint *o = out4 + (idx * 4);
    o[0] = a; o[1] = b; o[2] = c; o[3] = d;
  }
  '''

  vPrg = cl.Program(vCtx, vKernel).build()
  vMf = cl.mem_flags
  vBufIn = cl.Buffer(vCtx, vMf.READ_ONLY | vMf.COPY_HOST_PTR, hostbuf=aU32)
  vBufOut = cl.Buffer(vCtx, vMf.WRITE_ONLY, aOut.nbytes)

  vPrg.md5_singleblock(vQueue, (vN,), None, vBufIn, vBufOut, np.int32(vN))
  cl.enqueue_copy(vQueue, aOut, vBufOut).wait()

  vMapa = {}
  for vJ, vI in enumerate(aIdx):
    vDigest = struct.pack("<4I", int(aOut[vJ, 0]), int(aOut[vJ, 1]), int(aOut[vJ, 2]), int(aOut[vJ, 3])).hex()
    vMapa[vI] = vDigest
  return vMapa


def fNormalizarLineaBytes(vLinea: bytes) -> bytes:
  if vLinea.endswith(b"\n"):
    vLinea = vLinea[:-1]
  if vLinea.endswith(b"\r"):
    vLinea = vLinea[:-1]
  return vLinea


def fAbrirSalidas(vRutaEntrada: Path, vOutDir: Path, aAlgoritmos: list[str]) -> dict:
  vBase = vRutaEntrada.stem
  vOutDir.mkdir(parents=True, exist_ok=True)
  vFicheros = {}
  for vAlgo in aAlgoritmos:
    vRutaOut = vOutDir / f"{vBase}-{vAlgo}.txt"
    vFicheros[vAlgo] = open(vRutaOut, "wb", buffering=1024 * 1024)
  return vFicheros


def fCerrarSalidas(vFicheros: dict):
  for vF in vFicheros.values():
    try:
      vF.close()
    except Exception:
      pass


def fProcesarBatch(aLineas: list[bytes],
                   vMapaAlgoritmos: dict,
                   aSel: list[str],
                   vFicheros: dict,
                   vGPU: bool,
                   vGPUBackend: str | None):
  vUsarGPU_MD5 = vGPU and ("md5" in aSel) and (vMapaAlgoritmos.get("md5", {}).get("gpu") is True) and (vGPUBackend is not None)

  vMd5GPU = {}
  if vUsarGPU_MD5:
    try:
      if vGPUBackend == "cuda_cupy":
        vMd5GPU = fMD5GPU_CUDA_CuPy(aLineas)
      elif vGPUBackend == "opencl":
        vMd5GPU = fMD5GPU_OpenCL(aLineas)
    except Exception:
      vMd5GPU = {}

  for vI, vLinea in enumerate(aLineas):
    for vAlgo in aSel:
      if vAlgo == "md5" and vUsarGPU_MD5 and (vI in vMd5GPU):
        vHex = vMd5GPU[vI]
      else:
        vHex = vMapaAlgoritmos[vAlgo]["fHash"](vLinea)
      vFicheros[vAlgo].write(vHex.encode("ascii") + b":" + vLinea + b"\n")


def fMain():
  vParser = argparse.ArgumentParser(
    description="Genera ficheros hash:palabra por algoritmo a partir de una wordlist (1 string por línea)."
  )
  vParser.add_argument("wordlist", help="Ruta a la wordlist (texto plano, 1 string por línea).")
  vParser.add_argument("-o", "--out-dir", default=None, help="Directorio de salida (por defecto, el mismo que la wordlist).")
  vParser.add_argument("--algos", default=None, help="Lista separada por comas (si no se indica, se abre checklist).")
  vParser.add_argument("--list", action="store_true", help="Lista algoritmos disponibles y sale.")
  vParser.add_argument("-gpu", action="store_true", help="Intenta usar GPU (solo acelera MD5 <=55 bytes; resto CPU).")
  vParser.add_argument("--encoding", default="utf-8", help="Encoding para NTLM/SHA256NTLM (default: utf-8; fallback latin-1 por línea).")
  vParser.add_argument("--batch-lines", type=int, default=50000, help="Tamaño de batch (mejor para -gpu). Default: 50000.")
  vArgs = vParser.parse_args()

  vNecesitaChecklist = (not vArgs.list) and (vArgs.algos is None)

  vDep = fComprobarDependencias(vNecesitaChecklist=vNecesitaChecklist, vQuiereGPU=vArgs.gpu)
  if vDep != 0:
    return vDep

  vRutaEntrada = Path(vArgs.wordlist).expanduser().resolve()
  if not vRutaEntrada.exists():
    print(f"Error: no existe el archivo: {vRutaEntrada}", file=sys.stderr)
    return 2

  vOutDir = Path(vArgs.out_dir).expanduser().resolve() if vArgs.out_dir else vRutaEntrada.parent
  vMapaAlgoritmos = fCrearMapaAlgoritmos(vArgs.encoding)

  aDisponibles = sorted(vMapaAlgoritmos.keys())
  if vArgs.list:
    for vA in aDisponibles:
      print(vA)
    return 0

  if vArgs.algos:
    aSel = [v.strip().lower() for v in vArgs.algos.split(",") if v.strip()]
  else:
    aSel = fChecklistCurses(aDisponibles)

  if len(aSel) == 0:
    print("No se ha seleccionado ningún algoritmo. Saliendo.", file=sys.stderr)
    return 1

  aSel = [vA for vA in aSel if vA in vMapaAlgoritmos]
  if len(aSel) == 0:
    print("Selección inválida. Usa --list para ver algoritmos.", file=sys.stderr)
    return 1

  vInfoGPU = fDetectarGPU()
  vGPUBackend = None
  if vArgs.gpu:
    if not vInfoGPU.get("hay_gpu"):
      print("Aviso: -gpu pedido pero no se detecta GPU. Se usará CPU.", file=sys.stderr)
    else:
      vInit = fInicializarMD5GPU(vInfoGPU)
      if not vInit["ok"]:
        print("Aviso: -gpu pedido pero faltan dependencias (cupy o pyopencl). Se usará CPU.", file=sys.stderr)
      else:
        vGPUBackend = vInit["backend"]
        vTipo = vInfoGPU["gpus"][0].get("tipo", "desconocida")
        print(f"GPU detectada ({vTipo}). Backend: {vGPUBackend}. GPU solo acelera MD5 <=55 bytes.", file=sys.stderr)

  vFicheros = fAbrirSalidas(vRutaEntrada, vOutDir, aSel)

  vCont = 0
  aBatch = []
  try:
    with open(vRutaEntrada, "rb") as vF:
      for vLinea in vF:
        aBatch.append(fNormalizarLineaBytes(vLinea))
        if len(aBatch) >= vArgs.batch_lines:
          fProcesarBatch(aBatch, vMapaAlgoritmos, aSel, vFicheros, vArgs.gpu, vGPUBackend)
          vCont += len(aBatch)
          aBatch = []
          if vCont % 500000 == 0:
            print(f"Procesadas {vCont} líneas...", file=sys.stderr)

      if len(aBatch) > 0:
        fProcesarBatch(aBatch, vMapaAlgoritmos, aSel, vFicheros, vArgs.gpu, vGPUBackend)
        vCont += len(aBatch)

  finally:
    fCerrarSalidas(vFicheros)

  print(f"OK. Total líneas: {vCont}. Salida en: {vOutDir}", file=sys.stderr)
  return 0


if __name__ == "__main__":
  raise SystemExit(fMain())
