SET DELPHI_PATH=C:\Progra~1\Borland\D7\
SET COMPILELOG=compile.log

echo Compiling aesrv.dpr >compile.log
%DELPHI_PATH%BIN\dcc32 -M -H -W -U"%DELPHI_PATH%lib";"D:\DlpComp\RslDlm" aesrv.dpr >>%COMPILELOG%
if %errorlevel% == 0 echo Compiling OK! >>%COMPILELOG%
if errorlevel 1  goto CompErr

echo **************************************************************** >>%COMPILELOG%
echo **************************************************************** >>%COMPILELOG%

echo Compiling aetrm.dpr %COMPILELOG%
%DELPHI_PATH%BIN\dcc32 -M -H -M -U"%DELPHI_PATH%lib";"D:\DlpComp\RslDlm" aetrm.dpr >>%COMPILELOG%
if %errorlevel% == 0 echo Compiling OK! >>%COMPILELOG%
if errorlevel 1  goto CompErr

goto End

:CompErr
echo Compiling error! >>%COMPILELOG%
echo ERRORLEVEL=%ERRORLEVEL%  >>%COMPILELOG%
if %errorlevel% == 9009 echo Delphi not found! >>%COMPILELOG%
goto End

:CompOk
goto End

:End
del /q *.dcu
Exit