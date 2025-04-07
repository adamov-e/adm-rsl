{
Ќабор библиотек на €зыке Delphi дл€ разработки модулей проблемно-ориентированного €зыка RSL

  ¬ерси€: 1.0.0

  –азработчик: јдамов ≈рбулат, adamov.e.n@gmail.com
  ƒата последней модификации: 2009 год

  Ќабор разрабатывалс€ автором в учебно-познавательных цел€х.
  –азрешаетс€ свободное использование набора без каких либо ограничений.
  Ќабор предоставл€етс€ как есть, без какой-либо ответственности и претензий к автору.
}

Unit uniprov;

InterFace

Uses
  RSLType;

Const
  RSL_TAG_METHOD=0; 
  RSL_TAG_UNUSED=1;
  RSL_TAG_METHOD_PROP=2;
  RSL_TAG_CHAIN=3;
  RSL_TAG_PROPOFFS=4;

  CHAIN_BASE_OFFS = 0; 
  CHAIN_MEMBER_OFFS = 1; 
  CHAIN_FUNC = 2; 


Type

  TElemProc = function(objData:Pointer; val:PVALUE):Integer; cdecl;
  TRslChainProc = procedure(obj:Pointer); cdecl;

  PRslParmsInfo = ^TRslParmsInfo;
  TRslParmsInfo = Packed Record
     v_type:VALTYPE;
     flags:Byte;
  end;

  PMemberInfo = ^TMemberInfo;
  TMemberInfo = Packed Record
     ind:Integer;
     id:LongInt;
     name:PChar;
     declType:Byte;
     nParm:Integer;    // Number of parms
     parInfo:TRslParmsInfo;
     kind:Byte;          // RSL_KIND_RUN, RSL_KIND_GET, RSL_KIND_SET, RSL_KIND_VAR
     flags:Byte;         // VAL_FLAG_RDONLY, VAL_FLAG_HIDE
  end;

  PRslAutoProps = ^IRslAutoProps;
  IRslAutoProps = Packed Record
     size:Word;
     getIdOfName:function(p:Pointer; parm:PChar; id:PLongInt):Integer; cdecl;
     // return: 0 - ok, -1 error
     setId:function(p:Pointer; id:LongInt; val:PVALUE):Integer; cdecl;
     getId:function  (p:Pointer; id:LongInt; val:PVALUE):Integer; cdecl;
     enumProc:function (p:Pointer; cmd:Integer; info:PMemberInfo):Integer; cdecl;
     getNProps:function(p:Pointer):Integer; cdecl;
  end;

//typedef struct
//{   char              *name;
//   signed char       iniId; 
//   unsigned char       tag;
//   TElemProc  propGetOrRun;
//   TElemProc       propPut;    // Can be NULL for read only property
//   unsigned char    v_type;    // declared type of property or return val
//   int               nParm;    // Number of parms
//   const TRslParmsInfo  *parInfo;    // Types of parms  (get and set have the same parms)
//   long                 id;
//} TMethodEntry;

  PMethodEntry = ^TMethodEntry;
  TMethodEntry = Packed Record
     Name:PChar;
     iniId:ShortInt;
     tag:Byte;
     propGetOrRun:Pointer;  //адрес метода или метода дл€ чтени€ свойства
     propPut:Pointer;       //адрес метода дл€ установки свойства может быть NULL дл€ свойств только на чтение
     v_type:VALTYPE;          //тип возвращаемого значени€ метода или свойства
     nParm:Integer;           //кол-во параметров
     parInfo:PRslParmsInfo;   //типы параметров
     id:LongInt;
  end;

  PMethodTable = ^TMethodTable;
  TMethodTable = Packed Record
     clsName:PChar;
     userSize:Integer;
     Entrys:PMethodEntry;
     canInherit:Boolean;
     canCvtToIDisp:Boolean;
     ver:Byte; 
     alradyInited:Byte;
     autoPtr:PRslAutoProps;
     numAuto:Integer;
     id:LongInt;  // first ID for autoproprs
     nOffsProps:Integer;
     nMethProps:Integer;
     nPropInd:Integer;
     nMethInd:Integer;
     nMethPropGet:Integer;
     nMethPropPut:Integer;
     nMeth:Integer;
     maxNumAuto:LongInt;
  end;

  TMethodEntrys = Packed Array of TMethodEntry;

  PGenObject = ^TGenObject;

  PRslObject = ^IRslObject;
  IRslObject = Packed Record
    size:Word;   // Size of this structure
    AddRef:function(obj:PGenObject):Byte; cdecl;
    Release:function(obj:PGenObject):Byte; cdecl;
  end;

  TGenObject = Packed Object
    public

    refCount:Byte;
    vtbl:PRslObject;
    _vtbl:IRslObject;

    TablePtr:PMethodTable;
    _Table:TMethodTable;

    Entryes:PMethodEntry;
    _Entryes:Packed Array of TMethodEntry;

  end;

Procedure AddTableEntry(var ent:TMethodEntry; nam:PChar; id:ShortInt; tg:Byte; prGet:Pointer; prPut:Pointer; vt:VALTYPE; np:Integer; pi:PRslParmsInfo; id_:LongInt); overload;
Function  AddTableEntry(nam:PChar; id:ShortInt; tg:Byte; prGet:Pointer; prPut:Pointer; vt:VALTYPE; np:Integer; pi:PRslParmsInfo; id_:LongInt):TMethodEntry; overload;
//конструктор
Procedure RSL_CTRL(prGet:Pointer; var ent:TMethodEntry); overload;
Function  RSL_CTRL(prGet:Pointer):TMethodEntry; overload;
//деструктор
Procedure RSL_DSTR(prGet:Pointer; var ent:TMethodEntry); overload;
Function  RSL_DSTR(prGet:Pointer):TMethodEntry; overload;
//инициализаци€
Procedure RSL_INIT(prGet:Pointer; var ent:TMethodEntry); overload;
Function  RSL_INIT(prGet:Pointer):TMethodEntry; overload;
//свойство реализуемое через метод
Procedure RSL_PROP_METH(nam:PChar; prGet:Pointer; prPut:Pointer; var ent:TMethodEntry); overload;
Function  RSL_PROP_METH(nam:PChar; prGet:Pointer; prPut:Pointer):TMethodEntry; overload;
//метод
Procedure RSL_METH(nam:PChar; prGet:Pointer; var ent:TMethodEntry); overload;
Function  RSL_METH(nam:PChar; prGet:Pointer):TMethodEntry; overload;
//свойство типа VALUE
Procedure RSL_PROP(nam:PChar; PropOffs:Integer; var ent:TMethodEntry); overload;
Function  RSL_PROP(nam:PChar; PropOffs:Integer):TMethodEntry; overload;
//конец таблицы
Procedure RSL_TBL_END(var ent:TMethodEntry); overload;
Function  RSL_TBL_END():TMethodEntry; overload;
//универсальный элемент
Procedure RSL_CHAIN_BASE(BaseClsTable:PMethodTable; var ent:TMethodEntry); overload;
Function  RSL_CHAIN_BASE(BaseClsTable:PMethodTable):TMethodEntry; overload;

Implementation

{
#  define RSL_CHAIN_BASE(BaseCls) 
"Chain", -1, RSL_TAG_CHAIN,
(TElemProc)&BaseCls##::_Table,
NULL, CHAIN_BASE_OFFS, 0,
NULL, RSLoffsetofcls(BaseCls,thisCls_t)
}

procedure RSL_CHAIN_BASE(BaseClsTable:PMethodTable; var ent:TMethodEntry);
begin
  ent.Name:='Chain';
  ent.iniId:=-1;
  ent.Tag:=RSL_TAG_CHAIN;
  ent.propGetOrRun:=BaseClsTable;
  ent.propPut:=NIL;
  ent.v_type:=ValType(CHAIN_BASE_OFFS);
  ent.nParm:=0;
  ent.parInfo:=NIL;
  ent.Id:=0
end;

function RSL_CHAIN_BASE(BaseClsTable:PMethodTable):TMethodEntry;
begin
  Result.Name:='Chain';
  Result.iniId:=-1;
  Result.Tag:=RSL_TAG_CHAIN;
  Result.propGetOrRun:=BaseClsTable;
  Result.propPut:=NIL;
  Result.v_type:=ValType(CHAIN_BASE_OFFS);
  Result.nParm:=0;
  Result.parInfo:=NIL;
  Result.Id:=0
end;

Procedure RSL_CTRL(prGet:Pointer; var ent:TMethodEntry);
Begin
  ent.Name:='Constructor';
  ent.iniId:=RSL_DISP_MAKE;
  ent.Tag:=RSL_TAG_METHOD;
  ent.propGetOrRun:=prGet;
  ent.propPut:=NIL;
  ent.v_type:=V_UNDEF;
  ent.nParm:=0;
  ent.parInfo:=NIL;
  ent.Id:=0
End;

function  RSL_CTRL(prGet:Pointer):TMethodEntry;
Begin
  Result.Name:='Constructor';
  Result.iniId:=RSL_DISP_MAKE;
  Result.Tag:=RSL_TAG_METHOD;
  Result.propGetOrRun:=prGet;
  Result.propPut:=NIL;
  Result.v_type:=V_UNDEF;
  Result.nParm:=0;
  Result.parInfo:=NIL;
  Result.Id:=0
End;

Procedure RSL_DSTR(prGet:Pointer; var ent:TMethodEntry);
Begin
  ent.Name:='Destructor';
  ent.iniId:=RSL_DISP_DTRL;
  ent.Tag:=RSL_TAG_METHOD;
  ent.propGetOrRun:=prGet;
  ent.propPut:=NIL;
  ent.v_type:=V_UNDEF;
  ent.nParm:=0;
  ent.parInfo:=NIL;
  ent.Id:=0
End;

function  RSL_DSTR(prGet:Pointer):TMethodEntry;
Begin
  Result.Name:='Destructor';
  Result.iniId:=RSL_DISP_DTRL;
  Result.Tag:=RSL_TAG_METHOD;
  Result.propGetOrRun:=prGet;
  Result.propPut:=NIL;
  Result.v_type:=V_UNDEF;
  Result.nParm:=0;
  Result.parInfo:=NIL;
  Result.Id:=0
End;

Procedure RSL_INIT(prGet:Pointer; var ent:TMethodEntry);
Begin
  ent.Name:='Init';
  ent.iniId:=RSL_DISP_CTRL;
  ent.Tag:=RSL_TAG_METHOD;
  ent.propGetOrRun:=prGet;
  ent.propPut:=NIL;
  ent.v_type:=V_UNDEF;
  ent.nParm:=0;
  ent.parInfo:=NIL;
  ent.Id:=0
End;

function  RSL_INIT(prGet:Pointer):TMethodEntry;
Begin
  Result.Name:='Init';
  Result.iniId:=RSL_DISP_CTRL;
  Result.Tag:=RSL_TAG_METHOD;
  Result.propGetOrRun:=prGet;
  Result.propPut:=NIL;
  Result.v_type:=V_UNDEF;
  Result.nParm:=0;
  Result.parInfo:=NIL;
  Result.Id:=0
End;

Procedure RSL_PROP_METH(nam:PChar; prGet:Pointer; prPut:Pointer; var ent:TMethodEntry);
Begin
  ent.Name:=nam;
  ent.iniId:=-1;
  ent.Tag:=RSL_TAG_METHOD_PROP;
  ent.propGetOrRun:=prGet;
  ent.propPut:=prPut;
  ent.v_type:=V_UNDEF;
  ent.nParm:=0;
  ent.parInfo:=NIL;
  ent.Id:=0
End;

function  RSL_PROP_METH(nam:PChar; prGet:Pointer; prPut:Pointer):TMethodEntry;
Begin
  Result.Name:=nam;
  Result.iniId:=-1;
  Result.Tag:=RSL_TAG_METHOD_PROP;
  Result.propGetOrRun:=prGet;
  Result.propPut:=prPut;
  Result.v_type:=V_UNDEF;
  Result.nParm:=0;
  Result.parInfo:=NIL;
  Result.Id:=0
End;

Procedure RSL_METH(nam:PChar; prGet:Pointer; var ent:TMethodEntry);
Begin
  ent.Name:=nam;
  ent.iniId:=-1;
  ent.Tag:=RSL_TAG_METHOD;
  ent.propGetOrRun:=prGet;
  ent.propPut:=NIL;
  ent.v_type:=V_UNDEF;
  ent.nParm:=0;
  ent.parInfo:=NIL;
  ent.Id:=0
End;

function  RSL_METH(nam:PChar; prGet:Pointer):TMethodEntry;
Begin
  Result.Name:=nam;
  Result.iniId:=-1;
  Result.Tag:=RSL_TAG_METHOD;
  Result.propGetOrRun:=prGet;
  Result.propPut:=NIL;
  Result.v_type:=V_UNDEF;
  Result.nParm:=0;
  Result.parInfo:=NIL;
  Result.Id:=0
End;

procedure RSL_PROP(nam:PChar; PropOffs:Integer; var ent:TMethodEntry);
Begin
  ent.Name:=nam;
  ent.iniId:=-1;
  ent.Tag:=RSL_TAG_PROPOFFS;
  ent.propGetOrRun:=NIL;
  ent.propPut:=NIL;
  ent.v_type:=V_UNDEF;
  ent.nParm:=PropOffs;
  ent.parInfo:=NIL;
  ent.Id:=0
End;

function  RSL_PROP(nam:PChar; PropOffs:Integer):TMethodEntry;
Begin
  Result.Name:=nam;
  Result.iniId:=-1;
  Result.Tag:=RSL_TAG_PROPOFFS;
  Result.propGetOrRun:=NIL;
  Result.propPut:=NIL;
  Result.v_type:=V_UNDEF;
  Result.nParm:=PropOffs;
  Result.parInfo:=NIL;
  Result.Id:=0
End;

Procedure RSL_TBL_END(var ent:TMethodEntry);
Begin
  ent.Name:=NIL;
  ent.iniId:=0;
  ent.Tag:=0;
  ent.propGetOrRun:=NIL;
  ent.propPut:=NIL;
  ent.v_type:=VALTYPE(0);
  ent.nParm:=0;
  ent.parInfo:=NIL;
  ent.Id:=0;
End;

function  RSL_TBL_END():TMethodEntry;
Begin
  Result.Name:=NIL;
  Result.iniId:=0;
  Result.Tag:=0;
  Result.propGetOrRun:=NIL;
  Result.propPut:=NIL;
  Result.v_type:=VALTYPE(0);
  Result.nParm:=0;
  Result.parInfo:=NIL;
  Result.Id:=0;
End;

Procedure AddTableEntry(var ent:TMethodEntry; nam:PChar; id:ShortInt; tg:Byte; prGet:Pointer; prPut:Pointer; vt:VALTYPE; np:Integer; pi:PRslParmsInfo; id_:LongInt);
begin
  ent.Name:=nam;
  ent.iniId:=id;
  ent.Tag:=tg;                     
  ent.propGetOrRun:=prGet;
  ent.propPut:=prPut;
  ent.v_type:=vt;
  ent.nParm:=np;                                
  ent.parInfo:=pi;
  ent.Id:=id_;
end;

function AddTableEntry(nam:PChar; id:ShortInt; tg:Byte; prGet:Pointer; prPut:Pointer; vt:VALTYPE; np:Integer; pi:PRslParmsInfo; id_:LongInt):TMethodEntry;
begin
  Result.Name:=nam;
  Result.iniId:=id;
  Result.Tag:=tg;
  Result.propGetOrRun:=prGet;
  Result.propPut:=prPut;
  Result.v_type:=vt;
  Result.nParm:=np;
  Result.parInfo:=pi;
  Result.Id:=id_;
end;

Initialization

Finalization

End.
