{Шаблон проекта для DLM}
library ;
{отключаем выравнивание в рекордах}
{$A1}
{устанавливаем расширение файла}
{$E d32}
{включаем оптимизацию}
{$O+}

Uses
    rsltype,
    rsldll;

const
  DLL_PROCESS_DETACH = 0;
  DLL_PROCESS_ATTACH = 1;
  DLL_THREAD_ATTACH  = 2;
  DLL_THREAD_DETACH  = 3;

{*****************************************************************

******************************************************************}

procedure TestProc; cdecl;
begin
end;

{*****************************************************************

******************************************************************}

procedure InitExec; stdcall;
begin
end;

procedure DoneExec; stdcall;
begin
end;

function RslDllMain(isLoad:Integer; anyL:Pointer):Integer; stdcall;
begin
{*******************************************
Эта процедура есть в DLM на С++
но здесь она не работает до конца
поскольку я не знаю как она там реализована
поэтому я ее не экспортирую
********************************************}
  result:=0;
end;


procedure DLLEntryPoint(Reason: DWORD); 
begin 
  case Reason of 
    Dll_Process_Attach: //Подключение процесса
    Dll_Thread_Attach: //Подключение потока
    Dll_Thread_Detach: //Отключение потока
    Dll_Process_Detach: //Отключение процесса
  end; // case 
end;

procedure AddModuleObjects(); stdcall;
begin
end;


Exports
InitExec,
DoneExec,
AddModuleObjects;

begin
// Расположенный здесь код выполняется в первую 
// очередь при каждом вызове DLL любым exe-файлом.
  if (Not Assigned(DllProc)) then begin 
    DllProc := @DLLEntryPoint; 
    DllEntryPoint(Dll_Process_Attach); 
  end;
end.
