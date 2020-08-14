REM ADJUSTMENT NAME & PATH
REM Change running scripts directory
DEL /F /S /Q /A "C:\Scripts\*.vbs"
::email.bat:::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off
echo Sedang mengirim email......................................
setlocal
:: defaults
SET ET _datetime=%DATE:~7,2%-%DATE:~4,2%-%DATE:~10,4%
ECHO Date: %DATE% 
ECHO Time: %TIME%  
ECHO %_datetime%
set From=svr-scp@example.co.id
set To=it@example.co.id
set Subj="Automatically daily report %date% %time%"
set Body="*** Done, silahkan buka file 7z untuk melihat report!***"
REM pop3/imap4 mail server outgoing
set Serv=mail2.example.co.id
set Auth=ade.purnomo50@gmail.com
set Pass=123
REM Change attachment
set fileattach=C:\Temp-log\Zipper\ransi%_datetime%.7z
:: if command line arguments are supplied then use them
if "%~7" NEQ "" (
set From=%1
set To=%2
set Subj="%~3"
set Body="%~4"
set Serv=%5
set "Auth=%~6"
set "Pass=%~7"
set "fileattach=%~8"
)
call :createVBS "email-bat.vbs"
call :send %From% %To% %Subj% %Body% %Serv% %Auth% %Pass%
@echo off
del "%vbsfile%" 2>nul
goto :EOF
:send
cscript.exe /nologo "%vbsfile%" %1 %2 %3 %4 %5 %6 %7
echo done..............email terkirim gan !!!! >> K:\Daily\Mail_send_report_wekkly-%_datetime%.log
TIMEOUT 5
:eof
DEL /F /S /Q /A "C:\Scripts\*.vbs""
exit
:createVBS
set "vbsfile=%~1"
del "%vbsfile%" 2>nul
set cdoSchema=http://schemas.microsoft.com/cdo/configuration
echo >>"%vbsfile%" Set objArgs       = WScript.Arguments
echo >>"%vbsfile%" Set objEmail      = CreateObject("CDO.Message")
echo >>"%vbsfile%" objEmail.From     = objArgs(0)
echo >>"%vbsfile%" objEmail.To       = objArgs(1)
echo >>"%vbsfile%" objEmail.Subject  = objArgs(2)
echo >>"%vbsfile%" objEmail.Textbody = objArgs(3)
if defined fileattach echo >>"%vbsfile%" objEmail.AddAttachment "%fileattach%"
echo >>"%vbsfile%" with objEmail.Configuration.Fields
echo >>"%vbsfile%"  .Item ("%cdoSchema%/sendusing")        = 2 ' not local, smtp
echo >>"%vbsfile%"  .Item ("%cdoSchema%/smtpserver")       = objArgs(4)
echo >>"%vbsfile%"  .Item ("%cdoSchema%/smtpserverport")   = 465
echo >>"%vbsfile%"  .Item ("%cdoSchema%/smtpauthenticate") = 1 ' cdobasic
echo >>"%vbsfile%"  .Item ("%cdoSchema%/sendusername")     = objArgs(5)
echo >>"%vbsfile%"  .Item ("%cdoSchema%/sendpassword")     = objArgs(6)
echo >>"%vbsfile%"  .Item ("%cdoSchema%/smtpusessl")       = True
echo >>"%vbsfile%"  .Item ("%cdoSchema%/smtpconnectiontimeout") = 25
echo >>"%vbsfile%"  .Update
echo >>"%vbsfile%" end with
echo >>"%vbsfile%" objEmail.Send
:end
