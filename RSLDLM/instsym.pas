{
����� ������⥪ �� �몥 Delphi ��� ࠧࠡ�⪨ ���㫥� �஡�����-�ਥ��஢������ �몠 RSL

  �����: 1.0.0

  ���ࠡ��稪: ������ ��㫠�, adamov.e.n@gmail.com
  ��� ��᫥���� ����䨪�樨: 2009 ���

  ����� ࠧࠡ��뢠��� ���஬ � �祡��-�������⥫��� 楫��.
  ����蠥��� ᢮������ �ᯮ�짮����� ����� ��� ����� ���� ��࠭�祭��.
  ����� �।��⠢����� ��� ����, ��� �����-���� �⢥��⢥����� � ��⥭��� � �����.
}


Unit instsym;
InterFace

Uses rsltype, rsldll;

Var
  GenRunHandle:PISYMBOL;        //��� �࠭���� ��뫪� �� ��⮤ GenRun
  GenSetPropHandle:PISYMBOL;    //��� �࠭���� ��뫪� �� ��⮤ GenSetProp
  GenGetPropHandle:PISYMBOL;    //��� �࠭���� ��뫪� �� ��⮤ GenGetProp
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