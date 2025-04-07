{Шаблон проекта для ДЛМ терминала}
Library aewint;
{отключаем выравнивание в рекордах}
{$A1}
{устанавливаем расширение файла}
{$E d32}
{включаем оптимизацию}
{$O+}

Uses
    sysutils,
    messages,
    windows,
    zwinlite,
    rsltype,
    termext,
    rslapart,
    aeconst;

Type
  TWinPlusClass = Class(TLiteWindow)
    RSLObject:Pointer;
    Constructor Create(AWndParent: HWND); virtual;
    Procedure   WindowProcedure(var Msg: TMessage); Override;
    Procedure   WMDESTROY(var Msg: TMessage); message WM_DESTROY;
  End;

  TTestWinApartment = class(TTermWinApartment)
    CurrObj:TWinPlusClass;
    Function  DispatchCMD(cmd:Integer; inBuf, outBuf:Pointer):Integer; override;
    Function  mes_CMD_CreateObject(inBuf:Pointer; outBuf:Pointer):LongInt;
    Function  mes_CMD_CreateWindow(inBuf:Pointer; outBuf:Pointer):LongInt;
    Function  mes_CMD_DestroyObject(inBuf:Pointer; outBuf:Pointer):LongInt;
    Function  mes_CMD_ObjectShow(inBuf:Pointer; outBuf:Pointer):LongInt;
    Function  mes_CMD_ObjectClose(inBuf:Pointer; outBuf:Pointer):LongInt;
    Function  mes_CMD_AddChild(inBuf:Pointer; outBuf:Pointer):LongInt;
    Function  mes_CMD_MsgBox(inBuf:Pointer; outBuf:Pointer):LongInt;
    Function  mes_CMD_AddExChild(inBuf:Pointer; outBuf:Pointer):LongInt;
    Function  mes_CMD_SetStyle(inBuf:Pointer; outBuf:Pointer):LongInt;
    Function  mes_CMD_SetExStyle(inBuf:Pointer; outBuf:Pointer):LongInt;            
  end;


Var
  MainWin:HWND;
  CurrApp:TTestWinApartment;
  CurrThread, CurrProcess:Cardinal;
  isTable:Boolean;

////////////////////////////////////////////////////////////////
//Точка входа в бибилиотеку
////////////////////////////////////////////////////////////////
Procedure TWinPlusClass.WindowProcedure(var Msg: TMessage);
  Var buff:THandleMsgBuffer;
//      res:Pointer;
//      sz:LongWord;
Begin
  Inherited;
//  CurrApp.setHandled(SizeOf(buff));
  if (isTable) then
  begin
    Case (Msg.Msg) of
      WM_COMMAND, WM_SYSCOMMAND, WM_PAINT, WM_CLOSE, WM_CREATE:
        Begin
          Buff.Obj:=RSLObject;
          Buff.Msg:=Msg;
          RSLSendAsync(@buff, SizeOf(THandleMsgBuffer), ServHandleProc, CMD_HandleMessage);
        end;
    End;
  end;
//  res:=NIL;
//  sz:=0;
//  RSLtransactAsync(@buff, SizeOf(THandleMsgBuffer), ServHandleProc,CMD_HandleMessage, res, 0, sz, 10000);
End;

Procedure TWinPlusClass.WMDESTROY(var Msg: TMessage);
var buff:TPointerBuffer;
begin
//  RSLMsgBox('WM_DESTROY', 1);
//  CurrApp.setHandled(0);
  if (isTable) then
  begin
    FillChar(buff, SizeOf(buff), #0);
    RSLSendAsync(@buff, 0, ServHandleProc, CMD_Exit);
  end;
end;

Constructor TWinPlusClass.Create(AWndParent: HWND);
Begin
  Inherited;
  RSLObject:=NIL;
End;
///////////////////////////////////////////////////////////////
//Создаем объект
////////////////////////////////////////////////////////////////
Function TTestWinApartment.mes_CMD_CreateObject(inBuf:Pointer; outBuf:Pointer):LongInt;
Begin
//  setHandled(sizeof(TPointerBuffer));
  CurrObj:=TWinPlusClass.Create(MainWin);
  CurrObj.RSLObject:=PPointerBuffer(inBuf).obj;
  PPointerBuffer(outBuf).obj:=CurrObj;
  Result:=SizeOf(TPointerBuffer);
//  MessageBox(0, 'mes_CMD_CreateObject', 'mes_CMD_CreateObject', 0);
End;
//создаем само окно
Function TTestWinApartment.mes_CMD_CreateWindow(inBuf:Pointer; outBuf:Pointer):LongInt;
Begin
//  setHandled(sizeof(THWNDBuffer));
  CurrObj:=PPointerBuffer(inBuf).obj;
  CurrObj.CreateWindowEx();
  PHWNDBuffer(outBuf).hwin:=CurrObj.WndHandle;
  Result:=SizeOf(THWNDBuffer);
//  MessageBox(0, 'mes_CMD_CreateWindow', 'mes_CMD_CreateWindow', 0);
End;
//уничтожаем объект
Function TTestWinApartment.mes_CMD_DestroyObject(inBuf:Pointer; outBuf:Pointer):LongInt;
Begin
//  setHandled(0);
  CurrObj:=PPointerBuffer(inBuf).obj;
  CurrObj.Free();
  Result:=0;
//  MessageBox(0, 'mes_CMD_DestroyObject', 'mes_CMD_DestroyObject', 0);
End;
//Запускаем цикл сообщений
Function TTestWinApartment.mes_CMD_ObjectShow(inBuf:Pointer; outBuf:Pointer):LongInt;
Begin
//  setHandled(0);
  CurrObj:=PShowBuffer(inBuf).obj;
  CurrObj.Show(PShowBuffer(inBuf).cmd);
  Result:=0;
//  MessageBox(0, 'mes_CMD_ObjectShow', 'mes_CMD_ObjectShow', 0);
End;
//
Function TTestWinApartment.mes_CMD_ObjectClose(inBuf:Pointer; outBuf:Pointer):LongInt;
Begin
//  setHandled(0);
  CurrObj:=PPointerBuffer(inBuf).obj;
  CurrObj.Close();
  Result:=0;
//MessageBox(0, 'mes_CMD_ObjectClose', 'mes_CMD_ObjectClose', 0);
End;
//
Function TTestWinApartment.mes_CMD_AddChild(inBuf:Pointer; outBuf:Pointer):LongInt;
Begin
//  setHandled(sizeof(THWNDBuffer));
  CurrObj:=PChildBuffer(inBuf).obj;
  PHWNDBuffer(outBuf).hwin:=CurrObj.AddChild(PChildBuffer(inBuf).ClassName, PChildBuffer(inBuf).Text,
                                             PChildBuffer(inBuf).Style,
                                             PChildBuffer(inBuf).X, PChildBuffer(inBuf).Y,
                                             PChildBuffer(inBuf).W, PChildBuffer(inBuf).H);
  Result:=SizeOf(THWNDBuffer);
End;
//
Function  TTestWinApartment.mes_CMD_MsgBox(inBuf:Pointer; outBuf:Pointer):LongInt;
begin
  CurrObj:=PMsgBoxBuffer(inBuf).obj;
  CurrObj.MsgBox(PMsgBoxBuffer(inBuf).Text, PMsgBoxBuffer(inBuf).Caption, PMsgBoxBuffer(inBuf).uType);
  Result:=0;
end;
//
Function TTestWinApartment.mes_CMD_AddExChild(inBuf:Pointer; outBuf:Pointer):LongInt;
Begin
//  setHandled(sizeof(THWNDBuffer));
  CurrObj:=PExChildBuffer(inBuf).obj;
  PHWNDBuffer(outBuf).hwin:=CurrObj.AddChildEx(PExChildBuffer(inBuf).ClassName, PExChildBuffer(inBuf).Text,
                                               PExChildBuffer(inBuf).Style, PExChildBuffer(inBuf).ExStyle,
                                               PExChildBuffer(inBuf).X, PExChildBuffer(inBuf).Y,
                                               PExChildBuffer(inBuf).W, PExChildBuffer(inBuf).H);
  Result:=SizeOf(THWNDBuffer);
End;
//
Function  TTestWinApartment.mes_CMD_SetStyle(inBuf:Pointer; outBuf:Pointer):LongInt;
begin
  CurrObj:=PStyleBuffer(inBuf).obj;
  CurrObj.SetStyle(PStyleBuffer(inBuf).hwin, PStyleBuffer(inBuf).Style);
  CurrObj.SetPos(PStyleBuffer(inBuf).hwin, PStyleBuffer(inBuf).X, PStyleBuffer(inBuf).Y, PStyleBuffer(inBuf).W, PStyleBuffer(inBuf).H);
  Result:=0;
end;
//
Function  TTestWinApartment.mes_CMD_SetExStyle(inBuf:Pointer; outBuf:Pointer):LongInt;
begin
  CurrObj:=PStyleBuffer(inBuf).obj;
  CurrObj.SetExStyle(PStyleBuffer(inBuf).hwin, PStyleBuffer(inBuf).Style);
  CurrObj.SetPos(PStyleBuffer(inBuf).hwin, PStyleBuffer(inBuf).X, PStyleBuffer(inBuf).Y, PStyleBuffer(inBuf).W, PStyleBuffer(inBuf).H);
  Result:=0;
end;
//
Function  TTestWinApartment.DispatchCMD(cmd:Integer; inBuf, outBuf:Pointer):Integer;
Begin
  Case (cmd) Of
    CMD_CreateObject:Begin Result:=mes_CMD_CreateObject(inBuf, outBuf); End;
    CMD_CreateWindow:Begin Result:=mes_CMD_CreateWindow(inBuf, outBuf); End;
    CMD_DestroyObject:Begin Result:=mes_CMD_DestroyObject(inBuf, outBuf); End;
    CMD_ObjectShow:Begin Result:=mes_CMD_ObjectShow(inBuf, outBuf); End;
    CMD_ObjectClose:Begin Result:=mes_CMD_ObjectClose(inBuf, outBuf); End;
    CMD_AddChild:Begin Result:=mes_CMD_AddChild(inBuf, outBuf); End;
    CMD_AddExChild:Begin Result:=mes_CMD_AddExChild(inBuf, outBuf); End;    
    CMD_MsgBox:Begin Result:=mes_CMD_MsgBox(inBuf, outBuf); End;
    CMD_SetStyle:Begin Result:=mes_CMD_SetStyle(inBuf, outBuf); End;
    CMD_SetExStyle:Begin Result:=mes_CMD_SetExStyle(inBuf, outBuf); End;
  Else
    Result:=inherited DispatchCMD(cmd, inBuf, outBuf);
  End;
//MessageBox(0, PChar(inttostr(result)), 'TTestWinApartment', 0);
End;
//
function mes_CMD_AddTable(inBuf:Pointer; outBuf:Pointer):LongInt;
begin
  Result:=0;
  isTable:=True;
  Writeln('TEST');
end;
//
function mes_CMD_DelTable(inBuf:Pointer; outBuf:Pointer):LongInt;
begin
  Result:=0;
  isTable:=False;
end;
////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////
{вызывается при загрузке модуля в память}
Procedure mes_Load();
Begin
  isTable:=False;
  MainWin:=GetForegroundWindow();
  CurrApp:=TTestWinApartment.CREATE(10000);
  CurrThread:=GetCurrentThreadId();
  CurrProcess:=getCurrentProcessId();   
End;
{вызывается при выгрузке модуля из памяти}
Procedure mes_UnLoad();
Begin
  CurrApp.Free();
End;
{вызывается для получения версии}
Procedure mes_Version (inBuf:PTermVersion);
Begin
End;
////////////////////////////////////////////////////////////////
//Точка входа в бибилиотеку
////////////////////////////////////////////////////////////////
Function RslExtMessageProc(cmd:LongInt; inBuf, outBuf:Pointer):LongInt; cdecl;
Begin 
  Case (cmd) Of
    TRMDLM_LOAD:Begin mes_Load(); Result:=0; End; //происходит при загрузке 
    TRMDLM_UNLOAD:Begin mes_UnLoad(); Result:=0; End; //происходит при выходе из приложения
    TRMDLM_VERSION:Begin mes_Version(PTermVersion(inBuf)); Result:=0; End;
    EXIT_APPARTMENT:Begin Result:=CurrApp.process(cmd,inBuf, outBuf); End; //происходит при выходе из приложения
    CMD_AddTable:Begin Result:=mes_CMD_AddTable(inBuf, outBuf); end;
    CMD_DelTable:Begin Result:=mes_CMD_DelTable(inBuf, outBuf); end;    
    CMD_CreateObject, CMD_CreateWindow,
    CMD_DestroyObject, CMD_ObjectShow,
    CMD_ObjectClose, CMD_AddChild,
    CMD_MsgBox, CMD_AddExChild,
    CMD_SetStyle, CMD_SetExStyle:
        Begin  Result:=CurrApp.process(cmd,inBuf, outBuf);  End;
  Else
    Result:=0;
  End;
End;

////////////////////////////////////////////////////////////////
//Точка входа в бибилиотеку
////////////////////////////////////////////////////////////////
Procedure DLLEntryPoint(Reason: DWORD);
Begin
  Case Reason of
    Dll_Process_Attach:; //Подключение процесса
    Dll_Thread_Attach:;  //Подключение потока
    Dll_Thread_Detach:;  //Отключение потока
    Dll_Process_Detach:; //Отключение процесса
  End; // case
End;

Exports
RslExtMessageProc;

Begin
  If (Not Assigned(DllProc)) then begin
    DllProc := @DLLEntryPoint;
    DllEntryPoint(Dll_Process_Attach);
  End;
End.
