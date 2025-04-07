{
Набор библиотек на языке Delphi для разработки модулей проблемно-ориентированного языка RSL

  Версия: 1.0.0

  Разработчик: Адамов Ербулат, adamov.e.n@gmail.com
  Дата последней модификации: 2009 год

  Набор разрабатывался автором в учебно-познавательных целях.
  Разрешается свободное использование набора без каких либо ограничений.
  Набор предоставляется как есть, без какой-либо ответственности и претензий к автору.
}

Unit aestrutl;
InterFace

function PADC(_expr:string; _expC:Char; _expN: Cardinal) : string;
function PADR(_expr:String; _expC:Char; _expN:Cardinal) : string;
function PADL(_expr:String; _expC:Char; _expN:Cardinal) : string;

Implementation
{******************************************************************************
 * PADR  - дополняет переменную справа символами до некторой длинны.
 *
 * Вход: _expr - переменная над которой проводится операция
 *       _expN - длина до которой дополняется
 *       _expC - символ кторым дополняется
 ******************************************************************************}
function PADR(_expr:String; _expC:Char; _expN:Cardinal) : string;
var
  temp : string;
  str_size : Cardinal;
  diff     : Integer;
begin
  str_size := Length(_expr);
  diff := _expN - str_size;

  if diff > 0 then  temp := StringOfChar(_expC, diff)
   else temp := '';

  PADR := _expr + temp;
end;


{******************************************************************************
 * PADL  - дополняет переменную слева символами до некторой длинны.
 *
 * Вход: _expr - переменная над которой проводится операция
 *       _expN - длина до которой дополняется
 *       _expC - символ кторым дополняется
 ******************************************************************************}
function PADL(_expr:String; _expC:Char; _expN:Cardinal) : string;
var
  temp : string;
  str_size : Cardinal;
  diff     : Integer;
begin
  str_size := Length(_expr);
  diff := _expN - str_size;

  if diff > 0 then  temp := StringOfChar(_expC, diff)
   else temp := '';

  PADL := temp + _expr;
end;


{******************************************************************************
 * PADC  - дополняет переменную с обеих сторон символами до некоторой длинны.
 *
 * Вход: _expr - переменная над которой проводится операция
 *       _expN - длина до которой дополняется
 *       _expC - символ которым дополняется
 ******************************************************************************}
function PADC(_expr:string; _expC:Char; _expN: Cardinal) : string;
var
  temp_left  : string;
  temp_right : string;

  str_size   : Cardinal;
  diff       : Integer;
  diff_left  : Integer;
  diff_right : Integer;
begin
  str_size := Length(_expr);
  diff := _expN - str_size;

  if diff > 0 then
   begin
     diff_left  := Trunc(diff/2);
     diff_right := diff - diff_left;

     temp_left   := StringOfChar(_expC, diff_left);
     temp_right  := StringOfChar(_expC, diff_right);
   end
  else
   begin
     temp_left  := '';
     temp_right := '';
   end;

  PADC := temp_left + _expr + temp_right;
end;
Initialization

Finalization

End.