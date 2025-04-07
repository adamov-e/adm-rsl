SET DELPHI_PATH=C:\Progra~1\Delphi7\
echo Cimpiling aesrv.dpr >compile.log
%DELPHI_PATH%BIN\dcc32 -CC -B -U"%DELPHI_PATH%lib";"F:\dlmsdk\DLP\Units" aesrv.dpr
if %errorlevel% == 9009 echo Delphi not found! >>compile.log
if %errorlevel% == 0 echo Compiling OK!; >>compile.log
if errorlevel 1  echo Compiling error!; >>compile.log
echo ERRORLEVEL=%ERRORLEVEL%  >>compile.log
echo ********************************************** >>compile.log

echo Cimpiling aetrm.dpr >>compile.log
%DELPHI_PATH%BIN\dcc32 -CC -B -U"%DELPHI_PATH%lib";"F:\dlmsdk\DLP\Units" aetrm.dpr
if %errorlevel% == 9009 echo Delphi not found! >>compile.log
if %errorlevel% == 0 echo Compiling OK!; >>compile.log
if errorlevel 1  echo Compiling error!; >>compile.log
echo ERRORLEVEL=%ERRORLEVEL%  >>compile.log

del /q *.dcu