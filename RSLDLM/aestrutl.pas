{
����� ������⥪ �� �몥 Delphi ��� ࠧࠡ�⪨ ���㫥� �஡�����-�ਥ��஢������ �몠 RSL

  �����: 1.0.0

  ���ࠡ��稪: ������ ��㫠�, adamov.e.n@gmail.com
  ��� ��᫥���� ����䨪�樨: 2009 ���

  ����� ࠧࠡ��뢠��� ���஬ � �祡��-�������⥫��� 楫��.
  ����蠥��� ᢮������ �ᯮ�짮����� ����� ��� ����� ���� ��࠭�祭��.
  ����� �।��⠢����� ��� ����, ��� �����-���� �⢥��⢥����� � ��⥭��� � �����.
}

Unit aestrutl;
InterFace

function PADC(_expr:string; _expC:Char; _expN: Cardinal) : string;
function PADR(_expr:String; _expC:Char; _expN:Cardinal) : string;
function PADL(_expr:String; _expC:Char; _expN:Cardinal) : string;

Implementation
{******************************************************************************
 * PADR  - �������� ��६����� �ࠢ� ᨬ������ �� ����ன ������.
 *
 * �室: _expr - ��६����� ��� ���ன �஢������ ������
 *       _expN - ����� �� ���ன ����������
 *       _expC - ᨬ��� ���� ����������
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
 * PADL  - �������� ��६����� ᫥�� ᨬ������ �� ����ன ������.
 *
 * �室: _expr - ��६����� ��� ���ன �஢������ ������
 *       _expN - ����� �� ���ன ����������
 *       _expC - ᨬ��� ���� ����������
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
 * PADC  - �������� ��६����� � ����� ��஭ ᨬ������ �� �����ன ������.
 *
 * �室: _expr - ��६����� ��� ���ன �஢������ ������
 *       _expN - ����� �� ���ன ����������
 *       _expC - ᨬ��� ����� ����������
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