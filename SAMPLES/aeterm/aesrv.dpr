library aesrv;
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
  //получаем указатель на буфер для пересылки данных
  put:=RSLfs_getSendBuff(0, TermDlmName, CMD_aeDisableClose);
  //получать ничего не нада поэтому просто тправляем сообщение
  RSLfs_sendMessage(put);
end;


{*****************************************************************


******************************************************************}

procedure TestTermDLM; cdecl;
  var put:Pointer;
begin
  RSLMsgBox('SERVER TEST', []);
  //получаем указатель на буфер для пересылки данных
  put:=RSLfs_getSendBuff(0, TermDlmName, CMD_TestTerm);
  //Отправляем сообщение и получаем результат
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
