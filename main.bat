@echo off
pushd %cd%

@echo off
cd /d %~dp0
@echo off
echo "change working directory to %~dp0"

start /wait ./lib/configdevenv/autoinstall.bat

popd
