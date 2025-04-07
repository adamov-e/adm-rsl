unit aestrlist;
InterFace

Uses
    sysutils,
    classes,
    uniprov,
    rsltype,
    rsldll;

Type

  aePStringList = ^aeTStringList;
  aeTStringList = Packed Object
    public
    str:TStrings;

    function  Create():LongInt; cdecl;
    function  Done():LongInt; cdecl;

    function  RSLInit(prmOfs:PInteger):LongInt; cdecl; 
    function  Clear(ret:PVALUE):LongInt; cdecl;
    procedure Add(s:String); cdecl;
    function  RSLAdd():LongInt; cdecl;
    procedure Delete(i:Integer); cdecl;
    function  RSLDelete():LongInt; cdecl;
    function  RSLStrings(ret:PVALUE):LongInt; cdecl;
    function  RSLSaveToFile():LongInt; cdecl;
    function  RSLLoadFromFile():LongInt; cdecl;
    function  get_Count(ret:PVALUE):LongInt; cdecl;
    function  get(ret:PVALUE):LongInt; cdecl;
    
  end;

Var
  aePStringListTable:PMethodTable;
  aeTStringListEntrys:TMethodEntrys;

{*****************************************************************


******************************************************************}
Implementation

function aeTStringList.Create():LongInt;
Begin
  str:=TStringList.Create;
  Result:=0;
end;

function aeTStringList.Done():LongInt;
begin
  str.Free();
  Result:=0;
end;

function aeTStringList.RSLInit(prmOfs:PInteger):LongInt;
//  var i:LongInt;
//      v:PVALUE;
begin
//  i:=prmOfs^;
//  RSLMsgBox('%d',[Pointer(i)]);
//  RSLGetParm(i, @v);
  Result:=0;
end;

function aeTStringList.Clear(ret:PVALUE):LongInt;
begin
  str.Clear();
  Result:=0;
end;

procedure aeTStringList.Add(s:String);
Begin
  str.Add(s);
End;

function aeTStringList.RSLAdd():LongInt;
  var v:PVALUE;
Begin
  RSLGetParm(1, @v);
  if (v.v_type = V_STRING) Then Begin 
    Add(String(v.RSLString));
  End;
  Result:=0;
End;

procedure aeTStringList.Delete(i:Integer);
Begin
  str.Delete(i);
End;

function aeTStringList.RSLDelete():LongInt;
  var v:PVALUE;
Begin
  RSLGetParm(1, @v);
  if (v.v_type = V_INTEGER) Then Begin 
    if (v.intval < 0) Then RSLError('Не верен индекс atTStringList = %d',[Pointer(v.intval)]);
    if (v.intval >= Str.Count) Then RSLError('Не верен индекс atTStringList = %d',[Pointer(v.intval)]);
    Delete(v.intval);
  End;
  Result:=0;
End;

function aeTStringList.RSLStrings(ret:PVALUE):LongInt;
  var v:PVALUE;
Begin
  RSLGetParm(1, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Strings(INTEGER)',[]);
  if (v.intval < 0) Then RSLError('Не верен индекс atTStringList',[]);
  if (v.intval >= str.Count) Then RSLError('Не верен индекс atTStringList',[]);
  RSLValueClear(ret);
  RSLValueSet(ret, V_STRING, PChar(str[v.intval]));
  Result:=0;
End;

function aeTStringList.RSLSaveToFile():LongInt;
  var v:PVALUE;
Begin
  RSLGetParm(1, @v);
  If (v.v_type <> V_STRING) Then RSLError('SaveToFile(STRING)',[]);
  Try
    str.SaveToFile(String(v.RSLString));
  Except
    RSLError('Ошибка метода SaveToFile',[]);
  End;
  Result:=0;
End;

function aeTStringList.RSLLoadFromFile():LongInt;
  var v:PVALUE;
Begin
  RSLGetParm(1, @v);
  If (v.v_type <> V_STRING) Then RSLError('LoadFromFile(STRING)',[]);
  Try
    str.LoadFromFile(String(v.RSLString));
  Except
    RSLError('Ошибка метода LoadFromFile',[]);
  End;
  Result:=0;
End;

function  aeTStringList.get_Count(ret:PVALUE):LongInt;
  var i:LongInt;
begin
  i:=str.Count;
  RSLValueClear(ret);
  RSLValueSet(ret, V_INTEGER, @i);
  Result:=0;
end;

function  aeTStringList.get(ret:PVALUE):LongInt;
begin
  rslmsgbox('GET',[]);
end;

{*****************************************************************

******************************************************************}

procedure MakeaeTStringList();
  var i:Word;
begin
  SetLength(aeTStringListEntrys, 10);
  {Методы}
  i:=0;
  aeTStringListEntrys[i]:=RSL_METH('Add', @aeTStringList.RSLAdd);

  Inc(i);
  aeTStringListEntrys[i]:=RSL_METH('Delete', @aeTStringList.RSLDelete);

  Inc(i);
  aeTStringListEntrys[i]:=RSL_METH('Clear', @aeTStringList.Clear);

  Inc(i);
  aeTStringListEntrys[i]:=RSL_METH('SaveToFile', @aeTStringList.RSLSaveToFile);

  Inc(i);
  aeTStringListEntrys[i]:=RSL_METH('LoadFromFile', @aeTStringList.RSLLoadFromFile);

  Inc(i);
  aeTStringListEntrys[i]:=RSL_METH('Strings', @aeTStringList.RSLStrings);

  {Свойства}
  Inc(i);
  aeTStringListEntrys[i]:=RSL_PROP_METH('Count', @aeTStringList.get_Count, NIL);

  {конструктор, инициализатор, деструктор}
  Inc(i);
  aeTStringListEntrys[i]:=RSL_INIT(@aeTStringList.RSLInit);

  Inc(i);
  aeTStringListEntrys[i]:=RSL_CTRL(@aeTStringList.Create);

  Inc(i);
  aeTStringListEntrys[i]:=RSL_DSTR(@aeTStringList.Done);

  Inc(i);
  aeTStringListEntrys[i]:=RSL_TBL_END();
  {********************************************************}
  aePStringListTable^.clsName:='aeTStringList';
  aePStringListTable^.userSize:=SizeOf(aeTStringList);
  aePStringListTable^.Entrys:=@aeTStringListEntrys[0];
  aePStringListTable^.canInherit:=TRUE;
  aePStringListTable^.canCvtToIDisp:=TRUE;
  aePStringListTable^.Ver:=1;
  aePStringListTable^.autoPtr:=NIL;
end;

Initialization
  New(aePStringListTable);
  MakeaeTStringList();
Finalization
  Dispose(aePStringListTable);
End.

