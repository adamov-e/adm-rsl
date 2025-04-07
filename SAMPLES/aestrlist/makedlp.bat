SET DELPHI_PATH=C:\Progra~1\Delphi7\
echo Compiling %1 >>compile.log
%DELPHI_PATH%BIN\dcc32 -CC -B -U"%DELPHI_PATH%lib";"F:\dlmsdk\DLP\Units" strlist.dpr >>compile.log
if %errorlevel% == 9009 echo Delphi not found! >>compile.log
if %errorlevel% == 0 echo Compiling OK!; >>compile.log
if errorlevel 1  echo Compiling error!; >>compile.log
echo ERRORLEVEL=%ERRORLEVEL%  >>compile.log
del /q *.dcu
