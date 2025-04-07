Unit aeclip;
InterFace

Uses
    sysutils,
    clipbrd,
    rsltype,
    rsldll,
    uniprov,
    aeconst;

Type

  PaeClipboard = ^TaeClipboard;
  TaeClipboard = Packed Object
    public
    Remote:Boolean; //�� ���������?

    {������}
    Constructor Create();
    procedure Done(); virtual;
    //������ ����������� �� RSL
    function  RSLCreate(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLDone(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLInit(ParmNum:PLongInt):LongInt; virtual; cdecl;
    function  RSLGetBuffer(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLSetBuffer(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLClearBuffer(ret:PVALUE):LongInt; virtual; cdecl;
    //�������� ���������� �� RSL
    function  get_Remote(ret:PVALUE):LongInt; cdecl;
    function  put_Remote(new:PVALUE):LongInt; cdecl;
    //������ �������
    function  GetBuffer():PChar;
    procedure SetBuffer(parm:PChar);   
    procedure ClearBuffer();   
  end;


var
  PaeClipboardTable:PMethodTable;
  TaeClipboardTable:TMethodTable;
  TaeClipboardEntrys:Packed Array of TMethodEntry;

{*****************************************************************


******************************************************************}
Implementation

Constructor TaeClipboard.Create();
begin
  Remote:=TRUE;
end;

Procedure TaeClipboard.Done();
begin
end;

function  TaeClipboard.RSLCreate(ret:PVALUE):LongInt;
begin
  Create();
  Result:=0;
end;

function  TaeClipboard.RSLDone(ret:PVALUE):LongInt;
begin
  Done();
  Result:=0;
end;

function  TaeClipboard.RSLInit(ParmNum:PLongInt):LongInt;
  var v:PVALUE;
      i:LongInt;
begin
  i:=ParmNum^;

  RSLGetParm(i, @v);
  if (v.v_type = V_BOOL) Then Remote:=v.boolval;
  Result:=0;
End;

{*****************************************************************

                            ������

******************************************************************}

function  TaeClipboard.RSLClearBuffer(ret:PVALUE):LongInt;
begin
  ClearBuffer();
  Result:=0;
end;

function  TaeClipboard.RSLGetBuffer(ret:PVALUE):LongInt;
  var s:PChar;
begin
  RSLValueMake(ret);
  s:=GetBuffer();
  RSLValueSet(ret, V_STRING, s);
  Result:=0;
end;

function  TaeClipboard.RSLSetBuffer(ret:PVALUE):LongInt;
var  
  v:PVALUE;
begin
  RSLGetParm(1, @v);
  if (v.v_type<>V_STRING) Then RSLError('SetBuffer(STRING)',[]);
  SetBuffer(v.RSLString);
  Result:=0;
end;

{*****************************************************************

                ������� ��� RSL

******************************************************************}

function  TaeClipBoard.GetBuffer():PChar;
  var put, get:PTextBuffer;
      sz:LongWord;
begin
  Result:='';
  if (Remote) Then Begin
    //�������� ��������� �� ����� ��� ��������� ������
    put:=RSLfs_getSendBuff(0, TermDlmName, CMD_aeGetClipboard);
    //�������� ����� ���������� ���������
    get:=RSLfs_transactMessage(put, sz);
    if (sz >= SizeOf(TTextBuffer)) Then Result:=get.data;
  End Else Begin
    GetMem(get, SizeOf(TTextBuffer));
    Clipboard.GetTextBuf(get.data, SizeOf(TTextBuffer));
    Result:=get.data;
    //FreeMem(buff);
  End;
end;

procedure TaeClipBoard.SetBuffer(parm:PChar);   
var 
  put:PTextBuffer;
begin
  if (Remote) Then Begin
    //�������� ��������� �� ����� ��� ��������� ������
    put:=RSLfs_getSendBuff(SizeOf(TTextBuffer), TermDlmName, CMD_aeSetClipboard);
    StrCopy(put.data, parm);
    //�������� ������ �� ���� ������� ������ ��������� ���������
    RSLfs_sendMessage(put);
  End Else Begin
    Clipboard.SetTextBuf(parm);
  End;
end;

procedure TaeClipBoard.ClearBuffer();   
  var put:PTextBuffer;
begin
  if (Remote) Then Begin
    //�������� ��������� �� ����� ��� ��������� ������
    put:=RSLfs_getSendBuff(0, TermDlmName, CMD_aeClipboardClear);
    //���������� ���������
    RSLfs_sendMessage(put);
  End Else Begin
    Clipboard.Clear();
  End;
end;

{*****************************************************************

                    �������� �������

******************************************************************}

function  TaeClipBoard.get_Remote(ret:PVALUE):LongInt;
begin
  RSLValueClear(ret);
  RSLValueSet(ret, V_BOOL, @Remote);
  Result:=0;
end;

function  TaeClipBoard.put_Remote(new:PVALUE):LongInt;
begin
  if (new.v_type <> V_BOOL) Then RSLError('�������� ��������:BOOL', []);
  Remote:=new.boolval;
  Result:=0;
end;

{*****************************************************************



******************************************************************}

procedure MakeTaeClipboard();
  var i:Word;
begin
  SetLength(TaeClipboardEntrys, 9);
  {������}
  i:=0;
  RSL_METH('Get', @TaeClipboard.RSLGetBuffer, TaeClipboardEntrys[i]);

  Inc(i);
  RSL_METH('Set', @TaeClipboard.RSLSetBuffer, TaeClipboardEntrys[i]);

  Inc(i);
  RSL_METH('Clear', @TaeClipboard.RSLClearBuffer, TaeClipboardEntrys[i]);

  {��������}
  Inc(i);
  RSL_PROP_METH('Remote', @TaeClipboard.get_Remote, @TaeClipboard.put_Remote, TaeClipboardEntrys[i]);

  Inc(i);
  RSL_INIT(@TaeClipboard.RSLInit, TaeClipboardEntrys[i]);

  Inc(i);
  RSL_CTRL(@TaeClipboard.RSLCreate, TaeClipboardEntrys[i]);

  Inc(i);
  RSL_DSTR(@TaeClipboard.RSLDone, TaeClipboardEntrys[i]);

  Inc(i);
  RSL_TBL_END(TaeClipboardEntrys[i]);

  TaeClipboardTable.clsName:='TaeClipboard';
  TaeClipboardTable.userSize:=SizeOf(TaeClipboard);
  TaeClipboardTable.Entrys:=@TaeClipboardEntrys[0];
  TaeClipboardTable.canInherit:=TRUE;
  TaeClipboardTable.canCvtToIDisp:=TRUE;
  TaeClipboardTable.Ver:=1;
  TaeClipboardTable.autoPtr:=NIL;

  PaeClipboardTable:=@TaeClipboardTable;

end;

Begin
  MakeTaeClipboard();
End.
