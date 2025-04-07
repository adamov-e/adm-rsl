{
Набор библиотек на языке Delphi для разработки модулей проблемно-ориентированного языка RSL

  Версия: 1.0.0

  Разработчик: Адамов Ербулат, adamov.e.n@gmail.com
  Дата последней модификации: 2009 год

  Набор разрабатывался автором в учебно-познавательных целях.
  Разрешается свободное использование набора без каких либо ограничений.
  Набор предоставляется как есть, без какой-либо ответственности и претензий к автору.
}

unit btintf;

InterFace
  Uses 
    rsltype,
    rsltbl,
    rsldll;

Const
  // Modes for BtOpenTable
  BT_OPEN_ACCELERATED = -1;
  BT_OPEN_READONLY    = -2;
  BT_OPEN_VERIFY      = -3;
  BT_OPEN_EXCLUSIVE   = -4;
  BT_OPEN_NORMAL      =  0;


  // BLOB types
  BT_NOBLOB    = 0;
  BT_SBLOB     = 1;

  // Modes for BtOpenBlob
  BT_BLOB_READ   = 0;
  BT_BLOB_WRITE  = 1;
  BT_BLOB_RDWR   = 2;

  // Flags for BtBeginTransaction
  BT_TRN_CONCURENT = 1000;

  // Flags for BtSetRecordLock and BtBeginTransaction
  BT_LOCK_SWL = 100;
  BT_LOCK_SNL = 200;
  BT_LOCK_MWL = 300;
  BT_LOCK_MNL = 400;

  // Modes for BtUnlock
  BT_UNLOCK_SINGLE =  0;
  BT_UNLOCK_ONE    = -1;
  BT_UNLOCK_ALL    = -2;


//для работы с таблицами
function  RSLGetStdDataBase():PChar;
function  RSLGetStdDataPath():PChar;
function  RSLBtOpenDataBase(path:PChar; data:PChar; globalPassword:PChar; reportError:LongInt):BDHANDLE;
function  RSLBtOpenTable(db:BDHANDLE; name:PChar; mode:LongInt; keypath:LongInt; fileName:PChar):BTHANDLE;
procedure RSLBtSetBlobType(db:BDHANDLE; tp:LongInt);
function  RSLBtBindField(hd:BTHANDLE; name:PChar; const data:Pointer; dType:TFVT; len:LongInt):BNDHANDLE;
function  RSLBtFetchNext(hd:BTHANDLE):LongInt;
function  RSLBtFetchPrev(hd:BTHANDLE):LongInt;
procedure RSLBtCloseDataBase(db:BDHANDLE);
procedure RSLBtErrorDialog(db:BDHANDLE; er:LongInt; show:LongInt);
function  RSLBtCreateTable(db:BDHANDLE; strName:PChar; fileName:PChar):LongInt;
procedure RSLBtCloseTable(hd:BTHANDLE);
procedure RSLBtSetLockFlag(db:BDHANDLE; reclock:LongInt);
procedure RSLBtSetNoCurChangeFlag(db:BDHANDLE; isNoChange:LongInt);
procedure RSLBtGetVarlenInfo(hd:BTHANDLE; size:Word);
function  RSLBtGetVarlenSize(hd:BTHANDLE):LongWord;
procedure RSLBtSetVarlenSize(hd:BTHANDLE; size:LongWord);
function  RSLBtGetLastError(db:BDHANDLE):LongInt;
function  RSLBtUnlock(hd:BTHANDLE; mode:LongInt; addr:LongWord):LongInt;
function  RSLBtGetDirect(hd:BTHANDLE; pos:longint):LongInt;
function  RSLBtGetPos(hd:BTHANDLE; var pos:LongInt):LongInt;
function  RSLBtGetLE(hd:BTHANDLE):LongInt;
function  RSLBtGetGE(hd:BTHANDLE):LongInt;
function  RSLBtGetEQ(hd:BTHANDLE):LongInt;
procedure RSLBtReset(hd:BTHANDLE);
function  RSLBtDelete(hd:BTHANDLE):LongInt;
function  RSLBtUpdate(hd:BTHANDLE):LongInt;
function  RSLBtInsert(hd:BTHANDLE):LongInt;
function  RSLBtUnbindField(hd:BTHANDLE; id:BNDHANDLE):LongInt;
procedure RSLBtUnbindAll(hd:BTHANDLE);
function  RSLBtGetFieldID(hd:BTHANDLE; name:PChar):LongInt;
function  RSLBtGetField(hd:BTHANDLE; ind:LongInt; aPtr:Pointer; dType:TFVT; bufLen:LongInt):LongInt;
function  RSLBtPutField(hd:BTHANDLE; ind:LongInt; aPtr:Pointer; dType:TFVT):LongInt;
function  RSLBtBeginTransaction(bd:BDHANDLE; flags:LongInt):LongInt;
function  RSLBtEndTransaction(db:BDHANDLE):LongInt;
function  RSLBtAbortTransaction(db:BDHANDLE):LongInt;
procedure RSLBtSetBlobBuffSize(db:BDHANDLE; size:LongWord); // Default 1024
function  RSLBtOpenBlob(bf:BTHANDLE;openMode:LongInt):LongInt;
function  RSLBtCloseBlob(bf:BTHANDLE):LongInt;
function  RSLBtReadBlob(bf:BTHANDLE; buff:PChar; size:LongInt):LongInt;
function  RSLBtWriteBlob(bf:BTHANDLE; buff:PChar; size:LongInt):LongInt;
function  RSLBtPosBlob(bf:BTHANDLE; pos:LongWord):LongInt;
function  RSLBtGetBlobSize(bf:BTHANDLE; size:PLongWord):LongInt;
function  RSLBtTruncateBlob(bf:BTHANDLE):LongInt;
function  RSLBtErrorText(erCode:LongInt):PChar;
procedure RSLBtStopClient;
function  RSLBtLoopTables:LongInt;
function  RSLBtGetGT(hd:BTHANDLE):LongInt;
function  RSLBtGetLT(hd:BTHANDLE):LongInt;
function  RSLBtChangeKeyPath(hd:BTHANDLE; path:LongInt):LongInt;
function  RSLBtSetCnvMode(hbd:BDHANDLE; mode:LongInt):LongInt;
function  RSLBtGetErrorInfo(bd:BDHANDLE; numInfo:PLongInt):PBtError;
function  RSLBtOpenDataBaseSimple(path:PCHar; data:PChar; rdOnly:LongInt; var erInfo:TBtError):BDHANDLE;
function  RSLBtGetStructure(hd:BDHANDLE; name:PChar):PBtStructure;
procedure RSLBtFreeStructure(str:PBtStructure);
function  RSLBtStrGetFieldName(str:PBtStructure; nf:LongInt):PChar;
function  RSLBtStrGetComment(str:PBtStructure; nf:LongInt):PChar;
procedure RSLBtClearRecordBuff(hd:BTHANDLE);


procedure RSLBeginTransaction(); cdecl;
procedure RSLEndTransaction(); cdecl;
procedure RSLAbortTransaction(); cdecl;

Implementation
   Var TrnDB:BDHANDLE;

procedure RSLBeginTransaction();
  var v1, v2:PVALUE;
begin
  RSLGetParm(0, v1);
  RSLGetParm(1, v2);
  if (v1.v_type <> V_STRING) Then RslError('BeginTransaction(db:STRING, mode:INTEGER)', []);
  if (v2.v_type <> V_INTEGER) Then RslError('BeginTransaction(db:STRING, mode:INTEGER)', []);
  TrnDB:=RSLBtOpenDataBase(v1.RSLString, '', NIL, 1);
  RSLBtBeginTransaction(TrnDB, v2.intval);
end;

procedure RSLEndTransaction();
begin
  if (TrnDB <> NIL) Then RSLBtEndTransaction(TrnDB);
end;

procedure RSLAbortTransaction();
begin
  if (TrnDB <> NIL) Then RSLBtAbortTransaction(TrnDB);
end;


procedure RSLBtErrorDialog(db:BDHANDLE; er:LongInt; show:LongInt);
begin
  ExeExports.ptr_BtErrorDialog(db, er, show);
end;

function RSLGetStdDataBase():PChar;
begin
  Result:=ExeExports.ptr_GetStdDataBase();
end;

function RSLGetStdDataPath():PChar;
begin
  Result:=ExeExports.ptr_GetStdDataPath();
end;

function RSLBtOpenDataBase(path:PChar; data:PChar; globalPassword:PChar; reportError:LongInt):BDHANDLE;
begin
  Result:=ExeExports.ptr_BtOpenDataBase(path, data, globalPassword, reportError);
end;

procedure RSLBtCloseDataBase(db:BDHANDLE);
begin
  ExeExports.ptr_BtCloseDataBase(db);
end;

function RSLBtOpenTable(db:BDHANDLE; name:PChar; mode:LongInt; keypath:LongInt; fileName:PChar):BTHANDLE; 
begin
  Result:=ExeExports.ptr_BtOpenTable(db, name, mode, keypath, filename);
end;

function RSLBtCreateTable(db:BDHANDLE; strName:PChar; fileName:PChar):LongInt;
begin
  Result:=ExeExports.ptr_BtCreateTable(db, strName, fileName);
end;

procedure RSLBtCloseTable(hd:BTHANDLE);
begin
  ExeExports.ptr_BtCloseTable(hd);
end;

procedure RSLBtSetBlobType(db:BDHANDLE; tp:LongInt); 
begin
  ExeExports.ptr_BtSetBlobType(db, tp);
end;

function RSLBtBindField(hd:BTHANDLE; name:PChar; const data:Pointer; dType:TFVT; len:LongInt):BNDHANDLE; 
begin
  Result:=ExeExports.ptr_BtBindField(hd, name, data, dType, len);
end;

function RSLBtFetchNext(hd:BTHANDLE):LongInt; 
begin
  Result:=ExeExports.ptr_BtFetchNext(hd);
end;

function RSLBtFetchPrev(hd:BTHANDLE):LongInt;
begin
  Result:=ExeExports.ptr_BtFetchPrev(hd);
end;

procedure RSLBtSetLockFlag(db:BDHANDLE; reclock:LongInt);
begin
  ExeExports.ptr_BtSetLockFlag(db, recLock);
end;

procedure RSLBtSetNoCurChangeFlag(db:BDHANDLE; isNoChange:LongInt);
begin
  ExeExports.ptr_BtSetNoCurChangeFlag(db, isNoChange);
end;

procedure RSLBtGetVarlenInfo(hd:BTHANDLE; size:Word);
begin
  ExeExports.ptr_BtGetVarlenInfo(hd, size);
end;

function RSLBtGetVarlenSize(hd:BTHANDLE):LongWord;
begin
  Result:=ExeExports.ptr_BtGetVarlenSize(hd);
end;

procedure RSLBtSetVarlenSize(hd:BTHANDLE; size:LongWord);
begin
  ExeExports.ptr_BtSetVarlenSize(hd, size);
end;

function RSLBtUpdate(hd:BTHANDLE):LongInt;
begin
  Result:=ExeExports.ptr_BtUpdate(hd);
end;

function RSLBtInsert(hd:BTHANDLE):LongInt;
begin
  Result:=ExeExports.ptr_BtInsert(hd);
end;

function RSLBtDelete(hd:BTHANDLE):LongInt;
begin
  Result:=ExeExports.ptr_BtDelete(hd);
end;

procedure RSLBtReset(hd:BTHANDLE);
begin
  ExeExports.ptr_BtReset(hd);
end;

function RSLBtGetEQ(hd:BTHANDLE):LongInt;
begin
  Result:=ExeExports.ptr_BtGetEQ(hd);
end;

function RSLBtGetGE(hd:BTHANDLE):LongInt;
begin
  Result:=ExeExports.ptr_BtGetGE(hd);
end;

function RSLBtGetLE(hd:BTHANDLE):LongInt;
begin
  Result:=ExeExports.ptr_BtGetLE(hd);
end;

function RSLBtGetPos(hd:BTHANDLE; var pos:LongInt):LongInt;
begin
  Result:=ExeExports.ptr_BtGetPos(hd, pos);
end;

function RSLBtGetDirect(hd:BTHANDLE; pos:longint):LongInt;
begin
  Result:=ExeExports.ptr_BtGetDirect(hd, pos);
end;

function RSLBtUnlock(hd:BTHANDLE; mode:LongInt; addr:LongWord):LongInt;
begin
  Result:=ExeExports.ptr_BtUnlock(hd, mode, addr);
end;

function RSLBtGetLastError(db:BDHANDLE):LongInt;
begin
  Result:=ExeExports.ptr_BtGetLastError(db);
end;

function RSLBtUnbindField(hd:BTHANDLE; id:BNDHANDLE):LongInt;
begin
  Result:=ExeExports.ptr_BtUnbindField(hd, id);
end;

procedure RSLBtUnbindAll(hd:BTHANDLE);
begin
  ExeExports.ptr_BtUnbindAll(hd);
end;

function  RSLBtGetFieldID(hd:BTHANDLE; name:PChar):LongInt;
begin
  Result:=ExeExports.ptr_BtGetFieldID(hd, name);
end;

function  RSLBtGetField(hd:BTHANDLE; ind:LongInt; aPtr:Pointer; dType:TFVT; bufLen:LongInt):LongInt;
begin
  Result:=ExeExports.ptr_BtGetField(hd, ind, aPtr, dType, buflen);
end;

function  RSLBtPutField(hd:BTHANDLE; ind:LongInt; aPtr:Pointer; dType:TFVT):LongInt;
begin
  Result:=ExeExports.ptr_BtPutField(hd, ind, aPtr, dType);
end;

function  RSLBtBeginTransaction(bd:BDHANDLE; flags:LongInt):LongInt;
begin
  Result:=ExeExports.ptr_BtBeginTransaction(bd, flags);
end;

function  RSLBtEndTransaction(db:BDHANDLE):LongInt;
begin
  Result:=ExeExports.ptr_BtEndTransaction(db);
end;

function  RSLBtAbortTransaction(db:BDHANDLE):LongInt;
begin
  Result:=ExeExports.ptr_BtAbortTransaction(db);
end;

procedure RSLBtSetBlobBuffSize(db:BDHANDLE; size:LongWord); // Default 1024
begin
  ExeExports.ptr_BtSetBlobBuffSize(db, size);
end;

function  RSLBtOpenBlob(bf:BTHANDLE; openMode:LongInt):LongInt;
begin
  Result:=ExeExports.ptr_BtOpenBlob(bf, openMode);
end;

function  RSLBtCloseBlob(bf:BTHANDLE):LongInt;
begin
  Result:=ExeExports.ptr_BtCloseBlob(bf);
end;

function  RSLBtReadBlob(bf:BTHANDLE; buff:PChar; size:LongInt):LongInt;
begin
  Result:=ExeExports.ptr_BtReadBlob(bf, buff, size);
end;

function  RSLBtWriteBlob(bf:BTHANDLE; buff:PChar; size:LongInt):LongInt;
begin
  Result:=ExeExports.ptr_BtWriteBlob(bf, buff, size);
end;

function  RSLBtPosBlob(bf:BTHANDLE; pos:LongWord):LongInt;
begin
  Result:=ExeExports.ptr_BtPosBlob(bf, pos);
end;

function  RSLBtGetBlobSize(bf:BTHANDLE; size:PLongWord):LongInt;
begin
  Result:=ExeExports.ptr_BtGetBlobSize(bf, size);
end;

function  RSLBtTruncateBlob(bf:BTHANDLE):LongInt;
begin
  Result:=ExeExports.ptr_BtTruncateBlob(bf);
end;

function  RSLBtErrorText(erCode:LongInt):PChar;
begin
  Result:=ExeExports.ptr_BtErrorText(erCode);
end;

procedure RSLBtStopClient();
begin
  ExeExports.ptr_BtStopClient();
end;

function  RSLBtLoopTables():LongInt;
begin
  Result:=ExeExports.ptr_BtLoopTables();
end;

function  RSLBtGetGT(hd:BTHANDLE):LongInt;
begin
  Result:=ExeExports.ptr_BtGetGT(hd);
end;

function  RSLBtGetLT(hd:BTHANDLE):LongInt;
begin
  Result:=ExeExports.ptr_BtGetLT(hd);
end;

function  RSLBtChangeKeyPath(hd:BTHANDLE; path:LongInt):LongInt;
begin
  Result:=ExeExports.ptr_BtChangeKeyPath(hd, path);
end;

function  RSLBtSetCnvMode(hbd:BDHANDLE; mode:LongInt):LongInt;
begin
  Result:=ExeExports.ptr_LocBtSetCnvMode(hbd, mode);
end;

function  RSLBtGetErrorInfo(bd:BDHANDLE; numInfo:PLongInt):PBtError;
begin
  Result:=ExeExports.ptr_LocBtGetErrorInfo(bd, numInfo);
end;

function  RSLBtOpenDataBaseSimple(path:PCHar; data:PChar; rdOnly:LongInt; var erInfo:TBtError):BDHANDLE;
begin
  Result:=ExeExports.ptr_LocBtOpenDataBaseSimple(path, data, rdOnly, erInfo);
end;

function  RSLBtGetStructure(hd:BDHANDLE; name:PChar):PBtStructure;
begin
  Result:=ExeExports.ptr_LocBtGetStructure(hd, name);
end;

procedure RSLBtFreeStructure(str:PBtStructure);
begin
  ExeExports.ptr_LocBtFreeStructure(str);
end;

function  RSLBtStrGetFieldName(str:PBtStructure; nf:LongInt):PChar;
begin
  Result:=ExeExports.ptr_LocBtStrGetFieldName(str, nf);
end;

function  RSLBtStrGetComment(str:PBtStructure; nf:LongInt):PChar;
begin
  Result:=ExeExports.ptr_LocBtStrGetComment(str, nf);
end;

procedure RSLBtClearRecordBuff(hd:BTHANDLE);
begin
  ExeExports.ptr_BtClearRecordBuff(hd);
end;

Initialization

TrnDB:=NIL;

Finalization

End.