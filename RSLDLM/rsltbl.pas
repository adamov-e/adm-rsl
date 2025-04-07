{
Набор библиотек на языке Delphi для разработки модулей проблемно-ориентированного языка RSL

  Версия: 1.0.0

  Разработчик: Адамов Ербулат, adamov.e.n@gmail.com
  Дата последней модификации: 2009 год

  Набор разрабатывался автором в учебно-познавательных целях.
  Разрешается свободное использование набора без каких либо ограничений.
  Набор предоставляется как есть, без какой-либо ответственности и претензий к автору.
}

unit rsltbl;

interface
  uses 
    sysutils,
    rsltype;

Type
{Эта таблица для библиотеки выполняемой на сервере}
  TInitRslProvider = function(prvd:PCLNT_PRVD_HANDLE):LongInt; cdecl;
  TDoneRslProvider = procedure(prvd:CLNT_PRVD_HANDLE); cdecl;
{  TCreateRslObject = function(prvd:CLNT_PRVD_HANDLE; typeName:PChar):PGenObject; cdecl;
  TRslTypeProc = function(prvd:CLNT_PRVD_HANDLE; typeName:PChar):PRslTypeInfo; cdecl;
  TRslClassProc = function(prvd:CLNT_PRVD_HANDLE; typeName:PChar):PGenClass; cdecl;}
  fs_asyncProc_t = function(cmd:LongInt; inMes, outMes:Pointer):LongInt;


TRSLCALLTBL = Packed Record
  ptr_Print:function(fmt:PChar):LongInt; cdecl;
  ptr_Message:function(fmt:PChar):LongInt; cdecl;
  ptr_MsgBox:function(fmt:PChar):LongInt; cdecl;
  ptr_GetParm:function(n:LongInt; var val:PVALUE):Boolean; cdecl;
  ptr_PutParm:function(n:LongInt; v_type:VALTYPE; ptr:Pointer):Boolean; cdecl;
  ptr_GetNumParm:function():LongInt; cdecl;
  ptr_ReturnVal:procedure(v_type:VALTYPE; const ptr:Pointer); cdecl;
  ptr_AddSymGlobal:function(v_type:VALTYPE ;name:PChar):PISYMBOL; cdecl;
  ptr_FindSymbolProc:function(name:PChar; sym:SYMPROC):PISYMBOL; cdecl;
  ptr_SymGlobalSet:procedure(sym:PISYMBOL; v_type:VALTYPE; ptr:Pointer); cdecl;
  ptr_SymGlobalGet:procedure(sym:PISYMBOL); cdecl;
  ptr_AddStdProc:function(v_type:VALTYPE ;name:PChar;proc:Pointer;attr:LongInt):PSYMPROC; cdecl;
  ptr_RslError:procedure(fmt:PChar); cdecl;
  ptr_GetStdDataBase:function():PChar; stdcall;
  ptr_GetStdDataPath:function():PChar; stdcall;
  ptr_toupc:function(ch:LongInt):LongInt; cdecl;
  ptr_stricmpR:function(str1:PChar; str2:PChar):LongInt; cdecl;
  ptr_strnicmpR:function(str1:PChar; str2:PChar; len:LongInt):LongInt; cdecl;
  ptr_toDownc:function(ch:LongInt):LongInt; cdecl;
  ptr_struprR:function(str:PChar):PChar; cdecl;
  ptr_strnuprR:function(str:PChar; len:LongInt):PChar; cdecl;
  ptr_strlwrR:function(str:PChar):PChar; cdecl;
  ptr_strnlwrR:function(str:PChar; len:LongInt):PChar; cdecl;
  ptr_MakeFirstPath:function(Buff:PChar; filename:PChar; IncDir:PChar; ext:PChar):PChar; cdecl;
  ptr_FindIncFile:function(Buff:PChar; filename:PChar; IncPath:PChar; ext:PChar; fCurDir:LongInt):LongInt; cdecl;
  ptr_RunPath:function(name:PChar):PChar; cdecl;
  ptr_TestExistFile:function(filename:PChar):LongInt; cdecl;
  ptr_RslSplitFile:procedure(fname:PChar; dir:PChar; name:PChar; ext:PChar); cdecl;
  ptr_RslMergeFile:function(buff:PChar; dir:PChar; name:PChar; ext:PChar):PChar; cdecl;
  ptr_BtOpenDataBase:function(path:PChar; data:PChar; globalPassword:PChar; reportError:LongInt):BDHANDLE; stdcall;
  ptr_BtOpenDataBaseEx:function():BDHANDLE; stdcall;
  ptr_BtCloseDataBase:procedure(db:BDHANDLE); stdcall;
  ptr_BtErrorDialog:procedure(db:BDHANDLE; er:LongInt; show:LongInt); stdcall;
  ptr_BtSetAltColProc:procedure; stdcall;
  ptr_BtSetBlobType:procedure(db:BDHANDLE; tp:LongInt); stdcall;
  ptr_BtCreateTable:function(db:BDHANDLE; strName:PChar; filename:PChar):LongInt; stdcall;
  ptr_BtOpenTable:function(db:BDHANDLE; name:PChar; mode:LongInt; keypath:LongInt; fileName:PChar):BTHANDLE; stdcall;
  ptr_BtCloseTable:procedure(hd:BTHANDLE); stdcall;
  ptr_BtSetLockFlag:procedure(db:BDHANDLE; reclock:LongInt); stdcall;
  ptr_BtSetNoCurChangeFlag:procedure(db:BDHANDLE; isNoChange:LongInt); stdcall;
  ptr_BtGetVarlenInfo:procedure(hd:BTHANDLE; size:Word); stdcall;
  ptr_BtGetVarlenSize:function(hd:BTHANDLE):LongWord; stdcall;
  ptr_BtSetVarlenSize:procedure(hd:BTHANDLE; size:LongWord); stdcall;
  ptr_BtFetchNext:function(hd:BTHANDLE):LongInt; stdcall;
  ptr_BtFetchPrev:function(hd:BTHANDLE):LongInt; stdcall;
  ptr_BtUpdate:function(hd:BTHANDLE):LongInt; stdcall;
  ptr_BtInsert:function(hd:BTHANDLE):LongInt; stdcall;
  ptr_BtDelete:function(hd:BTHANDLE):LongInt; stdcall;
  ptr_BtReset:procedure(hd:BTHANDLE); stdcall;
  ptr_BtGetEQ:function(hd:BTHANDLE):LongInt; stdcall;
  ptr_BtGetGE:function(hd:BTHANDLE):LongInt; stdcall;
  ptr_BtGetLE:function(hd:BTHANDLE):LongInt; stdcall;
  ptr_BtGetPos:function(hd:BTHANDLE; var pos:LongInt):LongInt; stdcall;
  ptr_BtGetDirect:function(hd:BTHANDLE; pos:longint):LongInt; stdcall;
  ptr_BtUnlock:function(hd:BTHANDLE; mode:LongInt; addr:LongWord):LongInt; stdcall;
  ptr_BtGetLastError:function(db:BDHANDLE):LongInt; stdcall;
  ptr_BtBindField:function(hd:BTHANDLE; name:PChar; const data:Pointer; dType:TFVT; len:LongInt):BNDHANDLE; stdcall;
  ptr_BtUnbindField:function(hd:BTHANDLE; id:BNDHANDLE):LongInt; stdcall;
  ptr_BtUnbindAll:procedure(hd:BTHANDLE); stdcall;
  ptr_BtGetFieldID:function(hd:BTHANDLE; name:PChar):LongInt; stdcall;
  ptr_BtGetField:function(hd:BTHANDLE; ind:LongInt; aPtr:Pointer; dType:TFVT; bufLen:LongInt):LongInt; stdcall;
  ptr_BtPutField:function(hd:BTHANDLE; ind:LongInt; aPtr:Pointer; dType:TFVT):LongInt; stdcall;
  ptr_BtBeginTransaction:function(bd:BDHANDLE; flags:LongInt):LongInt; stdcall;
  ptr_BtEndTransaction:function(db:BDHANDLE):LongInt; stdcall;
  ptr_BtAbortTransaction:function(db:BDHANDLE):LongInt; stdcall;
  ptr_BtSetBlobBuffSize:procedure(db:BDHANDLE; size:LongWord); stdcall; // Default 1024
  ptr_BtOpenBlob:function(bf:BTHANDLE;openMode:LongInt):LongInt; stdcall;
  ptr_BtCloseBlob:function(bf:BTHANDLE):LongInt; stdcall;
  ptr_BtReadBlob:function(bf:BTHANDLE; buff:PChar; size:LongInt):LongInt; stdcall;
  ptr_BtWriteBlob:function(bf:BTHANDLE; buff:PChar; size:LongInt):LongInt; stdcall;
  ptr_BtPosBlob:function(bf:BTHANDLE; pos:LongWord):LongInt; stdcall;
  ptr_BtGetBlobSize:function(bf:BTHANDLE; size:PLongWord):LongInt; stdcall;
  ptr_BtTruncateBlob:function(bf:BTHANDLE):LongInt; stdcall;
  ptr_BtErrorText:function(erCode:LongInt):PChar; stdcall;
  ptr_BtStopClient:procedure; stdcall;
  ptr_BtLoopTables:function:LongInt; stdcall;
  ptr_BtGetGT:function(hd:BTHANDLE):LongInt; stdcall;
  ptr_BtGetLT:function(hd:BTHANDLE):LongInt; stdcall;
  ptr_BtChangeKeyPath:function(hd:BTHANDLE; path:LongInt):LongInt; stdcall;
  ptr_AddObjectProviderMod:procedure(init:Pointer; done:Pointer; create:Pointer); cdecl;
  ptr_ValueMake:procedure(val:PVALUE); cdecl;
  ptr_ValueClear:procedure(val:PVALUE); cdecl;
  ptr_ValueCopy:procedure(fromval:PVALUE; toval:PVALUE); cdecl;
  ptr_ValueIseq:function(this:PVALUE; dest:PVALUE):LongInt; cdecl;
  ptr_ValueMove:procedure(fromval:PVALUE; toval:PVALUE); cdecl;
  ptr_ValueSet:procedure(val:PVALUE; v_type:VALTYPE; ptr:Pointer); cdecl;
  ptr_PushValue:function(val:PVALUE):PVALUE; cdecl;
  ptr_PopValue:function():Boolean; cdecl;
  ptr_PutParm2:function(n:LongInt; v:PVALUE):Boolean; stdcall;
  ptr_ReturnVal2:procedure(v:PVALUE); cdecl;
  ptr_LobjInitList:procedure; stdcall;
  ptr_LobjDoneListvoid:procedure; stdcall;
  ptr_LobjRemove:procedure; stdcall;
  ptr_LobjForEach:function:LongInt; stdcall;
  ptr_LobjForEachL:function:LongInt; stdcall;
  ptr_LobjFirstThat:procedure; stdcall;
  ptr_LobjLastThat:procedure; stdcall;
  ptr_LobjNitems:function:LongInt; stdcall;
  ptr_LobjInsert:procedure; stdcall;
  ptr_LobjPrevItem:procedure; stdcall;
  ptr_LobjNextItem:procedure; stdcall;
  ptr_LobjFirstItem:procedure; stdcall;
  ptr_LobjLastItem:procedure; stdcall;
  ptr_SobjInit:procedure; stdcall;
  ptr_SobjUnlink:procedure; stdcall;
  ptr_FindMacro:function(name:PChar):PSYMPROC; cdecl;
  ptr_SwitchToMacro:function(sym:PSYMPROC; n:LongInt):Boolean; cdecl;
  ptr_AddObjectProviderModEx:procedure(init:Pointer; done:Pointer; create:Pointer; tpProc:Pointer); cdecl;
  ptr_UserNumber:function():LongInt; stdcall;
  ptr_RunMacro:function(sym:PSYMPROC):Boolean; cdecl;
  ptr_BtClearRecordBuff:procedure(hd:BTHANDLE); stdcall;
  ptr_fs_screenSize:procedure(var numcols, numrows:LongInt); stdcall;
  ptr_fs_saveStat:function():Pointer; stdcall;
  ptr_fs_restStat:procedure(buff:Pointer); stdcall;
  ptr_fs_event:function(var ev:TFSEvent; waitTime:LongInt):LongInt; stdcall;
  ptr_fs_wrtnatr:procedure(x:LongInt; y:LongInt; number:LongInt; attr:LongInt); cdecl;
  ptr_fs_setattr:procedure(color:LongWord); cdecl;      // Set default attribute
  ptr_fs_curattr:function():LongWord; cdecl;            // Вернуть текущий атрибут    
  ptr_fs_wrtstr:procedure(x:LongInt; y:LongInt; str:PChar); cdecl;
  ptr_fs_wrtncell:procedure(x:LongInt; y:LongInt; number:LongInt; charattr:LongInt); cdecl;
  ptr_fs_gettext:procedure(x1:LongInt; y1:LongInt; x2:LongInt; y2:LongInt; buf:Pointer); cdecl;
  ptr_fs_puttext:procedure(x1:LongInt; y1:LongInt; x2:LongInt; y2:LongInt; buf:Pointer); cdecl;
  ptr_fs_movetext:procedure(x1:LongInt; y1:LongInt; x2:LongInt; y2:LongInt; dx:LongInt; dy:LongInt); stdcall;
  ptr_fs_clr:procedure(ch:LongInt; atr:LongInt); cdecl;
  ptr_fs_bar:procedure(x1:LongInt; y1:LongInt; x2:LongInt; y2:LongInt; ch:LongInt; atr:LongInt); cdecl;
  ptr_fs_box:procedure(style:BORD; attr:LongInt; lcol:LongInt; trow:LongInt; rcol:LongInt; brow:LongInt); cdecl;
  ptr_fs_setcurtype:procedure(cur:LongWord); cdecl;
  ptr_fs_setcurpoz:procedure(x:LongInt; y:LongInt); cdecl;
  ptr_fs_getcurpoz:function(var x, y:LongInt):LongWord; cdecl;
  ptr_fs_version:procedure(var ver:TFsVersion); cdecl;
  ptr_fs_padstr:procedure(x:LongInt; y:LongInt; str:PChar; outlen:LongInt); cdecl;
  ptr_fs_wrtItemStr:procedure(x:LongInt; y:LongInt; str:PChar; outlen:LongInt; selAtr:LongInt); cdecl;
  ptr_fs_wrtMarkStr:procedure(x:LongInt; y:LongInt; str:PChar; outlen:LongInt; num:LongInt; pos:PMarkPos); cdecl;
  ptr_fs_saveStat2:procedure(); stdcall;
  ptr_fs_restStat2:procedure(); stdcall;
  ptr_fs_statLine:procedure(str:PChar; atr:LongInt; selAtr:LongInt); cdecl;
  ptr_fs_getBuffSize:function(x1:LongInt; y1:LongInt; x2:LongInt; y2:LongInt):LongInt; cdecl;
  ptr_fs_event2:function(var ev:TFSEvent; waitTime:LongInt):LongInt; stdcall;
  ptr_fs_screenSize2:procedure(var numcols, numrows:LongInt); stdcall;
  ptr_NWcallEx:function(OP:LongInt; POS_BLK:Pointer; DATA_BUF:Pointer; DATA_LEN:LongInt; KEY_BUF:Pointer; KEY_LEN:LongInt; KEY_NUM:ShortInt; reserved:LongWord):LongInt; cdecl;
  ptr_fs_getDeferBuff:function(sz:LongWord; dllname:PChar; cmd:LongInt):Pointer; cdecl;
  ptr_fs_queueMessage:procedure(mes:Pointer); cdecl;
  ptr_fs_getSendBuff:function(sz:LongWord; dllname:PChar; cmd:LongInt):Pointer; cdecl;
  ptr_fs_sendMessage:procedure(mes:Pointer); cdecl;
  ptr_fs_transactMessage:function(mes:Pointer; var sz:LongWord):Pointer; cdecl;
  ptr_copyToLow:procedure(); cdecl;
  ptr_copyFromLow:procedure(); cdecl;
  ptr_GetLowMem:procedure(); cdecl;
  ptr_FreeLowMem:procedure(); cdecl;
  ptr_ReadIniFile:function:LongInt; cdecl;
  ptr_RunProg:function:LongInt; cdecl;
  ptr_GetParmAttr:function(n:LongInt):LongInt; cdecl;
  ptr_LocRslDlmVersion:function():LongWord; stdcall;
  ptr_LocRslTArrayID:function():LongWord; stdcall;
  ptr_LocRslTArrayCreate:function(rootSize:LongInt; incSize:LongInt):Pointer; stdcall;
  ptr_LocRslTArrayPut:procedure(obj:Pointer; id:LongWord; val:PVALUE); stdcall;
  ptr_LocRslTArrayGet:function():PVALUE; stdcall;
  ptr_LocRslTArraySize:function():LongWord; stdcall;
  ptr_LocInstBuf:function:PChar; stdcall;
  ptr_LociNewMem:function(sz:LongWord):Pointer; stdcall;
  ptr_LociNewMemNull:function(sz:LongWord):Pointer; stdcall;
  ptr_LociDoneMem:procedure(ptr:Pointer); stdcall;
  ptr_LocRslObjGetUniqID:function():LongWord; stdcall;
  ptr_LocRslObjMemberFromID:function:LongInt; stdcall;
  ptr_LocRslObjInvoke:function(pObj:Pointer; id:LongInt; code:LongInt; nPar:LongInt; par:PVALUE; var propORret:VALUE):LongInt; stdcall;
  ptr_LocRslObjMemberFromName:function(pObj:Pointer; name:PChar; var id:LongInt):LongInt; stdcall;
  ptr_LocDoRaiseEvents:procedure; stdcall;
  ptr_LocRslGetInstance:function():Pointer; stdcall;
  ptr_LocRslSetInstance:function():Pointer; stdcall;
  ptr_LocRslLockInstance:function():LongWord; stdcall;
  ptr_LocRslUnLockInstance:function():LongWord; stdcall;
  ptr_LocRslInstGetNumModule:function():LongInt; stdcall;
  ptr_LocRslSendMes:function(mesCode:Integer; ptr:PRSL_SYSTEM_CALL):LongInt; stdcall;
  ptr_LocRslTArrayCnvType:function():Boolean; stdcall;
  ptr_LocRslGetInstSymbol:function(pName:PChar):PISYMBOL; stdcall;
  ptr_LocRslCallInstSymbol:function(sym:PISYMBOL; code:LongInt; nPar:LongInt; par:PVALUE; var propORret:VALUE):Boolean; stdcall;
  ptr_LocRslIsTArray:function():Pointer; stdcall;
  ptr_LocSetSymAttr:procedure(sym:ISYMBOL; attr:LongInt); stdcall;
  ptr_LocRslAddUniClass:function(TablePtr:Pointer; visible:Boolean):Pointer; stdcall;
  ptr_LocCreateObjectOfClass:function:Pointer; stdcall;
  ptr_LocUniObjectInit:procedure; stdcall;
  ptr_LocAddObjectProviderModEx2:procedure(init:Pointer; done:Pointer; create:Pointer; clsProc:Pointer); stdcall;
  ptr_LocRslGetInnerObj:function(pObj:Pointer):Pointer; stdcall;
  ptr_LocGenObjCreateEx:function(typeName:PChar; ctrlObj:Pointer):Pointer; stdcall;
  ptr_LocRslUniPropPtr:function(id:LongInt; tp:PLongInt; stat:PLongInt):PVALUE; stdcall;
  ptr_LocCreateObjectOfClassEx:function(cls:Pointer; outer:Pointer; userObj:Pointer):Pointer; stdcall;
  ptr_LocRslFindUniClass:function(typeName:PChar):Pointer; stdcall;
  ptr_LocRslGetUniClass:function(obj:Pointer):Pointer; stdcall;
  ptr_LocRslUniCast:function(clsName:PChar; obj:Pointer; var userClass:Pointer):Pointer; stdcall;
  ptr_LocBtSetCnvMode:function(hbd:BDHANDLE; mode:LongInt):LongInt; stdcall;
  ptr_LocBtGetErrorInfo:function(bd:BDHANDLE; numInfo:PLongInt):PBtError; stdcall;
  ptr_LocBtOpenDataBaseSimple:function(path:PCHar; data:PChar; rdOnly:LongInt; var erInfo:TBtError):BDHANDLE; stdcall;
  ptr_LocBtGetStructure:function(hd:BDHANDLE; name:PChar):PBtStructure; stdcall;
  ptr_LocBtFreeStructure:procedure(str:PBtStructure); stdcall;
  ptr_LocBtStrGetFieldName:function(str:PBtStructure; nf:LongInt):PChar; stdcall;
  ptr_LocBtStrGetComment:function(str:PBtStructure; nf:LongInt):PChar; stdcall;
  ptr_LocImportModule:function(name:PChar):Integer; stdcall; //int (DLMAPI * ptr_LocImportModule) (const char *name);
  ptr_addDispTable:procedure(name:PChar; p:fs_asyncProc_t); stdcall; //void (DLMAPI *ptr_addDispTable) (const char *name,fs_asyncProc_t p);
  ptr_remDispTable:procedure(name:PChar); stdcall; //void (DLMAPI *ptr_remDispTable) (const char *name);
  ptr_makeEvent:procedure(Var ev:TFSEvent); stdcall; //void (DLMAPI *ptr_makeEvent)    (TFSEvent *ev);
end;

  PRSLTBL = ^TRSLCALLTBL;

  BACKENTRY = PRSLTBL;

Var
  ExeExports:BACKENTRY;

function RslSetCallBacks(cmd:BACKENTRY):LongInt; stdcall;

implementation

Exports
  RslSetCallBacks;

function RslSetCallBacks(cmd:BACKENTRY):LongInt; stdcall;
begin
  ExeExports:=cmd;
  result:=RSL_Version;
end;

initialization

finalization

end.