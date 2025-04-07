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
{$DEBUGINFO ON}

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

procedure aeKeyEvent; cdecl;
  var put:PKeybdData;
      get:Pointer;
      v1, v2, v3, v4:PVALUE;
      sz:LongWord;
begin
  RSLGetParm(0, v1);
  RSLGetParm(1, v2);
  RSLGetParm(2, v3);
  RSLGetParm(3, v4);
  //получаем указатель на буфер для пересылки данных
  put:=RSLfs_getSendBuff(SizeOf(TKeybdData), TermDlmName, CMD_aeKeyEvent);
  if (v1.v_type = V_INTEGER) then put.key := v1.intval else RSLError('aeKeyEvent(virtual key)', []);
  if (v2.v_type = V_INTEGER) then put.scan:=v2.intval else put.scan:=0;
  if (v3.v_type = V_INTEGER) then put.flags:=v3.intval else put.flags:=0;
  if (v4.v_type = V_INTEGER) then put.exinfo:=v4.intval else put.exinfo:=0;
  //Отправляем сообщение и получаем результат
  get:=RSLfs_transactMessage(put, sz);
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

procedure aeGetTermDir; cdecl;
var v:PVALUE;
    put:PTxtBuffer512;
    get:PTxtBuffer512;
    sz:LongWord;
    s:String;
begin
  RSLGetParm(0, v);
  if (v.v_type = V_STRING) Then s:=v.RSLString;
  //получаем указатель на буфер для пересылки данных
  put:=RSLfs_getSendBuff(SizeOf(TTxtBuffer512), TermDlmName, CMD_aeGetDir);
  StrLCopy(put.data, PChar(s), SizeOf(put.data));
  //Отправляем сообщение и получаем результат
  get:=RSLfs_transactMessage(put, sz);
  if (sz >= SizeOf(TTxtBuffer512)) Then 
  RSLReturnVal(V_STRING, @get.data[0]);
end;

procedure aeOpenFileDialog; cdecl;
var v1, v2, v3:PVALUE;
    s1, s2, s3:String;
    put:POFNDialog;
    get:PTxtBuffer512;
    sz:LongWord;
begin
  s1:=''; s2:=''; s3:='';
  RSLGetParm(0, v1); RSLGetParm(1, v2); RSLGetParm(2, v3);
  if (v1.v_type = V_STRING) Then Begin s1:=v1.RSLString; End;
  if (v2.v_type = V_STRING) Then Begin s2:=v2.RSLString;  End;
  if (v3.v_type = V_STRING) Then Begin s3:=v3.RSLString;  End;
  //получаем указатель на буфер для пересылки данных
  put:=RSLfs_getSendBuff(SizeOf(TOFNDialog), TermDlmName, CMD_aeOpenFileDialog);
  FillChar(put.Title, SizeOf(put.Title), #0);
  FillChar(put.Path, SizeOf(put.Path), #0);
  FillChar(put.Mask, SizeOf(put.Mask), #0);
  StrLCopy(put.Title, PChar(s1), SizeOf(put.Title));
  StrLCopy(put.Path, PChar(s2), SizeOf(put.Path));
  StrLCopy(put.Mask, PChar(s3), SizeOf(put.Mask));
  //Отправляем сообщение и получаем результат
  get:=RSLfs_transactMessage(put, sz);
  if (sz >= SizeOf(TTxtBuffer512)) Then 
  RSLReturnVal(V_STRING, @get.data[0]);
end;

procedure aeSaveFileDialog; cdecl;
var v1, v2, v3:PVALUE;
    s1, s2, s3:String;
    put:POFNDialog;
    get:PTxtBuffer512;
    sz:LongWord;
begin
  s1:=''; s2:=''; s3:='';
  RSLGetParm(0, v1); RSLGetParm(1, v2); RSLGetParm(2, v3);
  if (v1.v_type = V_STRING) Then Begin s1:=v1.RSLString; End;
  if (v2.v_type = V_STRING) Then Begin s2:=v2.RSLString;  End;
  if (v3.v_type = V_STRING) Then Begin s3:=v3.RSLString;  End;
  //получаем указатель на буфер для пересылки данных
  put:=RSLfs_getSendBuff(SizeOf(TOFNDialog), TermDlmName, CMD_aeSaveFileDialog);
  FillChar(put.Title, SizeOf(put.Title), #0);
  FillChar(put.Path, SizeOf(put.Path), #0);
  FillChar(put.Mask, SizeOf(put.Mask), #0);
  StrLCopy(put.Title, PChar(s1), SizeOf(put.Title));
  StrLCopy(put.Path, PChar(s2), SizeOf(put.Path));
  StrLCopy(put.Mask, PChar(s3), SizeOf(put.Mask));
  //Отправляем сообщение и получаем результат
  get:=RSLfs_transactMessage(put, sz);
  if (sz >= SizeOf(TTxtBuffer512)) Then 
  RSLReturnVal(V_STRING, @get.data[0]);
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
  RSLAddStdProc(V_UNDEF, PChar('aeKeyEvent'), @aeKeyEvent, 0);
  RSLAddStdProc(V_UNDEF, PChar('aeGetTermDir'), @aeGetTermDir, 0);
  RSLAddStdProc(V_UNDEF, PChar('aeOpenFileDialog'), @aeOpenFileDialog, 0);
  RSLAddStdProc(V_UNDEF, PChar('aeSaveFileDialog'), @aeSaveFileDialog, 0);
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
