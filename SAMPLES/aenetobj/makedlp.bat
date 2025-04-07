C:\Progra~1\Borland\Delphi7\Bin\dcc32 -CC -B -U"C:\Progra~1\Borland\Delphi7\lib";"C:\Progra~1\Borland\Delphi7\lib\FastNet";"C:\Progra~1\Borland\Delphi7\lib\Obj";"C:\Progra~1\Borland\Delphi7\Demos\FastNet";"D:\dlmsdk\DLP\Units" aenetobj.dpr > err.log
del /q *.dcu
copy /y *.d32 d:\dlmsdk\dlm\ >> err.log