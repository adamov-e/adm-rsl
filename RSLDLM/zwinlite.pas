{
����� ��������� �� ����� Delphi ��� ���������� ������� ���������-���������������� ����� RSL

  ������: 1.0.0

  �����������: ������ �������, adamov.e.n@gmail.com
  ���� ��������� �����������: 2009 ���

  ����� �������������� ������� � ������-�������������� �����.
  ����������� ��������� ������������� ������ ��� ����� ���� �����������.
  ����� ��������������� ��� ����, ��� �����-���� ��������������� � ��������� � ������.
}

////////////////////////////////////////////////////////////////////////////////
//         WinLite, ���������� ������� � ������� ��� ������ � Win32 API
//                       (c) ������� ��������, 1999-2000
// ___________________________________________________________
//                                ������� ������
////////////////////////////////////////////////////////////////////////////////
//TLiteWindow - ����� ����, � ������������ subclass'����;
//TLiteDialog - ����� ������������ �������;
//TLiteDialogBox - ����� ���������� �������.

unit zWinLite;

interface

uses Windows, Messages;

////////////////////////////////////////////////////////////////////////////////
//����������������� ���������
//���������� ��������, ������� ������������ ��� ������������ ���������� ����� ����������� ���� � �������� ��������������.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ��������� ��� �������� ����
////////////////////////////////////////////////////////////////////////////////
type
  TWindowParams = record
    Caption     : PChar;
    Style       : DWord;
    ExStyle     : DWord;
    X           : Integer;
    Y           : Integer;
    Width       : Integer;
    Height      : Integer;
    WndParent   : THandle;
    WndMenu     : THandle;
    Param       : Pointer;
    WindowClass : TWndClass;
  end;

////////////////////////////////////////////////////////////////////////////////
// ��������� ��� �������� �������
////////////////////////////////////////////////////////////////////////////////
type
  TDialogParams = record
    Template    : PChar;
    WndParent   : THandle;
  end;

////////////////////////////////////////////////////////////////////////////////
//���������� �������� ������ TLiteFrame
//������� ����� ��� ���� � ��������. ������������� � ���� ���������� ���� � ��������� ����� ������� ���������. ��������� �������� message-��������.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// TLiteFrame
// ____________________________________________________________
// ������� ����� ��� �������� TLiteWindow, TLiteDialog, TLiteDialogBox
////////////////////////////////////////////////////////////////////////////////
type
  TLiteFrame = class(TObject)
  private
    FWndCallback: Pointer;
    FWndHandle  : HWND;
    FWndParent  : HWND;
    function    WindowCallback(hWnd: HWnd; Msg, WParam, LParam:Longint):Longint; stdcall;
  protected
    Procedure   WindowProcedure(var Msg: TMessage); Virtual;
    Procedure   WndProc(hWnd: HWnd; Msg, WParam, LParam: Integer); Virtual;
  public
    Property    WndHandle: HWND read FWndHandle write FWndHandle;
    Property    WndParent: HWND read FWndParent write FWndParent;
    Property    WndCallback: Pointer read FWndCallback;
  public
    Procedure   Show(cmd:Integer=SW_SHOWDEFAULT);
    Function    AddChild(Name, Text:PChar; Style:DWORD; X, Y, W, H:Integer):HWND;
    Function    AddChildEx(Name, Text:PChar; Style, xStyle:DWORD; X, Y, W, H:Integer):HWND;
    Constructor Create(AWndParent: HWND); virtual;
    Destructor  Destroy; override;
  end;

////////////////////////////////////////////////////////////////////////////////
//���������� �������� ������ TLiteWindow
//�������� ����������� ������ ���� � �������� ����. ����������� ������������ ���������� ����.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// TLiteWindow
// _______________________________________________
// ������� �����
////////////////////////////////////////////////////////////////////////////////
type
  TLiteWindow = class(TLiteFrame)
  private
    FWndParams  : TWindowParams;
    FWndSubclass: Pointer;
  protected
    procedure   CreateWindowParams(var WindowParams: TWindowParams); virtual;
  public
    property    X:Integer read FWndParams.X write FWndParams.X;
    property    Y:Integer read FWndParams.Y write FWndParams.Y;
    property    W:Integer read FWndParams.Width write FWndParams.Width;
    property    H:Integer read FWndParams.Height write FWndParams.Height;
    property    Caption:PChar read FWndParams.Caption Write FWndParams.Caption;
    property    Style:DWORD read FWndParams.Style Write FWndParams.Style;
    property    ExStyle:DWORD read FWndParams.ExStyle Write FWndParams.ExStyle;
    procedure   CreateWindow;
    procedure   DestroyWindow();    
    procedure   CreateWindowEx;
    procedure   DefaultHandler(var Msg); override;
    procedure   Close();
    function    SetStyle(wnd:HWND; dwStyle:LongInt):Longint;
    function    SetExStyle(wnd:HWND; dwStyle:LongInt):Longint;        
    function    GetStyle(wnd:HWND):Longint;
    function    GetExStyle(wnd:HWND):Longint;
    function    SetPos(wnd:HWND; dX, dY, dW, dH:Longint):Boolean;    
    Function    MsgBox(Text, Caption:PChar; uType:LongWord):Integer;
    constructor Create(AWndParent: HWND); override;
    constructor CreateSubclassed(AWnd: HWND); virtual;
    destructor  Destroy; override;
  end;

////////////////////////////////////////////////////////////////////////////////
//���������� ����������� ������ TLiteDialog
//�������� ������� ������� � �������� �������.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// TLiteDialog
// _______________________________________________
// ���������� �����
////////////////////////////////////////////////////////////////////////////////
type
  TLiteDialog = class(TLiteFrame)
  private
    FDlgParams  : TDialogParams;
  protected
    procedure   CreateDialogParams(var DialogParams: TDialogParams); virtual;
  public
    procedure   DefaultHandler(var Msg); override;
    constructor Create(AWndParent: HWND); override;
    destructor  Destroy; override;
  end;

////////////////////////////////////////////////////////////////////////////////
//���������� ���������� ����������� ������ TLiteDialogBox
//�������� ������� ������� � �������� �������. ��������� ����� �������.
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// TLiteDialogBox
// ______________________________________________
// ��������� ���������� �����
////////////////////////////////////////////////////////////////////////////////
type
  TLiteDialogBox = class(TLiteFrame)
  private
    FDlgParams  : TDialogParams;
  protected
    procedure   CreateDialogParams(var DialogParams: TDialogParams); virtual;
  public
    procedure   DefaultHandler(var Msg); override;
  public
    function    ShowModal: Integer;
  end;

  TIdleEvent = procedure(Sender: TObject) of object;

  TApplication = class
    FRunning:Boolean;
    FTerminate:Boolean;
    FOnIdle:TIdleEvent;
    constructor Create;
    function ProcessMessage(var Msg: TMsg): Boolean;
    procedure ProcessMessages;
    procedure HandleMessage;
    procedure Idle(const Msg: TMsg);
    procedure Run;
    procedure Terminate;            
  End;


////////////////////////////////////////////////////////////////////////////////
//���������� �������� ������ TLiteFrame
////////////////////////////////////////////////////////////////////////////////

implementation

////////////////////////////////////////////////////////////////////////////////
// TLiteFrame
// ___________________________________________________
// ������������� / �����������
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// �����������
////////////////////////////////////////////////////////////////////////////////
constructor TLiteFrame.Create(AWndParent: HWND);
begin
  inherited Create;
  FWndCallback:= NIL;
  FWndHandle  := 0;
  FWndParent  := 0;
  // ���������� ���������� ������������� ����
  FWndParent := AWndParent;
  // ������� ����� ��� ���� ��������� ������
  FWndCallback := VirtualAlloc(nil,12,MEM_RESERVE or MEM_COMMIT,PAGE_EXECUTE_READWRITE);
  // ��������� ���� ��������� ������
  asm
    mov  EAX, Self
    mov  ECX, [EAX].TLiteFrame.FWndCallback     
    mov  word  ptr [ECX+0], $6858               // pop  EAX
    mov  dword ptr [ECX+2], EAX                 // push _Self_
    mov  word  ptr [ECX+6], $E950               // push EAX
    mov  EAX, OFFSET(TLiteFrame.WindowCallback)
    sub  EAX, ECX
    sub  EAX, 12
    mov  dword ptr [ECX+8], EAX                 // jmp  TLiteFrame.WindowCallback
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// ����������
////////////////////////////////////////////////////////////////////////////////
destructor TLiteFrame.Destroy;
begin
  // ���������� ��������� ����� ��������� ������
  VirtualFree(FWndCallback, 0, MEM_RELEASE);
  // ����������� �� ���������
  inherited;
end;

////////////////////////////////////////////////////////////////////////////////
// TLiteFrame
// ___________________________________________________________
// ������� ��������� ���������
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ������� ��������� ������ ��� ��������� ������� ���������
////////////////////////////////////////////////////////////////////////////////
function TLiteFrame.WindowCallback(hWnd: HWnd; Msg, WParam, LParam: Integer): Longint;
var
  WindowMsg : TMessage;
begin
// ������� ���������
  if FWndHandle = 0 then FWndHandle := hWnd;
  // ��������� ���������
  WindowMsg.Msg    := Msg;
  WindowMsg.WParam := WParam;
  WindowMsg.LParam := LParam;
  // ������������ ���
  WindowProcedure(WindowMsg);
  // ���������� ��������� ������� �������
  Result := WindowMsg.Result;
  //���������� � ���� ���������
  WndProc(hWnd, Msg, WParam, LParam);
end;

////////////////////////////////////////////////////////////////////////////////
// ����������� ������� ��� ��������� ������� ���������
////////////////////////////////////////////////////////////////////////////////
procedure TLiteFrame.WindowProcedure(var Msg: TMessage);
begin
  // ������������ ��������� �� ������������
  Dispatch(Msg);
end;
////////////////////////////////////////////////////////////////////////////////
// ����������� ��������� ������ ��� ��������� ���������
////////////////////////////////////////////////////////////////////////////////
Procedure TLiteFrame.WndProc(hWnd: HWnd; Msg, WParam, LParam: Integer);
Begin
End;
////////////////////////////////////////////////////////////////////////////////
// ��������� ������/������� ����
////////////////////////////////////////////////////////////////////////////////
procedure   TLiteFrame.Show(cmd:Integer=SW_SHOWDEFAULT);
begin
  ShowWindow(FWndHandle, cmd);
end;
////////////////////////////////////////////////////////////////////////////////
// ��������� �������� ������� �����
////////////////////////////////////////////////////////////////////////////////
function TLiteFrame.AddChild(Name, Text:PChar;  Style:DWORD; X, Y, W, H:Integer):HWND;
begin
  Result:= Windows.CreateWindow(Name, Text, Style, X, Y, W, H, WndHandle, 0, 0, NIL);
end;
////////////////////////////////////////////////////////////////////////////////
// ��������� �������� ������� ����� �����������
////////////////////////////////////////////////////////////////////////////////
function TLiteFrame.AddChildEx(Name, Text:PChar;  Style, xStyle:DWORD; X, Y, W, H:Integer):HWND;
begin
  Result:= Windows.CreateWindowEx(xStyle, Name, Text, Style, X, Y, W, H, WndHandle, 0, 0, NIL);
end;

////////////////////////////////////////////////////////////////////////////////
//���������� �������� ������ TLiteWindow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// TLiteWindow
// _______________________________________________
// ������������� / �����������
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// �����������
////////////////////////////////////////////////////////////////////////////////
constructor TLiteWindow.Create(AWndParent: HWND);
begin
  inherited;
  FWndSubclass:=nil;
  // ��������� ��������� ����
  CreateWindowParams(FWndParams);
  // ������������ ����� ����
  RegisterClass(FWndParams.WindowClass);
end;

////////////////////////////////////////////////////////////////////////////////
// ����������� �������� � �������������
////////////////////////////////////////////////////////////////////////////////
constructor TLiteWindow.CreateSubclassed(AWnd: HWND);
begin
  inherited Create(GetParent(AWnd));
  // ��������� ������� �������
  FWndSubclass := Pointer(GetWindowLong(AWnd, GWL_WNDPROC));
  // ��������� ���������� ����
  FWndHandle   := AWnd;
  // ������������� ���� ������� �������
  SetWindowLong(FWndHandle, GWL_WNDPROC, DWord(WndCallback));
end;
////////////////////////////////////////////////////////////////////////////////
// ����������
////////////////////////////////////////////////////////////////////////////////
destructor TLiteWindow.Destroy;
begin
  // ��� ������ - ������ ������������� ?
  if FWndSubclass = nil then
  begin
    // ���������� ����� ����
    UnregisterClass(FWndParams.WindowClass.lpszClassName, FWndParams.WindowClass.hInstance);
    DestroyWindow();
  end
  else
    // ��������������� ������ ������� �������
    SetWindowLong(FWndHandle, GWL_WNDPROC, DWord(FWndSubclass));
  // ����������� �� ���������
  inherited;
end;
////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////
procedure TLiteWindow.CreateWindowEx;
begin
  // ������� ����
  with FWndParams do
    FWndHandle:=Windows.CreateWindowEx(ExStyle, WindowClass.lpszClassName, Caption,
      Style, X, Y, Width, Height,
      WndParent, WndMenu, FWndParams.WindowClass.hInstance, Param );
end;
////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////
procedure TLiteWindow.CreateWindow;
begin
  // ������� ����
  with FWndParams do
    FWndHandle:=Windows.CreateWindow(WindowClass.lpszClassName, Caption,
      Style, X, Y, Width, Height,
      WndParent, WndMenu, FWndParams.WindowClass.hInstance, Param );
end;
////////////////////////////////////////////////////////////////////////////////
// ������������ ���������� ���� �� ���������
////////////////////////////////////////////////////////////////////////////////
procedure TLiteWindow.CreateWindowParams(var WindowParams: TWindowParams);
var
  WndClassName : string;
begin
  // ��������� ��� ������
  Str(DWord(Self), WndClassName);
  WndClassName := ClassName+':'+WndClassName;
  // ��������� ���������� � ������ ����
  with FWndParams.WindowClass do
  begin
    style         := CS_DBLCLKS;
    lpfnWndProc   := WndCallback;
    cbClsExtra    := 0;
    cbWndExtra    := 0;
    lpszClassName := PChar(WndClassName);
    hInstance     := GetModuleHandle(NIL);
    hIcon         := LoadIcon(0, IDI_APPLICATION);
    hCursor       := LoadCursor(0, IDC_ARROW);
    hbrBackground := COLOR_BTNFACE + 1;
    lpszMenuName  := '';
  end;
  // ��������� ���������� �� ����
  with FWndParams do
  begin
    WndParent := FWndParent;
    Caption := 'RSL Window';
    Style   := WS_OVERLAPPEDWINDOW or WS_VISIBLE;
    ExStyle := 0;
    X       := Integer(CW_USEDEFAULT);
    Y       := Integer(CW_USEDEFAULT);
    Width   := Integer(CW_USEDEFAULT);
    Height  := Integer(CW_USEDEFAULT);
    WndMenu := 0;
    Param   := nil;
  end;
end;

procedure TLiteWindow.DestroyWindow();
begin
  // ���������� ����
  if IsWindow(WndHandle) then Windows.DestroyWindow(WndHandle);
end;

Procedure TLiteWindow.Close();
Begin
  DestroyWindow();
End;

function TLiteWindow.SetPos(wnd:HWND; dX, dY, dW, dH:Longint):Boolean;
begin
  Result:=  SetWindowPos(wnd, HWND_NOTOPMOST, dX, dY, dW, dH, SWP_FRAMECHANGED);
end;

function TLiteWindow.SetStyle(wnd:HWND; dwStyle:LongInt):Longint;
begin
  Result:=SetWindowLong(wnd, GWL_STYLE, dwStyle);
end;

function TLiteWindow.SetExStyle(wnd:HWND; dwStyle:LongInt):Longint;
begin
  Result:=SetWindowLong(wnd, GWL_EXSTYLE, dwStyle);
end;

function TLiteWindow.GetStyle(wnd:HWND):Longint;
begin
  Result:=GetWindowLong(wnd, GWL_STYLE);
end;

function TLiteWindow.GetExStyle(wnd:HWND):Longint;
begin
  Result:=GetWindowLong(wnd, GWL_EXSTYLE);
end;

Function TLiteWindow.MsgBox(Text, Caption:PChar; uType:LongWord):Integer;
Begin
  Result:=MessageBox(WndHandle, Text, Caption, uType);
End;

////////////////////////////////////////////////////////////////////////////////
// TLiteWindow
// ______________________________________________
// ������� ��������� ���������
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ���������� ��������� �� ���������
////////////////////////////////////////////////////////////////////////////////
procedure TLiteWindow.DefaultHandler(var Msg);
begin
  // ��� ������ - ������ ������������� ?
  if FWndSubclass = nil then
    // �������� ��������� ������� ��������� ���������
    with TMessage(Msg) do 
      Result := DefWindowProc(FWndHandle, Msg, WParam, LParam)
  else
    // �������� ������ ������� ������� ��������� ���������
    with TMessage(Msg) do 
      Result := CallWindowProc(FWndSubclass, FWndHandle, Msg, WParam, LParam);
end;
////////////////////////////////////////////////////////////////////////////////
//���������� ����������� ������ TLiteDialog
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// TLiteDialog
// ____________________________________________
// ������������� / �����������
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// �����������
////////////////////////////////////////////////////////////////////////////////
constructor TLiteDialog.Create(AWndParent: HWND);
begin
  inherited;
  // ��������� ��������� �������
  CreateDialogParams(FDlgParams);
  // ������� ������
  with FDlgParams do
    CreateDialogParam(hInstance, Template, WndParent, WndCallback, 0);
end;

////////////////////////////////////////////////////////////////////////////////
// ����������
////////////////////////////////////////////////////////////////////////////////
destructor TLiteDialog.Destroy;
begin
  // ���������� ������
  if IsWindow(FWndHandle) then DestroyWindow(FWndHandle);
  // ����������� �� ���������
  inherited;
end;

////////////////////////////////////////////////////////////////////////////////
// ������������ ���������� ������� �� ���������
////////////////////////////////////////////////////////////////////////////////
procedure TLiteDialog.CreateDialogParams(var DialogParams: TDialogParams);
begin
  DialogParams.WndParent := FWndParent;
  DialogParams.Template  := '';
end;

////////////////////////////////////////////////////////////////////////////////
// ��������� ��������� �� ���������
////////////////////////////////////////////////////////////////////////////////
procedure TLiteDialog.DefaultHandler(var Msg);
begin
  // ������������ �������� �� ���������
  with TMessage(Msg) do
    if Msg = WM_INITDIALOG then Result := 1
                           else Result := 0;
end;

////////////////////////////////////////////////////////////////////////////////
//���������� ���������� ����������� ������ TLiteDialogBox
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// TLiteDialogBox
// _________________________________________________________
// ������������� / �����������
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ������������ ���������� ������� �� ���������
////////////////////////////////////////////////////////////////////////////////
procedure TLiteDialogBox.CreateDialogParams(


var DialogParams: TDialogParams);
begin
  DialogParams.WndParent := FWndParent;
  DialogParams.Template  := '';
end;

////////////////////////////////////////////////////////////////////////////////
// ����������� ���������� �������
////////////////////////////////////////////////////////////////////////////////
function TLiteDialogBox.ShowModal: Integer;
begin
  // ��������� ��������� �������
  CreateDialogParams(FDlgParams);
  // ���������� ������
  with FDlgParams do
    Result := DialogBoxParam(hInstance, Template, WndParent, WndCallback, 0);
end;

////////////////////////////////////////////////////////////////////////////////
// ��������� ��������� �� ���������
////////////////////////////////////////////////////////////////////////////////
procedure TLiteDialogBox.DefaultHandler(var Msg);
begin
  // ������������ �������� �� ���������
  with TMessage(Msg) do
    if Msg = WM_INITDIALOG then Result := 1
                           else Result := 0;
end;


////////////////////////////////////////////////////////////////////////////////
//
//          TApplication
//
////////////////////////////////////////////////////////////////////////////////
constructor TApplication.Create;
begin
  inherited;
  FOnIdle := nil;
  FRunning := True;
  FTerminate := False;
end;

function TApplication.ProcessMessage(var Msg: TMsg): Boolean;
begin
  Result := False;
  if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
  begin
    Result := True;
    if Msg.Message <> WM_QUIT then
      begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end
    else
      FTerminate := True;
  end;
end;

procedure TApplication.ProcessMessages;
var
  Msg: TMsg;
begin
  while ProcessMessage(Msg) do {loop};
end;

procedure TApplication.Idle(const Msg: TMsg);
begin
  if Assigned(FOnIdle) then FOnIdle(Self);
end;

procedure TApplication.HandleMessage;
var
  Msg: TMsg;
begin
  if not ProcessMessage(Msg) then Idle(Msg);
end;

procedure TApplication.Run;
begin
  FRunning := True;
  FTerminate := False;
  try
      repeat
        HandleMessage;
      until FTerminate;
  finally
    FRunning := False;
  end;
end;

procedure TApplication.Terminate;
begin
  PostQuitMessage(0);
end;

initialization

finalization

end.
