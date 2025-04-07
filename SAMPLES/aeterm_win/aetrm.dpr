library aetrm;
{отключаем выравнивание в рекордах}
{$A1}
{устанавливаем расширение файла}
{$E d32}
{включаем оптимизацию}
{$O+}
{отключаем предупреждения}
{$WARNINGS OFF}
{отключаем хинты}
{$HINTS OFF}
{отключаем отладку}
{$DEBUGINFO OFF}

Uses
    sysutils, 
    windows,
    ShlObj, 
    commdlg,
    clipbrd,
    Sprinters,
    rsltype,
    termext,
    aeconst;

Const BUFF_SIZE = 1024;

Var
  hWindowHandle:HWND;
  PixelsX, PixelsY:Integer;

{Стандартный диалог выбора каталога}
function BrowseDirDialog (const Title: string; const Flag,csidl: integer):String;
var
  lpItemID : PItemIDList;
  BrowseInfo : TBrowseInfo;
  DisplayName : array[0..MAX_PATH] of char;
  TempPath : array[0..MAX_PATH] of char;
begin
  Result:='';
  FillChar(BrowseInfo, sizeof(TBrowseInfo), #0);
  SHGetSpecialFolderLocation(hWindowHandle,csidl,BrowseInfo.pidlRoot);
  with BrowseInfo do begin
    hwndOwner := hWindowHandle;
    pszDisplayName := @DisplayName;
    lpszTitle := PChar(Title);
    ulFlags := Flag;
  end;
  lpItemID := SHBrowseForFolder(BrowseInfo);
  if lpItemId <> nil then begin
    SHGetPathFromIDList(lpItemID, TempPath);
    Result := TempPath;
    GlobalFreePtr(lpItemID);
  end;
end;

function OpenFileDialog(szTitle, szPath, szMask:PChar):String;
var ofn:TOpenFileName;
    szInFile:array[0..MAX_PATH] of char;
begin
  Result:='';
  FillChar(szInFile, SizeOf(szInFile), #0);
  FillChar(ofn, SizeOf(TOpenFileName), #0);
  With ofn Do begin
    lStructSize     := sizeof(TOpenFileName);
    hwndOwner       := hWindowHandle;
    lpstrFile       := szInFile;
    nMaxFile        := sizeof(szInFile);
    lpstrFilter     := szMask;
    nFilterIndex    := 1;
    lpstrFileTitle  := NIL;
    nMaxFileTitle   := 0;
    lpstrInitialDir := szPath;
    lpstrTitle      := szTitle;
//    Flags           := OFN_PATHMUSTEXIST and OFN_ENABLEHOOK and OFN_EXPLORER;
//    lpfnHook        := OFNHookProcStyle;
  end;
  if (GetOpenFileName(ofn)) then Result:=szInFile;
end;

function SaveFileDialog(szTitle, szPath, szMask:PChar):String;
var ofn:TOpenFileName;
    szInFile:array[0..MAX_PATH] of char;
begin
  Result:='';
  FillChar(szInFile, SizeOf(szInFile), #0);
  FillChar(ofn, SizeOf(TOpenFileName), #0);
  With ofn Do begin
    lStructSize     := sizeof(TOpenFileName);
    hwndOwner       := hWindowHandle;
    lpstrFile       := szInFile;
    nMaxFile        := sizeof(szInFile);
    lpstrFilter     := szMask;
    nFilterIndex    := 1;
    lpstrFileTitle  := NIL;
    nMaxFileTitle   := 0;
    lpstrInitialDir := szPath;
    lpstrTitle      := szTitle;
//    Flags           := OFN_PATHMUSTEXIST and OFN_ENABLEHOOK and OFN_EXPLORER;
//    lpfnHook        := OFNHookProcStyle;
  end;
  if (GetSaveFileName(ofn)) then Result:=szInFile;
end;

{*****************************************************************


******************************************************************}

function aeDisableClose(inMes:Pointer; outMes:Pointer):LongInt;
  var hMenuHandle:HMENU; 
Begin 
  if (hWindowHandle <> 0) Then Begin  //если нашли продолжаем
    hMenuHandle:=GetSystemMenu(hWindowHandle, FALSE);       //получаем дескриптор меню найденного окна
    If (hMenuHandle <> 0) Then Begin  //если дескриптор меню = 0 ошибка
      DeleteMenu(hMenuHandle, SC_CLOSE, MF_BYCOMMAND);        //Удаляем пункт меню "закрыт"
    End;
  End;
  Result:=0;
end;

function aeKeyEvent(inMes:Pointer; outMes:Pointer):LongInt;
  var buff:PKeybdData;
Begin 
  buff:=inMes;
  keybd_event(buff.key, buff.scan, buff.flags, buff.exInfo);
  Result:=0;
end;

{**********************************************************************

            Функции для работы с буфером обмена

***********************************************************************}

function aeSetClipboard(inMes:Pointer; outMes:Pointer):LongInt;
  var buff:PTextBuffer;
Begin 
  buff:=inMes;
  //MessageBox(0, inMes, 'Test Term DLM', 0);
  Clipboard.SetTextBuf(buff.data);
  Result:=0; //возвращать ничего не нужно
end;

function aeGetClipboard(inMes:Pointer; outMes:Pointer):LongInt;
  var buff:PTextBuffer;
Begin 
  buff:=outMes;
  Clipboard.GetTextBuf(buff.data, SizeOf(TTextBuffer));
  //StrCopy(outMes, buff.data);
  //MessageBox(0, outMes, 'Test Term DLM', 0);
  Result:=SizeOf(TTextBuffer); //возвращаем размер данных
end;

function aeClipboardClear(inMes:Pointer; outMes:Pointer):LongInt;
Begin 
  Clipboard.Clear();
  Result:=0;
end;

{**********************************************************************

            Функции для работы с принтером

***********************************************************************}

Procedure GetPrinterInfo; {Получить информацию о принтере }
begin
  PixelsX:=GetDeviceCaps(Printer.Handle,LogPixelsX);
  PixelsY:=GetDeviceCaps(Printer.Handle,LogPixelsY);
end;

Function PrinterCoordX(x:integer):integer; { переводит координаты из мм в пиксели }
begin
 Result:=round(PixelsX/25.4*x);
end;

Function PrinterCoordY(y:integer):integer; { переводит координаты из мм в пиксели  }
begin
 Result:=round(PixelsY/25.4*Y);
end;

{ Тестируем на предмет поддержки escape кода "PASSTHROUGH" }
Function PrinterSupportPassthrough():Integer;
Var TestInt : integer;
begin
  TestInt := PASSTHROUGH;
  Result:=Escape(Printer.Handle, QUERYESCSUPPORT, sizeof(TestInt), @TestInt,nil);
end;

Procedure DirectPrint(s:PChar);
var PTBlock: TPassThroughData;
begin
  PTBlock.nLen := Length(s); 
  StrPCopy(@PTBlock.Data, s); 
  Escape(Printer.Canvas.Handle, PASSTHROUGH, 0, @PTBlock, nil);
end;

function aeBeginDocument(inMes:Pointer; outMes:Pointer):LongInt;
Begin 
  GetPrinterInfo();
  Try
    Printer.BeginDoc();
  Except
    RSLMsgBox('BeginDocument Error', 1);
  End;
  Result:=0;
end;

function aeBeginPrint(inMes:Pointer; outMes:Pointer):LongInt;
Begin 
  GetPrinterInfo();
  Try
    Printer.StartDocToPrinter();
  Except
    RSLMsgBox('BeginPrint Error', 1);
  End;
  Result:=0;
end;

function aeEndDocument(inMes:Pointer; outMes:Pointer):LongInt;
Begin 
  Try
    Printer.EndDoc();
  Except
    RSLMsgBox('EndDoc Error', 1);
  End;
  Result:=0;
end;

function aeEndPrint(inMes:Pointer; outMes:Pointer):LongInt;
Begin 
  Try
    Printer.EndDocToPrinter();
  Except
    RSLMsgBox('EndDocToPrinter Error', 1);
  End;
  Result:=0;
end;

function aePrintText(inMes:Pointer; outMes:Pointer):LongInt;
  var buff:PPrintBuffer;
Begin 
  buff:=inMes;
  Try
    Printer.Canvas.TextOut(PrinterCoordX(buff.X), PrinterCoordY(buff.Y), buff.data);
  Except
    RSLMsgBox('Print text Error', 1);
  End;
  Result:=0; //возвращать ничего не нужно
end;

function aeDirectPrint(inMes:Pointer; outMes:Pointer):LongInt;
  var buff:PPassThroughData;
Begin 
  buff:=inMes;
  Try
    Escape(Printer.Handle, PASSTHROUGH, 0, Pointer(buff), nil);
    Escape(Printer.Handle, PASSTHROUGH, SizeOf(TPassThroughData), Pointer(buff), nil);
    Escape(Printer.Canvas.Handle, PASSTHROUGH, 0, Pointer(buff), nil);
    Escape(Printer.Canvas.Handle, PASSTHROUGH, SizeOf(TPassThroughData), Pointer(buff), nil);
  Except
    RSLMsgBox('Print text Error', 1);
  End;
  Result:=0; //возвращать ничего не нужно
end;

function aeWritePrinter(inMes:Pointer; outMes:Pointer):LongInt;
  var iBuff:PPassThroughData;
      oBuff:PIntBuffer;
      N:LongWord;
Begin 
  iBuff:=inMes;
  oBuff:=outMes;
  Try
    oBuff.int:=Printer.WriteToPrinter(iBuff.data, iBuff.nLen);
  Except
    RSLMsgBox('WritePrinter Error', 1);
  End;
  Result:=SizeOf(TIntBuffer); //возвращаем размер данных
end;

Function aePrinterSupportPassthrough(inMes:Pointer; outMes:Pointer):LongInt;
Var TestInt : integer;
    buff:PIntBuffer;
begin
  buff:=outMes;
  buff.int:= PrinterSupportPassthrough();
  Result:=SizeOf(TIntBuffer);
end;

function aeGetPrinters(inMes:Pointer; outMes:Pointer):LongInt;
  var buff:PTextBuffer;
Begin 
  buff:=outMes;
  FillChar(buff.data, SizeOf(buff.data), #0);
  StrLCopy(buff.data, PChar(Printer.Printers.Text), SizeOf(buff.data)-1);
  Result:=SizeOf(TTextBuffer); //возвращаем размер данных
end;

function aeNewPage(inMes:Pointer; outMes:Pointer):LongInt;
Begin 
  Try
    Printer.NewPage();
  Except
    RSLMsgBox('NewPage ERROR', 1);
  End;
  Result:=0;
end;

function aeStartPage(inMes:Pointer; outMes:Pointer):LongInt;
Begin 
  Try
    Printer.StartPageToPrinter();
  Except
    RSLMsgBox('StartPageToPrinter Error', 1);
  End;
  Result:=0;
end;

function aeGetPrinterCount(inMes:Pointer; outMes:Pointer):LongInt;
  var buff:PIntBuffer;
Begin 
  buff:=outMes;
  buff.int:=Printer.Printers.Count;
  Result:=SizeOf(TIntBuffer); //возвращаем размер данных
end;

function aeGetPrinter(inMes:Pointer; outMes:Pointer):LongInt;
  var ibuff:PIntBuffer;
      obuff:PSmallTxtBuffer;
      i:Integer;
      s:String;
Begin 
  Result:=0;
  ibuff:=inMes;
  i:=ibuff.int;
  obuff:=outMes;
  if ((i >= 0) and (i < Printer.Printers.Count)) Then Begin
    FillChar(obuff.data, SizeOf(obuff.data), #0);
    StrLCopy(obuff.data, PChar(Printer.Printers[i]), SizeOf(obuff.data)-1);
    Result:=SizeOf(TSmallTxtBuffer); //возвращаем размер данных
  End;
end;

function aeSetPrinterIndex(inMes:Pointer; outMes:Pointer):LongInt;
  var buff:PIntBuffer;
Begin 
  buff:=inMes;
  Try
    Printer.PrinterIndex:=buff.int;
  Except
    RSLMsgBox('Error printer index', 1);
  End;
  Result:=0; //возвращаем размер данных
end;

function aeGetPrinterIndex(inMes:Pointer; outMes:Pointer):LongInt;
  var buff:PIntBuffer;
Begin 
  buff:=outMes;
  buff.int:=Printer.PrinterIndex;
  Result:=SizeOf(TIntBuffer); //возвращаем размер данных
end;

function aeGetDir(inMes:Pointer; outMes:Pointer):LongInt;
  var ibuff:PTxtBuffer512;
      obuff:PTxtBuffer512;
      i:Integer;
      s:String;
Begin 
  Result:=0;
  ibuff:=inMes;
  obuff:=outMes;
  s:=BrowseDirDialog(iBuff.data, BIF_RETURNONLYFSDIRS+BIF_EDITBOX+BIF_STATUSTEXT,CSIDL_DESKTOP);
  StrLCopy(oBuff.data, PChar(s), SizeOf(oBuff.data));
  Result:=SizeOf(TTxtBuffer512); //возвращаем размер данных
end;

function aeOpenFileDialog(inMes:Pointer; outMes:Pointer):LongInt;
  var ibuff:POFNDialog;
      obuff:PTxtBuffer512;
      i:Integer;
      s:String;
Begin 
  Result:=0;
  ibuff:=inMes;
  obuff:=outMes;
  s:=OpenFileDialog(iBuff.Title, iBuff.Path, iBuff.Mask);
  StrLCopy(oBuff.data, PChar(s), SizeOf(oBuff.data));
  Result:=SizeOf(TTxtBuffer512); //возвращаем размер данных
end;

function aeSaveFileDialog(inMes:Pointer; outMes:Pointer):LongInt;
  var ibuff:POFNDialog;
      obuff:PTxtBuffer512;
      i:Integer;
      s:String;
Begin 
  Result:=0;
  ibuff:=inMes;
  obuff:=outMes;
  s:=SaveFileDialog(iBuff.Title, iBuff.Path, iBuff.Mask);
  StrLCopy(oBuff.data, PChar(s), SizeOf(oBuff.data));
  Result:=SizeOf(TTxtBuffer512); //возвращаем размер данных
end;

{*****************************************************************


******************************************************************}

function TestTermDLM(inMes:Pointer; outMes:Pointer):LongInt;
begin
//  MessageBox(0, 'Test DLM', 'Test Term DLM', 0);
  RSLMsgBox('test', 1);
  RSLShowMessage('test', 1);
  Result:=0;
end;

{вызывается при загрузке модуля в память}
procedure mes_Load();
begin
end;

{вызывается при выгрузке модуля из памяти}
procedure mes_UnLoad();
begin
end;

procedure mes_Version (inMes:PTermVersion);
begin
end;

function RslExtMessageProc(cmd:LongInt; inMes:Pointer; outMes:Pointer):LongInt; cdecl;
begin
  Case (cmd) Of
    CMD_aeDisableClose:Begin Result:=aeDisableClose(inMes, outMes); End;
    CMD_aeSetClipBoard:Begin Result:=aeSetClipboard(inMes, outMes); End;
    CMD_aeGetClipBoard:Begin Result:=aeGetClipboard(inMes, outMes); End;
    CMD_aeClipBoardClear:Begin Result:=aeClipboardClear(inMes, outMes); End;
    CMD_aeBeginDocument:Begin Result:=aeBeginDocument(inMes, outMes); End;
    CMD_aeEndDocument:Begin Result:=aeEndDocument(inMes, outMes); End;
    CMD_aePrintText:Begin Result:=aePrintText(inMes, outMes); End;
    CMD_aeGetPrinters:Begin Result:=aeGetPrinters(inMes, outMes); End;
    CMD_aeNewPage:Begin Result:=aeNewPage(inMes, outMes); End;
    CMD_aeGetPrinterCount:Begin Result:=aeGetPrinterCount(inMes, outMes); End;
    CMD_aeSetPrinterIndex:Begin Result:=aeSetPrinterIndex(inMes, outMes); End;
    CMD_aeGetPrinterIndex:Begin Result:=aeGetPrinterIndex(inMes, outMes); End;
    CMD_aeGetPrinter:Begin Result:=aeGetPrinter(inMes, outMes); End;
    CMD_TestTerm:Begin Result:=TestTermDLM(inMes, outMes); End;
    CMD_aeSupportPassthrough:Begin Result:=aePrinterSupportPassthrough(inMes, outMes); End;
    CMD_aeDirectPrint:Begin Result:=aeDirectPrint(inMes, outMes); End;
    CMD_aeWritePrinter:Begin Result:=aeWritePrinter(inMes, outMes); End;
    CMD_aeBeginPrint:Begin Result:=aeBeginPrint(inMes, outMes); End;
    CMD_aeEndPrint:Begin Result:=aeEndPrint(inMes, outMes); End;
    CMD_aeStartPage:Begin Result:=aeStartPage(inMes, outMes); End;
    CMD_aeGetDir:Begin Result:=aeGetDir(inMes, outMes); End;
    CMD_aeOpenFileDialog:Begin Result:=aeOpenFileDialog(inMes, outMes); End;
    CMD_aeSaveFileDialog:Begin Result:=aeSaveFileDialog(inMes, outMes); End;
    CMD_aeKeyEvent:Begin Result:=aeKeyEvent(inMes, outMes); End;    
    -1:Begin mes_Load(); Result:=0; End;
    -2:Begin mes_UnLoad(); Result:=0; End;
    -4:Begin mes_Version(PTermVersion(inMes)); Result:=0; End;
  Else
    Result:=0;
  End;
end;

Exports
RslExtMessageProc;

Begin
  hWindowHandle:=0;
  hWindowHandle:=GetForegroundWindow();
End.
