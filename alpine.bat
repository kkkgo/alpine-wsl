@echo off
echo !NEED: Microsoft Windows [10.0.18362+]
echo ======================
echo Your version:
ver
echo ======================

@echo off
:: Get Administrator Rights
set _Args=%*
if "%~1" NEQ "" (
  set _Args=%_Args:"=%
)
fltmc 1>nul 2>nul || (
  cd /d "%~dp0"
  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~dp0"" && ""%~dpnx0"" ""%_Args%""", "", "runas", 1 > "%temp%\GetAdmin.vbs"
  "%temp%\GetAdmin.vbs"
  del /f /q "%temp%\GetAdmin.vbs" 1>nul 2>nul
  exit
)

cd /d %~sdp0
echo %~sdp0
wsl --unregister alpine
wsl --set-default-version 2
wsl --update
echo Download Alpine...
del /F /S /Q alpine.tar.gz
curl https://dl-cdn.alpinelinux.org/alpine/v3.18/releases/x86_64/alpine-minirootfs-3.18.2-x86_64.tar.gz --output alpine.tar.gz
rmdir /s/q alpine
mkdir alpine
wsl --import alpine alpine alpine.tar.gz
del /F /S /Q alpine.tar.gz
wsl -d alpine -e uname -a
wsl -d alpine -e sh -c "apk add nano vim wget curl bind-tools openssh traceroute zsh git grml-zsh-config"
wsl -d alpine -e sh -c "sed -i 's#/bin/ash#/bin/zsh#g' /etc/passwd"
wsl
