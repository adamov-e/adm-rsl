unit aesock;
InterFace

Uses
    IdTCPClient,
    sysutils,
    provider,
    rsltype,
    rsldll;

Const
  aeTSocketMethods = 8;  //МЕТОДЫ
  aeTSocketProps   = 4;  //СВОЙСТВА

Type

  aePSocket = ^aeTSocket;
  aeTSocket = Packed Object(TGenObject)
    RSLObject:Pointer;
    DLMObject:Pointer;
    public
    aeObj:TIdTCPClient;
    TimeOut:Integer;

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
    procedure RSLConnect(); virtual;
    procedure RSLDisconnect(); virtual;
    procedure RSLWrite(); virtual;
    procedure RSLWriteLn(); virtual;
    procedure RSLReadLn(); virtual;


    procedure set_Host(newVal:PVALUE); virtual;
    procedure get_Host(retVal:PVALUE); virtual;
    procedure set_Port(newVal:PVALUE); virtual;
    procedure get_Port(retVal:PVALUE); virtual;
    procedure get_Connected(retVal:PVALUE); virtual;
    procedure set_TimeOut(newVal:PVALUE); virtual;
    procedure get_TimeOut(retVal:PVALUE); virtual;

  end;

function MakeaeTSocket():Pointer;
procedure CreateaeTSocket();
function aeTSocketisProp(parm:PChar; Var id:LongInt):Integer; cdecl; 

Var
  aeTSocketTypeTable:IRslTypeInfo;
  aePSocketTypeTable:PRslTypeInfo;


{*****************************************************************


******************************************************************}
Implementation
Uses
    aeconst;


function aeTSocketTypeName():PChar; cdecl;
begin
  Result:='TaeSosket';
end;

function aeTSocketgetNProps():Integer; cdecl;
begin
  Result:=aeTSocketProps;
end;

function aeTSocketgetNMethods():Integer; cdecl;
begin
  Result:=aeTSocketMethods;
end;

function aeTSocketcanInherit():Integer; cdecl;
begin
  Result:=1;
end;

{
Если parm - метод необходимп вернуть 0,
если parm - свойство - вернуть 1,
иначе вернуть -1
}
function aeTSocketisProp(parm:PChar; Var id:LongInt):Integer; cdecl; 
begin
  id:=-1;
  Result:=-1;
  if (StrIComp('Help', parm) = 0)    Then Begin Result:=0; Exit; end;
  if (StrIComp('Connect', parm) = 0)    Then Begin Result:=0; Exit; end;
  if (StrIComp('Disconnect', parm) = 0) Then Begin Result:=0; Exit; end;
  if (StrIComp('Open', parm) = 0)       Then Begin Result:=0; Exit; end;
  if (StrIComp('Close', parm) = 0)      Then Begin Result:=0; Exit; end;
  if (StrIComp('Write', parm) = 0)      Then Begin Result:=0; Exit; end;
  if (StrIComp('WriteLn', parm) = 0)    Then Begin Result:=0; Exit; end;
  if (StrIComp('ReadLn', parm) = 0)     Then Begin Result:=0; Exit; end;

  if (StrIComp('Host', parm) = 0)          Then Begin Result:=1; Exit; end;
  if (StrIComp('Port', parm) = 0)          Then Begin Result:=1; Exit; end;
  if (StrIComp('Connected', parm) = 0)     Then Begin Result:=1; Exit; end;
  if (StrIComp('TimeOut', parm) = 0)          Then Begin Result:=1; Exit; end;
end;

{*****************************************************************


******************************************************************}

{
Функция возвращает -1 если parm не имя метода или свойства
или 0 если parm имя метода
или 1  если parm имя свойства
}
function aeTSocket.PropOrMethod(parm:PChar):LongInt;
  var i:LongInt;
begin
  Result:=aeTSocketisProp(parm, i);
end;

function aeTSocket.RslSet(parm:PChar; val:PVALUE; var id:LongInt):LongInt;
  var res:LongInt;
begin
  id:=-1;
  Result:=-1;
  res:=PropOrMethod(parm);
  if (res = -1) Then begin Result:=-1; Exit; end;
  if (res = 0) Then begin Result:=1; Exit; end;
  if (StrIComp('Host', parm) = 0)         Then Begin set_Host(val);  Result:=0;  Exit;  end;
  if (StrIComp('Port', parm) = 0)         Then Begin set_Port(val);  Result:=0;  Exit;  end;
  if (StrIComp('TimeOut', parm) = 0)         Then Begin set_TimeOut(val);  Result:=0;  Exit;  end;
end;

function aeTSocket.Get(parm:PChar; val:PVALUE; var id:LongInt):LongInt;
  var res:LongInt;
begin
  id:=-1;
  Result:=-1;
  res:=PropOrMethod(parm);
  if (res = -1) Then begin Result:=-1; Exit; end;
  if (res = 0) Then begin Result:=1; Exit; end;
  if (StrIComp('Host', parm) = 0)         Then Begin get_Host(val); Result:=0; Exit; end;
  if (StrIComp('Port', parm) = 0)         Then Begin get_Port(val); Result:=0; Exit; end;
  if (StrIComp('Connected', parm) = 0)    Then Begin get_Connected(val); Result:=0; Exit; end;
  if (StrIComp('TimeOut', parm) = 0)    Then Begin get_TimeOut(val); Result:=0; Exit; end;
end;

function aeTSocket.Run(method:PChar; var id:LongInt):LongInt;
  var res:LongInt;
   v1, v2:PVALUE;
begin
  id:=-1;
  Result:=-1;
  res:=PropOrMethod(method);
  if (res <> 0) Then begin Result:=-1; Exit; end;
  If (StrIComp('Help', method) = 0)       Then Begin  RSLHelp(); Result:=0;  Exit; end;
  If (StrIComp('Connect', method) = 0)    Then Begin  RSLConnect(); Result:=0;  Exit; end;
  If (StrIComp('Open', method) = 0)       Then Begin  RSLConnect(); Result:=0;  Exit; end;
  If (StrIComp('Disconnect', method) = 0) Then Begin  RSLDisconnect(); Result:=0;  Exit; end;
  If (StrIComp('Close', method) = 0)      Then Begin  RSLDisconnect(); Result:=0;  Exit; end;
  If (StrIComp('ReadLn', method) = 0)     Then Begin  RSLReadLn(); Result:=0;  Exit; end;
  If (StrIComp('Write', method) = 0)      Then Begin  RSLWrite(); Result:=0;  Exit; end;
  If (StrIComp('WriteLn', method) = 0)    Then Begin  RSLWriteLn(); Result:=0;  Exit; end;
end;

function aeTSocket.RunId(id:LongInt):LongInt;
  var ob:PVALUE;
begin
  Result:=-1;
  If (id = -3) Then Begin 
    RSLGetParm(0, @ob);
    if (ob.v_type = V_GENOBJ) Then RSLObject:=ob.obj Else RSLError('Ошибка получения указателя на потомка',[]);
    RSLInit(1); Result:=0;  
  End;
end;

function aeTSocket.TypeName():PChar; 
begin
  Result:=aeTSocketTypeName();
end;

{*********************************************************************

                        Методы

**********************************************************************}

Constructor aeTSocket.Create();
Begin
  Inherited;        
  _vtbl.rslSet:=@aeTSocket.rslSet;
  _vtbl.Get:=@aeTSocket.Get;
  _vtbl.Run:=@aeTSocket.Run;
  _vtbl.TypeName:=@aeTSocket.TypeName;
  _vtbl.RunId:=@aeTSocket.RunId;
end;

procedure aeTSocket.Done();
begin
  aeObj.Free();
end;

procedure aeTSocket.RSLInit(ParmNum:LongInt);
var 
  i:LongInt;
begin
  i:=ParmNum;
  aeObj:=TIdTCPClient.Create(NIL);
    TimeOut:=-1;
end;

procedure aeTSocket.RSLHelp();
Begin
  RSLPrint('TaeSocket %s', [PChar(#10+#13)]);
  RSLPrint('-------------------------------------------%s',[PChar(#10+#13)]);
End;

procedure aeTSocket.RSLConnect();
  var 
    ret:Boolean;
    v:PVALUE;
Begin
  If (Not aeObj.Connected()) Then Begin
    RSLGetParm(1, @v);
    if (v.v_type = V_INTEGER) Then TimeOut:=v.intval;
    ret:=FALSE;
    Try
      aeObj.Connect(TimeOut);
    Except
      RSLMsgBox('Connect Failed',[]);
    End;
    ret:=aeObj.Connected;
  End Else ret:=TRUE;
  RSLReturnVal(V_BOOL, @ret);
End;

procedure aeTSocket.RSLDisconnect();
Begin
  If (aeObj.Connected) Then
    Begin
      Try
        aeObj.Disconnect();
      Except
        RSLMsgBox('Disconnect failed',[]);
      End;
    End;
End;

procedure aeTSocket.RSLWrite();
  var v:PVALUE;
begin
  RSLGetParm(1, @v);
  if (v.v_type <> V_STRING) Then RSLError('String',[]);
  Try
    aeObj.Write(String(v.RSLString));
  Except
    RSLMsgBox('Write Failed',[]);
  End;
end;

procedure aeTSocket.RSLWriteLn();
  var v:PVALUE;
begin
  RSLGetParm(1, @v);
  if (v.v_type <> V_STRING) Then RSLError('String',[]);
  Try
    aeObj.WriteLn(String(v.RSLString));
  Except
    RSLError('WriteLn failed', []);
  End;
end;

procedure aeTSocket.RSLReadLn();
begin
  Try
    RSLReturnVal(V_STRING, PChar(aeObj.ReadLn()));
  Except
    RSLError('ReadLn failed', []);
  End;
end;

{*****************************************************************

                       СВОЙСТВА

******************************************************************}

procedure aeTSocket.set_Host(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  aeObj.Host:=String(newVal.RSLString);
end;

procedure aeTSocket.get_Host(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(aeObj.Host));
end;

procedure aeTSocket.set_Port(newVal:PVALUE);
begin
  if (newVal.v_type <> V_INTEGER) Then RSLError('INTEGER',[]);
  aeObj.port:=newVal.intval;
end;

procedure aeTSocket.get_Port(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_INTEGER, @aeObj.port);
end;

procedure aeTSocket.get_Connected(retVal:PVALUE);
  var ret:Boolean;
begin
  RSLValueClear(retVal);
  ret:=aeObj.Connected;
  RSLValueSet(retVal, V_BOOL, @ret);
end;

procedure aeTSocket.set_TimeOut(newVal:PVALUE);
begin
  if (newVal.v_type <> V_INTEGER) Then RSLError('INTEGER',[]);
  TimeOut:=newVal.intval;
end;

procedure aeTSocket.get_TimeOut(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_INTEGER, @TimeOut);
end;
{*****************************************************************


******************************************************************}

function MakeaeTSocket():Pointer;
  var P:aePSocket;
begin
  P:=RSLiNewMemNULL(SizeOf(aeTSocket));
  If (P = NIL) Then RSLError('Недостаточно памяти для создания TaeSocket', []);
  P.Create;
  Result:=P;
end;

procedure CreateaeTSocket();
  var obj:aePSocket;
begin
  obj:=MakeaeTSocket();
  obj.RSLInit(0);
  RSLReturnVal(V_GENOBJ, obj);
end;

Begin
  aeTSocketTypeTable.size:=SizeOf(IRslTypeInfo);
  aeTSocketTypeTable.isProp:=@aeTSocketisProp;
  aeTSocketTypeTable.getNProps:=@aeTSocketgetNProps;
  aeTSocketTypeTable.getNMethods:=@aeTSocketgetNMethods;
  aeTSocketTypeTable.canInherit:=@aeTSocketcanInherit;
  aeTSocketTypeTable.create:=NIL;
  aeTSocketTypeTable.typeName:=@aeTSocketTypeName;
  aePSocketTypeTable:=@aeTSocketTypeTable;
End.
