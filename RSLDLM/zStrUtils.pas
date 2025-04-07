{
Набор библиотек на языке Delphi для разработки модулей проблемно-ориентированного языка RSL

  Версия: 1.0.0

  Разработчик: Адамов Ербулат, adamov.e.n@gmail.com
  Дата последней модификации: 2009 год

  Набор разрабатывался автором в учебно-познавательных целях.
  Разрешается свободное использование набора без каких либо ограничений.
  Набор предоставляется как есть, без какой-либо ответственности и претензий к автору.
}

unit zStrUtils;
interface
{$D-}

uses
  Windows;

function WideStrToStr(const ws: widestring; codepage: word): ansistring;
function StrToWideStr(const s: ansistring; codepage: word): widestring;
Function ConvertAnsiToOem(const S:String) : string;
Function ConvertOemToAnsi(const S:String) : string;
Function ConvertUTF8ToOem(const S:UTF8String):String;
Function ConvertOemToUTF8(const S:String):UTF8String;

implementation

function WideStrToStr(const ws: widestring; codepage: word): ansistring; 
var
  l: integer;
begin
  if ws = '' then  result := ''
  else
  begin
    l := WideCharToMultiByte(codepage,
    wc_compositecheck or wc_discardns or wc_sepchars or wc_defaultchar,
    @ws[1], - 1, nil, 0, nil, nil);
    setlength(result, l - 1);
    if l > 1 then
      WideCharToMultiByte(codepage,
      wc_compositecheck or wc_discardns or wc_sepchars or wc_defaultchar,
      @ws[1], - 1, @result[1], l - 1, nil, nil);
  end;
end;

function StrToWideStr(const s: ansistring; codepage: word): widestring;
var
  l: integer;
begin
  if s = '' then  result := ''
  else
  begin
    l := MultiByteToWideChar(codepage, mb_precomposed, pchar(@s[1]), - 1, nil, 0);
    setlength(result, l - 1);
    if l > 1 then
      MultiByteToWideChar(codepage, mb_precomposed, pchar(@s[1]),
      - 1, pwidechar(@result[1]), l - 1);
    end;
end;

Function ConvertAnsiToOem(const S:String) : string;
{ ConvertAnsiToOem translates a string into the OEM-defined character set }
Begin
  SetLength(Result, Length(S));
  if Length(Result) > 0 then
    AnsiToOem(PChar(S), PChar(Result));
End; { ConvertAnsiToOem }

Function ConvertOemToAnsi(const S:String) : string;
{ ConvertOemToAnsi translates a string from the OEM-defined
  character set into either an ANSI or a wide-character string }
Begin
  SetLength(Result, Length(S));
  if Length(Result) > 0 then
    OemToAnsi(PChar(S), PChar(Result));
End; { ConvertOemToAnsi }

Function ConvertUTF8ToOem(const S:UTF8String):String;
Var v_s:String;
Begin
  v_s:=UTF8ToAnsi(S);
  Result:=ConvertAnsiToOem(v_s);
End;

Function ConvertOemToUTF8(const S:String):UTF8String;
Var v_s:String;
Begin
  v_s:=ConvertOemToAnsi(S);
  Result:=AnsiToUTF8(v_s);
End;

end.
 