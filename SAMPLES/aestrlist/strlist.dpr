library strlist;
{отключаем выравнивание в рекордах}
{$A1}
{устанавливаем расширение файла}
{$E d32}
{включаем оптимизацию}
{$O+}
{отключаем предупреждения}
{$WARNINGS OFF}
{отключаем хинты}
{$HINTS OFF}
{отключаем отладку}
{$DEBUGINFO OFF}

{$DEFINE USE_PROVIDER}

Uses
    rsldll,
    aestrlist;



{*****************************************************************


******************************************************************}

procedure InitExec; stdcall;
begin
end;

procedure DoneExec; stdcall;
begin
end;

function DlmMain(isLoad:Integer; anyL:Pointer):Integer;  stdcall;
begin
  result:=0;
end;

procedure AddModuleObjects(); stdcall;
begin
  RslAddUniClass(aePStringListTable, TRUE);
end;

Exports
InitExec,
DoneExec,
DlmMain,
AddModuleObjects;

End.
