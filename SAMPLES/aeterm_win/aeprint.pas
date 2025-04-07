Unit aeprint;
InterFace

Uses
    sysutils,
    windows,
    winspool,
    Sprinters,
    rsltype,
    rsldll,
    uniprov,
    aeconst,
    zStrUtils;

Type

  PaePrinter = ^TaePrinter;
  TaePrinter = Packed Object
    public
    Remote:Boolean; //на терминале?
    OEMtoANSI:Boolean; //автоматически конвертировать?
    PixelsX, PixelsY:Integer;

    {Методы}
    Constructor Create();
    procedure Done(); virtual;
    //методы вызываемые из RSL
    function  RSLCreate(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLDone(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLInit(ParmNum:PLongInt):LongInt; virtual; cdecl;

    function  RSLBeginDoc(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLEndDoc(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLBeginPrint(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLEndPrint(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLNewPage(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLStartPage(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLPrintText(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLPrinter(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLDirectPrint(ret:PVALUE):LongInt; virtual; cdecl;
    function  RSLWritePrinter(ret:PVALUE):LongInt; virtual; cdecl;
    //свойства вызываемые из RSL
    function  get_Remote(ret:PVALUE):LongInt; cdecl;
    function  put_Remote(new:PVALUE):LongInt; cdecl;
    function  get_Printers(ret:PVALUE):LongInt; cdecl;
    function  get_Title(ret:PVALUE):LongInt; cdecl;
    function  put_Title(new:PVALUE):LongInt; cdecl;
    function  get_Count(ret:PVALUE):LongInt; cdecl;
    function  get_PrinterIndex(ret:PVALUE):LongInt; cdecl;
    function  put_PrinterIndex(new:PVALUE):LongInt; cdecl;
    function  get_PrinterSupportPassthrough(ret:PVALUE):LongInt; cdecl;
    function  get_OEMtoANSI(ret:PVALUE):LongInt; cdecl;
    function  put_OEMtoANSI(new:PVALUE):LongInt; cdecl;
    function  get_FontName(ret:PVALUE):LongInt; cdecl;
    function  put_FontName(new:PVALUE):LongInt; cdecl;
    function  get_FontSize(ret:PVALUE):LongInt; cdecl;
    function  put_FontSize(new:PVALUE):LongInt; cdecl;

    //Родные методы объекта
    procedure BeginDocument();
    procedure BeginPrint();
    procedure EndDocument();
    procedure EndPrint();   
    procedure NewPage();   
    procedure StartPage();
    procedure PrintText(vx:LongInt; vy:LongInt; vs:PChar);   
    Procedure DirectPrint(vs:PChar);   
    Function  WriteToPrinter(vs:PChar):Integer;
    function  GetPrinter(ind:Integer):PChar;
    Procedure GetPrinterInfo;
    Function  PrinterCoordX(x:integer):integer;
    Function  PrinterCoordY(y:integer):integer;
    Function  PrinterSupportPassthrough():Integer;
  end;


var
  PaePrinterTable:PMethodTable;
  TaePrinterEntrys:TMethodEntrys;

{*****************************************************************


******************************************************************}
Implementation

Constructor TaePrinter.Create();
begin
  Remote:=TRUE;
  OEMtoANSI:=FALSE;
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

  RSLGetParm(i, v);
  if (v.v_type = V_BOOL) Then Remote:=v.boolval;
  Result:=0;
End;

{*****************************************************************

                            Методы

******************************************************************}

function  TaePrinter.RSLBeginDoc(ret:PVALUE):LongInt;
begin
  BeginDocument();
  Result:=0;
end;

function  TaePrinter.RSLEndDoc(ret:PVALUE):LongInt;
begin
  EndDocument();
  Result:=0;
end;

function  TaePrinter.RSLNewPage(ret:PVALUE):LongInt;
begin
  NewPage();
  Result:=0;
end;

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

function  TaePrinter.RSLStartPage(ret:PVALUE):LongInt;
begin
  StartPage();
  Result:=0;
end;

function  TaePrinter.RSLPrintText(ret:PVALUE):LongInt;
var  
  v1, v2, v3:PVALUE;
begin
  RSLGetParm(1, v1);
  RSLGetParm(2, v2);
  RSLGetParm(3, v3);
  if (v1.v_type<>V_INTEGER) Then RSLError('PrintText(X:INT;Y:INT;S:STR)',[]);
  if (v2.v_type<>V_INTEGER) Then RSLError('PrintText(X:INT;Y:INT;S:STR)',[]);
  if (v3.v_type<>V_STRING) Then RSLError('PrintText(X:INT;Y:INT;S:STR)',[]);
  PrintText(v1.intval, v2.intval, v3.RSLString);
  Result:=0;
end;

function  TaePrinter.RSLPrinter(ret:PVALUE):LongInt;
  var v:PVALUE;
begin
  RSLGetParm(1, v);
  if (v.v_type<>V_INTEGER) Then RSLError('Printer(IND:INT):STRING',[]);
  if (v.intval < 0) Then RSLError('Printer(IND:INT):STRING',[]);
  RSLValueClear(ret);
  RSLValueSet(ret, V_STRING, GetPrinter(v.intval));
  Result:=0;
end;

function  TaePrinter.RSLDirectPrint(ret:PVALUE):LongInt;
  var v:PVALUE;
begin
  RSLGetParm(1, v);
  if (v.v_type<>V_STRING) Then RSLError('DirectPrint(S:STRING)',[]);
  DirectPrint(v.RSLString);
  Result:=0;
end;

function  TaePrinter.RSLWritePrinter(ret:PVALUE):LongInt;
  var v:PVALUE;
      i:Integer;
begin
  RSLGetParm(1, v);
  if (v.v_type<>V_STRING) Then RSLError('WritePrinter(S:STRING)',[]);
  i:=WriteToPrinter(v.RSLString);
  RSLValueClear(ret);
  RSLValueSet(ret, V_INTEGER, @i);
  Result:=0;
end;

{*****************************************************************

                Обертки для RSL

******************************************************************}

Procedure TaePrinter.GetPrinterInfo; {Получить информацию о принтере }
begin
  Try
    PixelsX:=GetDeviceCaps(Printer.Handle,LogPixelsX);
    PixelsY:=GetDeviceCaps(Printer.Handle,LogPixelsY);
  Except
    on E:Exception do 
        Begin RSLMsgBox('%s', [PChar(E.Message)]); End;
  End;
end;

Function TaePrinter.PrinterCoordX(x:integer):integer; { переводит координаты из мм в пиксели }
begin
 Result:=Round(PixelsX/25.4*x);
end;

Function TaePrinter.PrinterCoordY(y:integer):integer; { переводит координаты из мм в пиксели  }
begin
 Result:=Round(PixelsY/25.4*Y);
end;

procedure TaePrinter.BeginDocument();
  var put:PChar;
begin
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(0, TermDlmName, CMD_aeBeginDocument);
    //отправляем сообщение
    RSLfs_sendMessage(put);
  End Else Begin
    GetPrinterInfo();
    Try
      Printer.BeginDoc();
    Except
      on E:Exception do Begin RSLMsgBox('%s', [PChar(E.Message)]); End;
    End;
  End;
end;

Procedure TaePrinter.BeginPrint();
begin
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    RSLfs_getSendBuff(0, TermDlmName, CMD_aeBeginPrint);
    //отправляем сообщение
    RSLfs_sendMessage(NIL);
  End Else Begin
    GetPrinterInfo();
    Try
      Printer.StartDocToPrinter();
    Except
      on E:Exception do Begin RSLMsgBox('%s', [PChar(E.Message)]); End;
    End;
  End;

end;

procedure TaePrinter.EndDocument();   
var   put:PChar;
begin
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(0, TermDlmName, CMD_aeEndDocument);
    //отправляем сообщение
    RSLfs_sendMessage(put);
  End Else Begin
    Try
      Printer.EndDoc();
    Except
      on E:Exception do Begin RSLMsgBox('%s', [PChar(E.Message)]); End;
    End;
  End;
end;

procedure TaePrinter.EndPrint();   
begin
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    RSLfs_getSendBuff(0, TermDlmName, CMD_aeEndPrint);
    //отправляем сообщение
    RSLfs_sendMessage(NIL);
  End Else Begin
    Try
      Printer.EndDocToPrinter();
    Except
      on E:Exception do Begin RSLMsgBox('%s', [PChar(E.Message)]); End;
    End;
  End;
end;

procedure TaePrinter.NewPage();   
var   put:PChar;
begin
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(0, TermDlmName, CMD_aeNewPage);
    //отправляем сообщение
    RSLfs_sendMessage(put);
  End Else Begin
    Try
      Printer.NewPage();
    Except
      on E:Exception do Begin RSLMsgBox('%s', [PChar(E.Message)]); End;
    End;
  End;
end;

procedure TaePrinter.StartPage();   
begin
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    RSLfs_getSendBuff(0, TermDlmName, CMD_aeStartPage);
    //отправляем сообщение
    RSLfs_sendMessage(NIL);
  End Else Begin
    Try
      Printer.StartPageToPrinter();
    Except
      on E:Exception do Begin RSLMsgBox('%s', [PChar(E.Message)]); End;
    End;
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
    FillChar(put.data, SizeOf(put.data), #0);
    StrLCopy(put.data, vs, SizeOf(put.data)-1);
    //получать ничего не нада поэтому просто тправляем сообщение
    RSLfs_sendMessage(put);
  End Else Begin
    Try
      If (OEMtoANSI) Then
        Printer.Canvas.TextOut(PrinterCoordX(vx), PrinterCoordY(vy), ConvertOemToAnsi(vs))
      Else
        Printer.Canvas.TextOut(PrinterCoordX(vx), PrinterCoordY(vy), vs)
    Except
      on E:Exception do Begin RSLMsgBox('%s', [PChar(E.Message)]); End;
    End;
  End;
end;

procedure TaePrinter.DirectPrint(vs:PChar);
  var put:PPassThroughData;
  i:Integer;
begin
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(TPassThroughData), TermDlmName, CMD_aeDirectPrint);
    put.nLen:=Length(vs);
    FillChar(put.data, SizeOf(put.data), #0);
    StrLCopy(put.data, vs, SizeOf(put.data)-1);
    //получать ничего не нада поэтому просто тправляем сообщение
    RSLfs_sendMessage(put);
  End Else Begin
    if (PrinterSupportPassthrough() > 0) then begin
      New(put);
      put.nLen:=Length(vs);
      FillChar(put.data, SizeOf(put.data), #0);
      StrLCopy(put.data, vs, SizeOf(put.data)-1);
      Escape(Printer.Canvas.Handle, PASSTHROUGH, SizeOf(TPassThroughData), Pointer(put), nil);
      Escape(Printer.Canvas.Handle, PASSTHROUGH, 0, Pointer(put), nil);
      Escape(Printer.Handle, PASSTHROUGH, SizeOf(TPassThroughData), Pointer(put), nil);
      Escape(Printer.Handle, PASSTHROUGH, 0, Pointer(put), nil);
      Dispose(put);
    end;
  End;
end;

function TaePrinter.WriteToPrinter(vs:PChar):Integer;
  var put:PPassThroughData;
      get:PIntBuffer;
      sz:LongWord;
begin
  Result:=0;
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(TPassThroughData), TermDlmName, CMD_aeDirectPrint);
    put.nLen:=Length(vs);
    FillChar(put.data, SizeOf(put.data), #0);
    StrLCopy(put.data, vs, SizeOf(put.data)-1);
    get:=RSLfs_transactMessage(put, sz);
    if (sz >= SizeOf(TIntBuffer)) Then Result:=get.int;
  End Else Begin
    Result:=Printer.WriteToPrinter(vs, Length(vs));
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
    Try
      Result:=PChar(Printer.Printers[ind]);
    Except
      on E:Exception do Begin RSLMsgBox('%s', [PChar(E.Message)]); End;
    End;
  End;
end;

{возвращаемое значение 0-неподдерживает, >0-поддерживает}
{ Тестируем на предмет поддержки escape кода "PASSTHROUGH" }
function  TaePrinter.PrinterSupportPassthrough():Integer;
  var get:PIntBuffer;
      put:Pointer;
      sz:LongWord;
      TestInt : integer;
begin
  Result:=0;
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(0, TermDlmName, CMD_aeSupportPassthrough);
    //отправляем сообщение
    get:=RSLfs_transactMessage(put, sz);
    if (sz >= SizeOf(TIntBuffer)) Then Result:=get.int;
  End Else Begin
    TestInt := PASSTHROUGH;
    Result:=Escape(Printer.Handle, QUERYESCSUPPORT, sizeof(TestInt), @TestInt,nil);
  End;
end;


{*****************************************************************

                    Свойства объекта

******************************************************************}

function  TaePrinter.get_PrinterSupportPassthrough(ret:PVALUE):LongInt;
var i:Integer;
begin
  i:=PrinterSupportPassthrough();
  RSLValueClear(ret);
  RSLValueSet(ret, V_INTEGER, @i);
  Result:=0;
end;

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
  if (new.v_type <> V_STRING) Then RSLError('Title:STRING', []);
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(TPrintBuffer), TermDlmName, CMD_aeSetPrintTitle);
    StrCopy(put.data, new.RSLString);
    //получать ничего не нада поэтому просто тправляем сообщение
    RSLfs_sendMessage(put);
  End Else Begin
    Try
      Printer.Title:=new.RSLString;
    Except
      on E:Exception do Begin RSLMsgBox('%s', [PChar(E.Message)]); End;
    end;
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
    Try
        Printer.PrinterIndex:=new.intval;
    Except
      on E:Exception do Begin RSLMsgBox('%s', [PChar(E.Message)]); End;
    End;
  End;
  Result:=0;
end;

function  TaePrinter.get_OEMtoANSI(ret:PVALUE):LongInt;
  var put, get:PBoolBuffer;
      sz:LongWord;
begin
  RSLValueClear(ret);
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(0, TermDlmName, CMD_aeGetOEMtoANSI);
    //получаем буфер отправляем сообщение
    get:=RSLfs_transactMessage(put, sz);
    if (sz >= SizeOf(PBoolBuffer)) Then RSLValueSet(ret, V_BOOL, @get.bool);
  End Else Begin
    RSLValueSet(ret, V_BOOL, @OEMtoANSI);
  End;
  Result:=0;
end;

function  TaePrinter.put_OEMtoANSI(new:PVALUE):LongInt;
  var put:PBoolBuffer;
begin
  if (new.v_type <> V_BOOL) Then RSLError('Неверный параметр:BOOL', []);
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(PBoolBuffer), TermDlmName, CMD_aeSetOEMtoANSI);
    put.bool:=new.boolval;
    //получать ничего не нада поэтому просто отправляем сообщение
    RSLfs_sendMessage(put);
  End Else Begin
    OEMtoANSI:=new.boolval;
  End;
  Result:=0;
end;

function  TaePrinter.get_FontName(ret:PVALUE):LongInt;
  var put, get:PSmallTxtBuffer;
      sz:LongWord;
begin
  RSLValueClear(ret);
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(0, TermDlmName, CMD_aeGetFontName);
    //получаем буфер отправляем сообщение
    get:=RSLfs_transactMessage(put, sz);
    if (sz >= SizeOf(PSmallTxtBuffer)) Then RSLValueSet(ret, V_STRING, @get.data[0]);
  End Else Begin
    RSLValueSet(ret, V_STRING, PChar(Printer.Canvas.Font.Name));
  End;
  Result:=0;
end;

function  TaePrinter.put_FontName(new:PVALUE):LongInt;
  var put:PSmallTxtBuffer;
begin
  if (new.v_type <> V_STRING) Then RSLError('Неверный параметр:STRING', []);
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(PSmallTxtBuffer), TermDlmName, CMD_aeSetFontName);
    StrCopy(put.data, new.RSLString);
    //получать ничего не нада поэтому просто тправляем сообщение
    RSLfs_sendMessage(put);
  End Else Begin
    Printer.Canvas.Font.Name:=String(new.RSLString);
  End;
  Result:=0;
end;

function  TaePrinter.get_FontSize(ret:PVALUE):LongInt;
  var put, get:PIntBuffer;
      sz:LongWord;
      i:Integer;
begin
  RSLValueClear(ret);
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(0, TermDlmName, CMD_aeGetFontSize);
    //получаем буфер отправляем сообщение
    get:=RSLfs_transactMessage(put, sz);
    if (sz >= SizeOf(TIntBuffer)) Then RSLValueSet(ret, V_INTEGER, @get.int);
  End Else Begin
    i:=Printer.Canvas.Font.Size;
    RSLValueSet(ret, V_INTEGER, @i);
  End;
  Result:=0;
end;

function  TaePrinter.put_FontSize(new:PVALUE):LongInt;
  var put:PIntBuffer;
begin
  if (new.v_type <> V_INTEGER) Then RSLError('Неверный параметр:INTEGER', []);
  if (Remote) Then Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(TIntBuffer), TermDlmName, CMD_aeSetFontSize);
    put.int:=new.intval;
    //получать ничего не нада поэтому просто отправляем сообщение
    RSLfs_sendMessage(put);
  End Else Begin
    Printer.Canvas.Font.Size:=new.intval;
  End;
  Result:=0;
end;

{*****************************************************************



******************************************************************}

procedure MakeTaePrinter();
  var i:Word;
begin
  SetLength(TaePrinterEntrys, 23);
  {Методы}
  i:=0;
  TaePrinterEntrys[i]:=RSL_METH('BeginDoc', @TaePrinter.RSLBeginDoc);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_METH('BeginPrint', @TaePrinter.RSLBeginPrint);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_METH('EndDoc', @TaePrinter.RSLEndDoc);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_METH('EndPrint', @TaePrinter.RSLEndPrint);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_METH('NewPage', @TaePrinter.RSLNewPage);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_METH('StartPage', @TaePrinter.RSLStartPage);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_METH('PrintText', @TaePrinter.RSLPrintText);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_METH('Printer', @TaePrinter.RSLPrinter);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_METH('DirectPrint', @TaePrinter.RSLDirectPrint);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_METH('WritePrinter', @TaePrinter.RSLWritePrinter);

  {Свойства}
  Inc(i);
  TaePrinterEntrys[i]:=RSL_PROP_METH('Remote', @TaePrinter.get_Remote, @TaePrinter.put_Remote);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_PROP_METH('Printers', @TaePrinter.get_Printers, NIL);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_PROP_METH('Title', @TaePrinter.get_Title, @TaePrinter.put_Title);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_PROP_METH('Count', @TaePrinter.get_Count, NIL);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_PROP_METH('PrinterIndex', @TaePrinter.get_PrinterIndex, @TaePrinter.put_PrinterIndex);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_PROP_METH('SupportPassthrough', @TaePrinter.get_PrinterSupportPassthrough, NIL);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_PROP_METH('OEMtoANSI', @TaePrinter.get_OEMtoANSI, @TaePrinter.put_OEMtoANSI);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_PROP_METH('FontName', @TaePrinter.get_FontName, @TaePrinter.put_FontName);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_PROP_METH('FontSize', @TaePrinter.get_FontSize, @TaePrinter.put_FontSize);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_INIT(@TaePrinter.RSLInit);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_CTRL(@TaePrinter.RSLCreate);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_DSTR(@TaePrinter.RSLDone);

  Inc(i);
  TaePrinterEntrys[i]:=RSL_TBL_END();

  PaePrinterTable^.clsName:='TaePrinter';
  PaePrinterTable^.userSize:=SizeOf(TaePrinter);
  PaePrinterTable^.Entrys:=@TaePrinterEntrys[0];
  PaePrinterTable^.canInherit:=TRUE;
  PaePrinterTable^.canCvtToIDisp:=TRUE;
  PaePrinterTable^.Ver:=1;
  PaePrinterTable^.autoPtr:=NIL;
end;

Initialization
  New(PaePrinterTable);
  MakeTaePrinter();
Finalization
  Dispose(PaePrinterTable);
End.
