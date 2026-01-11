@echo off
setlocal EnableDelayedExpansion

set /a n=126
for /L %%i in (1,1,254) do (
    ping -n 1 -w 100 192.168.1.%%i >nul

    set /a mod=%%i%%2
    if !mod! EQU 0 (
        cls
        echo Network analysis in progress...
        echo Remaining time estimation: !n! secondes
        set /a n-=1
    )
)

arp -a

set "ips="
set "macs="

for /f "tokens=1,2" %%A in ('arp -a ^| findstr /R "^[ ]*[0-9]"') do (
    set "ips=!ips!,%%A"
)

for /f "tokens=2" %%B in ('arp -a ^| findstr /R "[0-9A-Fa-f][0-9A-Fa-f]-[0-9A-Fa-f][0-9A-Fa-f]-[0-9A-Fa-f][0-9A-Fa-f]-[0-9A-Fa-f][0-9A-Fa-f]-[0-9A-Fa-f][0-9A-Fa-f]-[0-9A-Fa-f][0-9A-Fa-f]"') do (
    set "macs=!macs!,%%B"
)

if defined ips set "ips=!ips:~1!"

if "!ips!"=="" (
    echo No IP found with ARP.
    pause
    exit /b 1
)
if "!macs!"=="" (
    echo No MAC Adress found with ARP.
    pause
    exit /b 1
)

echo Found IPs: !ips!
echo.
echo Found MACs: !macs!
echo.

for %%I in (!ips!) do (
    echo -------------------------------
    echo informations for %%I
    nslookup %%I
    echo.
)

pause
