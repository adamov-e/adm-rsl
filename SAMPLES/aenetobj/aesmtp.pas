unit aesmtp;
InterFace

Uses
    sysutils,
    IdEMailAddress,
    idMessage,
    idSMTP,
    provider,
    rsltype,
    rsldll,
    aesock;

Const
  aeTSMTPMethods = 8+aeTSocketMethods;
  aeTSMTPProps   = 12+aeTSocketProps;

Type

  aePSMTP = ^aeTSMTP;
  aeTSMTP = Packed Object(aeTSocket)
    public

    IdMsgSend:TIdMessage;

    Constructor Create;
    procedure   Done(); virtual;
    procedure RSLInit(ParmNum:LongInt); virtual;
    function  RslSet(parm:PChar; val:PVALUE; var id:LongInt):LongInt; virtual; cdecl;
    function  Get(parm:PChar; val:PVALUE; var id:LongInt):LongInt; virtual; cdecl;
    function  Run(method:PChar; var id:LongInt):LongInt; virtual; cdecl;
    function  typeName():PChar; virtual; cdecl;
    function  RunId(id:LongInt):LongInt; virtual; cdecl;
    function  PropOrMethod(parm:PChar):LongInt; virtual;

    procedure RSLHelp(); virtual;
    procedure RSLSendMail(); virtual;
    procedure RSLVerify(); virtual;
    procedure RSLAddText(); virtual;
    procedure RSLAddAttachment(); virtual;
    procedure RSLClearAttachments(); virtual;
    procedure RSLAddReceiver(); virtual;
    procedure RSLAddCC(); virtual;
    procedure RSLAddBCC(); virtual;

    procedure set_Text(newVal:PVALUE); virtual;
    procedure get_Text(retVal:PVALUE); virtual;
    procedure set_UserName(newVal:PVALUE); virtual;
    procedure get_UserName(retVal:PVALUE); virtual;
    procedure set_Password(newVal:PVALUE); virtual;
    procedure get_Password(retVal:PVALUE); virtual;
    procedure set_From(newVal:PVALUE); virtual;
    procedure get_From(retVal:PVALUE); virtual;
    procedure set_FromAddress(newVal:PVALUE); virtual;
    procedure get_FromAddress(retVal:PVALUE); virtual;
    procedure set_FromName(newVal:PVALUE); virtual;
    procedure get_FromName(retVal:PVALUE); virtual;
    procedure set_ToAddress(newVal:PVALUE); virtual;
    procedure get_ToAddress(retVal:PVALUE); virtual;
    procedure set_Subject(newVal:PVALUE); virtual;
    procedure get_Subject(retVal:PVALUE); virtual;
    procedure set_Charset(newVal:PVALUE); virtual;
    procedure get_Charset(retVal:PVALUE); virtual;
    procedure set_CCList(newVal:PVALUE); virtual;
    procedure get_CCList(retVal:PVALUE); virtual;
    procedure set_BCCList(newVal:PVALUE); virtual;
    procedure get_BCCList(retVal:PVALUE); virtual;

  end;

function MakeaeTSMTP():Pointer;
procedure CreateaeTSMTP();

Var
  aeTSMTPTypeTable:IRslTypeInfo;
  aePSMTPTypeTable:PRslTypeInfo;

{*****************************************************************


******************************************************************}
Implementation


function aeTSMTPTypeName():PChar; cdecl;
begin
  Result:='TaeSMTP';
end;

function aeTSMTPgetNProps():Integer; cdecl;
begin
  Result:=aeTSMTPProps;
end;

function aeTSMTPgetNMethods():Integer; cdecl;
begin
  Result:=aeTSMTPMethods;
end;

function aeTSMTPcanInherit():Integer; cdecl;
begin
  Result:=1;
end;

{
Если parm - метод необходимп вернуть 0,
если parm - свойство - вернуть 1,
иначе вернуть -1
}
function aeTSMTPisProp(parm:PChar; Var id:LongInt):Integer; cdecl; 
var i:Integer;
begin
  i:=aeTSocketisProp(parm, id);
  if (i <> -1) Then Begin Result:=i; Exit; End;
  id:=-1;
  Result:=-1;
  if (StrIComp('Verify', parm) = 0)     Then Begin Result:=0; Exit; end;
  if (StrIComp('SendMail', parm) = 0)   Then Begin Result:=0; Exit; end;
  if (StrIComp('AddText', parm) = 0)    Then Begin Result:=0; Exit; end;
  if (StrIComp('AddAttachment', parm) = 0)    Then Begin Result:=0; Exit; end;
  if (StrIComp('ClearAttachments', parm) = 0)    Then Begin Result:=0; Exit; end;
  if (StrIComp('AddReceiver', parm) = 0)    Then Begin Result:=0; Exit; end;
  if (StrIComp('AddCC', parm) = 0)    Then Begin Result:=0; Exit; end;
  if (StrIComp('AddBCC', parm) = 0)    Then Begin Result:=0; Exit; end;

  if (StrIComp('Body', parm) = 0)          Then Begin Result:=1; Exit; end;
  if (StrIComp('Text', parm) = 0)          Then Begin Result:=1; Exit; end;
  if (StrIComp('UserName', parm) = 0)      Then Begin Result:=1; Exit; end;
  if (StrIComp('Password', parm) = 0)      Then Begin Result:=1; Exit; end;
  if (StrIComp('From', parm) = 0)   Then Begin Result:=1; Exit; end;
  if (StrIComp('FromAddress', parm) = 0)   Then Begin Result:=1; Exit; end;
  if (StrIComp('FromName', parm) = 0)      Then Begin Result:=1; Exit; end;
  if (StrIComp('ToAddress', parm) = 0)     Then Begin Result:=1; Exit; end;
  if (StrIComp('Subject', parm) = 0)       Then Begin Result:=1; Exit; end;
  if (StrIComp('Charset', parm) = 0)       Then Begin Result:=1; Exit; end;
  if (StrIComp('CCList', parm) = 0)        Then Begin Result:=1; Exit; end;
  if (StrIComp('BCCList', parm) = 0)       Then Begin Result:=1; Exit; end;
end;

{*****************************************************************


******************************************************************}

{
Функция возвращает -1 если parm не имя метода или свойства
или 0 если parm имя метода
или 1  если parm имя свойства
}
function aeTSMTP.PropOrMethod(parm:PChar):LongInt;
  var i:LongInt;
begin
  Result:=aeTSMTPisProp(parm, i);
end;

function aeTSMTP.RslSet(parm:PChar; val:PVALUE; var id:LongInt):LongInt;
  var res:LongInt;
begin
  id:=-1;  Result:=-1;

  res:=PropOrMethod(parm);
  if (res = -1) Then begin Result:=-1; Exit; end;
  if (res = 0) Then begin Result:=1; Exit; end;

  res:=inherited RSLSet(parm, val, id);
  if (res=0) Then Begin Result:=0;  Exit; End;

  if (StrIComp('Body', parm) = 0)         Then Begin set_Text(val); Result:=0; Exit; end;
  if (StrIComp('Text', parm) = 0)         Then Begin set_Text(val); Result:=0; Exit; end;
  if (StrIComp('UserName', parm) = 0)     Then Begin set_UserName(val);  Result:=0;  Exit;  end;
  if (StrIComp('Password', parm) = 0)     Then Begin set_Password(val);  Result:=0;  Exit;  end;
  if (StrIComp('From', parm) = 0)  Then Begin set_From(val); Result:=0; Exit; end;
  if (StrIComp('FromAddress', parm) = 0)  Then Begin set_FromAddress(val); Result:=0; Exit; end;
  if (StrIComp('FromName', parm) = 0)     Then Begin set_FromName(val); Result:=0; Exit; end;
  if (StrIComp('ToAddress', parm) = 0)    Then Begin set_ToAddress(val); Result:=0; Exit; end;
  if (StrIComp('Subject', parm) = 0)      Then Begin set_Subject(val); Result:=0; Exit; end;
  if (StrIComp('Charset', parm) = 0)      Then Begin set_Charset(val); Result:=0; Exit; end;
  if (StrIComp('CCList', parm) = 0)       Then Begin set_CCList(val); Result:=0; Exit; end;
  if (StrIComp('BCCList', parm) = 0)      Then Begin set_BCCList(val); Result:=0; Exit; end;
end;

function aeTSMTP.Get(parm:PChar; val:PVALUE; var id:LongInt):LongInt;
  var res:LongInt;
begin
  id:=-1;  Result:=-1;

  res:=PropOrMethod(parm);
  if (res = -1) Then begin Result:=-1; Exit; end;
  if (res = 0) Then begin Result:=1; Exit; end;

  res:=inherited Get(parm, val, id);
  if (res=0) Then Begin Result:=0;  Exit; End;

  if (StrIComp('Body', parm) = 0)         Then Begin get_Text(val); Result:=0; Exit; end;
  if (StrIComp('Text', parm) = 0)         Then Begin get_Text(val); Result:=0; Exit; end;
  if (StrIComp('UserName', parm) = 0)     Then Begin get_UserName(val); Result:=0; Exit; end;
  if (StrIComp('Password', parm) = 0)     Then Begin get_Password(val); Result:=0; Exit; end;
  if (StrIComp('From', parm) = 0)  Then Begin get_From(val); Result:=0; Exit; end;
  if (StrIComp('FromAddress', parm) = 0)  Then Begin get_FromAddress(val); Result:=0; Exit; end;
  if (StrIComp('FromName', parm) = 0)     Then Begin get_FromName(val); Result:=0; Exit; end;
  if (StrIComp('ToAddress', parm) = 0)    Then Begin get_ToAddress(val); Result:=0; Exit; end;
  if (StrIComp('Subject', parm) = 0)      Then Begin get_Subject(val); Result:=0; Exit; end;
  if (StrIComp('Charset', parm) = 0)      Then Begin get_Charset(val); Result:=0; Exit; end;
  if (StrIComp('CCList', parm) = 0)       Then Begin get_CCList(val); Result:=0; Exit; end;
  if (StrIComp('BCCList', parm) = 0)      Then Begin get_BCCList(val); Result:=0; Exit; end;
end;

function aeTSMTP.Run(method:PChar; var id:LongInt):LongInt;
  var res, ret:LongInt;
begin
  id:=-1;  Result:=-1;

  res:=PropOrMethod(method);
  if (res <> 0) Then begin Result:=-1; Exit; end;

  ret:=inherited Run(method, id);
  if (ret <> -1) Then Begin Result:=ret;  Exit; End;

  If (StrIComp('SendMail', method) = 0)         Then Begin  RSLSendMail(); Result:=0;  Exit; end;
  If (StrIComp('Verify', method) = 0)           Then Begin  RSLVerify(); Result:=0;  Exit; end;
  If (StrIComp('AddText', method) = 0)          Then Begin  RSLAddText(); Result:=0;  Exit; end;
  If (StrIComp('AddAttachment', method) = 0)    Then Begin  RSLAddAttachment(); Result:=0;  Exit; end;
  If (StrIComp('ClearAttachments', method) = 0) Then Begin  RSLClearAttachments(); Result:=0;  Exit; end;
  If (StrIComp('AddReceiver', method) = 0)      Then Begin  RSLAddReceiver(); Result:=0;  Exit; end;
  If (StrIComp('AddCC', method) = 0)      Then Begin  RSLAddCC(); Result:=0;  Exit; end;
  If (StrIComp('AddBCC', method) = 0)      Then Begin  RSLAddBCC(); Result:=0;  Exit; end;
end;

function aeTSMTP.RunId(id:LongInt):LongInt;
  var ob:PVALUE;
begin
  Result:=-1;
  Case (id) Of
    -3:Begin 
         RSLGetParm(0, @ob);
         if (ob.v_type = V_GENOBJ) Then RSLObject:=ob.obj Else RSLError('Ошибка получения указателя на потомка',[]);
         RSLInit(1); Result:=0;  
       End;
  End;
end;

function aeTSMTP.TypeName():PChar; 
begin
  Result:=aeTSMTPTypeName();
end;

{*****************************************************************

                       МЕТОДЫ

******************************************************************}

Constructor aeTSMTP.Create();
begin
  inherited;
  _vtbl.rslSet:=@aeTSMTP.rslSet;
  _vtbl.Get:=@aeTSMTP.Get;
  _vtbl.Run:=@aeTSMTP.Run;
  _vtbl.TypeName:=@aeTSMTP.TypeName;
  _vtbl.RunId:=@aeTSMTP.RunId;
end;

procedure  aeTSMTP.Done();
begin
  aeObj.Free();
end;


procedure aeTSMTP.RSLInit(ParmNum:LongInt);
var 
  i:LongInt;
begin
    i:=ParmNum;
    aeObj:=TIdSMTP.Create(NIL);
    IdMsgSend:=TIdMessage.Create(NIL);
end;

procedure aeTSMTP.RSLHelp();
Begin
  inherited;
  RSLPrint('TaeSMTP %s', [PChar(#10+#13)]);
  RSLPrint('procedure SendMail() %s',[PChar(#10+#13)]);
  RSLPrint('procedure Verify(UserName: string) %s',[PChar(#10+#13)]);
  RSLPrint('procedure AddText(Text:STRING) %s',[PChar(#10+#13)]);
  RSLPrint('procedure AddAttachment(FileName:STRING) %s',[PChar(#10+#13)]);
  RSLPrint('procedure ClearAttachments() %s',[PChar(#10+#13)]);
  RSLPrint('procedure AddReceiver(Text:STRING) %s',[PChar(#10+#13)]);
  RSLPrint('procedure AddCC(Text:STRING) %s',[PChar(#10+#13)]);
  RSLPrint('procedure AddBCC(Text:STRING) %s',[PChar(#10+#13)]);

  RSLPrint('property UserName:STRING %s',[PChar(#10+#13)]);
  RSLPrint('property Password:STRING %s',[PChar(#10+#13)]);
  RSLPrint('property CharSet:STRING %s',[PChar(#10+#13)]);
  RSLPrint('property From:STRING %s',[PChar(#10+#13)]);
  RSLPrint('property FromName:STRING %s',[PChar(#10+#13)]);
  RSLPrint('property FromAddress:STRING %s',[PChar(#10+#13)]);
  RSLPrint('property ToAddress:STRING %s',[PChar(#10+#13)]);
  RSLPrint('property Text:STRING %s',[PChar(#10+#13)]);
  RSLPrint('property Subject:STRING %s',[PChar(#10+#13)]);
  RSLPrint('-------------------------------------------%s',[PChar(#10+#13)]);
End;

procedure aeTSMTP.RSLSendMail();
begin
  If (aeObj.Connected) Then Begin
    Try
      TIdSMTP(aeObj).Send(IdMsgSend);
    Finally
      TIdSMTP(aeObj).Disconnect;
    End;
  End Else RSLError('Должно быть установлено соединение!',[]);
end;

procedure aeTSMTP.RSLVerify();
  Var 
    ret:String;
    v:PVALUE;
begin
  RSLGetParm(1, @v);
  if (v.v_type <> V_STRING) Then RSLError('String',[]);
  Try
    ret:=TIdSMTP(aeObj).Verify(String(v.RSLString));
  Except
    RSLError('Verify failed', []);
  End;
  RSLReturnVal(V_STRING, PChar(ret));
end;

procedure aeTSMTP.RSLAddText();
  Var 
    v:PVALUE;
begin
  RSLGetParm(1, @v);
  if (v.v_type <> V_STRING) Then RSLError('String',[]);
  IdMsgSend.Body.Add(String(v.RSLString));
end;

procedure aeTSMTP.RSLAddAttachment();
  Var 
    v:PVALUE;
begin
    RSLGetParm(1, @v);
    if (v.v_type <> V_STRING) Then RSLError('String',[]);
    TIdAttachment.Create(IdMsgSend.MessageParts, String(v.RSLString));
end;

procedure aeTSMTP.RSLClearAttachments();
begin
  IdMsgSend.MessageParts.Clear();
end;

procedure aeTSMTP.RSLAddReceiver();
  Var 
    v1, v2:PVALUE;
    email:TIdEMailAddressItem;
begin
    RSLGetParm(1, @v1);
    RSLGetParm(2, @v2);
    if (v1.v_type <> V_STRING) Then RSLError('Address:String, Name:String',[]);
    if (v2.v_type <> V_STRING) Then RSLError('Address:String, Name:String',[]);
    With IdMsgSend.Recipients.Add Do
    Begin
        Address:=v1.RSLString;
        Name:=v2.RSLString;
    End;
end;

procedure aeTSMTP.RSLAddCC();
  Var 
    v1, v2:PVALUE;
    email:TIdEMailAddressItem;
begin
    RSLGetParm(1, @v1);
    RSLGetParm(2, @v2);
    if (v1.v_type <> V_STRING) Then RSLError('Address:String, Name:String',[]);
    if (v2.v_type <> V_STRING) Then RSLError('Address:String, Name:String',[]);
    With IdMsgSend.CCList.Add Do
    Begin
        Address:=v1.RSLString;
        Name:=v2.RSLString;
    End;
end;

procedure aeTSMTP.RSLAddBCC();
  Var 
    v1, v2:PVALUE;
    email:TIdEMailAddressItem;
begin
    RSLGetParm(1, @v1);
    RSLGetParm(2, @v2);
    if (v1.v_type <> V_STRING) Then RSLError('Address:String, Name:String',[]);
    if (v2.v_type <> V_STRING) Then RSLError('Address:String, Name:String',[]);
    With IdMsgSend.BCCList.Add Do
    Begin
        Address:=v1.RSLString;
        Name:=v2.RSLString;
    End;
end;


{*****************************************************************

                       СВОЙСТВА

******************************************************************}

procedure aeTSMTP.set_Text(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  IdMsgSend.Body.Text:=String(newVal.RSLString);
end;

procedure aeTSMTP.get_Text(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(IdMsgSend.Body.Text));
end;

procedure aeTSMTP.set_UserName(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  TIdSMTP(aeObj).Username:=String(newVal.RSLString);
end;

procedure aeTSMTP.get_UserName(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(TIdSMTP(aeObj).Username));
end;

procedure aeTSMTP.set_Password(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  TIdSMTP(aeObj).Password:=String(newVal.RSLString);
end;

procedure aeTSMTP.get_Password(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(TIdSMTP(aeObj).Password));
end;

procedure aeTSMTP.set_From(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  IdMsgSend.From.Text:=String(newVal.RSLString);
end;

procedure aeTSMTP.get_From(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(IdMsgSend.From.Text));
end;

procedure aeTSMTP.set_FromAddress(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  IdMsgSend.From.Address:=String(newVal.RSLString);
end;

procedure aeTSMTP.get_FromAddress(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(IdMsgSend.From.Address));
end;

procedure aeTSMTP.set_FromName(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  IdMsgSend.From.Name:=String(newVal.RSLString);
end;

procedure aeTSMTP.get_FromName(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(IdMsgSend.From.Name));
end;

procedure aeTSMTP.set_ToAddress(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  IdMsgSend.Recipients.EMailAddresses:=String(newVal.RSLString);
end;

procedure aeTSMTP.get_ToAddress(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(IdMsgSend.Recipients.EMailAddresses));
end;

procedure aeTSMTP.set_Subject(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  IdMsgSend.Subject:=String(newVal.RSLString);
end;

procedure aeTSMTP.get_Subject(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(IdMsgSend.Subject));
end;

procedure aeTSMTP.set_CharSet(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  IdMsgSend.Charset:=String(newVal.RSLString);
end;

procedure aeTSMTP.get_CharSet(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(IdMsgSend.Charset));
end;

procedure aeTSMTP.set_CCList(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  IdMsgSend.CCList.EMailAddresses:=String(newVal.RSLString);
end;

procedure aeTSMTP.get_CCList(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(IdMsgSend.CCList.EMailAddresses));
end;

procedure aeTSMTP.set_BCCList(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  IdMsgSend.BCCList.EMailAddresses:=String(newVal.RSLString);
end;

procedure aeTSMTP.get_BCCList(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(IdMsgSend.BCCList.EMailAddresses));
end;

{*****************************************************************


******************************************************************}

function MakeaeTSMTP():Pointer;
  var P:aePSMTP;
begin
  P:=RSLiNewMemNULL(SizeOf(aeTSMTP));
  If (P = NIL) Then RSLError('Недостаточно памяти для создания TaeTSMTP', []);
  P.Create;
  Result:=P;
end;

procedure CreateaeTSMTP();
  var obj:aePSMTP;
begin
  obj:=MakeaeTSMTP();
  obj.RSLInit(0);
  RSLReturnVal(V_GENOBJ, obj);
end;

Begin
  aeTSMTPTypeTable.size:=SizeOf(IRslTypeInfo);
  aeTSMTPTypeTable.isProp:=@aeTSMTPisProp;
  aeTSMTPTypeTable.getNProps:=@aeTSMTPgetNProps;
  aeTSMTPTypeTable.getNMethods:=@aeTSMTPgetNMethods;
  aeTSMTPTypeTable.canInherit:=@aeTSMTPcanInherit;
  aeTSMTPTypeTable.create:=NIL;
  aeTSMTPTypeTable.typeName:=@aeTSMTPTypeName;
  aePSMTPTypeTable:=@aeTSMTPTypeTable;
End.
