{
����� ������⥪ �� �몥 Delphi ��� ࠧࠡ�⪨ ���㫥� �஡�����-�ਥ��஢������ �몠 RSL

  �����: 1.0.0

  ���ࠡ��稪: ������ ��㫠�, adamov.e.n@gmail.com
  ��� ��᫥���� ����䨪�樨: 2009 ���

  ����� ࠧࠡ��뢠��� ���஬ � �祡��-�������⥫��� 楫��.
  ����蠥��� ᢮������ �ᯮ�짮����� ����� ��� ����� ���� ��࠭�祭��.
  ����� �।��⠢����� ��� ����, ��� �����-���� �⢥��⢥����� � ��⥭��� � �����.
}

unit myunit;

interface

var str:PChar;

implementation
  uses  
        rsltype, 
        btintf,
        rsltbl, 
        rslfs,
        rsldll,
        DLMSys;

Type
  Test = Class(TGenObject)

  end;

Procedure DemoCPP; stdcall;
var
  UN:LongInt;
  DLMVER:Word;
  BD:BDHANDLE;
  BT:BTHANDLE;
  BND:BNDHANDLE;
  oper:SmallInt;
  autokey:LongInt;
  appkey:PChar;
  sum:Extended;
  res:Integer;
begin
  GetMem(appkey, 31);
  UN:=RSLUserNumber();
  DLMVER:=RSLVersion();
  RSLPrint('UserNumber: %d'#13,[pointer(UN)]);
  RSLPrint('DLM Version: %d'#13,[pointer(DLMVER)]);
  BD:=RSLBtOpenDataBase('d:\\dbfile\\bank.def', '', '', 1);
  if (BD = NIL) Then RSLError('�訡�� ������ ᫮����', []);  
  RSLBtSetBlobType(BD, BT_NOBLOB);
  BT:=RSLBtOpenTable(BD, 'document.dbt', BT_OPEN_READONLY, 0, 'd:\\dbfile\\document.dbt'); 
  if (BT = NIL) Then RSLError('�訡�� ������ 䠩��', []);  
  RSLBtBindField(BT, 'AutoKey', @autokey, FT_LONG, 4);
  RSLBtBindField(BT, 'Oper', @oper, FT_INT, 2);
  RSLBtBindField(BT, 'ApplicationKey', appkey, FT_STRING, 30);
  RSLBtBindField(BT, 'Sum', @sum, FT_LDMON, 10);
  res:=RSLBtFetchNext(BT);
  if (res <> 0) Then RSLError('�訡�� next', []);  
  res:=RSLBtFetchNext(BT);
  if (res <> 0) Then RSLError('�訡�� next', []);  
  RSLPrint('Autokey=%d'#13, [Pointer(autokey)]);
  RSLPrint('Oper=%d'#13, [Pointer(oper)]);
  RSLPrint('Appkey=%s'#13, [appkey]);
  //RSLMsgBox('Test', []);
  //RSLPrint('Sum=%f'#13, [@sum]);
  RSLReturnVal(V_STRING, appkey);
end;


initialization

ExportProcedure('DemoCPP',@DemoCPP,V_UNDEF);
//ExportObject(@InitProvider, @DoneProvider, @CreateObject, @GetTypeInfo);

end.

