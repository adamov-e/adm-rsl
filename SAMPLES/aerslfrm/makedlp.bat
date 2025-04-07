SET DELPHI_PATH=C:\Progra~1\Delphi7\
SET COMPILELOG=compile.log
SET FILENAME=aerslfrm.dpr

echo Compiling %FILENAME% >>%COMPILELOG%

%DELPHI_PATH%BIN\dcc32 -M -W -H -U"%DELPHI_PATH%lib";"F:\dlmsdk\DLP\Units" %FILENAME% >>%COMPILELOG%

if %errorlevel% == 0 echo Compiling OK! >>%COMPILELOG%
if errorlevel 1  goto CompErr
goto End

:CompErr
echo Compiling error! >>%COMPILELOG%
echo ERRORLEVEL=%ERRORLEVEL%  >>%COMPILELOG%
if %errorlevel% == 9009 echo Delphi not found here >>%COMPILELOG%
goto End

:End
del /q *.dcu
Exit

