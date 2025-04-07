unit aePOP3;
InterFace

Uses
    sysutils,
    NMpop3,
    provider,
    rsltype,
    rsldll,
    aesock;

Const
  aeTPOP3Methods = 3;
  aeTPOP3Props   = 10;

Type

  aePPOP3 = ^aeTPOP3;
  aeTPOP3 = Packed Object(aeTSocket)
    public
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
    procedure RSLGetMailMessage(); virtual;
    procedure RSLDeleteMailMessage(); virtual;
    procedure RSLList(); virtual;

    procedure set_UserName(newVal:PVALUE); virtual;
    procedure get_UserName(retVal:PVALUE); virtual;
    procedure set_Password(newVal:PVALUE); virtual;
    procedure get_Password(retVal:PVALUE); virtual;
    procedure set_AttachFilePath(newVal:PVALUE); virtual;
    procedure get_AttachFilePath(retVal:PVALUE); virtual;
    procedure get_MailCount(retVal:PVALUE); virtual;
    procedure get_MsgAttachments(retVal:PVALUE); virtual;
    procedure get_MsgBody(retVal:PVALUE); virtual;
    procedure get_MsgFrom(retVal:PVALUE); virtual;
    procedure get_MsgHead(retVal:PVALUE); virtual;
    procedure get_MsgID(retVal:PVALUE); virtual;
    procedure get_MsgSubject(retVal:PVALUE); virtual;
  end;

function MakeaeTPOP3():Pointer;
procedure CreateaeTPOP3();

Var
  aeTPOP3TypeTable:IRslTypeInfo;
  aePPOP3TypeTable:PRslTypeInfo;

{*****************************************************************


******************************************************************}
Implementation

function aeTPOP3TypeName():PChar; cdecl;
begin
  Result:='TaePOP3';
end;

function aeTPOP3getNProps():Integer; cdecl;
begin
  Result:=aeTPOP3Props+aeTSocketProps;
end;

function aeTPOP3getNMethods():Integer; cdecl;
begin
  Result:=aeTPOP3Methods+aeTSocketMethods;
end;

function aeTPOP3canInherit():Integer; cdecl;
begin
  Result:=1;
end;

{
Если parm - метод необходимп вернуть 0,
если parm - свойство - вернуть 1,
иначе вернуть -1
}
function aeTPOP3isProp(parm:PChar; Var id:LongInt):Integer; cdecl; 
var i:Integer;
begin
  i:=aeTSocketisProp(parm, id);
  if (i <> -1) Then Begin Result:=i; Exit; End;
  id:=-1;
  Result:=-1;
  if (StrIComp('GetMailMessage', parm) = 0)    Then Begin Result:=0; Exit; end;
  if (StrIComp('DeleteMailMessage', parm) = 0) Then Begin Result:=0; Exit; end;
  if (StrIComp('List', parm) = 0)              Then Begin Result:=0; Exit; end;

  if (StrIComp('UserName', parm) = 0)       Then Begin Result:=1; Exit; end;
  if (StrIComp('Password', parm) = 0)       Then Begin Result:=1; Exit; end;
  if (StrIComp('AttachFilePath', parm) = 0) Then Begin Result:=1; Exit; end;
  if (StrIComp('MailCount', parm) = 0)      Then Begin Result:=1; Exit; end;
  if (StrIComp('MsgAttachments', parm) = 0) Then Begin Result:=1; Exit; end;
  if (StrIComp('MsgBody', parm) = 0)        Then Begin Result:=1; Exit; end;
  if (StrIComp('MsgFrom', parm) = 0)        Then Begin Result:=1; Exit; end;
  if (StrIComp('MsgHead', parm) = 0)        Then Begin Result:=1; Exit; end;
  if (StrIComp('MsgID', parm) = 0)          Then Begin Result:=1; Exit; end;
  if (StrIComp('MsgSubject', parm) = 0)     Then Begin Result:=1; Exit; end;
end;

{*****************************************************************


******************************************************************}

{
Функция возвращает -1 если parm не имя метода или свойства
или 0 если parm имя метода
или 1  если parm имя свойства
}
function aeTPOP3.PropOrMethod(parm:PChar):LongInt;
  var i:LongInt;
begin
  Result:=aeTPOP3isProp(parm, i);
end;

function aeTPOP3.RslSet(parm:PChar; val:PVALUE; var id:LongInt):LongInt;
  var res:LongInt;
begin
  id:=-1;  Result:=-1;

  res:=PropOrMethod(parm);
  if (res = -1) Then begin Result:=-1; Exit; end;
  if (res = 0) Then begin Result:=1; Exit; end;

  res:=inherited Get(parm, val, id);
  if (res=0) Then Begin Result:=0;  Exit; End;

  if (StrIComp('UserName', parm) = 0)      Then Begin set_UserName(val); Result:=0; Exit; end;
  if (StrIComp('Password', parm) = 0)  Then Begin set_Password(val); Result:=0; Exit; end;
  if (StrIComp('AttachFilePath', parm) = 0)  Then Begin set_AttachFilePath(val); Result:=0; Exit; end;
end;

function aeTPOP3.Get(parm:PChar; val:PVALUE; var id:LongInt):LongInt;
  var res:LongInt;
begin
  id:=-1;  Result:=-1;

  res:=PropOrMethod(parm);
  if (res = -1) Then begin Result:=-1; Exit; end;
  if (res = 0) Then begin Result:=1; Exit; end;

  res:=inherited Get(parm, val, id);
  if (res=0) Then Begin Result:=0;  Exit; End;

  if (StrIComp('UserName', parm) = 0)      Then Begin get_UserName(val); Result:=0; Exit; end;
  if (StrIComp('Password', parm) = 0)      Then Begin get_Password(val); Result:=0; Exit; end;
  if (StrIComp('AttachFilePath', parm) = 0)Then Begin get_AttachFilePath(val); Result:=0; Exit; end;

  if (StrIComp('MailCount', parm) = 0)     Then Begin get_MailCount(val); Result:=0; Exit; end;
  if (StrIComp('MsgAttachments', parm) = 0) Then Begin get_MsgAttachments(val); Result:=0; Exit; end;
  if (StrIComp('MsgBody', parm) = 0)        Then Begin get_MsgBody(val); Result:=0; Exit; end;
  if (StrIComp('MsgFrom', parm) = 0)        Then Begin get_MsgFrom(val); Result:=0; Exit; end;
  if (StrIComp('MsgHead', parm) = 0)        Then Begin get_MsgHead(val); Result:=0; Exit; end;
  if (StrIComp('MsgID', parm) = 0)          Then Begin get_MsgID(val); Result:=0; Exit; end;
  if (StrIComp('MsgSubject', parm) = 0)     Then Begin get_MsgSubject(val); Result:=0; Exit; end;
end;

function aeTPOP3.Run(method:PChar; var id:LongInt):LongInt;
  var res:LongInt;
   v1, v2:PVALUE;
begin
  id:=-1;  Result:=-1;

  res:=PropOrMethod(method);
  if (res <> 0) Then begin Result:=-1; Exit; end;

  res:=inherited Run(method, id);
  if (res=0) Then Begin Result:=0;  Exit; End;

  If (StrIComp('Connect', method) = 0)            Then Begin  RSLConnect(); Result:=0;  Exit; end;
  If (StrIComp('Open', method) = 0)               Then Begin  RSLConnect(); Result:=0;  Exit; end;
  If (StrIComp('Disconnect', method) = 0)         Then Begin  RSLDisconnect(); Result:=0;  Exit; end;
  If (StrIComp('Close', method) = 0)              Then Begin  RSLDisconnect(); Result:=0;  Exit; end;
  If (StrIComp('GetMailMessage', method) = 0)     Then Begin  RSLGetMailMessage(); Result:=0;  Exit; end;
  If (StrIComp('DeleteMailMessage', method) = 0)  Then Begin  RSLDeleteMailMessage(); Result:=0;  Exit; end;
  If (StrIComp('List', method) = 0)               Then Begin  RSLList(); Result:=0;  Exit; end;
end;

function aeTPOP3.RunId(id:LongInt):LongInt;
  var ob:PVALUE;
begin
  Result:=-1;
  If (id = -3) Then Begin 
    RSLGetParm(0, @ob);
    if (ob.v_type = V_GENOBJ) Then RSLObject:=ob.obj Else RSLError('Ошибка получения указателя на потомка',[]);
    RSLInit(1); Result:=0;  
  End;
end;

function aeTPOP3.TypeName():PChar; 
begin
  Result:=aeTPOP3TypeName();
end;


{*****************************************************************

                       МЕТОДЫ

******************************************************************}

constructor aeTPOP3.Create();
Begin
  Inherited;        
  _vtbl.rslSet:=@aeTPOP3.rslSet;
  _vtbl.Get:=@aeTPOP3.Get;
  _vtbl.Run:=@aeTPOP3.Run;
  _vtbl.TypeName:=@aeTPOP3.TypeName;
  _vtbl.RunId:=@aeTPOP3.RunId;
end;

procedure  aeTPOP3.Done();
begin
  TNMPOP3(aeobj).Free();
end;


procedure aeTPOP3.RSLInit(ParmNum:LongInt);
var 
  i:LongInt;
begin
  i:=ParmNum;
  aeObj:=TNMPOP3.Create(NIL);
  aeObj.Proxy:='';
  aeObj.ProxyPort:=0;
  aeObj.TimeOut:=10000;
  aeObj.ReportLevel:=0;
end;

procedure aeTPOP3.RSLHelp();
Begin
  inherited;
  RSLPrint('TaePOP3 %s', [PChar(#10+#13)]);
  RSLPrint('procedure GetMailMessage(MailNumber: integer) %s',[PChar(#10+#13)]);
  RSLPrint('procedure DeleteMailMessage(MailNumber: integer) %s',[PChar(#10+#13)]);
  RSLPrint('procedure List() %s',[PChar(#10+#13)]);
  RSLPrint('property UserName:STRING %s',[PChar(#10+#13)]);
  RSLPrint('property Password:STRING %s',[PChar(#10+#13)]);
  RSLPrint('property AttachFilePath:STRING %s',[PChar(#10+#13)]);
  RSLPrint('property MailCount:INTEGER %s',[PChar(#10+#13)]);
  RSLPrint('property MsgAttachments:STRING %s',[PChar(#10+#13)]);
  RSLPrint('property MsgBody:STRING %s',[PChar(#10+#13)]);
  RSLPrint('property MsgFrom:STRING %s',[PChar(#10+#13)]);
  RSLPrint('property MsgHead:STRING %s',[PChar(#10+#13)]);
  RSLPrint('property MsgID:INTEGER %s',[PChar(#10+#13)]);
  RSLPrint('property MsgSubject:STRING %s',[PChar(#10+#13)]);
  RSLPrint('-------------------------------------------%s',[PChar(#10+#13)]);
End;


procedure aeTPOP3.RSLGetMailMessage();
var v:PVALUE;
Begin
  if (Not TNMPOP3(aeobj).Connected) Then Exit; 
  RSLGetParm(1, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('INTEGER',[]);
  if (v.intval > 0) and (v.intval <= TNMPOP3(aeobj).MailCount) Then Begin
    Try
      TNMPOP3(aeobj).GetMailMessage(v.intval);
    Except
      RSLMsgBox('GetMailMessage Error',[]);
    End;
  End;
End;

procedure aeTPOP3.RSLDeleteMailMessage();
var v:PVALUE;
Begin
  if (Not TNMPOP3(aeobj).Connected) Then Exit; 
  RSLGetParm(1, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('INTEGER',[]);
  if (v.intval > 0) and (v.intval <= TNMPOP3(aeobj).MailCount) Then Begin
    Try
      TNMPOP3(aeobj).DeleteMailMessage(v.intval);
    Except
      RSLMsgBox('DeleteMailMessage Error',[]);
    End;
  End;
End;

procedure aeTPOP3.RSLList();
Begin
  Try
    TNMPOP3(aeobj).List();
  Except
    RSLError('List failed', []);
  End;
End;

{*****************************************************************

                       СВОЙСТВА

******************************************************************}
procedure aeTPOP3.set_UserName(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  TNMPOP3(aeobj).UserID:=String(newVal.RSLString);
end;

procedure aeTPOP3.get_UserName(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(TNMPOP3(aeobj).UserID));
end;

procedure aeTPOP3.set_Password(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  TNMPOP3(aeobj).Password:=String(newVal.RSLString);
end;

procedure aeTPOP3.get_Password(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(TNMPOP3(aeobj).Password));
end;

procedure aeTPOP3.set_AttachFilePath(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  TNMPOP3(aeobj).AttachFilePath:=String(newVal.RSLString);
end;

procedure aeTPOP3.get_AttachFilePath(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(TNMPOP3(aeobj).AttachFilePath));
end;

procedure aeTPOP3.get_MailCount(retVal:PVALUE);
  var ret:LongInt;
begin
  ret:=TNMPOP3(aeobj).MailCount;
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_INTEGER, @ret);
end;

procedure aeTPOP3.get_MsgAttachments(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(TNMPOP3(aeobj).MailMessage.Attachments.Text));
end;

procedure aeTPOP3.get_MsgBody(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(TNMPOP3(aeobj).MailMessage.Body.Text));
end;

procedure aeTPOP3.get_MsgFrom(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(TNMPOP3(aeobj).MailMessage.From));
end;

procedure aeTPOP3.get_MsgHead(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(TNMPOP3(aeobj).MailMessage.Head.Text));
end;

procedure aeTPOP3.get_MsgID(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(TNMPOP3(aeobj).MailMessage.MessageID));
end;

procedure aeTPOP3.get_MsgSubject(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(TNMPOP3(aeobj).MailMessage.Subject));
end;


{*****************************************************************

******************************************************************}

function MakeaeTPOP3():Pointer;
  var P:aePPOP3;
begin
  P:=RSLiNewMemNULL(SizeOf(aeTPOP3));
  If (P = NIL) Then RSLError('Недостаточно памяти для создания TaeTPOP3', []);
  P.Create;
  Result:=P;
end;

procedure CreateaeTPOP3();
  var obj:aePPOP3;
begin
  obj:=MakeaeTPOP3();
  obj.RSLInit(0);
  RSLReturnVal(V_GENOBJ, obj);
end;

Begin
  aeTPOP3TypeTable.size:=SizeOf(IRslTypeInfo);
  aeTPOP3TypeTable.isProp:=@aeTPOP3isProp;
  aeTPOP3TypeTable.getNProps:=@aeTPOP3getNProps;
  aeTPOP3TypeTable.getNMethods:=@aeTPOP3getNMethods;
  aeTPOP3TypeTable.canInherit:=@aeTPOP3canInherit;
  aeTPOP3TypeTable.create:=NIL;
  aeTPOP3TypeTable.typeName:=@aeTPOP3TypeName;
  aePPOP3TypeTable:=@aeTPOP3TypeTable;
End.
