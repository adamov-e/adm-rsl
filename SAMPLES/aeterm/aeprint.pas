Unit aeprint;
InterFace

Uses
    sysutils,
    printers,
    rsltype,
    rsldll,
    uniprov,
    aeconst;

Type

  PaePrinter = ^TaePrinter;
  TaePrinter = Packed Object
    public
    Remote:Boolean; //на терминале?

    {Методы}
    Constructor Create();
    procedure Done(); virtual;
    //методы вызываемые из RSL
    function  RSLCreate(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLDone(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLInit(ParmNum:PLongInt):LongInt; virtual; cdecl;

    function  RSLBeginPrint(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLEndPrint(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLPrintText(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLNewPage(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLPrinter(ret:PVALUE):LongInt; virtual; cdecl;
    //свойства вызываемые из RSL
    function  get_Remote(ret:PVALUE):LongInt; cdecl;
    function  put_Remote(new:PVALUE):LongInt; cdecl;
    function  get_Printers(ret:PVALUE):LongInt; cdecl;
    function  get_Title(ret:PVALUE):LongInt; cdecl;
    function  put_Title(new:PVALUE):LongInt; cdecl;
    function  get_Count(ret:PVALUE):LongInt; cdecl;
    function  get_PrinterIndex(ret:PVALUE):LongInt; cdecl;
    function  put_PrinterIndex(new:PVALUE):LongInt; cdecl;
    //Родные методы объекта
    procedure BeginPrint();
    procedure EndPrint();   
    procedure PrintText(vx:LongInt; vy:LongInt; vs:PChar);   
    procedure NewPage();   
    function  GetPrinter(ind:Integer):PChar;
  end;


var
  PaePrinterTable:PMethodTable;
  TaePrinterTable:TMethodTable;
  TaePrinterEntrys:Packed Array of TMethodEntry;

{*****************************************************************


******************************************************************}
Implementation

Constructor TaePrinter.Create();
begin
  Remote:=TRUE;
end;

Procedure TaePrinter.Done();
begin
end;

function  TaePrinter.RSLCreate(ret:PVALUE):LongInt;
begin
  Create();
  Result:=0;
end;

function  TaePrinter.RSLDone(ret:PVALUE):LongInt;
begin
  Done();
  Result:=0;
end;

function  TaePrinter.RSLInit(ParmNum:PLongInt):LongInt;
  var v:PVALUE;
      i:LongInt;
begin
  i:=ParmNum^;

  RSLGetParm(i, @v);
  if (v.v_type = V_BOOL) Then Remote:=v.boolval;
  Result:=0;
End;

{*****************************************************************

                            Методы

******************************************************************}

function  TaePrinter.RSLBeginPrint(ret:PVALUE):LongInt;
begin
  BeginPrint();
  Result:=0;
end;

function  TaePrinter.RSLEndPrint(ret:PVALUE):LongInt;
begin
  EndPrint();
  Result:=0;
end;

function  TaePrinter.RSLPrintText(ret:PVALUE):LongInt;
var  
  v1, v2, v3:PVALUE;
begin
  RSLGetParm(1, @v1);
  RSLGetParm(2, @v2);
  RSLGetParm(3, @v3);
  if (v1.v_type<>V_INTEGER) Then RSLError('PrintText(X:INT;Y:INT;S:STR)',[]);
  if (v2.v_type<>V_INTEGER) Then RSLError('PrintText(X:INT;Y:INT;S:STR)',[]);
  if (v3.v_type<>V_STRING) Then RSLError('PrintText(X:INT;Y:INT;S:STR)',[]);
  PrintText(v1.intval, v2.intval, v3.RSLString);
  Result:=0;
end;

function  TaePrinter.RSLNewPage(ret:PVALUE):LongInt;
begin
  NewPage();
  Result:=0;
end;

function  TaePrinter.RSLPrinter(ret:PVALUE):LongInt;
  var v:PVALUE;
begin
  RSLGetParm(1, @v);
  if (v.v_type<>V_INTEGER) Then RSLError('Printer(IND:INT):STRING',[]);
  if (v.intval < 0) Then RSLError('Printer(IND:INT):STRING',[]);
  RSLValueClear(ret);
  RSLValueSet(ret, V_STRING, GetPrinter(v.intval));
  Result:=0;
end;


{*****************************************************************

                Обертки для RSL

******************************************************************}

procedure TaePrinter.BeginPrint();
  var put:PChar;
begin
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(0, TermDlmName, CMD_aeBeginPrint);
    //отправляем сообщение
    RSLfs_sendMessage(put);
  End Else Begin
    Printer.BeginDoc();
  End;
end;

procedure TaePrinter.EndPrint();   
var 
  put:PChar;
begin
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(0, TermDlmName, CMD_aeEndPrint);
    //отправляем сообщение
    RSLfs_sendMessage(put);
  End Else Begin
    Printer.EndDoc();
  End;
end;

procedure TaePrinter.PrintText(vx:LongInt; vy:LongInt; vs:PChar);
  var put:PPrintBuffer;
begin
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(TPrintBuffer), TermDlmName, CMD_aePrintText);
    put.X:=vx;
    put.y:=vy;
    StrCopy(put.data, vs);
    //получать ничего не нада поэтому просто тправляем сообщение
    RSLfs_sendMessage(put);
  End Else Begin
    Printer.Canvas.TextOut(vx, vy, vs);
  End;
end;

procedure TaePrinter.NewPage();   
var 
  put:PChar;
begin
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(0, TermDlmName, CMD_aeNewPage);
    //отправляем сообщение
    RSLfs_sendMessage(put);
  End Else Begin
    Printer.NewPage();
  End;
end;

function  TaePrinter.GetPrinter(ind:Integer):PChar;
  var put:PIntBuffer;
      get:PSmallTxtBuffer;
      sz:LongWord;
begin
  Result:='';
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(TIntBuffer), TermDlmName, CMD_aeGetPrinter);
    put.int:=ind;
    //отправляем сообщение
    get:=RSLfs_transactMessage(put, sz);
    if (sz >= SizeOf(TSmallTxtBuffer)) Then Result:=get.data;
  End Else Begin
    Result:=PChar(Printer.Printers[ind]);
  End;
end;


{*****************************************************************

                    Свойства объекта

******************************************************************}

function  TaePrinter.get_Remote(ret:PVALUE):LongInt;
begin
  RSLValueClear(ret);
  RSLValueSet(ret, V_BOOL, @Remote);
  Result:=0;
end;

function  TaePrinter.put_Remote(new:PVALUE):LongInt;
begin
  if (new.v_type <> V_BOOL) Then RSLError('Неверный параметр:BOOL', []);
  Remote:=new.boolval;
  Result:=0;
end;

function  TaePrinter.get_Printers(ret:PVALUE):LongInt;
  var put, get:PTextBuffer;
      sz:LongWord;
begin
  RSLValueClear(ret);
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(0, TermDlmName, CMD_aeGetPrinters);
    //получаем буфер отправляем сообщение
    get:=RSLfs_transactMessage(put, sz);
    if (sz >= SizeOf(TTextBuffer)) Then RSLValueSet(ret, V_STRING, @get.data[0]);
  End Else Begin
    RSLValueSet(ret, V_STRING, PChar(Printer.Printers.Text));
  End;
  Result:=0;
end;


function  TaePrinter.get_Title(ret:PVALUE):LongInt;
  var put, get:PTextBuffer;
      sz:LongWord;
begin
  RSLValueClear(ret);
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(0, TermDlmName, CMD_aeGetPrintTitle);
    //получаем буфер отправляем сообщение
    get:=RSLfs_transactMessage(put, sz);
    if (sz >= SizeOf(TTextBuffer)) Then RSLValueSet(ret, V_STRING, @get.data[0]);
  End Else Begin
    RSLValueSet(ret, V_STRING, PChar(Printer.Title));
  End;
  Result:=0;
end;

function  TaePrinter.put_Title(new:PVALUE):LongInt;
  var put:PTextBuffer;
begin
  if (new.v_type <> V_STRING) Then RSLError('Неверный параметр:STRING', []);
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(TPrintBuffer), TermDlmName, CMD_aeSetPrintTitle);
    StrCopy(put.data, new.RSLString);
    //получать ничего не нада поэтому просто тправляем сообщение
    RSLfs_sendMessage(put);
  End Else Begin
    Printer.Title:=String(new.RSLString);
  End;
  Result:=0;
end;

function  TaePrinter.get_Count(ret:PVALUE):LongInt;
  var put, get:PIntBuffer;
      i:Integer;
      sz:LongWord;
begin
  RSLValueClear(ret);
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(0, TermDlmName, CMD_aeGetPrinterCount);
    //получаем буфер отправляем сообщение
    get:=RSLfs_transactMessage(put, sz);
    if (sz >= SizeOf(TIntBuffer)) Then RSLValueSet(ret, V_INTEGER, @get.int);
  End Else Begin
    i:=Printer.Printers.Count;
    RSLValueSet(ret, V_INTEGER, @i);
  End;
  Result:=0;
end;


function  TaePrinter.get_PrinterIndex(ret:PVALUE):LongInt;
  var put, get:PIntBuffer;
      sz:LongWord;
      i:Integer;
begin
  RSLValueClear(ret);
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(0, TermDlmName, CMD_aeGetPrinterIndex);
    //получаем буфер отправляем сообщение
    get:=RSLfs_transactMessage(put, sz);
    if (sz >= SizeOf(TIntBuffer)) Then RSLValueSet(ret, V_INTEGER, @get.int);
  End Else Begin
    i:=Printer.PrinterIndex;
    RSLValueSet(ret, V_INTEGER, @i);
  End;
  Result:=0;
end;

function  TaePrinter.put_PrinterIndex(new:PVALUE):LongInt;
  var put:PIntBuffer;
begin
  if (new.v_type <> V_INTEGER) Then RSLError('Неверный параметр:INTEGER', []);
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(TIntBuffer), TermDlmName, CMD_aeSetPrinterIndex);
    put.int:=new.intval;
    //получать ничего не нада поэтому просто тправляем сообщение
    RSLfs_sendMessage(put);
  End Else Begin
    Printer.PrinterIndex:=new.intval;
  End;
  Result:=0;
end;


{*****************************************************************



******************************************************************}

procedure MakeTaePrinter();
  var i:Word;
begin
  SetLength(TaePrinterEntrys, 15);
  {Методы}
  i:=0;
  RSL_METH('BeginDoc', @TaePrinter.RSLBeginPrint, TaePrinterEntrys[i]);

  Inc(i);
  RSL_METH('EndDoc', @TaePrinter.RSLEndPrint, TaePrinterEntrys[i]);

  Inc(i);
  RSL_METH('PrintText', @TaePrinter.RSLPrintText, TaePrinterEntrys[i]);

  Inc(i);
  RSL_METH('NewPage', @TaePrinter.RSLNewPage, TaePrinterEntrys[i]);

  Inc(i);
  RSL_METH('Printer', @TaePrinter.RSLPrinter, TaePrinterEntrys[i]);

  {Свойства}
  Inc(i);
  RSL_PROP_METH('Remote', @TaePrinter.get_Remote, @TaePrinter.put_Remote, TaePrinterEntrys[i]);

  Inc(i);
  RSL_PROP_METH('Printers', @TaePrinter.get_Printers, NIL, TaePrinterEntrys[i]);

  Inc(i);
  RSL_PROP_METH('Title', @TaePrinter.get_Title, @TaePrinter.put_Title, TaePrinterEntrys[i]);

  Inc(i);
  RSL_PROP_METH('Count', @TaePrinter.get_Count, NIL, TaePrinterEntrys[i]);

  Inc(i);
  RSL_PROP_METH('PrinterIndex', @TaePrinter.get_PrinterIndex, @TaePrinter.put_PrinterIndex, TaePrinterEntrys[i]);

  Inc(i);
  RSL_INIT(@TaePrinter.RSLInit, TaePrinterEntrys[i]);

  Inc(i);
  RSL_CTRL(@TaePrinter.RSLCreate, TaePrinterEntrys[i]);

  Inc(i);
  RSL_DSTR(@TaePrinter.RSLDone, TaePrinterEntrys[i]);

  Inc(i);
  RSL_TBL_END(TaePrinterEntrys[i]);

  TaePrinterTable.clsName:='TaePrinter';
  TaePrinterTable.userSize:=SizeOf(TaePrinter);
  TaePrinterTable.Entrys:=@TaePrinterEntrys[0];
  TaePrinterTable.canInherit:=TRUE;
  TaePrinterTable.canCvtToIDisp:=TRUE;
  TaePrinterTable.Ver:=1;
  TaePrinterTable.autoPtr:=NIL;

  PaePrinterTable:=@TaePrinterTable;

end;

Begin
  MakeTaePrinter();
End.
