{
����� ������⥪ �� �몥 Delphi ��� ࠧࠡ�⪨ ���㫥� �஡�����-�ਥ��஢������ �몠 RSL

  �����: 1.0.0

  ���ࠡ��稪: ������ ��㫠�, adamov.e.n@gmail.com
  ��� ��᫥���� ����䨪�樨: 2009 ���

  ����� ࠧࠡ��뢠��� ���஬ � �祡��-�������⥫��� 楫��.
  ����蠥��� ᢮������ �ᯮ�짮����� ����� ��� ����� ���� ��࠭�祭��.
  ����� �।��⠢����� ��� ����, ��� �����-���� �⢥��⢥����� � ��⥭��� � �����.
}

Unit aemask;
InterFace

Var
  Eng, Rus, Cif, Sign:Set Of Char;

function TextOnMask(mask:String; str:String):String;
function MaskOnText(mask:String; str:String):String;

Implementation

{������뢠�� ⥪�� �� ����
१���⮬ ����砥��� ⥪�� �� ��᪥ �� � ��⮬ ᨬ�����}
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
      '#':Begin {����� ���� ���, ᨬ��� ��� ����� -+}
            If ((str[j] in cif)) or (str[j] in Sign) Then Begin Res:=Res+str[j]; Inc(j); End;
          End;
      '0':Begin {������ ���� ��易⥫쭠 ���} 
            If (str[j] in cif) Then Begin Res:=Res+str[j]; Inc(j); End;
          End;
      '9':Begin {����� ���� ⮫쪮 ���}
            If (str[j] in cif) Then Begin Res:=Res+str[j]; Inc(j); End;
          End;
      'a','A':Begin {����� ���� ⮫쪮 �㪢�}
            If ((str[j] in Eng) or (str[j] in Rus)) Then Begin Res:=Res+str[j]; Inc(j); End;
          End;
    Else
      Res:=Res+mask[i];
    End;
  End;
  Result:=Res;
End;


{������뢠�� ���� �� ⥪��
१���⮬ ����砥��� ⥪�� �� ��᪥ �� ��� ��⮬ ᨬ�����}
function MaskOnText(mask:String; str:String):String;
  var i:LongInt;
      Res:String;
Begin
  If (Length(mask) <= 0) Then Begin Result:=str; Exit; End;
  If (Length(str) <= 0) Then Begin Result:=''; Exit; End;
  Res:='';
  For i:=1 To Length(mask) Do Begin
    Case mask[i] Of
      '#':Begin {����� ���� ���, ᨬ��� ��� ����� -+}
            If ((str[i] in cif)) or (str[i] in Sign) Then Begin Res:=Res+str[i]; End;
          End;
      '0':Begin {������ ���� ��易⥫쭠 ���} 
            If (str[i] in cif) Then Begin Res:=Res+str[i]; End;
          End;
      '9':Begin {����� ���� ⮫쪮 ���}
            If (str[i] in cif) Then Begin Res:=Res+str[i]; End;
          End;
      'a','A':Begin {����� ���� ⮫쪮 ���}
            If ((str[i] in Eng) or (str[i] in Rus)) Then Begin Res:=Res+str[i]; End;
          End;
    End;
  End;
  Result:=Res;
End;

Initialization
  Eng:=['q','w','e','r','t','y','u','i','o','p','a','s','d','f','g','h','j','k','l','z','x','c','v','b','n','m','Q','W','E','R','T','Y','U','I','O','P','A','S','D','F','G','H','J','K','L','Z','X','C','V','B','N','M'];
  Rus:=['�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�'];
  Cif:=['1','2','3','4','5','6','7','8','9', '0'];
  Sign:=['-','+'];
Finalization

End.