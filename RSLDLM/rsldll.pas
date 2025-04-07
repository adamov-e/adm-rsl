{
����� ��������� �� ����� Delphi ��� ���������� ������� ���������-���������������� ����� RSL

  ������: 1.0.0

  �����������: ������ �������, adamov.e.n@gmail.com
  ���� ��������� �����������: 2009 ���

  ����� �������������� ������� � ������-�������������� �����.
  ����������� ��������� ������������� ������ ��� ����� ���� �����������.
  ����� ��������������� ��� ����, ��� �����-���� ��������������� � ��������� � ������.
}

unit RSLdll;

interface
  uses
    rsltype,
    rsltbl;

//std stack rutines
function  RSLPrint(fmt:PChar;args:array of pointer):LongInt;
function  RSLPrintC(fmt:PChar;args:array of const):LongInt;
function  RSLMessage(fmt:PChar;args:array of pointer):LongInt;
function  RSLMessageC(fmt:PChar;args:array of const):LongInt;
function  RSLMsgBox(fmt:PChar;args:array of pointer):LongInt;
function  RSLMsgBoxC(fmt:PChar;args:array of const):LongInt;
procedure RSLError(fmt:PChar;args:array of pointer);
procedure RSLErrorC(fmt:PChar;args:array of const);
function  RSLUserNumber():LongInt;
function  RSLVersion():Word;
function  RSLGetNumParm():LongInt;
function  RSLPutParm(n:LongInt; v_type:VALTYPE; ptr:Pointer):Boolean;
function  RSLGetParm(n:LongInt; var val:PVALUE):Boolean;
procedure RSLReturnVal(v_type:VALTYPE; ptr:Pointer); Overload;
procedure RSLReturnVal(ptr:Integer); Overload;
procedure RSLReturnVal(ptr:String); Overload;
procedure RSLReturnVal(ptr:Double); Overload;
procedure RSLReturnVal(ptr:Extended); Overload;
procedure RSLReturnVal(ptr:Boolean); Overload;
procedure RSLReturnVal(ptr:Longword); Overload;
procedure RSLReturnVal(ptr:Byte); Overload;
procedure RSLReturnVal(ptr:Word); Overload;
procedure RSLReturnVal(ptr:Real); Overload;
function  RSLAddStdProc(v_type:VALTYPE ;name:PChar;proc:Pointer;attr:LongInt):PSYMPROC;
//������ �� ��������
function  RSLStricmpR(str1:PChar; str2:PChar):LongInt;
function  RSLStrUprR(str1:PChar):PChar;
function  RSLStrLwrR(str1:PChar):PChar;
//��� ������ � ����������� RSL
procedure RSLValueMake(val:PVALUE);
procedure RSLValueClear(val:PVALUE);
procedure RSLValueCopy(fromval:PVALUE; toval:PVALUE);
function  RSLValueIseq(this:PVALUE; dest:PVALUE):LongInt;
procedure RSLValueMove(fromval:PVALUE; toval:PVALUE);
procedure RSLValueSet(val:PVALUE; v_type:VALTYPE; ptr:Pointer);Overload;
procedure RSLValueSet(val:PVALUE; ptr:Integer); Overload;
procedure RSLValueSet(val:PVALUE; ptr:Longword); Overload;
procedure RSLValueSet(val:PVALUE; ptr:Boolean); Overload;
procedure RSLValueSet(val:PVALUE; ptr:String); Overload;
procedure RSLValueSet(val:PVALUE; ptr:Double); Overload;
procedure RSLValueSet(val:PVALUE; ptr:Real); Overload;
procedure RSLValueSet(val:PVALUE; ptr:Extended); Overload;
procedure RSLValueSet(val:PVALUE; ptr:Byte); Overload;
procedure RSLValueSet(val:PVALUE; ptr:Word); Overload;
function  RSLPushValue(val:PVALUE):PVALUE;
function  RSLPopValue():Boolean;
function  RSLPutParm2(n:LongInt; v:PVALUE):Boolean;
procedure RSLReturnVal2(v:PVALUE);
//
function  RslGetInstSymbol(pName:PChar):PISYMBOL;
function  RslCallInstSymbol(sym:PISYMBOL; code:LongInt; nPar:LongInt; par:PVALUE; var propORret:VALUE):Boolean;
function  RSLFindMacro(name:PChar):PSYMPROC;
function  RSLRunMacro(sym:PSYMPROC; args:array of pointer):Boolean;
function  RSLRunMacroC(sym:PSYMPROC; arglist:array of const):Boolean;
//sym:PSYMPROC;
function  RSLTestExistFile(filename:PChar):LongInt;
procedure RslSplitFile(fname:PChar; var dir:PChar; var name:PChar; var ext:PChar);
function  RslMergeFile(var buff:PChar; dir:PChar; name:PChar; ext:PChar):PChar;
//
function  RSLfs_getDeferBuff(sz:LongWord; dllname:PChar; cmd:LongInt):Pointer;
procedure RSLfs_queueMessage(mes:Pointer); 
function  RSLfs_getSendBuff(sz:LongWord; dllname:PChar; cmd:LongInt):Pointer;
procedure RSLfs_sendMessage(mes:Pointer);
function  RSLfs_transactMessage(mes:Pointer; var sz:LongWord):Pointer;
//
function  RSLiNewMem(sz:LongWord):Pointer;
function  RSLiNewMemNULL(sz:LongWord):Pointer;
procedure RSLiDoneMem(ptr:Pointer);
//��� ������ � ������������
procedure RSLAddObjectProviderMod(init:Pointer; done:Pointer; create:Pointer);
procedure RSLAddObjectProviderModEx(init:Pointer; done:Pointer; create:Pointer; tpProc:Pointer);
function  RslAddUniClass(TablePtr:Pointer; visible:Boolean):Pointer;
//
function  RSLGetInnerObj(pObj:Pointer):Pointer;
function  RSLObjInvoke(pObj:Pointer; id:LongInt; code:LongInt; nPar:LongInt; par:PVALUE; var propORret:VALUE):LongInt;
function  RSLObjMemberFromName(pObj:Pointer; name:PChar; var id:LongInt):LongInt;
function  RSLUniCast(clsName:PChar; obj:Pointer; var userClass:Pointer):Pointer;
//
function  RSLAddSymGlobal(v_type:VALTYPE ;name:PChar):PISYMBOL;
procedure RSLSymGlobalSet(sym:PISYMBOL; v_type:VALTYPE; ptr:Pointer); overload;
procedure RSLSymGlobalSet(sym:PISYMBOL; ptr:Integer); overload;
procedure RSLSymGlobalSet(sym:PISYMBOL; ptr:String); overload;
procedure RSLSymGlobalSet(sym:PISYMBOL; ptr:Boolean); overload;
procedure RSLSymGlobalSet(sym:PISYMBOL; ptr:Double); overload;
procedure RSLSymGlobalSet(sym:PISYMBOL; ptr:Extended); overload;
procedure RSLSymGlobalGet(sym:PISYMBOL);
//
Procedure RSLaddDispTable(name:PChar; p:fs_asyncProc_t);
Procedure RSLremDispTable(name:PChar);

Implementation

//Std stack routines
{**************************************************

******************************************************}

function RSLPrint(fmt:PChar; args:array of pointer):LongInt;
begin
  result:=ExeExports.ptr_Print(fmt);
end;

function RSLPrintC(fmt:PChar; args:array of const):LongInt;
var
  i: Integer;
  p: Pointer;
begin
  for i:= high(args) downto 0 do
  begin
    with args[i] do
      case VType of
        vtInt64:      p:=Pointer(VInt64);
        vtInteger:    p:=Pointer(VInteger);
        vtExtended:   p:=Pointer(VExtended);
        vtString:     p:=Pointer(VString);
        vtPChar:      p:=Pointer(VPChar);
        vtAnsiString: p:=VAnsiString;
        vtBoolean:    p:=Pointer(vBoolean);
        vtPointer:    p:=VPointer;
        vtChar:       p:=Addr(VChar);
        vtCurrency:   p:=VCurrency;
        vtObject:     p:=VObject;
        vtWideChar:   p:=Addr(VWideChar);
        vtPWideChar:  p:=Pointer(VPWideChar);
        vtWideString: p:=Pointer(VWideString);
      else continue;
      end;
    asm
      push p
    end;
  end;
  result:=ExeExports.ptr_Print(fmt);
end;

function RSLMessage(fmt:PChar; args:array of pointer):LongInt;
begin
  result:=ExeExports.ptr_Message(fmt);
end;

function RSLMessageC(fmt:PChar; args:array of const):LongInt;
var
  i: Integer;
  p: Pointer;
begin
  for i:= high(args) downto 0 do
  begin
    with args[i] do
      case VType of
        vtInt64:      p:=Pointer(VInt64);
        vtInteger:    p:=Pointer(VInteger);
        vtExtended:   p:=Pointer(VExtended);
        vtString:     p:=Pointer(VString);
        vtPChar:      p:=Pointer(VPChar);
        vtAnsiString: p:=VAnsiString;
        vtBoolean:    p:=Addr(vBoolean);
        vtPointer:    p:=VPointer;
        vtChar:       p:=Addr(VChar);
        vtCurrency:   p:=VCurrency;
        vtObject:     p:=VObject;
        vtWideChar:   p:=Addr(VWideChar);
        vtPWideChar:  p:=Pointer(VPWideChar);
        vtWideString: p:=Pointer(VWideString);
      else continue;
      end;
    asm
      push p
    end;
  end;
  result:=ExeExports.ptr_Message(fmt);
end;

function RSLMsgBox(fmt:PChar; args:array of pointer):LongInt; 
begin
result:=ExeExports.ptr_MsgBox(fmt);
end;

function RSLMsgBoxC(fmt:PChar; args:array of const):LongInt; 
var
  i: Integer;
  p: Pointer;
begin
  for i:= high(args) downto 0 do
  begin
    with args[i] do
      case VType of
        vtInt64:      p:=Pointer(VInt64);
        vtInteger:    p:=Pointer(VInteger);
        vtExtended:   p:=Pointer(VExtended);
        vtString:     p:=Pointer(VString);
        vtPChar:      p:=Pointer(VPChar);
        vtAnsiString: p:=VAnsiString;
        vtBoolean:    p:=Pointer(vBoolean);
        vtPointer:    p:=VPointer;
        vtChar:       p:=Addr(VChar);
        vtCurrency:   p:=VCurrency;
        vtObject:     p:=VObject;
        vtWideChar:   p:=Addr(VWideChar);
        vtPWideChar:  p:=Pointer(VPWideChar);
        vtWideString: p:=Pointer(VWideString);
      else continue;
      end;
    asm
      push p
    end;
  end;
result:=ExeExports.ptr_MsgBox(fmt);
end;

procedure RSLError(fmt:PChar; args:array of pointer);
begin
  ExeExports.ptr_RslError(fmt);
end;

procedure RSLErrorC(fmt:PChar;args:array of const);
var
  i: Integer;
  p: Pointer;
begin
  for i:= high(args) downto 0 do
  begin
    with args[i] do
      case VType of
        vtInt64:      p:=Pointer(VInt64);
        vtInteger:    p:=Pointer(VInteger);
        vtExtended:   p:=Pointer(VExtended);
        vtString:     p:=Pointer(VString);
        vtPChar:      p:=Pointer(VPChar);
        vtAnsiString: p:=VAnsiString;
        vtBoolean:    p:=Addr(vBoolean);
        vtPointer:    p:=VPointer;
        vtChar:       p:=Addr(VChar);
        vtCurrency:   p:=VCurrency;
        vtObject:     p:=VObject;
        vtWideChar:   p:=Addr(VWideChar);
        vtPWideChar:  p:=Pointer(VPWideChar);
        vtWideString: p:=Pointer(VWideString);
      else continue;
      end;
    asm
      push p
    end;
  end;
  ExeExports.ptr_RslError(fmt);
end;

function RSLGetParm(n:LongInt; var val:PVALUE):Boolean;
begin
  Result:=ExeExports.ptr_GetParm(n, val);
end;

function RSLPutParm(n:LongInt; v_type:VALTYPE; ptr:Pointer):Boolean;
begin
  Result:=ExeExports.ptr_PutParm(n, v_type, ptr);
end;

function RSLGetNumParm():LongInt; 
begin
  Result:=ExeExports.ptr_GetNumParm();
end;

procedure RSLReturnVal(v_type:VALTYPE; ptr:Pointer);
begin
  ExeExports.ptr_ReturnVal(v_type, ptr);
end;

procedure RSLReturnVal(ptr:Integer);
begin
  ExeExports.ptr_ReturnVal(V_INTEGER, Addr(ptr));
end;

procedure RSLReturnVal(ptr:String);
begin
  ExeExports.ptr_ReturnVal(V_STRING, PChar(ptr));
end;

procedure RSLReturnVal(ptr:Double);
begin
  ExeExports.ptr_ReturnVal(V_DOUBLE, Addr(ptr));
end;

procedure RSLReturnVal(ptr:Extended);
begin
  ExeExports.ptr_ReturnVal(V_DOUBLEL, Addr(ptr));
end;

procedure RSLReturnVal(ptr:Boolean);
begin
  ExeExports.ptr_ReturnVal(V_BOOL, Addr(ptr));
end;

procedure RSLReturnVal(ptr:LongWord);
begin
  ExeExports.ptr_ReturnVal(V_INTEGER, Addr(ptr));
end;

procedure RSLReturnVal(ptr:Byte);
begin
  ExeExports.ptr_ReturnVal(V_INTEGER, Addr(ptr));
end;

procedure RSLReturnVal(ptr:Word);
begin
  ExeExports.ptr_ReturnVal(V_INTEGER, Addr(ptr));
end;

procedure RSLReturnVal(ptr:Real);
begin
  ExeExports.ptr_ReturnVal(V_DOUBLE, Addr(ptr));
end;

function RSLUserNumber():LongInt;
begin
  result:=ExeExports.ptr_UserNumber();
end;

function RSLVersion():Word;
begin;
  Result:=ExeExports.ptr_LocRslDlmVersion();
end;

function RSLAddStdProc(v_type:VALTYPE; name:PChar; proc:Pointer; attr:LongInt):PSYMPROC;
begin
  Result:=ExeExports.ptr_AddStdProc(v_type, name, proc, attr);
end;

function  RSLStricmpR(str1:PChar; str2:PChar):LongInt; 
begin
  Result:=ExeExports.ptr_stricmpR(str1, str2);
end;

function  RSLStrUprR(str1:PChar):PChar; 
begin
  Result:=ExeExports.ptr_struprR(str1);
end;

function  RSLStrLwrR(str1:PChar):PChar; 
begin
  Result:=ExeExports.ptr_strlwrR(str1);
end;

{******************************************


*********************************************}

procedure RSLAddObjectProviderMod(init:Pointer; done:Pointer; create:Pointer);
begin
  ExeExports.ptr_AddObjectProviderMod(init, done, create);
end;

procedure RSLAddObjectProviderModEx(init:Pointer; done:Pointer; create:Pointer; tpProc:Pointer);
begin
  ExeExports.ptr_AddObjectProviderModEx(init, done, create, tpProc); 
end;

function RslAddUniClass(TablePtr:Pointer; visible:Boolean):Pointer;
begin
  Result:=ExeExports.ptr_LocRslAddUniClass(TablePtr, visible);
end;

{**************************************************

******************************************************}

procedure RSLValueMake(val:PVALUE);
begin
  ExeExports.ptr_ValueMake(val);
end;

procedure RSLValueClear(val:PVALUE);
begin
  ExeExports.ptr_ValueClear(val);
end;

procedure RSLValueCopy(fromval:PVALUE; toval:PVALUE);
begin
  ExeExports.ptr_ValueCopy(fromval, toval);
end;

function  RSLValueIseq(this:PVALUE; dest:PVALUE):LongInt;
begin
  Result:=ExeExports.ptr_ValueIseq(this, dest);
end;

procedure RSLValueMove(fromval:PVALUE; toval:PVALUE);
begin
  ExeExports.ptr_ValueMove(fromval, toval);
end;

procedure RSLValueSet(val:PVALUE; v_type:VALTYPE; ptr:Pointer);
begin
  ExeExports.ptr_ValueSet(val, v_type, ptr);
end;

procedure RSLValueSet(val:PVALUE; ptr:Integer);
begin
  ExeExports.ptr_ValueSet(val, V_INTEGER, Addr(ptr));
end;

procedure RSLValueSet(val:PVALUE; ptr:String);
begin
  ExeExports.ptr_ValueSet(val, V_STRING, PChar(ptr));
end;

procedure RSLValueSet(val:PVALUE; ptr:Byte);
begin
  ExeExports.ptr_ValueSet(val, V_INTEGER, Addr(ptr));
end;

procedure RSLValueSet(val:PVALUE; ptr:Word);
begin
  ExeExports.ptr_ValueSet(val, V_INTEGER, Addr(ptr));
end;

procedure RSLValueSet(val:PVALUE; ptr:Real);
begin
  ExeExports.ptr_ValueSet(val, V_DOUBLE, Addr(ptr));
end;

procedure RSLValueSet(val:PVALUE; ptr:Double);
begin
  ExeExports.ptr_ValueSet(val, V_DOUBLE, Addr(ptr));
end;

procedure RSLValueSet(val:PVALUE; ptr:Extended);
begin
  ExeExports.ptr_ValueSet(val, V_DOUBLEL, Addr(ptr));
end;

procedure RSLValueSet(val:PVALUE; ptr:Boolean);
begin
  ExeExports.ptr_ValueSet(val, V_BOOL, Addr(ptr));
end;

procedure RSLValueSet(val:PVALUE; ptr:LongWord);
begin
  ExeExports.ptr_ValueSet(val, V_INTEGER, Addr(ptr));
end;

function  RSLPushValue(val:PVALUE):PVALUE;
begin
  Result:=ExeExports.ptr_PushValue(val);
end;

function  RSLPopValue():Boolean;
begin
  Result:=ExeExports.ptr_PopValue();
end;

function  RSLPutParm2(n:LongInt; v:PVALUE):Boolean;
begin
  Result:=ExeExports.ptr_PutParm2(n, v);
end;

procedure RSLReturnVal2(v:PVALUE);
begin
  ExeExports.ptr_ReturnVal2(v);
end;

{********************************************************************

*********************************************************************}

function RslGetInstSymbol(pName:PChar):PISYMBOL;
begin
  Result:=ExeExports.ptr_LocRslGetInstSymbol(pName);
end;

function RslCallInstSymbol(sym:PISYMBOL; code:LongInt; nPar:LongInt; par:PVALUE; var propORret:VALUE):Boolean;
begin
  Result:=ExeExports.ptr_LocRslCallInstSymbol(sym, code, nPar, par, propORret);
end;

function RSLFindMacro(name:PChar):PSYMPROC;
begin
  Result:=ExeExports.ptr_FindMacro(name);
end;

{ ������ ������
RSLRunMacro(ChangeNotifyMacro,
[Pointer(V_INTEGER), @j, Pointer(V_BOOL), @i, Pointer(V_STRING), PChar('TEST'), Pointer(V_ENDLIST)]);
}
function RSLRunMacro(sym:PSYMPROC; args:array of pointer):Boolean;
var i:Integer;
    p:Pointer;
Begin
  for i:= high(args) downto 0 do
  begin
    p:=args[i];
    asm
      push p
    end;
  end;
  Result:=ExeExports.ptr_RunMacro(sym);
End;
{������ ������
RSLRunMacroConst(ChangeNotifyMacro,
[Pointer(V_INTEGER), j, Pointer(V_BOOL), i, Pointer(V_STRING), 'TEST', Pointer(V_ENDLIST)]);
}
function RSLRunMacroC(sym:PSYMPROC; arglist:array of const):Boolean;
var
  i: Integer;
  p: Pointer;
begin
  for i:= high(arglist) downto 0 do
  begin
    with arglist[i] do
      case VType of
        vtInt64:      p:=Pointer(VInt64);
        vtInteger:    p:=Addr(VInteger);
        vtExtended:   p:=Pointer(VExtended);
        vtString:     p:=Pointer(VString);
        vtPChar:      p:=Pointer(VPChar);
        vtAnsiString: p:=VAnsiString;
        vtBoolean:    p:=Addr(vBoolean);
        vtPointer:    p:=VPointer;
        vtChar:       p:=Addr(VChar);
        vtCurrency:   p:=VCurrency;
        vtObject:     p:=VObject;
        vtWideChar:   p:=Addr(VWideChar);
        vtPWideChar:  p:=Pointer(VPWideChar);
        vtWideString: p:=Pointer(VWideString);
      else continue;
      end;
    asm
      push p
    end;
  end;
  Result:=ExeExports.ptr_RunMacro(sym);
end;

{********************************************************************

*********************************************************************}
function RSLTestExistFile(filename:PChar):LongInt;
begin
  Result:=ExeExports.ptr_TestExistFile(filename);
end;

procedure RslSplitFile(fname:PChar; var dir:PChar; var name:PChar; var ext:PChar);
begin
  ExeExports.ptr_RslSplitFile(fname, dir, name, ext);
end;

function RslMergeFile(var buff:PChar; dir:PChar; name:PChar; ext:PChar):PChar;
begin
  Result:=ExeExports.ptr_RslMergeFile(buff, dir, name, ext);
end;

{********************************************************************

*********************************************************************}

function  RSLfs_getDeferBuff(sz:LongWord; dllname:PChar; cmd:LongInt):Pointer; 
begin
  Result:=ExeExports.ptr_fs_getDeferBuff(sz, dllname, cmd);
end;

procedure RSLfs_queueMessage(mes:Pointer); 
begin
  ExeExports.ptr_fs_queueMessage(mes);
end;

function  RSLfs_getSendBuff(sz:LongWord; dllname:PChar; cmd:LongInt):Pointer;
begin
  Result:=ExeExports.ptr_fs_getSendBuff(sz, dllname, cmd);
end;

procedure RSLfs_sendMessage(mes:Pointer);
begin
  ExeExports.ptr_fs_sendMessage(mes);
end;

function  RSLfs_transactMessage(mes:Pointer; var sz:LongWord):Pointer;
begin
  Result:=ExeExports.ptr_fs_transactMessage(mes, sz);
end;

{********************************************************************

*********************************************************************}
{�������� ������ �������� size ���� �� ���� � EXE �����, ����������� DLM.
��� �������� ������ ���������� ������ RSL ������� ����������.}
function RSLiNewMem(sz:LongWord):Pointer;
begin
  Result:=ExeExports.ptr_LociNewMem(sz);
end;
{�������� ������ �������� size ���� �� ���� � EXE �����, ����������� DLM.
��� �������� ������ ���������� NULL.}
function RSLiNewMemNULL(sz:LongWord):Pointer;
begin
  Result:=ExeExports.ptr_LociNewMemNull(sz);
end;
{����������� ������, ���������� ��� ������ ������� iNewMem � iNewMemNull}
procedure RSLiDoneMem(ptr:Pointer);
begin
  ExeExports.ptr_LociDoneMem(ptr);
end;

{********************************************************************

*********************************************************************}

{���� ��� �������� ������� ��� ������ ������� GenObjCreateEx ��� 
CreateObjectOfClass ������ ������������ ������, �� ����� ������ ���������, 
��� ������� ��������. � ���� ������ ������ �������������� ������� � 
���������� ���������. ������� �������� ���������� ��������� �� ������� ������.
������� RslGetInnerObj ���������� ��������� �� ���������� ������ �� ��������� 
� �������� ��������� �������� �������.

���������� ��� ���������� ������ ��� ������ ADDREF ���
RELEASE ����� ��������� �������� ������� �� ����� ���� ������
������� ������ ������������� �������. 

����� ��������� ����� ������, ��� ���������� ������� ������ ��������������� 
� 1. ������� ������ ������������� ������� ��� �������� �� �������������.
��� �������� �������-�������� �������� ���������� ������� RELEASE ��� ���������� 
�������.}

function RSLGetInnerObj(pObj:Pointer):Pointer;
begin
  Result:=ExeExports.ptr_LocRslGetInnerObj(pObj);
end;

{��������� ��������� ������� �����, ���������� ����� �������� �������� ���
��������� �������� �������� ��� ������� pObj. 

id ������ ������������� ������ �����������, ���������� ��� ������ 
RslObjMemberFromName.

code ���������� �������, ������� ���������� ���������. 
����� ��������� ���� �� ��������� ��������:

RSL_DISP_RUN     - ������� �����;
RSL_DISP_GET     - ��������� �������� ��������;
RSL_DISP_SET     - �������� ����� �������� ��������;
RSL_DISP_GET_OR_RUN - ��������� �������� �������� ��� ������� �����.

nPar ������ ���������� ���������� ������������ ������ ��� ��������
par - ������ ����������.
                                                               
propORret - ���� code ����� RSL_DISP_SET �������� ����� �������� ��� ��������.
� ��������� ������� ���� ������������ �������� �������� ��� ������.
                                                                   

��� �������� ���������� ������� ���������� 0. }
function RSLObjInvoke(pObj:Pointer; id:LongInt; code:LongInt; nPar:LongInt; par:PVALUE; var propORret:VALUE):LongInt;
begin
  Result:=ExeExports.ptr_LocRslObjInvoke(pObj, id, code, nPar, par, propORret);
end;

{������� ���� �������� ��� ����� �������� ���������� ���� � ������� pObj.
���� �������� ��� ����� �� ������, ������������ -1.
���� ������� �������� ������������ 1.
���� ������ ����� ������������ 0.
���� ��� �������, �� �� �������� ����� ��� ��� ��������, ������������ 2.}
function RSLObjMemberFromName(pObj:Pointer; name:PChar; var id:LongInt):LongInt;
begin
  Result:=ExeExports.ptr_LocRslObjMemberFromName(pObj, name, id);
end;

function RSLUniCast(clsName:PChar; obj:Pointer; var userClass:Pointer):Pointer;
begin
  Result:=ExeExports.ptr_LocRslUniCast(clsName, obj, userClass);
end;

function  RSLAddSymGlobal(v_type:VALTYPE ;name:PChar):PISYMBOL;
begin
  Result:=ExeExports.ptr_AddSymGlobal(v_type, name);
end;

procedure RSLSymGlobalSet(sym:PISYMBOL; v_type:VALTYPE; ptr:Pointer);
begin
  ExeExports.ptr_SymGlobalSet(sym, v_type, ptr);
end;

procedure RSLSymGlobalSet(sym:PISYMBOL; ptr:Integer);
begin
  ExeExports.ptr_SymGlobalSet(sym, V_INTEGER, Addr(ptr));
end;

procedure RSLSymGlobalSet(sym:PISYMBOL; ptr:String);
begin
  ExeExports.ptr_SymGlobalSet(sym, V_STRING, PChar(ptr));
end;

procedure RSLSymGlobalSet(sym:PISYMBOL; ptr:Boolean);
begin
  ExeExports.ptr_SymGlobalSet(sym, V_BOOL, Addr(ptr));
end;

procedure RSLSymGlobalSet(sym:PISYMBOL; ptr:Double);
begin
  ExeExports.ptr_SymGlobalSet(sym, V_DOUBLE, Addr(ptr));
end;

procedure RSLSymGlobalSet(sym:PISYMBOL; ptr:Extended);
begin
  ExeExports.ptr_SymGlobalSet(sym, V_DOUBLEL, Addr(ptr));
end;

procedure RSLSymGlobalGet(sym:PISYMBOL);
begin
  ExeExports.ptr_SymGlobalGet(sym);
end;

Procedure RSLaddDispTable(name:PChar; p:fs_asyncProc_t);
Begin 
  ExeExports.ptr_addDispTable(name, p);
End;

Procedure RSLremDispTable(name:PChar);
Begin 
  ExeExports.ptr_remDispTable(name);
End;

initialization

finalization

end.
