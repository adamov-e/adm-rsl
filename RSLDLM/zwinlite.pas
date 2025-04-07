{
Набор библиотек на языке Delphi для разработки модулей проблемно-ориентированного языка RSL

  Версия: 1.0.0

  Разработчик: Адамов Ербулат, adamov.e.n@gmail.com
  Дата последней модификации: 2009 год

  Набор разрабатывался автором в учебно-познавательных целях.
  Разрешается свободное использование набора без каких либо ограничений.
  Набор предоставляется как есть, без какой-либо ответственности и претензий к автору.
}

////////////////////////////////////////////////////////////////////////////////
//         WinLite, библиотека классов и функций для работы с Win32 API
//                       (c) Николай Мазуркин, 1999-2000
// ___________________________________________________________
//                                Оконные классы
////////////////////////////////////////////////////////////////////////////////
//TLiteWindow - класс окна, с возможностью subclass'инга;
//TLiteDialog - класс немодального диалога;
//TLiteDialogBox - класс модального диалога.

unit zWinLite;

interface

uses Windows, Messages;

////////////////////////////////////////////////////////////////////////////////
//Инициализационные структуры
//Объявление структур, которые используются для формирования параметров вновь создаваемых окон и диалогов соответственно.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Параметры для создания окна
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
// Параметры для создания диалога
////////////////////////////////////////////////////////////////////////////////
type
  TDialogParams = record
    Template    : PChar;
    WndParent   : THandle;
  end;

////////////////////////////////////////////////////////////////////////////////
//Декларация базового класса TLiteFrame
//Базовый класс для окон и диалогов. Инкапсулирует в себе дескриптор окна и объявляет общую оконную процедуру. Реализует механизм message-процедур.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// TLiteFrame
// ____________________________________________________________
// Базовый класс для объектов TLiteWindow, TLiteDialog, TLiteDialogBox
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
//Декларация оконного класса TLiteWindow
//Создание уникального класса окна и создание окна. Возможность субклассинга стороннего окна.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// TLiteWindow
// _______________________________________________
// Оконный класс
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
//Декларация диалогового класса TLiteDialog
//Загрузка шаблона диалога и создание диалога.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// TLiteDialog
// _______________________________________________
// Диалоговый класс
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
//Декларация модального диалогового класса TLiteDialogBox
//Загрузка шаблона диалога и создание диалога. Модальный показ диалога.
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// TLiteDialogBox
// ______________________________________________
// Модальный диалоговый класс
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
//Реализация базового класса TLiteFrame
////////////////////////////////////////////////////////////////////////////////

implementation

////////////////////////////////////////////////////////////////////////////////
// TLiteFrame
// ___________________________________________________
// Инициализация / финализация
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Конструктор
////////////////////////////////////////////////////////////////////////////////
constructor TLiteFrame.Create(AWndParent: HWND);
begin
  inherited Create;
  FWndCallback:= NIL;
  FWndHandle  := 0;
  FWndParent  := 0;
  // Запоминаем дескриптор родительского окна
  FWndParent := AWndParent;
  // Создаем место под блок обратного вызова
  FWndCallback := VirtualAlloc(nil,12,MEM_RESERVE or MEM_COMMIT,PAGE_EXECUTE_READWRITE);
  // Формируем блок обратного вызова
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
// Деструктор
////////////////////////////////////////////////////////////////////////////////
destructor TLiteFrame.Destroy;
begin
  // Уничтожаем структуру блока обратного вызова
  VirtualFree(FWndCallback, 0, MEM_RELEASE);
  // Уничтожение по умолчанию
  inherited;
end;

////////////////////////////////////////////////////////////////////////////////
// TLiteFrame
// ___________________________________________________________
// Функции обработки сообщений
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Функция обратного вызова для получения оконных сообщений
////////////////////////////////////////////////////////////////////////////////
function TLiteFrame.WindowCallback(hWnd: HWnd; Msg, WParam, LParam: Integer): Longint;
var
  WindowMsg : TMessage;
begin
// оконной процедуры
  if FWndHandle = 0 then FWndHandle := hWnd;
  // Формируем сообщение
  WindowMsg.Msg    := Msg;
  WindowMsg.WParam := WParam;
  WindowMsg.LParam := LParam;
  // Обрабатываем его
  WindowProcedure(WindowMsg);
  // Возвращаем результат обратно системе
  Result := WindowMsg.Result;
  //Отправляем в нашу процедуру
  WndProc(hWnd, Msg, WParam, LParam);
end;

////////////////////////////////////////////////////////////////////////////////
// Виртуальная функция для обработки оконных сообщений
////////////////////////////////////////////////////////////////////////////////
procedure TLiteFrame.WindowProcedure(var Msg: TMessage);
begin
  // Распределяем сообщения по обработчикам
  Dispatch(Msg);
end;
////////////////////////////////////////////////////////////////////////////////
// Виртуальная процедура просто для обработки сообщений
////////////////////////////////////////////////////////////////////////////////
Procedure TLiteFrame.WndProc(hWnd: HWnd; Msg, WParam, LParam: Integer);
Begin
End;
////////////////////////////////////////////////////////////////////////////////
// Процедура показа/скрытия окна
////////////////////////////////////////////////////////////////////////////////
procedure   TLiteFrame.Show(cmd:Integer=SW_SHOWDEFAULT);
begin
  ShowWindow(FWndHandle, cmd);
end;
////////////////////////////////////////////////////////////////////////////////
// Процедура создания объекта дочки
////////////////////////////////////////////////////////////////////////////////
function TLiteFrame.AddChild(Name, Text:PChar;  Style:DWORD; X, Y, W, H:Integer):HWND;
begin
  Result:= Windows.CreateWindow(Name, Text, Style, X, Y, W, H, WndHandle, 0, 0, NIL);
end;
////////////////////////////////////////////////////////////////////////////////
// Процедура создания объекта дочки расширенная
////////////////////////////////////////////////////////////////////////////////
function TLiteFrame.AddChildEx(Name, Text:PChar;  Style, xStyle:DWORD; X, Y, W, H:Integer):HWND;
begin
  Result:= Windows.CreateWindowEx(xStyle, Name, Text, Style, X, Y, W, H, WndHandle, 0, 0, NIL);
end;

////////////////////////////////////////////////////////////////////////////////
//Реализация оконного класса TLiteWindow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// TLiteWindow
// _______________________________________________
// Инициализация / финализация
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Конструктор
////////////////////////////////////////////////////////////////////////////////
constructor TLiteWindow.Create(AWndParent: HWND);
begin
  inherited;
  FWndSubclass:=nil;
  // Формируем параметры окна
  CreateWindowParams(FWndParams);
  // Регистрируем класс окна
  RegisterClass(FWndParams.WindowClass);
end;

////////////////////////////////////////////////////////////////////////////////
// Конструктор элемента с субклассингом
////////////////////////////////////////////////////////////////////////////////
constructor TLiteWindow.CreateSubclassed(AWnd: HWND);
begin
  inherited Create(GetParent(AWnd));
  // Сохраняем оконную функцию
  FWndSubclass := Pointer(GetWindowLong(AWnd, GWL_WNDPROC));
  // Сохраняем дескриптор окна
  FWndHandle   := AWnd;
  // Устанавливаем свою оконную функцию
  SetWindowLong(FWndHandle, GWL_WNDPROC, DWord(WndCallback));
end;
////////////////////////////////////////////////////////////////////////////////
// Деструктор
////////////////////////////////////////////////////////////////////////////////
destructor TLiteWindow.Destroy;
begin
  // Наш объект - объект субклассиннга ?
  if FWndSubclass = nil then
  begin
    // Уничтожаем класс окна
    UnregisterClass(FWndParams.WindowClass.lpszClassName, FWndParams.WindowClass.hInstance);
    DestroyWindow();
  end
  else
    // Восстанавливаем старую оконную функцию
    SetWindowLong(FWndHandle, GWL_WNDPROC, DWord(FWndSubclass));
  // Уничтожение по умолчанию
  inherited;
end;
////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////
procedure TLiteWindow.CreateWindowEx;
begin
  // Создаем окно
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
  // Создаем окно
  with FWndParams do
    FWndHandle:=Windows.CreateWindow(WindowClass.lpszClassName, Caption,
      Style, X, Y, Width, Height,
      WndParent, WndMenu, FWndParams.WindowClass.hInstance, Param );
end;
////////////////////////////////////////////////////////////////////////////////
// Формирование параметров окна по умолчанию
////////////////////////////////////////////////////////////////////////////////
procedure TLiteWindow.CreateWindowParams(var WindowParams: TWindowParams);
var
  WndClassName : string;
begin
  // Формируем имя класса
  Str(DWord(Self), WndClassName);
  WndClassName := ClassName+':'+WndClassName;
  // Заполняем информацию о классе окна
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
  // Заполняем информацию об окне
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
  // Уничтожаем окно
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
// Функции обработки сообщений
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Обработчик сообщений по умолчанию
////////////////////////////////////////////////////////////////////////////////
procedure TLiteWindow.DefaultHandler(var Msg);
begin
  // Наш объект - объект субклассиннга ?
  if FWndSubclass = nil then
    // Вызываем системную функцию обработки сообщений
    with TMessage(Msg) do 
      Result := DefWindowProc(FWndHandle, Msg, WParam, LParam)
  else
    // Вызываем старую оконную функцию обработки сообщений
    with TMessage(Msg) do 
      Result := CallWindowProc(FWndSubclass, FWndHandle, Msg, WParam, LParam);
end;
////////////////////////////////////////////////////////////////////////////////
//Реализация диалогового класса TLiteDialog
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// TLiteDialog
// ____________________________________________
// Инициализация / финализация
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Конструктор
////////////////////////////////////////////////////////////////////////////////
constructor TLiteDialog.Create(AWndParent: HWND);
begin
  inherited;
  // Формируем параметры диалога
  CreateDialogParams(FDlgParams);
  // Создаем диалог
  with FDlgParams do
    CreateDialogParam(hInstance, Template, WndParent, WndCallback, 0);
end;

////////////////////////////////////////////////////////////////////////////////
// Деструктор
////////////////////////////////////////////////////////////////////////////////
destructor TLiteDialog.Destroy;
begin
  // Уничтожаем диалог
  if IsWindow(FWndHandle) then DestroyWindow(FWndHandle);
  // Уничтожение по умолчанию
  inherited;
end;

////////////////////////////////////////////////////////////////////////////////
// Формирование параметров диалога по умолчанию
////////////////////////////////////////////////////////////////////////////////
procedure TLiteDialog.CreateDialogParams(var DialogParams: TDialogParams);
begin
  DialogParams.WndParent := FWndParent;
  DialogParams.Template  := '';
end;

////////////////////////////////////////////////////////////////////////////////
// Обработка сообщений по умолчанию
////////////////////////////////////////////////////////////////////////////////
procedure TLiteDialog.DefaultHandler(var Msg);
begin
  // Возвращаемые значения по умолчанию
  with TMessage(Msg) do
    if Msg = WM_INITDIALOG then Result := 1
                           else Result := 0;
end;

////////////////////////////////////////////////////////////////////////////////
//Реализация модального диалогового класса TLiteDialogBox
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// TLiteDialogBox
// _________________________________________________________
// Инициализация / финализация
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Формирование параметров диалога по умолчанию
////////////////////////////////////////////////////////////////////////////////
procedure TLiteDialogBox.CreateDialogParams(


var DialogParams: TDialogParams);
begin
  DialogParams.WndParent := FWndParent;
  DialogParams.Template  := '';
end;

////////////////////////////////////////////////////////////////////////////////
// Активизация модального диалога
////////////////////////////////////////////////////////////////////////////////
function TLiteDialogBox.ShowModal: Integer;
begin
  // Формируем параметры диалога
  CreateDialogParams(FDlgParams);
  // Показываем диалог
  with FDlgParams do
    Result := DialogBoxParam(hInstance, Template, WndParent, WndCallback, 0);
end;

////////////////////////////////////////////////////////////////////////////////
// Обработка сообщений по умолчанию
////////////////////////////////////////////////////////////////////////////////
procedure TLiteDialogBox.DefaultHandler(var Msg);
begin
  // Возвращаемые значения по умолчанию
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
