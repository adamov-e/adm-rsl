{
Набор библиотек на языке Delphi для разработки модулей проблемно-ориентированного языка RSL

  Версия: 1.0.0

  Разработчик: Адамов Ербулат, adamov.e.n@gmail.com
  Дата последней модификации: 2009 год

  Набор разрабатывался автором в учебно-познавательных целях.
  Разрешается свободное использование набора без каких либо ограничений.
  Набор предоставляется как есть, без какой-либо ответственности и претензий к автору.
}

///////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////
Unit liteobj;
InterFace
Uses SysUtils, Windows, Messages;

Type
///////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////
  _TLiteObj = Object
//    vmtTable:Pointer;
    protected
      procedure Init; virtual;
    Public
      Function VmtAddr: Pointer;
  End;

  PObj = ^TLiteObj;

  TOnEvent = procedure(Sender:PObj) of object;

  TLiteObj = Object(_TLiteObj)
  Protected
    FOnCreate:TOnEvent;
    FOnInit:TOnEvent;
    FOnDestroy:TOnEvent;
  Public
    This:PObj;
    Property OnCreate:TOnEvent Read FOnCreate Write FOnCreate;
    Property OnInit:TOnEvent Read FOnInit Write FOnInit;
    Property OnDestroy:TOnEvent Read FOnDestroy Write FOnDestroy;
    Constructor Create;
    Destructor  Destroy; virtual;
    Procedure   Init; virtual;
    Procedure   Free; virtual;
    function    VmtAddr:Pointer;
    function    InstanceSize: Integer;
  End;
 
  PEvent = ^TEvent;
  TEvent = Object(TLiteObj) 
      FHandle:THandle;
    Public
      Property Handle:THandle Read FHandle Write FHandle;
      Constructor Create( isMan:Boolean = true; isSign:Boolean = false);
      Destructor  Destroy; virtual;
      Procedure   Reset; virtual;
      Procedure   Signal; virtual;
      Function    isValid:Boolean;
      Function    Pulse:Boolean;
  End;

///////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////

  PThread = ^TThread;

  TOnThreadExecute = procedure(Sender:PThread) of object;

  TThread = object(TLiteObj)
    Protected
      FHandle :THandle; 
      FThreadID:DWORD;
      FPriority:Integer;
      FOnExecute:TOnThreadExecute;
      FTerminated:Boolean;
      Procedure SetPriority(Const Value:Integer);
      Function  GetPriority:Integer;
    Public
      Property    Handle:THandle Read FHandle Write FHandle;
      Property    ThreadID:DWORD Read FThreadID Write FThreadID;
      Property    Priority:Integer Read GetPriority Write SetPriority;
      Property    OnExecute:TOnThreadExecute Read FOnExecute Write FOnExecute;
      Property    Terminated:Boolean Read FTerminated Write FTerminated;
      Constructor Create(thAttr:Pointer=NIL; szStack:DWORD=0; Suspended:Boolean=FALSE);
      Destructor  Destroy; virtual;
      Function    Resume:DWORD; virtual;
      Function    Suspend:DWORD; virtual;
      Procedure   Execute; virtual;
      Procedure   Terminate; virtual;
      Function    WaitFor:Integer; virtual;
      Function    WaitForTime(T: DWORD):Integer; virtual;
  End;

///////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////

  PLiteFrame = ^ TLiteFrame;

  TLiteFrame = object(TLiteObj)
  Private
//    FWndCallback: Pointer;
    FWndHandle  : HWND;
    FWndParent  : HWND;
    Function    WindowCallback(hWnd: HWnd; Msg, WParam, LParam:Longint):Longint; stdcall;
  Protected
    Procedure   WindowProcedure(var Msg: TMessage); Virtual;
    Procedure   WndProc(hWnd: HWnd; Msg, WParam, LParam: Integer); Virtual;
  Public
    Property    WndHandle: HWND read FWndHandle write FWndHandle;
    Property    WndParent: HWND read FWndParent write FWndParent;
//    Property    WndCallback: Pointer read FWndCallback;
    Constructor Create(AWndParent: HWND);
    Destructor  Destroy; virtual;
  End;

///////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////
  PLiteWindow = ^TLiteWindow;
  TLiteWindow = Object(TLiteFrame)
  Private
    FWndSubclass: Pointer;
    FStyle      :Integer;
    FExStyle    :Integer;
    FX, FY, FWidth, FHeight:Integer;
    FCaption    :PChar;
    FWindowClass:TWndClass;
    FWndMenu    :THandle;
    FParam      :Pointer;
  Protected 
    Function    GetX:Integer;
    Procedure   SetX(Const Value:Integer);
    Function    GetY:Integer;
    Procedure   SetY(Const Value:Integer);
    Function    GetWidth:Integer;
    Procedure   SetWidth(Const Value:Integer);
    Function    GetHeight:Integer;
    Procedure   SetHeight(Const Value:Integer);
    Function    GetCaption:PChar;
    Procedure   SetCaption(Const Value:PChar);
    Function    GetStyle:DWORD;overload;
    Procedure   SetStyle(Const Value:DWORD);overload;
    Function    GetExStyle:DWORD;overload;
    Procedure   SetExStyle(Const Value:DWORD);overload;
  Public
    Property    X:Integer read GetX write SetX;
    Property    Y:Integer read GetY write SetY;
    Property    W:Integer read GetWidth write SetWidth;
    Property    H:Integer read GetHeight write SetHeight;
    Property    Caption:PChar read GetCaption Write SetCaption;
    Property    Style:DWORD read GetStyle Write SetStyle;
    Property    ExStyle:DWORD read GetExStyle Write SetExStyle;
    Procedure   Show(cmd:Integer=SW_SHOWDEFAULT);
    Function    AddChild(AName, AText:PChar; dStyle:DWORD; dX, dY, dW, dH:Integer):HWND;
    Function    AddChildEx(AName, AText:PChar; dStyle, xStyle:DWORD; dX, dY, dW, dH:Integer):HWND;
    Procedure   CreateWindow;  virtual;
    Procedure   CreateWindowEx; virtual;
    Procedure   DestroyWindow(); virtual;
    Procedure   DefaultHandler(var Msg); virtual;
    Procedure   Close(); virtual;
    Function    SetStyle(wnd:HWND; dwStyle:LongInt):Longint; overload;
    Function    SetExStyle(wnd:HWND; dwStyle:LongInt):Longint; overload;
    Function    GetStyle(wnd:HWND):Longint; overload;
    Function    GetExStyle(wnd:HWND):Longint; overload;
    Function    SetPos(wnd:HWND; dX, dY, dW, dH:Longint):Boolean;    
    Function    MsgBox(AText, ACaption:PChar; uType:LongWord):Integer;
    Constructor Create(AWndParent: HWND = 0);
    Constructor CreateSubclassed(AWnd: HWND);
    Destructor  Destroy; virtual;
  end;

Function NewEvent( isMan:Boolean = true; isSign:Boolean = false):PEvent;
Function NewThread(thAttr:Pointer=NIL;szStack:DWORD=0; Suspended:Boolean=FALSE):PThread;
Function NewLiteWindow(AWndParent: HWND = 0):PLiteWindow;


Implementation

function WindowProc( Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM ): LRESULT; stdcall;
var obj:PLiteWindow;
begin
  obj:=Pointer(GetWindowLong(Wnd, GWL_USERDATA));
  obj.WindowCallback(wnd, Msg, wParam, lParam);
  Result := DefWindowProc( Wnd, Msg, wParam, lParam );
end;

Procedure NilAndFree(Var Obj);
Var Ob:PObj;
Begin
  Ob:=PObj(Obj);
  Pointer(Obj):=NIL;
  Ob.Free;
End;
///////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////
procedure _TLiteObj.Init;
begin
//  FillChar( Pointer( Integer(@Self) + 4 )^, Sizeof( Self ) - 4, 0 );
end;

Function _TLiteObj.VmtAddr:Pointer;
asm
//   MOV EAX, [EAX]
End;

function TLiteObj.InstanceSize: Integer;
asm
   MOV    EAX, [EAX]
   MOV    EAX,[EAX-4]
end;

function TLiteObj.VmtAddr: Pointer;
asm
//  MOV    EAX, [EAX - 4]
end;

Constructor TLiteObj.Create;
Begin
  This:=@Self;
  Init;
End;

Procedure TLiteObj.Init;
Begin
  inherited;
End;

Procedure TLiteObj.Free;
Begin
  Destroy();
End;

Destructor TLiteObj.Destroy;
Begin
  This:=NIL;
End;
///////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////
Function NewEvent( isMan:Boolean = true; isSign:Boolean = false):PEvent;
Begin
  New(Result, Create(isMan, isSign));
End;

Constructor TEvent.Create(isMan:Boolean = true; isSign:Boolean = false);
Begin
  Inherited Create;
  Handle := CreateEvent(NIL, isMan, isSign,NIL);
End;

Destructor TEvent.Destroy;
Begin
  If (FHandle <> 0) Then CloseHandle(Handle);
  Inherited;
End;

Procedure TEvent.Reset;
Begin
  ResetEvent(Handle);
End;

Procedure TEvent.Signal;
Begin
  SetEvent(Handle);
End;

Function TEvent.isValid():Boolean;
Begin
  Result:=TRUE;
  If (Handle = 0) Then  Result:=FALSE;
End;

Function TEvent.Pulse:Boolean;
Begin
  Result:=PulseEvent(Handle);
End;
///////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////
Function NewThread(thAttr:Pointer=NIL;szStack:DWORD=0; Suspended:Boolean=FALSE):PThread;
Begin
  New(Result, Create(thAttr, szStack, Suspended));
End;

Constructor TThread.Create(thAttr:Pointer=NIL;szStack:DWORD=0; Suspended:Boolean=FALSE);
Var cf:DWORD;
Begin
  Inherited Create;
  cf:=0;
  If (Suspended <> FALSE) Then cf:=CREATE_SUSPENDED;
  FThreadID:=0;
  FOnExecute:=NIL;
  Handle  := CreateThread(thAttr, szStack, @TThread.Execute, This, cf, FThreadID);
End;

Destructor TThread.Destroy;
Begin
  If (not FTerminated) Then
  Begin
    Terminate;
    WaitFor;
  End;
  If (FHandle <> 0) Then CloseHandle(Handle);
  Inherited;
End;

Function TThread.Resume:Dword;
Begin
  Result:=ResumeThread(Handle);
End;

Function TThread.Suspend:Dword;
Begin
  Result:=SuspendThread(Handle);
End;

Procedure TThread.SetPriority(Const Value:Integer);
Begin
  If (Handle <> 0) Then SetThreadPriority(Handle, Value);
End;

Function  TThread.GetPriority:Integer;
Begin
  Result:=0;
  If (Handle <> 0) Then Result:=GetThreadPriority(Handle);
End;

Procedure TThread.Execute;
Begin
  If (Assigned(FOnExecute)) Then OnExecute(@Self);
  FTerminated:=TRUE;
End;

Procedure TThread.Terminate;
Begin
  If (TerminateThread(FHandle, 0) <> FALSE) Then FTerminated:=TRUE;
End;

Function TThread.WaitFor:Integer;
Begin
  Result := -1;
  If (FHandle = 0) Then Exit;
  WaitForSingleObject(FHandle, INFINITE);
  GetExitCodeThread(FHandle, DWORD(Result));
End;

Function TThread.WaitForTime(T: DWORD): Integer;
Begin
  Result := WAIT_OBJECT_0;
  If  (FHandle = 0) Then Exit;
  Result := WaitForSingleObject(FHandle, T);
  If (Result = WAIT_OBJECT_0) Then  GetExitCodeThread(FHandle, T);
End;
///////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////
constructor TLiteFrame.Create(AWndParent: HWND);
begin
  inherited Create;
//  FWndCallback:= NIL;
  FWndHandle  := 0;
  FWndParent  := 0;
  // И рђЇ¬й® жЄ е¦±л±Ёрђі®н™‡н±®е©Іж¬јт«ЇЈмЎ®л® 
  FWndParent := AWndParent;
end;
// ЕҐті±ілі®н—¬н№„estructor TLiteFrame.Destroy;
Begin
  // Ф­йёІп§ жЄ ті±ілііс±ЎЎмЇЄнћєн±®в± у®ЇЈмЎўиЇўнћён»Љ//  VirtualFree(FWndCallback, 0, MEM_RELEASE);
  // Ф­йёІп§Ґо©Ґ рђ¬ н±¶нї«оЃ†нѕЁ
  inherited;
End;
// Хіо«¶йЅ пў°бі­п¤® гј§пЈ  е¬ї рђЇ«нІўн¶­йЅ п«®о®»уЎІ®пў№ж®Ёз‹ЉFunction TLiteFrame.WindowCallback(hWnd: HWnd; Msg, WParam, LParam: Integer): Longint;
Var
  WindowMsg : TMessage;
Begin
// п«®о®®зЎЇсЇ·Ґеґ°
  if FWndHandle = 0 then FWndHandle := hWnd;
  // Х®с­©°н±љнє тЇЇЎж®Ёг‹Љ  WindowMsg.Msg    := Msg;
  WindowMsg.WParam := WParam;
  WindowMsg.LParam := LParam;
  // ПЎсЎў ујЈ жЄ ж¤®
  WindowProcedure(WindowMsg);
  // Г®иЈ°бє жЄ с¦ЁімЅІб° пў°бі­мЎ±йІІж­Ґ
  Result := WindowMsg.Result;
  //ПІрђ± г¬їжЄ аЎ­б№і рђ±®нЅљнµіс±‹Љ  WndProc(hWnd, Msg, WParam, LParam);
End;
// ГЁсіґ мЅ­бЅ н¶’нѕЄнЅ§нЅ е¬ї пў°бў®у«¦ п«®о®»уЎІ®пў№ж®Ёз‹ЉProcedure TLiteFrame.WindowProcedure(var Msg: TMessage);
Begin
  // С т°±Ґе¦«жЄ тЇЇЎж®Ё рђ¬ пў°бў®уё©ЄбЄЌ
  //Dispatch(Msg);
End;
// ГЁсіґ мЅ­бЅ рђ±®нЅљнµісћЎЇсЇІІмЎ¤мЅ пў°бў®у«¦ тЇЇЎж®Ёз‹ЉProcedure TLiteFrame.WndProc(hWnd: HWnd; Msg, WParam, LParam: Integer);
Begin
End;
////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////
Function NewLiteWindow(AWndParent: HWND = 0):PLiteWindow;
Begin
  New(Result, Create(AWndParent));
End;
//
constructor TLiteWindow.Create(AWndParent: HWND = 0);
var
  WndClassName:String;
begin
  inherited Create(AWndParent);
  FWndSubclass:=nil;
  // Х®с­©°н±љнє рђЎ°б­Ґу±№ п«­нћён»Љ  // Х®с­©°н±љнє й­ї л¬ тІћЌ
  Str(DWord(@Self), WndClassName);
  WndClassName := 'RSLWindowClass:'+WndClassName;
  // И рђЇ«пЂҐкЎЁоµ®с­Ў¶йј мЎЄмЎ±тЈЎ®л® 
  with FWindowClass do
  begin
    style         := CS_DBLCLKS;
    lpfnWndProc   := @WindowProc;
    cbClsExtra    := 0;
    cbWndExtra    := 0;
    lpszClassName := PChar(WndClassName);
    hInstance     := GetModuleHandle(NIL);
    hIcon         := LoadIcon(0, IDI_APPLICATION);
    hCursor       := LoadCursor(0, IDC_ARROW);
    hbrBackground := COLOR_BTNFACE + 1;
    lpszMenuName  := '';
  end;
  // СҐд©±у±©°н±љнє л¬ тЇЎ®л® 
  if (RegisterClass(FWindowClass) = 0) then Exit;
  // И рђЇ«пЂҐкЎЁоµ®с­Ў¶йј пџ п«­г‹Љ  FWndParent := AWndParent;
  FCaption := 'RSL Window';
  FStyle   := WS_OVERLAPPEDWINDOW or WS_VISIBLE;
  FExStyle := 0;
  FX       := Integer(CW_USEDEFAULT);
  FY       := Integer(CW_USEDEFAULT);
  FWidth   := Integer(CW_USEDEFAULT);
  FHeight  := Integer(CW_USEDEFAULT);
  FWndMenu := 0;
  FParam   := nil;
end;
// Л®оІІсґ«Іп® м¦¬ж®Інћєн±± тґўЄмЎ±т©®ЈпЄЌ
constructor TLiteWindow.CreateSubclassed(AWnd: HWND);
begin
  inherited Create(GetParent(AWnd));
  // Т®нє†н±­жЄ п«®о®і н¶’нѕЄнЅ§нјЌ
  FWndSubclass := Pointer(GetWindowLong(AWnd, GWL_WNDPROC));
  // Т®нє†н±­жЄ е¦±л±Ёрђі®н™†нїЄоћЌ
  FWndHandle   := AWnd;
  // Ф±уЎ® г¬ЁгЎҐкЎ±гЇѕ п«®о®і н¶’нѕЄнЅ§нјЌ
//  SetWindowLong(FWndHandle, GWL_WNDPROC, DWord(WndCallback));
end;
// ЕҐті±ілі®н—¬н№¤estructor TLiteWindow.Destroy;
begin
  // О  пўєж«І - пўєж«І тґўЄмЎ±т©®­дћ ?
  if FWndSubclass = nil then
  begin
    // Ф­йёІп§ жЄ л¬ тЇЎ®л® 
    UnregisterClass(FWindowClass.lpszClassName, FWindowClass.hInstance);
    DestroyWindow();
    FreeMem(FWindowClass.lpszClassName);
  end
  else
    // Г®тІі оЎўм©ўб¦¬ тіЎ°нІІн±®лЇ­оґѕ н¶’нѕЄнЅ§нјЌ
    SetWindowLong(FWndHandle, GWL_WNDPROC, DWord(FWndSubclass));
  // Ф­йёІп§Ґо©Ґ рђ¬ н±¶нї«оЃ†нѕЁ
  inherited;
end;
//
procedure TLiteWindow.CreateWindowEx;
var p:PLiteWindow;
    s:String;
    hwin:HWND;
begin
  p:=PLiteWindow(This);
  s:=FWindowClass.lpszClassName;
  // Т®иҐ жЄ п«­м‹Љ  hwin:=Windows.CreateWindowEx(0, Pchar(s), 'TEST',
      0, 10, 10, 300, 300,
      0, 0, GetModuleHandle(NIL), NIL);
{  p:=PLiteWindow(This);
  FWndHandle:=Windows.CreateWindowEx(p.FExStyle, p.FWindowClass.lpszClassName, p.FCaption,
      p.FStyle, p.FX, p.FY, p.FWidth, p.FHeight,
      p.FWndParent, p.FWndMenu, p.FWindowClass.hInstance, NIL);}
end;
//
Procedure  TLiteWindow.CreateWindow;
Begin 
  // Т®иҐ жЄ п«­м‹Љ  FWndHandle:=Windows.CreateWindow(FWindowClass.lpszClassName, PChar(FCaption),
      FStyle, FX, FY, FWidth, FHeight,
      FWndParent, FWndMenu, FWindowClass.hInstance, NIL);
end;
//
procedure TLiteWindow.DestroyWindow();
begin
  // Ф­йёІп§ жЄ п«­м‹Љ  if IsWindow(FWndHandle) then Windows.DestroyWindow(WndHandle);
end;
//
Procedure TLiteWindow.Close();
Begin
  DestroyWindow();
End;
//
function TLiteWindow.SetPos(wnd:HWND; dX, dY, dW, dH:Longint):Boolean;
begin
  Result:=SetWindowPos(wnd, HWND_NOTOPMOST, dX, dY, dW, dH, SWP_FRAMECHANGED);
end;
//
function TLiteWindow.SetStyle(wnd:HWND; dwStyle:LongInt):Longint;
begin
  Result:=SetWindowLong(wnd, GWL_STYLE, dwStyle);
end;
//
function TLiteWindow.SetExStyle(wnd:HWND; dwStyle:LongInt):Longint;
begin
  Result:=SetWindowLong(wnd, GWL_EXSTYLE, dwStyle);
end;
//
function TLiteWindow.GetStyle(wnd:HWND):Longint;
begin
  Result:=GetWindowLong(wnd, GWL_STYLE);
end;
//
function TLiteWindow.GetExStyle(wnd:HWND):Longint;
begin
  Result:=GetWindowLong(wnd, GWL_EXSTYLE);
end;
//
Function TLiteWindow.MsgBox(AText, ACaption:PChar; uType:LongWord):Integer;
Begin
  Result:=MessageBox(WndHandle, AText, ACaption, uType);
End;
// ПЎсЎў®уё©Є тЇЇЎж®ЁзЎЇмЎіоЃ†нѕЁ
procedure TLiteWindow.DefaultHandler(var Msg);
begin
  // О  пўєж«І - пўєж«І тґўЄмЎ±т©®­дћ ?
  if FWndSubclass = nil then
    // Г»ијўб¦¬ т©ІІж­­нІІн±ґн±єн»¶йј пў°бў®у«¦ тЇЇЎж®Ёз‹Љ    with TMessage(Msg) do 
      Result := DefWindowProc(FWndHandle, Msg, WParam, LParam)
  else
    // Г»ијўб¦¬ тіЎ°нІІн±®лЇ­оґѕ н¶’нѕЄнЅ§нј пў°бў®у«¦ тЇЇЎж®Ёз‹Љ    with TMessage(Msg) do 
      Result := CallWindowProc(FWndSubclass, FWndHandle, Msg, WParam, LParam);
end;
// Р°п·Ґеґ°нћєн±Їп« ићЇт«±»у©Ѕ п«­нћён»ЉProcedure   TLiteWindow.Show(cmd:Integer=SW_SHOWDEFAULT);
Begin
  ShowWindow(FWndHandle, cmd);
End;
// Р°п·Ґеґ°нћєн±±пЁ¤б®Ё пўєж«Інћєн±¤пёЄж‹ЉFunction TLiteWindow.AddChild(AName, AText:PChar;  dStyle:DWORD; dX, dY, dW, dH:Integer):HWND;
Begin
  Result:= Windows.CreateWindow(AName, AText, dStyle, dX, dY, dW, dH, FWndHandle, 0, 0, NIL);
End;
// Р°п·Ґеґ°нћєн±±пЁ¤б®Ё пўєж«Інћєн±¤пёЄжЎ°бІёй±Ґо® 
Function TLiteWindow.AddChildEx(AName, AText:PChar;  dStyle, xStyle:DWORD; dX, dY, dW, dH:Integer):HWND;
Begin
  Result:= Windows.CreateWindowEx(xStyle, AName, AText, dStyle, dX, dY, dW, dH, FWndHandle, 0, 0, NIL);
End;
//
Function    TLiteWindow.GetX:Integer;
Var r:TRect;
Begin
  Result:=0;
  If (GetWindowRect(FWndHandle, r) <> FALSE) Then Result:=r.Left;
End;
//
Procedure   TLiteWindow.SetX(Const Value:Integer);
Begin
  FX:=Value;
  SetWindowPos(FWndHandle, HWND_NOTOPMOST, FX, FY, FWidth, FHeight, SWP_FRAMECHANGED);
End;
//
Function    TLiteWindow.GetY:Integer;
Var r:TRect;
Begin
  Result:=0;
  If (GetWindowRect(FWndHandle, r) <> FALSE) Then Result:=r.Top;
End;
//
Procedure   TLiteWindow.SetY(Const Value:Integer);
Begin
  FY:=Value;
  SetWindowPos(FWndHandle, HWND_NOTOPMOST, FX, FY, FWidth, FHeight, SWP_FRAMECHANGED);
End;
//
Function    TLiteWindow.GetWidth:Integer;
Var r:TRect;
Begin
  Result:=0;
  If (GetWindowRect(FWndHandle, r) <> FALSE) Then Result:=r.Right;
End;
//
Procedure   TLiteWindow.SetWidth(Const Value:Integer);
Begin
  FWidth:=Value;
  SetWindowPos(FWndHandle, HWND_NOTOPMOST, FX, FY, FWidth, FHeight, SWP_FRAMECHANGED);
End;
//
Function    TLiteWindow.GetHeight:Integer;
Var r:TRect;
Begin
  Result:=0;
  If (GetWindowRect(FWndHandle, r) <> FALSE) Then Result:=r.Bottom;
End;
//
Procedure   TLiteWindow.SetHeight(Const Value:Integer);
Begin
  FHeight:=Value;
  SetWindowPos(FWndHandle, HWND_NOTOPMOST, FX, FY, FWidth, FHeight, SWP_FRAMECHANGED);
End;
//
Function    TLiteWindow.GetCaption:PChar;
Var str:String;
Begin
  Result:='';
  If (GetWindowText(FWndHandle, PChar(str), GetWindowTextLength(FWndHandle)) <> 0) Then Result:=PChar(str);
End;
//
Procedure   TLiteWindow.SetCaption(Const Value:PChar);
Begin
   SetWindowText(FWndHandle, Value);
End;
//
Function    TLiteWindow.GetStyle:DWORD;
Begin
  Result:=GetWindowLong(FWndHandle, GWL_STYLE);
End;
//
Procedure   TLiteWindow.SetStyle(Const Value:DWORD);
Begin
  SetWindowLong(FWndHandle, GWL_STYLE, Value);
End;
//
Function    TLiteWindow.GetExStyle:DWORD;
Begin
  Result:=GetWindowLong(FWndHandle, GWL_EXSTYLE);
End;
//
Procedure   TLiteWindow.SetExStyle(Const Value:DWORD);
Begin
  SetWindowLong(FWndHandle, GWL_EXSTYLE, Value);
End;


Initialization

Finalization

End.
