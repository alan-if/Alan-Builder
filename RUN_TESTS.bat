@ECHO OFF
CLS
:: Delete old files:
DEL /S *.a3c *.a3log *.ifid  > nul 2>&1

ABuilder.exe
ECHO.
ECHO.
ECHO ^\^\^\^\^\^\^\^\^\^\^\^\^\^\
ECHO  EXIT CODE: %ERRORLEVEL%
ECHO //////////////
EXIT /B
