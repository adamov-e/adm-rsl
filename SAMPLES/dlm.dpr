{������ �஥�� ��� DLM}
library TEST;
{�⪫�砥� ��ࠢ������� � ४�ठ�}
{$A1}
{��⠭�������� ���७�� 䠩��}
{$E d32}
{����砥� ��⨬�����}
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
// ��ᯮ������� ����� ��� �믮������ � ����� 
// ��।� �� ������ �맮�� DLL ��� exe-䠩���.
End.
