library aetrm;
{��������� ������������ � ��������}
{$A1}
{������������� ���������� �����}
{$E d32}
{�������� �����������}
{$O+}
{��������� ��������������}
{$WARNINGS OFF}
{��������� �����}
{$HINTS OFF}
{��������� �������}
{$DEBUGINFO OFF}

Uses
    sysutils, 
    windows,
    clipbrd,
    printers,
    rsltype,
    termext,
    aeconst;


Const BUFF_SIZE = 1024;

Var
  hWindowHandle:HWND;
  str:String;
  Buff:PChar;

{*****************************************************************


******************************************************************}

function aeDisableClose(inMes:Pointer; outMes:Pointer):LongInt;
  var hMenuHandle:HMENU; 
Begin 
  if (hWindowHandle <> 0) Then Begin  //���� ����� ����������
    hMenuHandle:=GetSystemMenu(hWindowHandle, FALSE);       //�������� ���������� ���� ���������� ����
    If (hMenuHandle <> 0) Then Begin  //���� ���������� ���� = 0 ������
      DeleteMenu(hMenuHandle, SC_CLOSE, MF_BYCOMMAND);        //������� ����� ���� "������"
      //EnableMenuItem(hMenuHandle, SC_CLOSE, MF_DISABLED); 
    End;
  End;
  SetConsoleTitle(Buff);                                  //�������������� ������ ���������
  Result:=0;
end;

{**********************************************************************

            ������� ��� ������ � ������� ������

***********************************************************************}

function aeSetClipboard(inMes:Pointer; outMes:Pointer):LongInt;
  var buff:PTextBuffer;
Begin 
  buff:=inMes;
  //MessageBox(0, inMes, 'Test Term DLM', 0);
  Clipboard.SetTextBuf(buff.data);
  Result:=0; //���������� ������ �� �����
end;

function aeGetClipboard(inMes:Pointer; outMes:Pointer):LongInt;
  var buff:PTextBuffer;
Begin 
  buff:=outMes;
  Clipboard.GetTextBuf(buff.data, SizeOf(TTextBuffer));
  //StrCopy(outMes, buff.data);
  //MessageBox(0, outMes, 'Test Term DLM', 0);
  Result:=SizeOf(TTextBuffer); //���������� ������ ������
end;

function aeClipboardClear(inMes:Pointer; outMes:Pointer):LongInt;
Begin 
  Clipboard.Clear();
  Result:=0;
end;

{**********************************************************************

            ������� ��� ������ � ���������

***********************************************************************}

function aeBeginPrint(inMes:Pointer; outMes:Pointer):LongInt;
Begin 
  Printer.BeginDoc();
  Result:=0;
end;

function aeEndPrint(inMes:Pointer; outMes:Pointer):LongInt;
Begin 
  //MessageBox(0, inMes, 'End Print', 0);
  Printer.EndDoc();
  Result:=0;
end;

function aePrintText(inMes:Pointer; outMes:Pointer):LongInt;
  var buff:PPrintBuffer;
Begin 
  buff:=inMes;
  Printer.Canvas.TextOut(buff.X, buff.Y, buff.data);
  Result:=0; //���������� ������ �� �����
end;

function aeGetPrinters(inMes:Pointer; outMes:Pointer):LongInt;
  var buff:PTextBuffer;
Begin 
  buff:=outMes;
  StrCopy(buff.data, PChar(Printer.Printers.Text));
  Result:=SizeOf(TTextBuffer); //���������� ������ ������
end;

function aeNewPage(inMes:Pointer; outMes:Pointer):LongInt;
Begin 
  //MessageBox(0, inMes, 'End Print', 0);
  Printer.NewPage();
  Result:=0;
end;

function aeGetPrinterCount(inMes:Pointer; outMes:Pointer):LongInt;
  var buff:PIntBuffer;
Begin 
  buff:=outMes;
  buff.int:=Printer.Printers.Count;
  Result:=SizeOf(TIntBuffer); //���������� ������ ������
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
    StrCopy(obuff.data, PChar(Printer.Printers[i]));
    Result:=SizeOf(TSmallTxtBuffer); //���������� ������ ������
  End;
  //MessageBox(0, '11111', 'End Print', 0);
end;

function aeSetPrinterIndex(inMes:Pointer; outMes:Pointer):LongInt;
  var buff:PIntBuffer;
Begin 
  buff:=inMes;
  Printer.PrinterIndex:=buff.int;
  Result:=0; //���������� ������ ������
end;

function aeGetPrinterIndex(inMes:Pointer; outMes:Pointer):LongInt;
  var buff:PIntBuffer;
Begin 
  buff:=outMes;
  buff.int:=Printer.PrinterIndex;
  Result:=SizeOf(TIntBuffer); //���������� ������ ������
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

{���������� ��� �������� ������ � ������}
procedure mes_Load();
begin
end;

{���������� ��� �������� ������ �� ������}
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
     CMD_aeBeginPrint:Begin Result:=aeBeginPrint(inMes, outMes); End;
     CMD_aeEndPrint:Begin Result:=aeEndPrint(inMes, outMes); End;
     CMD_aePrintText:Begin Result:=aePrintText(inMes, outMes); End;
     CMD_aeGetPrinters:Begin Result:=aeGetPrinters(inMes, outMes); End;
     CMD_aeNewPage:Begin Result:=aeNewPage(inMes, outMes); End;
     CMD_aeGetPrinterCount:Begin Result:=aeGetPrinterCount(inMes, outMes); End;
     CMD_aeSetPrinterIndex:Begin Result:=aeSetPrinterIndex(inMes, outMes); End;
     CMD_aeGetPrinterIndex:Begin Result:=aeGetPrinterIndex(inMes, outMes); End;
     CMD_aeGetPrinter:Begin Result:=aeGetPrinter(inMes, outMes); End;
     CMD_TestTerm:Begin Result:=TestTermDLM(inMes, outMes); End;
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
  str:='_____RSBANK07303_____';
  GetMem(Buff, BUFF_SIZE);       //�������� ������ ��� ������ ���������
End.
