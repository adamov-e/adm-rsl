library strlist;
{��������� ������������ � ��������}
{$A1}
{������������� ���������� �����}
{$E d32}
{�������� �����������}
{$O+}
{��������� ��������������}
{$WARNINGS OFF}
{��������� �����}
{$HINTS OFF}
{��������� �������}
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
