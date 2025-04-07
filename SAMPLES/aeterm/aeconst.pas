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
  CMD_aeNewPage= 9;
  CMD_aeGetPrintTitle= 10;
  CMD_aeSetPrintTitle= 11;
  CMD_aeGetPrinterCount= 12;
  CMD_aeSetPrinterIndex= 13;
  CMD_aeGetPrinterIndex= 14;
  CMD_aeGetPrinter= 15;

  CMD_TestTerm = 99;

Type

  PTextBuffer=^TTextBuffer;
  TTextBuffer=Packed Record
    data:Packed Array[0..15000] of Char;
  End;                    

  PPrintBuffer=^TPrintBuffer;
  TPrintBuffer=Packed Record
    X, Y:Integer;
    data:Packed Array[0..512] of Char;
  End;

  PIntBuffer=^TIntBuffer;
  TIntBuffer=Packed Record
    int:LongInt;
  End;

  PSmallTxtBuffer=^TSmallTxtBuffer;
  TSmallTxtBuffer=Packed Record
    data:Packed Array[0..256] of Char;
  End;                    


Implementation

End.

