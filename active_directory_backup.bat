REM PATH & NAME ADJUSMENT
@echo off
echo ================Initializing................
SET _datetime=%DATE:~7,2%-%DATE:~4,2%-%DATE:~10,4%
ECHO Date: %DATE% >> C:\log\Daily-DC-0-State-%_datetime%.log
ECHO Time: %TIME% >> C:\log\Daily-DC-0-State-%_datetime%.log

REM --------------------------------------------------------------------------------------------------------------------------
wbadmin start systemstatebackup -backuptarget:D: -quiet
REM --------------------------------------------------------------------------------------------------------------------------
TIMEOUT 20
REM --------------------------------------------------------------------------------------------------------------------------
set set dir=C:\ D:\
REM --------------------------------------------------------------------------------------------------------------------------
echo --------------------------------------------------------- >> C:\log\Daily-DC-0-State-%_datetime%.log
echo #an automatically generated delivery status notification# >> C:\log\Daily-DC-0-State-%_datetime%.log
echo --------------------------------------------------------- >> C:\log\Daily-DC-0-State-%_datetime%.log
REM --------------------------------------------------------------------------------------------------------------------------
REM change to directory
cd %dir%
set path="C:\Program Files\7-Zip\";%path%"

REM --------------------------------------------------------------------------------------------------------------------------
echo ------------------------------------------------------- >> C:\log\Daily-DC-0-State-%_datetime%.log
:sindiv
7z u -mmt4 "X:\Backup_DC0-%_datetime%.7z" "D:\WindowsImageBackup\JKT-DC0\" >> C:\log\Daily-DC-0-State-%_datetime%.log
echo ------------------------------------------------------- >> C:\log\Daily-DC-0-State-%_datetime%.log
REM --------------------------------------------------------------------------------------------------------------------------
echo --------------------------------------------------------- >> C:\log\Daily-DC-0-State-%_datetime%.log
echo #                    created by Arumi                   # >> C:\log\Daily-DC-0-State-%_datetime%.log
echo --------------------------------------------------------- >> C:\log\Daily-DC-0-State-%_datetime%.log
move "C:\log\*.log" "\\10.11.2.70\Backup\DC\Daily\Log Backup activity\Daily"
REM --------------------------------------------------------------------------------------------------------------------------
REM Delete file yang telah selesai di copy
DEL /F /S /Q /A "D:\WindowsImageBackup\*"
@RD /S /Q "D:\WindowsImageBackup"
REM --------------------------------------------------------------------------------------------------------------------------
REM RATENSI
forfiles /P "Y:" /S /M "Backup_DC0*.7z" /D -4 /C "CMD /C DEL @file"
REM --------------------------------------------------------------------------------------------------------------------------
:EOF
exit
