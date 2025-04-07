unit aeHTTP;
InterFace

Uses
    idhttp,
    sysutils,
    provider,
    rsltype,
    rsldll,
    aesock;

Const
  aeTHTTPMethods = 3+aeTSocketMethods;
  aeTHTTPProps   = 4+aeTSocketProps;

Type

  aePHTTP = ^aeTHTTP;
  aeTHTTP = Packed Object(aeTSocket)
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
    //методы
    procedure RSLHelp(); virtual;
    procedure RSLGet(); virtual;
    procedure RSLHead(); virtual;
    procedure RSLOptions(); virtual;
    //свойства
    procedure set_ProxyServer(newVal:PVALUE); virtual;
    procedure get_ProxyServer(retVal:PVALUE); virtual;
    procedure set_ProxyPort(newVal:PVALUE); virtual;
    procedure get_ProxyPort(retVal:PVALUE); virtual;
    procedure set_ProxyPassword(newVal:PVALUE); virtual;
    procedure get_ProxyPassword(retVal:PVALUE); virtual;
    procedure set_ProxyUsername(newVal:PVALUE); virtual;
    procedure get_ProxyUsername(retVal:PVALUE); virtual;

  end;

function MakeaeTHTTP():Pointer;
procedure CreateaeTHTTP();

Var
  aeTHTTPTypeTable:IRslTypeInfo;
  aePHTTPTypeTable:PRslTypeInfo;

{*****************************************************************


******************************************************************}
Implementation

function aeTHTTPTypeName():PChar; cdecl;
begin
  Result:='TaeHTTP';
end;

function aeTHTTPgetNProps():Integer; cdecl;
begin
  Result:=aeTHTTPProps;
end;

function aeTHTTPgetNMethods():Integer; cdecl;
begin
  Result:=aeTHTTPMethods;
end;

function aeTHTTPcanInherit():Integer; cdecl;
begin
  Result:=1;
end;

{
Если parm - метод необходимп вернуть 0,
если parm - свойство - вернуть 1,
иначе вернуть -1
}
function aeTHTTPisProp(parm:PChar; Var id:LongInt):Integer; cdecl; 
var i:Integer;
begin
  i:=aeTSocketisProp(parm, id);
  if (i <> -1) Then Begin Result:=i; Exit; End;
  id:=-1;
  Result:=-1;
  if (StrIComp('Get', parm) = 0)               Then Begin Result:=0; Exit; end;
  if (StrIComp('Head', parm) = 0)              Then Begin Result:=0; Exit; end;
  if (StrIComp('Options', parm) = 0)           Then Begin Result:=0; Exit; end;

  if (StrIComp('ProxyServer', parm) = 0)  Then Begin Result:=1; Exit; end;
  if (StrIComp('ProxyPort', parm) = 0)  Then Begin Result:=1; Exit; end;
  if (StrIComp('ProxyPassword', parm) = 0)  Then Begin Result:=1; Exit; end;
  if (StrIComp('ProxyUsername', parm) = 0)  Then Begin Result:=1; Exit; end;
end;

{*****************************************************************


******************************************************************}

{
Функция возвращает -1 если parm не имя метода или свойства
или 0 если parm имя метода
или 1  если parm имя свойства
}
function aeTHTTP.PropOrMethod(parm:PChar):LongInt;
  var i:LongInt;
begin
  Result:=aeTHTTPisProp(parm, i);
end;

function aeTHTTP.RslSet(parm:PChar; val:PVALUE; var id:LongInt):LongInt;
  var res:LongInt;
begin
  id:=-1;  Result:=-1;

  res:=PropOrMethod(parm);
  if (res = -1) Then begin Result:=-1; Exit; end;
  if (res = 0) Then begin Result:=1; Exit; end;

  res:=inherited Get(parm, val, id);
  if (res=0) Then Begin Result:=res;  Exit; End;

  if (StrIComp('ProxyServer', parm) = 0)    Then Begin set_ProxyServer(val); Result:=0; Exit; end;
  if (StrIComp('ProxyPort', parm) = 0)      Then Begin set_ProxyPort(val); Result:=0; Exit; end;
  if (StrIComp('ProxyPassword', parm) = 0)  Then Begin set_ProxyPassword(val); Result:=0; Exit; end;
  if (StrIComp('ProxyUsername', parm) = 0)  Then Begin set_ProxyUsername(val); Result:=0; Exit; end;
end;

function aeTHTTP.Get(parm:PChar; val:PVALUE; var id:LongInt):LongInt;
  var res:LongInt;
begin
  id:=-1;  Result:=-1;

  res:=PropOrMethod(parm);
  if (res = -1) Then begin Result:=-1; Exit; end;
  if (res = 0) Then begin Result:=1; Exit; end;

  res:=inherited Get(parm, val, id);
  if (res=0) Then Begin Result:=res;  Exit; End;

  if (StrIComp('ProxyServer', parm) = 0)    Then Begin get_ProxyServer(val); Result:=0; Exit; end;
  if (StrIComp('ProxyPort', parm) = 0)      Then Begin get_ProxyPort(val); Result:=0; Exit; end;
  if (StrIComp('ProxyPassword', parm) = 0)  Then Begin get_ProxyPassword(val); Result:=0; Exit; end;
  if (StrIComp('ProxyUsername', parm) = 0)  Then Begin get_ProxyUsername(val); Result:=0; Exit; end;

end;

function aeTHTTP.Run(method:PChar; var id:LongInt):LongInt;
  var res:LongInt;
   v1, v2:PVALUE;
begin
  id:=-1;  Result:=-1;

  res:=PropOrMethod(method);
  if (res <> 0) Then begin Result:=-1; Exit; end;

  res:=inherited Run(method, id);
  if (res=0) Then Begin Result:=res;  Exit; End;

  If (StrIComp('Get', method) = 0)                Then Begin  RSLGet(); Result:=0;  Exit; end;
  If (StrIComp('Head', method) = 0)               Then Begin  RSLHead(); Result:=0;  Exit; end;
  If (StrIComp('Options', method) = 0)            Then Begin  RSLOptions(); Result:=0;  Exit; end;
end;

function aeTHTTP.RunId(id:LongInt):LongInt;
  var ob:PVALUE;
begin
  Result:=-1;
  If (id = -3) Then Begin 
    RSLGetParm(0, @ob);
    if (ob.v_type = V_GENOBJ) Then RSLObject:=ob.obj Else RSLError('Ошибка получения указателя на потомка',[]);
    RSLInit(1); Result:=0;  
  End;
end;

function aeTHTTP.TypeName():PChar; 
begin
  Result:=aeTHTTPTypeName();
end;


{*****************************************************************

                       МЕТОДЫ

******************************************************************}

constructor aeTHTTP.Create();
Begin
  Inherited;        
  _vtbl.rslSet:=@aeTHTTP.rslSet;
  _vtbl.Get:=@aeTHTTP.Get;
  _vtbl.Run:=@aeTHTTP.Run;
  _vtbl.TypeName:=@aeTHTTP.TypeName;
  _vtbl.RunId:=@aeTHTTP.RunId;
  aeObj:=TIdHTTP.Create(NIL);
end;

procedure  aeTHTTP.Done();
begin
  TIdHTTP(aeobj).Free();
end;


procedure aeTHTTP.RSLInit(ParmNum:LongInt);
var 
  i:LongInt;
begin
  i:=ParmNum;
  TIdHTTP(aeObj).ProxyParams.Clear();
end;

procedure aeTHTTP.RSLHelp();
Begin
  inherited;
  RSLPrint('TaeHTTP %s', [PChar(#10+#13)]);
  RSLPrint('procedure Get(URL: string) %s', [PChar(#10+#13)]);
  RSLPrint('procedure Head(URL: string) %s', [PChar(#10+#13)]);
  RSLPrint('procedure Options(URL: string) %s', [PChar(#10+#13)]);

  RSLPrint('property ProxyServer:STRING %s', [PChar(#10+#13)]);
  RSLPrint('property ProxyPort:STRING %s', [PChar(#10+#13)]);
  RSLPrint('property ProxyPassword:INTEGER%s', [PChar(#10+#13)]);
  RSLPrint('property ProxyUsername:STRING %s', [PChar(#10+#13)]);
  RSLPrint('-------------------------------------------%s',[PChar(#10+#13)]);
End;

procedure aeTHTTP.RSLGet();
var v:PVALUE;
Begin
  RSLGetParm(1, @v);
  if (v.v_type<>V_STRING) Then RSLError('STRING', []);
  Try
    TIdHTTP(aeobj).Get(String(v.RSLString));
  Except
    RSLError('Get failed', []);
  End;
End;

procedure aeTHTTP.RSLHead();
var v:PVALUE;
Begin
  RSLGetParm(1, @v);
  if (v.v_type<>V_STRING) Then RSLError('STRING', []);
  Try
    TIdHTTP(aeobj).Head(String(v.RSLString));
  Except
    RSLError('Head failed', []);
  End;
End;

procedure aeTHTTP.RSLOptions();
var v:PVALUE;
Begin
  RSLGetParm(1, @v);
  if (v.v_type<>V_STRING) Then RSLError('STRING', []);
  Try
    TIdHTTP(aeobj).Options(String(v.RSLString));
  Except
    RSLError('Options failed', []);
  End;
End;

{*****************************************************************

                       СВОЙСТВА

******************************************************************}


procedure aeTHTTP.set_ProxyServer(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  TIdHTTP(aeObj).ProxyParams.ProxyServer:=String(newVal.RSLString);
end;

procedure aeTHTTP.get_ProxyServer(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(TIdHTTP(aeObj).ProxyParams.ProxyServer));
end;

procedure aeTHTTP.set_ProxyPort(newVal:PVALUE);
begin
  if (newVal.v_type <> V_INTEGER) Then RSLError('INTEGER',[]);
  TIdHTTP(aeObj).ProxyParams.ProxyPort:=newVal.intval;
end;

procedure aeTHTTP.get_ProxyPort(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_INTEGER, @TIdHTTP(aeObj).ProxyParams.ProxyServer);
end;

procedure aeTHTTP.set_ProxyPassword(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  TIdHTTP(aeObj).ProxyParams.ProxyPassword:=String(newVal.RSLString);
end;

procedure aeTHTTP.get_ProxyPassword(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(TIdHTTP(aeObj).ProxyParams.ProxyPassword));
end;

procedure aeTHTTP.set_ProxyUsername(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  TIdHTTP(aeObj).ProxyParams.ProxyUsername:=String(newVal.RSLString);
end;

procedure aeTHTTP.get_ProxyUsername(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(TIdHTTP(aeObj).ProxyParams.ProxyUsername));
end;

{*****************************************************************

******************************************************************}

function MakeaeTHTTP():Pointer;
  var P:aePHTTP;
begin
  P:=RSLiNewMemNULL(SizeOf(aeTHTTP));
  If (P = NIL) Then RSLError('Недостаточно памяти для создания TaeTHTTP', []);
  P.Create;
  Result:=P;
end;

procedure CreateaeTHTTP();
  var obj:aePHTTP;
begin
  obj:=MakeaeTHTTP();
  obj.RSLInit(0);
  RSLReturnVal(V_GENOBJ, obj);
end;

Begin
  aeTHTTPTypeTable.size:=SizeOf(IRslTypeInfo);
  aeTHTTPTypeTable.isProp:=@aeTHTTPisProp;
  aeTHTTPTypeTable.getNProps:=@aeTHTTPgetNProps;
  aeTHTTPTypeTable.getNMethods:=@aeTHTTPgetNMethods;
  aeTHTTPTypeTable.canInherit:=@aeTHTTPcanInherit;
  aeTHTTPTypeTable.create:=NIL;
  aeTHTTPTypeTable.typeName:=@aeTHTTPTypeName;
  aePHTTPTypeTable:=@aeTHTTPTypeTable;
End.
