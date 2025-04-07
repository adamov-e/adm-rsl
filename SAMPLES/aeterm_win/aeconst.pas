unit aeconst;
InterFace

Const
  TermDlmName='aetrm';
  
  CMD_aeDisableClose = 1;
  CMD_aeSetClipboard = 2;
  CMD_aeGetClipboard = 3;
  CMD_aeClipboardClear = 4;
  CMD_aeBeginPrint = 5;
  CMD_aeEndPrint = 6;
  CMD_aePrintText = 7;
  CMD_aeGetPrinters = 8;
  CMD_aeNewPage = 9;
  CMD_aeGetPrintTitle = 10;
  CMD_aeSetPrintTitle = 11;
  CMD_aeGetPrinterCount = 12;
  CMD_aeSetPrinterIndex = 13;
  CMD_aeGetPrinterIndex = 14;
  CMD_aeGetPrinter = 15;
  CMD_aeSupportPassthrough = 16;
  CMD_aeDirectPrint = 17;
  CMD_aeWritePrinter = 18;
  CMD_aeBeginDocument = 19;
  CMD_aeEndDocument = 20;
  CMD_aeStartPage = 21;
  CMD_aeGetDir = 22;
  CMD_aeOpenFileDialog = 23;
  CMD_aeSaveFileDialog = 24;
  CMD_aeKeyEvent = 25;
  CMD_aeGetOEMtoANSI = 26;
  CMD_aeSetOEMtoANSI = 27;
  CMD_aeGetFontName = 28;
  CMD_aeSetFontName = 29;
  CMD_aeGetFontSize = 30;
  CMD_aeSetFontSize = 31;

  CMD_TestTerm = 99;

Type

  TArr512 = Packed Array[0..511] of Char;
  TArr256 = Packed Array[0..255] of Char;

  PTextBuffer=^TTextBuffer;
  TTextBuffer=Packed Record
    data:Packed Array[0..15000] of Char;
  End;                    

  PPrintBuffer=^TPrintBuffer;
  TPrintBuffer=Packed Record
    X, Y:Integer;
    data:TArr512;
  End;

  PIntBuffer=^TIntBuffer;
  TIntBuffer=Packed Record
    int:LongInt;
  End;

  PBoolBuffer=^TBoolBuffer;
  TBoolBuffer=Packed Record
    bool:Boolean;
  End;

  PSmallTxtBuffer=^TSmallTxtBuffer;
  TSmallTxtBuffer=Packed Record
    data:TArr256;
  End;                    

  PTxtBuffer512=^TTxtBuffer512;
  TTxtBuffer512=Packed Record
    data:TArr512;
  End;                    

  POFNDialog = ^TOFNDialog;
  TOFNDialog=Packed Record
    Title:TArr512;
    Path:TArr512;
    Mask:TArr256;
  End;

  { описываем структуру "PASSTHROUGH" }
  PPassThroughData = ^TPassThroughData;
  TPassThroughData = Packed Record 
    nLen:Word; 
    Data:TArr256;
  end;

  PKeybdData = ^TKeybdData;
  TKeybdData = Packed Record
    key:Byte;
    scan:Byte;
    flags:LongWord;
    exInfo:LongWord;
  End;
  
Implementation

End.

