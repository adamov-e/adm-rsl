{
Набор библиотек на языке Delphi для разработки модулей проблемно-ориентированного языка RSL

  Версия: 1.0.0

  Разработчик: Адамов Ербулат, adamov.e.n@gmail.com
  Дата последней модификации: 2009 год

  Набор разрабатывался автором в учебно-познавательных целях.
  Разрешается свободное использование набора без каких либо ограничений.
  Набор предоставляется как есть, без какой-либо ответственности и претензий к автору.
}

unit termext;

interface
  uses 
    sysutils,
    rsltype;

Type
{Эта таблица для библиотеки выполняемой на терминале}

TRSLCALLTBL = Packed Record
  ptr_toupc:function(ch:LongInt):LongInt; cdecl;
  ptr_stricmpR:function(str1:PChar; str2:PChar):LongInt; cdecl;
  ptr_strnicmpR:function(str1:PChar; str2:PChar; len:LongInt):LongInt; cdecl;
  ptr_toDownc:function(ch:LongInt):LongInt; cdecl;
  ptr_struprR:function(str:PChar):PChar; cdecl;
  ptr_strnuprR:function(str:PChar; len:LongInt):PChar; cdecl;
  ptr_strlwrR:function(str:PChar):PChar; cdecl;
  ptr_strnlwrR:function(str:PChar; len:LongInt):PChar; cdecl;
  ptr_MakeFirstPath:function(Buff:PChar; nfile:PChar; IncDir:PChar; ext:PChar):PChar; cdecl;
  ptr_FindIncFile:function(Buff:PChar; nfile:PChar; IncPath:PChar; ext:PChar; fCurDir:LongInt):LongInt; cdecl;
  ptr_RunPath:function(name:PChar):PChar; cdecl;  //  name должна вмещать полный путь 
  ptr_RslSplitFile:procedure(const fname:PChar; var dir:PChar; var name:PChar; var ext:PChar); cdecl;
  ptr_RslMergeFile:function(var buff:PChar; const dir:PChar; const name:PChar; const ext:PChar):PChar; cdecl;
  ptr_TestExistFile:function(const nfile:PChar):LongInt; cdecl;
  ptr_ReadIniFile:function(name:PChar; fun:LongInt):LongInt; cdecl;
  ptr_RunProg:function(prog:PChar; com:PChar; initmes:PChar; pausemes:PChar; swap_size:LongInt):LongInt; cdecl;
  ptr_MsgBox:procedure(str:PChar; nStr:LongInt); cdecl;
  ptr_ShowMessage:procedure(str:PChar; nStr:LongInt); cdecl;
//bool   (* ptr_sendAsync) (const void *in,size_t sz,const char * tblName,int cmdId);
  ptr_sendAsync:function(inBuff:Pointer; sz:LongWord; tblName:PChar; cmdId:Integer):Boolean; cdecl;
//bool   (* ptr_transactAsync) (const void *in,size_t sz,const char * tblName,int cmdId, void *out,size_t szOut,size_t *szOutPtr,unsigned long timeOut);
  ptr_transactAsync:function(inBuff:Pointer; sz:LongWord; tblName:PChar; cmdId:Integer;  outBuff:Pointer; szOut:LongWord; var szOutPtr:LongWord; timeOut:LongWord):Boolean; cdecl;
//bool   (* ptr_beginAsync) (const void *in,size_t sz,const char * tblName,int cmdId, void *out,size_t szOut,size_t *szOutPtr,TFsComplete *cmplPtr);   
  ptr_beginAsync:function(inBuff:Pointer; sz:LongWord; tblName:PChar; cmdId:Integer; outBuff:Pointer; szOut:LongWord; Var szOutPtr:LongWord; Var cmplPtr:TFsComplete):Boolean; cdecl;
//bool   (* ptr_resultAsync) (TFsComplete *cmplPtr,DWORD timeOut);
  ptr_resultAsync:function(Var cmplPtr:TFsComplete; timeOut:LongWord):Boolean; cdecl;
//void   (* ptr_cancelAsync) (TFsComplete *cmplPtr);
  ptr_cancelAsync:procedure(Var cmplPtr:TFsComplete); cdecl;

end;

  PRSLTBL = ^TRSLCALLTBL;

  BACKENTRY = PRSLTBL;


Var
  ExeExports:BACKENTRY;

Function  RslSetCallBacks(cmd:BACKENTRY):LongInt; stdcall;

Procedure RSLMsgBox(mes:PChar; nmes:LongInt);
Procedure RSLShowMessage(mes:PChar; nmes:LongInt);
Function  RSLSendAsync(inBuff:Pointer; sz:LongWord; tblName:PChar; cmdId:Integer):Boolean;
Function  RSLtransactAsync(inBuff:Pointer; sz:LongWord; tblName:PChar; cmdId:Integer;  outBuff:Pointer; szOut:LongWord; var szOutPtr:LongWord; timeOut:LongWord):Boolean;
Function  RSLbeginAsync(inBuff:Pointer; sz:LongWord; tblName:PChar; cmdId:Integer; outBuff:Pointer; szOut:LongWord; Var szOutPtr:LongWord; Var cmplPtr:TFsComplete):Boolean;
Function  RSLresultAsync(Var cmplPtr:TFsComplete; timeOut:LongWord):Boolean;
Procedure RSLcancelAsync(Var cmplPtr:TFsComplete);

Exports
  RslSetCallBacks;

implementation

function RslSetCallBacks(cmd:BACKENTRY):LongInt;
begin
  ExeExports:=cmd;
  result:=RSL_Version;
end;

procedure RSLMsgBox(mes:PChar; nmes:LongInt);
begin
  ExeExports.ptr_MsgBox(@mes, nmes);
end;

procedure RSLShowMessage(mes:PChar; nmes:LongInt);
begin
  ExeExports.ptr_ShowMessage(@mes, nmes);
end;

Function RSLSendAsync(inBuff:Pointer; sz:LongWord; tblName:PChar; cmdId:Integer):Boolean;
Begin
  Result:=ExeExports.ptr_sendAsync(inBuff, sz, tblName, cmdId);
End;

Function RSLtransactAsync(inBuff:Pointer; sz:LongWord; tblName:PChar; cmdId:Integer;  outBuff:Pointer; szOut:LongWord; var szOutPtr:LongWord; timeOut:LongWord):Boolean;
Begin
  Result:=ExeExports.ptr_transactAsync(inBuff, sz, tblName, cmdId, outBuff, szOut, szOutPtr, timeOut);
End;

Function RSLbeginAsync(inBuff:Pointer; sz:LongWord; tblName:PChar; cmdId:Integer; outBuff:Pointer; szOut:LongWord; Var szOutPtr:LongWord; Var cmplPtr:TFsComplete):Boolean;
Begin
  Result:=ExeExports.ptr_beginAsync(inBuff, sz, tblName, cmdId, outBuff, szOut, szOutPtr, cmplPtr);
End;

Function RSLresultAsync(Var cmplPtr:TFsComplete; timeOut:LongWord):Boolean;
Begin
  Result:=ExeExports.ptr_resultAsync(cmplPtr, timeOut);
End;

Procedure RSLcancelAsync(Var cmplPtr:TFsComplete);
Begin
  ExeExports.ptr_cancelAsync(cmplPtr);
End;

Initialization 

finalization

End.