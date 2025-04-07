SET DELPHI_PATH=C:\Progra~1\Delphi7
SET DLMSDK=D:\dlmsdk\DLP
SET COMPILELOG=compile.log
SET FILENAME=%1

echo Compiling %FILENAME% >>%COMPILELOG%

%DELPHI_PATH%\BIN\dcc32 -M -W -H -U"%DELPHI_PATH%\lib";"%DLMSDK%\Units" %FILENAME% >>%COMPILELOG%

if %errorlevel% == 0 echo Compiling OK! >>%COMPILELOG%
if errorlevel 1  goto CompErr
del %COMPILELOG%
goto End

:CompErr
echo Compiling error! >>%COMPILELOG%
echo ERRORLEVEL=%ERRORLEVEL%  >>%COMPILELOG%
if %errorlevel% == 9009 echo Delphi not found here >>%COMPILELOG%
goto End

:End
del /q *.dcu
Exit

REM Syntax: dcc32 [options] filename [options]
REM  -A<unit>=<alias> = Set unit alias  -LU<package> = Use package        
REM  -B = Build all units               -M = Make modified units         
REM  -CC = Console target               -N<path> = DCU output directory  
REM  -CG = GUI target                   -O<paths> = Object directories   
REM  -D<syms> = Define conditionals     -P = look for 8.3 file names also
REM  -E<path> = EXE output directory    -Q = Quiet compile               
REM  -F<offset> = Find error            -R<paths> = Resource directories 
REM  -GD = Detailed map file            -U<paths> = Unit directories     
REM  -GP = Map file with publics        -V = Debug information in EXE    
REM  -GS = Map file with segments       -VR = Generate remote debug (RSM)
REM  -H = Output hint messages          -W = Output warning messages     
REM  -I<paths> = Include directories    -Z = Output 'never build' DCPs   
REM  -J = Generate .obj file            -$<dir> = Compiler directive     
REM  -JP = Generate C++ .obj file       --help = Show this help screen   
REM  -K<addr> = Set image base addr     --version = Show name and version
REM Compiler switches: -$<letter><state> (defaults are shown below)
REM  A8  Aligned record fields           P+  Open string params            
REM  B-  Full boolean Evaluation         Q-  Integer overflow checking     
REM  C+  Evaluate assertions at runtime  R-  Range checking                
REM  D+  Debug information               T-  Typed @ operator              
REM  G+  Use imported data references    U-  Pentium(tm)-safe divide       
REM  H+  Use long strings by default     V+  Strict var-strings            
REM  I+  I/O checking                    W-  Generate stack frames         
REM  J-  Writeable structured consts     X+  Extended syntax               
REM  L+  Local debug symbols             Y+  Symbol reference info         
REM  M-  Runtime type info               Z1  Minimum size of enum types    
REM  O+  Optimization                  
