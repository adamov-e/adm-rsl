{
Набор библиотек на языке Delphi для разработки модулей проблемно-ориентированного языка RSL

  Версия: 1.0.0

  Разработчик: Адамов Ербулат, adamov.e.n@gmail.com
  Дата последней модификации: 2009 год

  Набор разрабатывался автором в учебно-познавательных целях.
  Разрешается свободное использование набора без каких либо ограничений.
  Набор предоставляется как есть, без какой-либо ответственности и претензий к автору.
}

unit provider;

InterFace
  Uses rsltype, rsldll;

Type

  PRslObject = ^IRslObject;
  IRslObject = Packed Record
    Size:LongWord;   // Size of this structure
    AddRef:function(obj:Pointer):Word; cdecl;
    Release:function(obj:Pointer):Word; cdecl;
    // return: 0 - property, 1 - method, -1 - undefined parameter
    RslSet:function(obj:Pointer; parm:PChar; val:PVALUE; var id:LongInt):LongInt; cdecl;
    SetId:function(obj:Pointer; id:LongInt; val:PVALUE):LongInt; cdecl;
    // return: 0 - property, 1 - method, -1 - undefined parameter
    Get:function(obj:Pointer; parm:PChar; val:PVALUE; var id:LongInt):LongInt; cdecl;
    GetId:function(obj:Pointer; id:LongInt; val:PVALUE):LongInt; cdecl;
    // return: 0 - property, 1 - method, -1 - undefined parameter
    Run:function(obj:Pointer; method:PChar; var id:LongInt):LongInt; cdecl;
    RunId:function(obj:Pointer; id:LongInt):LongInt; cdecl;
    // Used by RSL Only
    isParent:function(obj:Pointer; sym:SYMCLASS):LongInt; cdecl;
    canCvtToIDispatch:function(obj:Pointer):LongInt; cdecl;
    TypeName:function(obj:Pointer):PChar; cdecl;
    TypeID:function(obj:Pointer):LongWord; cdecl;
    Attach:function(obj:Pointer; method:PChar; sym:SYMPROC):LongInt; cdecl;
    getUniqID:function(pObj:Pointer; name:PChar):LongInt; cdecl;
    memberFromID:function(pObj:Pointer; dispid:LongInt; var id:LongInt):LongInt; cdecl;
    genProc:function(pObj:Pointer; cmd:LongInt; data:Pointer):LongInt; cdecl;
    getInterface:procedure(pObj:Pointer; kind:LongInt); cdecl;
  end;

  PRslTypeInfo2 = ^IRslTypeInfo2;
  IRslTypeInfo2 = Packed Record
    size:LongWord;   // Size of this structure
    AddRef:function(cls:Pointer):Byte; cdecl;
    Release:function(cls:Pointer):Byte; cdecl;
    isProp:function(cls:Pointer; parm:PChar; Var id:LongInt):Integer; cdecl;
    getNProps:function(cls:Pointer):Integer; cdecl;
    getNMethods:function(cls:Pointer):Integer; cdecl;
    canInherit:function(cls:Pointer):Integer; cdecl;
    create:function(cls:Pointer; ctrl:Pointer):Pointer; cdecl;
    typeName:function(cls:Pointer):PChar; cdecl;
    getNumObjects:function(cls:Pointer):Integer; cdecl;
  end;


  PRslTypeInfo = ^IRslTypeInfo;
  IRslTypeInfo = Packed Record
    size:LongWord;   // Size of this structure
    isProp:function(parm:PChar; Var id:LongInt):Integer; cdecl;
    getNProps:function():Integer; cdecl;
    getNMethods:function():Integer; cdecl;
    canInherit:function():Integer; cdecl;
    create:function(ctrl:Pointer):Pointer; cdecl;
    typeName:function():PChar; cdecl;
  end;


  {‚бҐ ®ЎкҐЄвл ¤«п RSL ¤®«¦­л ­ б«Ґ¤®ў вмбп ®в TGenObject}
  PGenObject = ^TGenObject;
  TGenObject = Packed Object
    vtbl:Pointer;
    _vtbl:IRslObject;
    refCount:Word;

    Constructor Create();
    Procedure  Done(); virtual;
    procedure RSLInit(ParmNum:LongInt); virtual;  abstract;
    function AddRef():Word; virtual; cdecl;
    function Release():Word; virtual; cdecl;
    function RslSet(parm:PChar; val:PVALUE; var id:LongInt):LongInt; virtual; cdecl;
    function SetId(id:LongInt; val:PVALUE):LongInt; virtual; cdecl;
    function Get(parm:PChar; val:PVALUE; var id:LongInt):LongInt; virtual;  cdecl;
    function GetId(id:LongInt; val:PVALUE):LongInt; virtual; cdecl;
    function Run(method:PChar; var id:LongInt):LongInt; virtual; cdecl;
    function RunId(id:LongInt):LongInt; virtual; cdecl;
    function isParent(sym:SYMCLASS):LongInt; virtual; cdecl;
    function canCvtToIDispatch():LongInt; virtual; cdecl;
    function typeName():PChar; virtual; cdecl;
    function typeID():LongWord; virtual; cdecl;
    function Attach(method:PChar; sym:SYMPROC):LongInt; virtual; cdecl;
    function getUniqID(name:PChar):LongInt; virtual; cdecl;
    function memberFromID(dispid:LongInt; var id:LongInt):LongInt; virtual; cdecl;
    function genProc(cmd:LongInt; data:Pointer):LongInt; virtual; cdecl;
    procedure getInterface(kind:LongInt); virtual; cdecl;

    function getNProps():Integer; cdecl;
    function getNMethods():Integer; cdecl;
    function canInherit():Integer; cdecl;

    function PropOrMethod(parm:PChar):LongInt; virtual;
  end;

function RSLADDREF(ptr:PGenObject):Word; cdecl;
function RSLRELEASE(ptr:PGenObject):Word; cdecl;

Implementation


procedure DoneGenObject(ptr:PGenObject);
begin
  //rslmsgbox('DISPOSE = %s',[ptr.typename]);
  ptr.Done();
  RSLiDoneMem(ptr);
//  Dispose(ptr);
end;

function RSLADDREF(ptr:PGenObject):Word;
begin
  Result:=ptr.AddRef();
//  rslmsgbox('ADDREF = %d',[Pointer(ptr.refCount)]);
end;

function RSLRELEASE(ptr:PGenObject):Word;
begin
  Result:=ptr.Release();
//  rslmsgbox('RELEASE = %d',[Pointer(ptr.refCount)]);
  if (ptr.refCount = 0) Then DoneGenObject(ptr);
end;

Constructor TGenObject.Create;
begin
  Inherited;
  _vtbl.size:=SizeOf(IRslObject);
  _vtbl.AddRef:=@RSLADDREF;
  _vtbl.Release:=@RSLRELEASE;
  _vtbl.rslSet:=@TGenObject.rslSet;
  _vtbl.SetId:=@TGenObject.SetId;
  _vtbl.Get:=@TGenObject.Get;
  _vtbl.GetId:=@TGenObject.GetId;
  _vtbl.Run:=@TGenObject.Run;
  _vtbl.RunId:=@TGenObject.RunId;
  _vtbl.isParent:=NIL;
  _vtbl.canCvtToIDispatch:=NIL;
  _vtbl.TypeName:=@TGenObject.TypeName;
  _vtbl.TypeId:=@TGenObject.TypeId;
  _vtbl.Attach:=@TGenObject.Attach;
  _vtbl.getUniqID:=NIL;
  _vtbl.memberFromID:=NIL;
  _vtbl.genProc:=NIL;
  _vtbl.getInterface:=NIL;
  vtbl:=@_vtbl;
  refCount:=0;
  AddRef();
end;

Procedure TGenObject.Done();
begin
end;

function TGenObject.AddRef():Word;
begin
  Inc(refCount);
  Result:=refCount;
//  RSLMsgBox('TGenObject.AddRef', []);
end;

function TGenObject.Release():Word;
begin
  if (refCount > 0) Then Dec(refCount);
  Result:=refCount;
  //RSLMsgBox('TGenObject.Release', []);
end;

function TGenObject.RslSet(parm:PChar; val:PVALUE; var id:LongInt):LongInt;
begin
//  RSLMsgBox('TGenObject.Set=%s', [parm]);
  id:=-1;
  Result:=-1;
end;

function TGenObject.SetId(id:LongInt; val:PVALUE):LongInt;
begin
//  RSLMsgBox('TGenObject.SetID=%d', [Pointer(id)]);
  Result:=-1;
end;

function TGenObject.Get(parm:PChar; val:PVALUE; var id:LongInt):LongInt;
begin
//  RSLMsgBox('TGenObject.Get=%s', [parm]);
  id:=-1;
  Result:=-1;
end;

function TGenObject.GetId(id:LongInt; val:PVALUE):LongInt;
begin
//  RSLMsgBox('TGenObject.GetId=%d', [Pointer(id)]);
  Result:=-1;
end;

function TGenObject.Run(method:PChar; var id:LongInt):LongInt;
begin
//  RSLMsgBox('TGenObject.Run=%s', [method]);
  id:=-1;
  Result:=-1;
end;

function TGenObject.RunId(id:LongInt):LongInt;
begin
//  RSLMsgBox('TGenObject.RunId=%d', [Pointer(id)]);
  Result:=-1;
end;

function TGenObject.isParent(sym:SYMCLASS):LongInt;
begin
//  RSLMsgBox('TGenObject.isParent', []);
  Result:=-1;
end;

function TGenObject.canCvtToIDispatch():LongInt;
begin
//  RSLMsgBox('TGenObject.canCvtToIDispatch', []);
  Result:=-1;
end;

function TGenObject.typeName():PChar; 
begin
//  RSLMsgBox('TGenObject.typeName', []);
  Result:='TGenObject';
end;

function TGenObject.typeID():LongWord;
begin
//  RSLMsgBox('TGenObject.typeID', []);
  Result:=LongWord(@Self);
end;

function TGenObject.Attach(method:PChar; sym:SYMPROC):LongInt;
begin
//  RSLMsgBox('TGenObject.Attach', []);
  Result:=-1;
end;

function TGenObject.getUniqID(name:PChar):LongInt;
begin
//  RSLMsgBox('TGenObject.getUniqID', []);
  Result:=-1;
end;

function TGenObject.memberFromID(dispid:LongInt; var id:LongInt):LongInt;
begin
//  RSLMsgBox('TGenObject.memberFromID', []);
  id:=-1;
  Result:=-1;
end;

function TGenObject.genProc(cmd:LongInt; data:Pointer):LongInt; 
begin
//  RSLMsgBox('TGenObject.genProc', []);
  Result:=-1;
end;

procedure TGenObject.getInterface(kind:LongInt); 
begin
//  RSLMsgBox('TGenObject.getInterface',[]);
end;

function TGenObject.PropOrMethod(parm:PChar):LongInt;
begin
  Result:=-1;
end;

function TGenObjectisProp(parm:PChar; Var id:LongInt):Integer; 
begin
//  RSLMsgBox('TGenObject.isProp',[]);
  id:=-1;
  Result:=-1;
end;

function TGenObject.getNProps():Integer;
begin
//  RSLMsgBox('TGenObject.nProps',[]);
  Result:=0;
end;

function TGenObject.getNMethods():Integer;
begin
//  RSLMsgBox('TGenObject.nMethods',[]);
  Result:=0;
end;

function TGenObject.canInherit():Integer;
begin
//  RSLMsgBox('TGenObject.inherit',[]);
  Result:=0;
end;

initialization

finalization

end.