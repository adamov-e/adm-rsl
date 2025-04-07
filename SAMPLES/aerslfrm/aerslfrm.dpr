//
library aerslfrm;
{отключаем выравнивание в рекордах}
{$A1}
{устанавливаем расширение файла}
{$E d32}
{включаем оптимизацию}
{$O+}

uses
  windows,
  messages,
  Dialogs,
  Classes,
  StdCtrls,
  sysutils,
  forms,
  rsltype,
  rsldll;

Type
 TRSLForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  protected  
  procedure WndProc(var Message: TMessage); override;

  private    { Private declarations }
  procedure ButtonClicked(Sender : TObject);

  public    { Public declarations }
    procedure CreateButton;
    procedure CreateLabel;
  end;

{$R *.dfm}
Var
  hWindowHandle, g_hWnd, hMainWindow:HWND;
  RSLForm:TRSLForm;
  MyForm:TForm;

function EnumWindowProc(hWin:HWND; lParm:LPARAM ):Boolean;
var dwProcessID:DWORD;
begin
  dwProcessID:=0;
  GetWindowThreadProcessId(hWin, @dwProcessID);

  if (dwProcessID <> DWORD(lParm)) then Result:=TRUE;

  if (GetParent(hWin) = 0) then begin
    // Нашли. hWnd - то что надо
    g_hWnd := hWin;
    Result := FALSE;
    end;
  Result:=TRUE;
end;

procedure TRSLForm.WndProc(var Message: TMessage);
begin
  Case Message.Msg of
    wm_Destroy, wm_Close:begin 
                end;
    WM_KEYUP:Begin  End;
    WM_KEYDOWN:Begin  End;
    WM_LBUTTONDOWN:Begin  End;
    WM_LBUTTONUP:Begin  End;
    WM_CREATE:begin  End;
  Else
  End;
  inherited;
end;

procedure TRSLForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  Close;
end;

procedure TRSLForm.ButtonClicked(Sender: TObject);
begin
  ShowMessage('ButtonClicked')
end;

procedure TRSLForm.CreateButton;
var
  btn : TButton;
begin
  btn := TButton.Create(Self);  { Уничтожать кнопку будет форма }
  btn.Parent := Self;           { Родителем кнопки будет форма }
  btn.OnClick := ButtonClicked; { Процедура, которая будет исполняться при }
  btn.Top:=10;
  btn.Left:=100;
  btn.Caption:='BUTTON';
end;

procedure TRSLForm.CreateLabel;
var
  lbl : TLabel;
begin
  lbl := TLabel.Create(Self);  { Уничтожать кнопку будет форма }
  lbl.Parent := Self;           { Родителем кнопки будет форма }
  lbl.Top:=10;
  lbl.Left:=10;
  lbl.Caption:='TEXT';
end;

procedure TRSLForm.FormCreate(Sender: TObject);
begin
//  BorderStyle:=bsDialog;
  BorderStyle:=bsSingle;
//  BorderStyle:=bsSizeable;
  CreateLabel;
  CreateButton;
end;

procedure CreateTheForm1; cdecl;
BEGIN
  Application.Handle:=hWindowHandle;
  RSLForm := TRSLForm.Create(Application.MainForm);
  with RSLForm do begin
    try
     ParentWindow:=hWindowHandle;
     ShowModal;
    finally
    RSLForm.Free;
    end;
  end;
END;

procedure CreateTheForm2; cdecl;
BEGIN
  MyForm := TForm.Create(nil);
  with MyForm do begin
    try
      ParentWindow:=hWindowHandle;
      ShowModal;
    finally
      Free;
    end;
  end;
END;


{*****************************************************************

******************************************************************}

procedure InitExec; stdcall;
var dwProcessID:DWORD;
begin
  hWindowHandle:=GetForegroundWindow();
  hMainWindow:=GetParent(hWindowHandle);
//  ShowMessage(PChar(IntToStr(hWindowHandle)));
//  ShowMessage(PChar(IntToStr(hMainWindow)));  
  g_hWnd := 0;
  dwProcessID:=GetCurrentProcessId();
//  EnumWindows(@EnumWindowProc, dwProcessID);
  if (hWindowHandle = g_hWnd) then ShowMessage('=');
//  hWindowHandle:=GetDesktopWindow();
end;

procedure DoneExec; stdcall;
begin
end;

function DlmMain(isLoad:Integer; anyL:Pointer):Integer;  stdcall;
begin
  result:=0;
end;

procedure AddModuleObjects(); stdcall;
begin
  RSLAddStdProc(V_UNDEF, PChar('CreateTheForm'), @CreateTheForm1, 0);
end;


Exports
InitExec,
DoneExec,
DlmMain,
AddModuleObjects;

Begin
End.
