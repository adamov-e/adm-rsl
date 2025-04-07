{
Набор библиотек на языке Delphi для разработки модулей проблемно-ориентированного языка RSL

  Версия: 1.0.0

  Разработчик: Адамов Ербулат, adamov.e.n@gmail.com
  Дата последней модификации: 2009 год

  Набор разрабатывался автором в учебно-познавательных целях.
  Разрешается свободное использование набора без каких либо ограничений.
  Набор предоставляется как есть, без какой-либо ответственности и претензий к автору.
}


Unit instsym;
InterFace

Uses rsltype, rsldll;

Var
  GenRunHandle:PISYMBOL;        //тут хранится ссылка на метод GenRun
  GenSetPropHandle:PISYMBOL;    //тут хранится ссылка на метод GenSetProp
  GenGetPropHandle:PISYMBOL;    //тут хранится ссылка на метод GenGetProp
  CallR2MHandle:PISYMBOL;

Procedure initSymbols();

Implementation

Procedure initSymbols();
Begin
  GenRunHandle:=RslGetInstSymbol('GenRun');
  GenGetPropHandle:=RslGetInstSymbol('GenGetProp');
  GenSetPropHandle:=RslGetInstSymbol('GenSetProp');
  CallR2MHandle:=RslGetInstSymbol('CallR2M');

  if (GenRunHandle = NIL) Then RSLError('GenRun=NIL',[]);
  if (GenGetPropHandle = NIL) Then RSLError('GenGetProp=NIL',[]);
  if (GenSetPropHandle = NIL) Then RSLError('GenSetProp=NIL',[]);
  if (CallR2MHandle = NIL) Then RSLError('CallR2M=NIL',[]);
End;

End.