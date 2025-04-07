Unit aeconst;
InterFace
Uses
  Messages,
  Windows;

Const
  TermDlmName = 'aewint';
  ServHandleProc = 'SrvExtMsgProc';
  
  CMD_CreateObject = 1;
  CMD_CreateWindow = 2;
  CMD_DestroyObject = 3;
  CMD_AddChild = 4;
  CMD_AddExChild = 5;
  CMD_ObjectClose = 6;
  CMD_ObjectShow = 7;
  CMD_MsgBox = 8;
  CMD_SetStyle = 9;
  CMD_SetExStyle = 10;
  
  CMD_ObjectEnd = 49;
  CMD_HandleMessage = 51;
  CMD_Exit = 52;
  CMD_AddTable = 53;
  CMD_DelTable = 54;

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

  PPointerBuffer=^TPointerBuffer;
  TPointerBuffer=Packed Record
    obj:Pointer;
  End;

  PBoolBoffer=^TBoolBuffer;
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

  PHandleMsgBuffer=^THandleMsgBuffer;
  THandleMsgBuffer=Packed Record
    obj:Pointer;
    Msg:TMessage;
  End;

  PHWNDBuffer=^THWNDBuffer;
  THWNDBuffer=Packed Record
    hwin:HWND;
  End;

  PShowBuffer=^TShowBuffer;
  TShowBuffer=Packed Record
    obj:Pointer;  
    cmd:Integer;
  End;

  PChildBuffer = ^TChildBuffer;
  TChildBuffer = Packed Record
    obj:Pointer;
    ClassName:TArr256;
    Text:TArr512;
    Style, X, Y, W, H:LongInt;
  End;

  PExChildBuffer = ^TExChildBuffer;
  TExChildBuffer = Packed Record
    obj:Pointer;
    ClassName:TArr256;
    Text:TArr512;
    ExStyle, Style, X, Y, W, H:LongInt;
  End;

  PMsgBoxBuffer = ^TMsgBoxBuffer; 
  TMsgBoxBuffer = packed record
    obj:Pointer;  
    Text:TArr256;
    Caption:TArr256;
    uType:LongWord;
  end;

  PStyleBuffer = ^TStyleBuffer;
  TStyleBuffer = packed record
    obj:Pointer;  
    hwin:HWND;
    Style, X, Y, W, H:Integer;
  end;
  
Implementation

End.

