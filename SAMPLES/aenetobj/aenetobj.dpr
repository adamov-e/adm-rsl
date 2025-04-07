library aenetobj;
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
    sysutils,
    provider,
    rsltype,
    rsldll,
    aeconst,
//    aeftp,
    aehttp,
//    aepop3,
    aesmtp,
    aesock;



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

function CreateObject(clntId:CLNT_PRVD_HANDLE; typeName:PChar):PGenObject; cdecl;
begin
  Result:=NIL;
//  if (StrIComp('TaeSMTP', typeName) = 0) Then  Result:=MakeaeTSMTP();
//  if (StrIComp('TaePOP3', typeName) = 0) Then  Result:=MakeaeTPOP3();
//  if (StrIComp('TaeFTP', typeName) = 0) Then  Result:=MakeaeTFTP();
  if (StrIComp('TaeSocket', typeName) = 0) Then  Result:=MakeaeTSocket();
  if (StrIComp('TaeHTTP', typeName) = 0) Then  Result:=MakeaeTHTTP();
End;

function InitProvider(var clntID:CLNT_PRVD_HANDLE):Integer; cdecl;
begin
  clntId:=NIL;
  Result:=0;
end;

procedure DoneProvider(clntID:CLNT_PRVD_HANDLE); cdecl;
begin
end;

function GetTypeInfo(clntId:CLNT_PRVD_HANDLE; typeName:PChar):PRslTypeInfo; cdecl;
begin
  Result:=NIL;
//  if ((StrIComp('TaePOP3', typeName) = 0) or (StrIComp('$RslSelfInfo1', typeName) = 0)) Then  
//    Begin Result:=aePPOP3TypeTable; Exit; End;
//  if ((StrIComp('TaeFTP', typeName) = 0) or (StrIComp('$RslSelfInfo2', typeName) = 0)) Then  
//    Begin Result:=aePFTPTypeTable; Exit; End;
  if ((StrIComp('TaeSMTP', typeName) = 0) or (StrIComp('$RslSelfInfo0', typeName) = 0)) Then  
    Begin Result:=aePSMTPTypeTable; Exit; End;
  if ((StrIComp('TaeSocket', typeName) = 0) or (StrIComp('$RslSelfInfo3', typeName) = 0)) Then  
    Begin Result:=aePSocketTypeTable; Exit; End;
  if ((StrIComp('TaeHTTP', typeName) = 0) or (StrIComp('$RslSelfInfo4', typeName) = 0)) Then  
    Begin Result:=aePHTTPTypeTable; Exit; End;
end;

procedure AddModuleObjects(); stdcall;
begin
  GenRunHandle:=RslGetInstSymbol('GenRun');
//  RSLAddStdProc(V_UNDEF, PChar('TaePOP3'), @CreateaeTPOP3, 0);
//  RSLAddStdProc(V_UNDEF, PChar('TaeFTP'), @CreateaeTFTP, 0);
  RSLAddStdProc(V_UNDEF, PChar('TaeSMTP'), @CreateaeTSMTP, 0);
  RSLAddStdProc(V_UNDEF, PChar('TaeSocket'), @CreateaeTSocket, 0);
  RSLAddStdProc(V_UNDEF, PChar('TaeHTTP'), @CreateaeTHTTP, 0);

  RSLAddObjectProviderModEx(@InitProvider, @DoneProvider, @CreateObject, @GetTypeInfo);
end;

Exports
InitExec,
DoneExec,
DlmMain,
AddModuleObjects;

End.
