#!/bin/bash

git clone https://github.com/icsharpcode/ILSpy
cd ILSpy
git submodule update --init --recursive
curl -sL https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -o /tmp/microsoftrepo.deb
sudo apt -y install /tmp/microsoftrepo.deb
sudo apt -y update
sudo apt -y install jq
vVersDSK=$(jq -r '.sdk.version' global.json | cut -d'.' -f1,2)
sudo apt -y install dotnet-sdk-$vVersDSK
sudo apt -y install powershell
dotnet build ILSpy.sln
mkdir -p ~/bin
cd ~/ILSpy/ICSharpCode.ILSpyCmd/bin/Debug/net8.0
mkdir ~/bin/ilspycmd/
cp -r * ~/bin/ilspycmd/
echo '#!/bin/bash'                              > ~/bin/ilspy
echo 'dotnet ~/bin/ilspycmd/ilspycmd.dll "$@"' >> ~/bin/ilspy
chmod +x                                          ~/bin/ilspy
sudo dotnet workload update --from-previous-sdk
sudo dotnet workload update
# Para ejecutar el decompilador
# ~/bin/ilspy -o ./CarpetaConCodFuente '/ruta/al/archivo/dll' 
