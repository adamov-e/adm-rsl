{
Набор библиотек на языке Delphi для разработки модулей проблемно-ориентированного языка RSL

  Версия: 1.0.0

  Разработчик: Адамов Ербулат, adamov.e.n@gmail.com
  Дата последней модификации: 2009 год

  Набор разрабатывался автором в учебно-познавательных целях.
  Разрешается свободное использование набора без каких либо ограничений.
  Набор предоставляется как есть, без какой-либо ответственности и претензий к автору.
}

UNIT platform;
Interface

CONST
  RSL_STD_ALIGNMENT = 4; //WIN32
//  RSL_STD_ALIGNMENT = 2; //WIN16
//  RSL_STD_ALIGNMENT = 1; //DOS

  RSL_MIN_SAFE_ALIGNMENT = 1;

  function RSL_PACKED_SIZE(sz, alg:Double):Double;
  function RSL_STD_PACKED_SIZE(sz:Double):Double;
  function RSL_SAFE_PACKED_SIZE(sz:Double):Double;

#define RSL_PACKED_SIZE(sz,alg) \
   ((((sz)+(alg)-1)/(alg))*(alg))

#define RSL_STD_PACKED_SIZE(sz) \
   RSL_PACKED_SIZE((sz),RSL_STD_ALIGNMENT)

#define RSL_SAFE_PACKED_SIZE(sz) \
   RSL_PACKED_SIZE((sz),RSL_MIN_SAFE_ALIGNMENT)

Implementation

function RSL_PACKED_SIZE(sz, alg:Double):Double;
begin
  Result:=((((sz)+(alg)-1)/(alg))*(alg));
end;

function RSL_STD_PACKED_SIZE(sz:Double):Double;
begin
  Result:=RSL_PACKED_SIZE(sz, RSL_STD_ALIGNMENT)
end;

function RSL_SAFE_PACKED_SIZE(sz:Double):Double;
begin
  Result:=RSL_PACKED_SIZE((sz),RSL_MIN_SAFE_ALIGNMENT);
end;

Initialization

Finalization

End.
