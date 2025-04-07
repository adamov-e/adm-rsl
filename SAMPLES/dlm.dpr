{Шаблон проекта для DLM}
library TEST;
{отключаем выравнивание в рекордах}
{$A1}
{устанавливаем расширение файла}
{$E d32}
{включаем оптимизацию}
{$O+}

Uses
    sysutils, 
    rsltype,
    rsldll;


procedure TEST; cdecl;
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


procedure AddModuleObjects(); stdcall;
begin
end;

Exports
  InitExec,
  DoneExec,
  AddModuleObjects;

Begin
// Расположенный здесь код выполняется в первую 
// очередь при каждом вызове DLL любым exe-файлом.
End.
