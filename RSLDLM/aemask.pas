{
Набор библиотек на языке Delphi для разработки модулей проблемно-ориентированного языка RSL

  Версия: 1.0.0

  Разработчик: Адамов Ербулат, adamov.e.n@gmail.com
  Дата последней модификации: 2009 год

  Набор разрабатывался автором в учебно-познавательных целях.
  Разрешается свободное использование набора без каких либо ограничений.
  Набор предоставляется как есть, без какой-либо ответственности и претензий к автору.
}

Unit aemask;
InterFace

Var
  Eng, Rus, Cif, Sign:Set Of Char;

function TextOnMask(mask:String; str:String):String;
function MaskOnText(mask:String; str:String):String;

Implementation

{Накладывает текст на маску
результатом получается текст по маске но с учетом символов}
function TextOnMask(mask:String; str:String):String;
  var i, j:LongInt;
      Res:String;
Begin
  If (Length(mask) <= 0) Then Begin Result:=str; Exit; End;
  If (Length(str) <= 0) Then Begin Result:=''; Exit; End;
  Res:='';
  j:=1;
  For i:=1 To Length(mask) Do Begin
    Case mask[i] Of
      '#':Begin {Может быть цифра, символ или знаки -+}
            If ((str[j] in cif)) or (str[j] in Sign) Then Begin Res:=Res+str[j]; Inc(j); End;
          End;
      '0':Begin {Должна быть обязательна цифра} 
            If (str[j] in cif) Then Begin Res:=Res+str[j]; Inc(j); End;
          End;
      '9':Begin {Может быть только цифра}
            If (str[j] in cif) Then Begin Res:=Res+str[j]; Inc(j); End;
          End;
      'a','A':Begin {Может быть только буква}
            If ((str[j] in Eng) or (str[j] in Rus)) Then Begin Res:=Res+str[j]; Inc(j); End;
          End;
    Else
      Res:=Res+mask[i];
    End;
  End;
  Result:=Res;
End;


{Накладывает маску на текст
результатом получается текст по маске но без учетом символов}
function MaskOnText(mask:String; str:String):String;
  var i:LongInt;
      Res:String;
Begin
  If (Length(mask) <= 0) Then Begin Result:=str; Exit; End;
  If (Length(str) <= 0) Then Begin Result:=''; Exit; End;
  Res:='';
  For i:=1 To Length(mask) Do Begin
    Case mask[i] Of
      '#':Begin {Может быть цифра, символ или знаки -+}
            If ((str[i] in cif)) or (str[i] in Sign) Then Begin Res:=Res+str[i]; End;
          End;
      '0':Begin {Должна быть обязательна цифра} 
            If (str[i] in cif) Then Begin Res:=Res+str[i]; End;
          End;
      '9':Begin {Может быть только цифра}
            If (str[i] in cif) Then Begin Res:=Res+str[i]; End;
          End;
      'a','A':Begin {Может быть только цифра}
            If ((str[i] in Eng) or (str[i] in Rus)) Then Begin Res:=Res+str[i]; End;
          End;
    End;
  End;
  Result:=Res;
End;

Initialization
  Eng:=['q','w','e','r','t','y','u','i','o','p','a','s','d','f','g','h','j','k','l','z','x','c','v','b','n','m','Q','W','E','R','T','Y','U','I','O','P','A','S','D','F','G','H','J','K','L','Z','X','C','V','B','N','M'];
  Rus:=['й','ц','у','к','е','н','г','ш','щ','з','х','ъ','ф','ы','в','а','п','р','о','л','д','ж','э','я','ч','с','м','и','т','ь','б','ю','ё','Й','Ц','У','К','Е','Н','Г','Ш','Щ','З','Х','Ъ','Ф','Ы','В','А','П','Р','О','Л','Д','Ж','Э','Я','Ч','С','М','И','Т','Ь','Б','Ю','Ё'];
  Cif:=['1','2','3','4','5','6','7','8','9', '0'];
  Sign:=['-','+'];
Finalization

End.