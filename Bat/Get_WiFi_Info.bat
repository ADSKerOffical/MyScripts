@echo off
chcp 65001 > nul

set "bssid="
set "ssid="
set "macaddr="
set "ipaddr="

for /f "tokens=2 delims=," %%i in ('getmac /fo csv /nh') do (
    set "macaddr=%%i"
)

for /f "tokens=1,* delims=:" %%a in ('netsh wlan show interfaces ^| findstr /i "BSSID"') do (
    set "bssid=%%b"
)
set "bssid=%bssid:~1%"

for /f "tokens=2 delims=:" %%a in ('netsh wlan show interfaces ^| findstr /i "SSID"') do (
    set "ssid=%%a"
)
set "ssid=%ssid:~1%"

for /f "delims=" %%i in ('netstat -n -p tcp ^| findstr "ESTABLISHED"') do set "ipaddr=%%i"

echo "SSID (имя точки доступа): %ssid%"
echo "BSSID: %bssid%"
echo "MAC Адрес: %macaddr%"
echo "IPv4 Адрес: %ipaddr%"

net session >nul 2>&1
if %errorlevel% == 0 (
    netsh wlan show profile name="%ssid%" key=clear
) else (
    echo "Для некоторых функций нужно иметь права администратора"
)
