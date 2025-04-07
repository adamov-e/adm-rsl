library aesrv;
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

Uses
    sysutils, 
    rsltype,
    rsldll,
    aeconst,
    aeclip,
    aeprint;

procedure aeDisableClose; cdecl;
  var put:Pointer;
begin
  //�������� ��������� �� ����� ��� ��������� ������
  put:=RSLfs_getSendBuff(0, TermDlmName, CMD_aeDisableClose);
  //�������� ������ �� ���� ������� ������ ��������� ���������
  RSLfs_sendMessage(put);
end;


{*****************************************************************


******************************************************************}

procedure TestTermDLM; cdecl;
  var put:Pointer;
begin
  RSLMsgBox('SERVER TEST', []);
  //�������� ��������� �� ����� ��� ��������� ������
  put:=RSLfs_getSendBuff(0, TermDlmName, CMD_TestTerm);
  //���������� ��������� � �������� ���������
  RSLfs_sendMessage(put);
end;


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
  RSLAddStdProc(V_UNDEF, PChar('aeDisableClose'), @aeDisableClose, 0);
  //
  RSLAddStdProc(V_UNDEF, PChar('TestTermDLM'), @TestTermDLM, 0);

  RslAddUniClass(PaeClipboardTable, TRUE);
  RslAddUniClass(PaePrinterTable, TRUE);
end;

Exports
  InitExec,
  DoneExec,
  DlmMain,
  AddModuleObjects;

End.
