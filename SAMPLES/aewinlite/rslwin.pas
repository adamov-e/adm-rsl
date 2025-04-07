Unit RSLWin;
InterFace
Uses
    windows,
    messages,
    winplus,
    rsltype,
    uniprov;

Type
 PWinObj = ^TWinObj;
 TWinObj = Packed Object
  Protected
    isDispTable:Boolean; //зарегистрирована ли таблица
    RSLObject:Pointer;
    DLMObject:Pointer;
    obj:TWinPlusClass;
    isLocal:Boolean;
    WndHandle:HWND;
    RSLMsgHandlerId:LongInt;
    RSLMsgHandler:String;
    Procedure AddDispTable(); //регистрация таблицы
    Procedure RemDispTable(); //удаление регистрации таблицы
  Public
    Function Init(ParmNum:PInteger):Integer; cdecl;
    Function RSLCreate(ret:PVALUE):LongInt; cdecl;
    Function RSLDone(ret:PVALUE):LongInt; cdecl;
    Function RSLAddChild(ret:PVALUE):Integer; cdecl;
    Function RSLAddChildEx(ret:PVALUE):Integer; cdecl;
    Function RSLShow(ret:PVALUE):Integer; cdecl;
    Function RSLRun(ret:PVALUE):Integer; cdecl;
    Function RSLMsgBox(ret:PVALUE):Integer; cdecl;
    Function RSLClose(ret:PVALUE):Integer; cdecl;
    Function RSLSetStyle(ret:PVALUE):Integer; cdecl;
    Function RSLSetExStyle(ret:PVALUE):Integer; cdecl;
    Function RSLGetStyle(ret:PVALUE):Integer; cdecl;
    Function RSLGetExStyle(ret:PVALUE):Integer; cdecl;
    Function RSLSendMsg(ret:PVALUE):Integer; cdecl;
    Function RSLPostMsg(ret:PVALUE):Integer; cdecl;
    Function RSLSetText(ret:PVALUE):Integer; cdecl;
    Function RSLGetText(ret:PVALUE):Integer; cdecl;
    Function RSLEnable(ret:PVALUE):Integer; cdecl;
    Function RSLDisable(ret:PVALUE):Integer; cdecl;
    Function RSLEnabled(ret:PVALUE):Integer; cdecl;
    Function RSLVisible(ret:PVALUE):Integer; cdecl;
    Function RSLSetTimer(ret:PVALUE):Integer; cdecl;
    Function RSLKillTimer(ret:PVALUE):Integer; cdecl;                

    Function get_MsgHandler(ret:PVALUE):LongInt; cdecl;
    Function put_MsgHandler(new:PVALUE):LongInt; cdecl;
    Function get_isLocal(ret:PVALUE):LongInt; cdecl;
    Function put_isLocal(new:PVALUE):LongInt; cdecl;
    Function get_WndHandle(ret:PVALUE):LongInt; cdecl;
  End;

Var
  MainWin:HWND;
  RSLEvent:TFSEvent;
  PWinObjTable:PMethodTable;
  TWinObjEntrys:Packed Array [0..26] of TMethodEntry;


Implementation
Uses
  Sysutils,
  rsldll,
  rslfs,
  aeconst;


Function RSLHandleObject(inMes:Pointer; outMes:Pointer):LongInt;
Var ibuff:PHandleMsgBuffer;
    Obj:PWinObj;
    retVal:VALUE;
    parms:Packed Array[0..6] of VALUE;
Begin
  Result:=0;
  iBuff:=inMes;
  Obj:=iBuff.obj;
  If (Obj.RSLMsgHandlerId <> -1) Then
  Begin
    RSLValueMake(@retVal);
    RSLValueSet(@parms[0], iBuff.Msg.LParamLo);
    RSLValueSet(@parms[1], iBuff.Msg.WParamHi);
    RSLValueSet(@parms[2], iBuff.Msg.WParamLo);
    RSLValueSet(@parms[3], iBuff.Msg.WParamHi);
    RSLValueSet(@parms[4], iBuff.Msg.LParam);
    RSLValueSet(@parms[5], iBuff.Msg.WParam);
    RSLValueSet(@parms[6], iBuff.Msg.Msg);
    RslObjInvoke(Obj.RSLObject, Obj.RSLMsgHandlerId, RSL_DISP_RUN, 7, @parms[0], retVal);
  End;
End;

Function RSLExitObject(inMes:Pointer; outMes:Pointer):LongInt;
begin
  Result:=0;
  FillChar(RSLEvent, sizeof(TFSEvent), #0);
  RSLEvent.key := K_USER + 101; //  RSLEvent.key := K_ESC; 
  RSLfs_makeEvent(RSLEvent);
end;

Function SrvExtMessageProc(cmd:LongInt; inMes, outMes:Pointer):LongInt; cdecl;
Begin
  Case (cmd) Of
    CMD_HandleMessage:Begin Result:=RSLHandleObject(inMes, outMes); End;
    CMD_Exit:Begin Result:=RSLExitObject(inMes, outMes); End;
  Else
    Result:=0;
  End;
End;
{*****************************************************************************

                                    Методы

*****************************************************************************}
procedure TWinObj.AddDispTable(); //регистрация таблицы
var put:Pointer;
begin
  //регистрируем процедуру обработчик
  if ((not isLocal) and (not isDispTable)) then
    begin
      RSLaddDispTable(ServHandleProc, @SrvExtMessageProc);
      isDispTable:=True;
      put:=RSLfs_getSendBuff(0, TermDlmName, CMD_AddTable);
      RSLfs_sendMessage(put);
    end;
end;

procedure TWinObj.RemDispTable(); //удаление регистрации таблицы
var put:Pointer;
begin
  //удаляем процедуру обработчик
  if (isDispTable) then
    begin
      RSLremDispTable(ServHandleProc);
      isDispTable:=False;
      put:=RSLfs_getSendBuff(0, TermDlmName, CMD_DelTable);
      RSLfs_sendMessage(put);
    End;
end;

Function  TWinObj.RSLCreate(ret:PVALUE):LongInt;
Begin
  Result:=0;
  RSLMsgHandler:='';
  RSLMsgHandlerId:=0;
  RSLObject:=NIL;
  isLocal:=TRUE;
  WndHandle:=0;
  obj:=NIL;
  isDispTable:=False;
end;

Function TWinObj.RSLDone(ret:PVALUE):LongInt;
Var put:Pointer;
    sz:LongWord;
Begin
  If (isLocal) Then
  Begin
    obj.Free();
  End
  Else
  Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(TPointerBuffer), TermDlmName, CMD_DestroyObject);
    PPointerBuffer(put).obj:=obj;
    //ставим запрос в очередь
    RSLfs_transactMessage(put, sz);
    RemDispTable();
  End;
  Result:=0;
End;

Function TWinObj.Init(ParmNum:PInteger):Integer;
Var i:LongInt;
    v, v1, v2, v3, v4, v5, v6, v7, v8:PVALUE;
    put, get:Pointer;
    sz:LongWord;
Begin
  DLMObject:=@Self; //получаем ссылку на объект Delphi
  RSLGetParm(0, v); //получаем ссылку на объект RSL
  RSLObject:=v.obj; //получаем ссылку на объект RSL
  //получаем параметры
  i:=ParmNum^;
  RSLGetParm(i, v1);
  If (v1.v_type = V_BOOL) Then isLocal:=v1.boolval Else RSLError('isLocal:Boolean',[]);
  Inc(i); RSLGetParm(i, v2);
  Inc(i); RSLGetParm(i, v3);
  Inc(i); RSLGetParm(i, v4);
  Inc(i); RSLGetParm(i, v5);
  Inc(i); RSLGetParm(i, v6);
  Inc(i); RSLGetParm(i, v7);
  Inc(i); RSLGetParm(i, v8);
  //начинаем инициализацию
  If (isLocal) Then 
  Begin
    obj:=TWinPlusClass.Create(MainWin);
    obj.RSLObject:=RSLObject;
    If (v2.v_type = V_STRING)  then obj.Caption:=v2.RSLString;
    If (v3.v_type = V_INTEGER) then obj.X:=v3.intval;
    If (v4.v_type = V_INTEGER) then obj.Y:=v4.intval;
    If (v5.v_type = V_INTEGER) then obj.W:=v5.intval;
    If (v6.v_type = V_INTEGER) then obj.H:=v6.intval;
    If (v7.v_type = V_INTEGER) then obj.Style:=v7.intval;
    If (v8.v_type = V_INTEGER) then obj.ExStyle:=v8.intval;
  End
  Else 
  Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(TPointerBuffer), TermDlmName, CMD_CreateObject);
    PPointerBuffer(put).obj:=DLMObject;
    //Отправляем сообщение и получаем результат
    get:=RSLfs_transactMessage(put, sz);
    if (sz <> SizeOf(TPointerBuffer)) Then RSLErrorC('Terminal Create Object = %d',[sz]);
    obj:=PPointerBuffer(get).obj;
  End;
  //Создаем окно
  If (isLocal) Then
  Begin
    obj.CreateWindowEx();
    WndHandle:=obj.WndHandle;
  End
  Else
  Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(TPointerBuffer), TermDlmName, CMD_CreateWindow);
    PPointerBuffer(put).obj:=obj;
    //Отправляем сообщение и получаем результат
    get:=RSLfs_transactMessage(put, sz);
    if (sz <> SizeOf(THWNDBuffer)) Then RSLError('Terminal Create Window',[]);
    WndHandle:=PHWNDBuffer(get).hwin;
    AddDispTable();
  End;
  Result:=0;
End;

Function TWinObj.RSLRun(ret:PVALUE):Integer;
Begin
  If (isLocal) Then
  Begin
    obj.Run();
  End
  Else
  Begin
    While (true) do begin
      FillChar(RSLEvent, sizeof(TFSEvent), #0);
      RSLfs_event (RSLEvent, 500);
      if (RSLEvent.key = K_USER + 101) then break;
      if (RSLEvent.key = K_ESC) then break;          
    end;;
  End;
  Result:=0;
End;

Function TWinObj.RSLShow(ret:PVALUE):Integer;
Var v:PVALUE;
    put:Pointer;
    sz:LongWord;
Begin
  RSLGetParm(1, v);
  If (v.v_type <> V_INTEGER) Then RSLError('Show(Cmd:INTEGER)', []);
  If (isLocal) Then
  Begin
    obj.Show(v.intval);
    UpdateWindow(obj.WndHandle);
  End
  Else
  Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(TShowBuffer), TermDlmName, CMD_ObjectShow);
    PShowBuffer(put).obj:=obj;
    PShowBuffer(put).cmd:=v.intval;
    //ставим запрос в очередь
    RSLfs_transactMessage(put, sz);
  End;
  Result:=0;
End;

Function TWinObj.RSLAddChild(ret:PVALUE):Integer;
Var v1, v2, v3, v4, v5, v6, v7:PVALUE;
    hwin:HWND;
    put, get:Pointer;
    sz:LongWord;
Begin
  RSLGetParm(1, v1);
  If (v1.v_type <> V_STRING) then RSLError('Method:AddChild(Class, Text:STRING; Style, X, Y, Width, Height:INTEGER)', []);
  RSLGetParm(2, v2);
  If (v2.v_type <> V_STRING) then RSLError('Method:AddChild(Class, Text:STRING; Style, X, Y, Width, Height:INTEGER)', []);
  RSLGetParm(3, v3);
  If (v3.v_type <> V_INTEGER) then RSLError('Method:AddChild(Class, Text:STRING; Style, X, Y, Width, Height:INTEGER)', []);
  RSLGetParm(4, v4);
  If (v4.v_type <> V_INTEGER) then RSLError('Method:AddChild(Class, Text:STRING; Style, X, Y, Width, Height:INTEGER)', []);
  RSLGetParm(5, v5);
  If (v5.v_type <> V_INTEGER) then RSLError('Method:AddChild(Class, Text:STRING; Style, X, Y, Width, Height:INTEGER)', []);
  RSLGetParm(6, v6);
  If (v6.v_type <> V_INTEGER) then RSLError('Method:AddChild(Class, Text:STRING; Style, X, Y, Width, Height:INTEGER)', []);
  RSLGetParm(7, v7);
  If (v7.v_type <> V_INTEGER) then RSLError('Method:AddChild(Class, Text:STRING; Style, X, Y, Width, Height:INTEGER)', []);
  If (isLocal) Then
  Begin
    hwin:=obj.AddChild(v1.RSLString, v2.RSLString, v3.intval, v4.intval, v5.intval, v6.intval, v7.intval);
  End
  Else
  Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(TChildBuffer), TermDlmName, CMD_AddChild);
    PChildBuffer(put).obj:=obj;
    StrCopy(PChildBuffer(put).ClassName, v1.RSLString);
    StrCopy(PChildBuffer(put).Text, v2.RSLString);
    PChildBuffer(put).Style:=v3.intval;
    PChildBuffer(put).X:=v4.intval;
    PChildBuffer(put).Y:=v5.intval;
    PChildBuffer(put).W:=v6.intval;
    PChildBuffer(put).H:=v7.intval;
    //ставим запрос в очередь
    get:=RSLfs_transactMessage(put, sz);
    if (sz <> SizeOf(THWNDBuffer)) Then RSLError('Terminal Add Child',[]);
    hwin:=PHWNDBuffer(get).hwin;
  End;
  RSLValueClear(ret);
  RSLValueSet(ret, hwin);
  Result:=0;
End;

Function TWinObj.RSLAddChildEx(ret:PVALUE):Integer;
Var v1, v2, v3, v4, v5, v6, v7, v8:PVALUE;
    hwin:HWND;
    put, get:Pointer;
    sz:LongWord;
Begin
  RSLGetParm(1, v1);
  If (v1.v_type <> V_STRING) then RSLError('Method:AddChild(Class, Text:STRING; Style, ExStyle, X, Y, Width, Height:INTEGER)', []);
  RSLGetParm(2, v2);
  If (v2.v_type <> V_STRING) then RSLError('Method:AddChild(Class, Text:STRING; Style, ExStyle, X, Y, Width, Height:INTEGER)', []);
  RSLGetParm(3, v3);
  If (v3.v_type <> V_INTEGER) then RSLError('Method:AddChild(Class, Text:STRING; Style, ExStyle, X, Y, Width, Height:INTEGER)', []);
  RSLGetParm(4, v4);
  If (v4.v_type <> V_INTEGER) then RSLError('Method:AddChild(Class, Text:STRING; Style, ExStyle, X, Y, Width, Height:INTEGER)', []);
  RSLGetParm(5, v5);
  If (v5.v_type <> V_INTEGER) then RSLError('Method:AddChild(Class, Text:STRING; Style, ExStyle, X, Y, Width, Height:INTEGER)', []);
  RSLGetParm(6, v6);
  If (v6.v_type <> V_INTEGER) then RSLError('Method:AddChild(Class, Text:STRING; Style, ExStyle, X, Y, Width, Height:INTEGER)', []);
  RSLGetParm(7, v7);
  If (v7.v_type <> V_INTEGER) then RSLError('Method:AddChild(Class, Text:STRING; Style, ExStyle, X, Y, Width, Height:INTEGER)', []);
  RSLGetParm(8, v8);
  If (v8.v_type <> V_INTEGER) then RSLError('Method:AddChild(Class, Text:STRING; Style, ExStyle, X, Y, Width, Height:INTEGER)', []);
  if (isLocal) then
  begin
    hwin:=obj.AddChildEx(v1.RSLString, v2.RSLString, v3.intval, v4.intval, v5.intval, v6.intval, v7.intval, v8.intval);
  end
  else
  begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(TExChildBuffer), TermDlmName, CMD_AddExChild);
    PExChildBuffer(put).obj:=obj;
    StrCopy(PExChildBuffer(put).ClassName, v1.RSLString);
    StrCopy(PExChildBuffer(put).Text, v2.RSLString);
    PExChildBuffer(put).Style:=v3.intval;
    PExChildBuffer(put).ExStyle:=v4.intval;
    PExChildBuffer(put).X:=v5.intval;
    PExChildBuffer(put).Y:=v6.intval;
    PExChildBuffer(put).W:=v7.intval;
    PExChildBuffer(put).H:=v8.intval;
    //ставим запрос в очередь
    get:=RSLfs_transactMessage(put, sz);
    if (sz <> SizeOf(THWNDBuffer)) Then RSLError('Terminal Add ExChild',[]);
    hwin:=PHWNDBuffer(get).hwin;
  end;
  RSLValueClear(ret);
  RSLValueSet(ret, hwin);
  Result:=0;
End;

Function TWinObj.RSLMsgBox(ret:PVALUE):Integer;
Var v1, v2, v3:PVALUE;
    put:Pointer;
    sz:LongWord;
Begin
  Result:=0;
  RSLGetParm(1, v1);
  RSLGetParm(2, v2);
  RSLGetParm(3, v3);
  If (v1.v_type <> V_STRING) then RSLError('MsgBox(Text, Caption:String; Type:Integer)', []);
  If (v2.v_type <> V_STRING) then RSLError('MsgBox(Text, Caption:String; Type:Integer)', []);
  If (v3.v_type <> V_INTEGER) then RSLError('MsgBox(Text, Caption:String; Type:Integer)', []);
  if (isLocal) then
  begin
    obj.MsgBox(v1.RSLString, v2.RSLString, v3.intval);
  end
  else
  begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(TMsgBoxBuffer), TermDlmName, CMD_MsgBox);
    PMsgBoxBuffer(put).obj:=obj;
    StrCopy(PMsgBoxBuffer(put).Text, v1.RSLString);
    StrCopy(PMsgBoxBuffer(put).Caption, v2.RSLString);
    PMsgBoxBuffer(put).uType:=v3.intval;
    //ставим запрос в очередь
    RSLfs_transactMessage(put, sz);
  end;
End;

Function TWinObj.RSLClose(ret:PVALUE):Integer;
Var put:Pointer;
    sz:LongWord;
Begin
  Result:=0;
  If (isLocal) Then
  Begin
    obj.Close();
  End
  Else
  Begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(TPointerBuffer), TermDlmName, CMD_ObjectClose);
    PPointerBuffer(put).obj:=obj;
    //ставим запрос в очередь
    RSLfs_transactMessage(put, sz);
    FillChar(RSLEvent, sizeof(TFSEvent), #0);
    RSLEvent.key := K_USER + 101; //  RSLEvent.key := K_ESC;
    RSLfs_makeEvent(RSLEvent);
  End;
End;

function TWinObj.RSLSetStyle(ret:PVALUE):Integer;
var v1, v2, v3, v4, v5, v6:PVALUE;
    put:Pointer;
    sz:LongWord;
Begin
  Result:=0;
  RSLGetParm(1, v1);
  RSLGetParm(2, v2);
  RSLGetParm(3, v3);
  RSLGetParm(4, v4);
  RSLGetParm(5, v5);
  RSLGetParm(6, v6);
  If (v1.v_type <> V_INTEGER) then RSLError('SetStyle(Window, Style, X, Y, Width, Height:Integer)', []);
  If (v2.v_type <> V_INTEGER) then RSLError('SetStyle(Window, Style, X, Y, Width, Height:Integer)', []);
  If (v3.v_type <> V_INTEGER) then RSLError('SetStyle(Window, Style, X, Y, Width, Height:Integer)', []);
  If (v4.v_type <> V_INTEGER) then RSLError('SetStyle(Window, Style, X, Y, Width, Height:Integer)', []);
  If (v5.v_type <> V_INTEGER) then RSLError('SetStyle(Window, Style, X, Y, Width, Height:Integer)', []);
  If (v6.v_type <> V_INTEGER) then RSLError('SetStyle(Window, Style, X, Y, Width, Height:Integer)', []);
  if (isLocal) then
  begin
    obj.SetStyle(v1.intval, v2.intval);
    obj.SetPos(v1.intval, v3.intval, v4.intval, v5.intval, v6.intval);
  end
  else
  begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(TStyleBuffer), TermDlmName, CMD_SetStyle);
    PStyleBuffer(put).obj:=obj;
    PStyleBuffer(put).hwin:=v1.intval;
    PStyleBuffer(put).Style:=v2.intval;
    PStyleBuffer(put).X:=v3.intval;
    PStyleBuffer(put).Y:=v4.intval;
    PStyleBuffer(put).W:=v5.intval;
    PStyleBuffer(put).H:=v6.intval;                    
    //ставим запрос в очередь
    RSLfs_transactMessage(put, sz);
  end;
End;

function TWinObj.RSLSetExStyle(ret:PVALUE):Integer;
var v1, v2, v3, v4, v5, v6:PVALUE;
    put:Pointer;
    sz:LongWord;
Begin
  Result:=0;
  RSLGetParm(1, v1);
  RSLGetParm(2, v2);
  RSLGetParm(3, v3);
  RSLGetParm(4, v4);
  RSLGetParm(5, v5);
  RSLGetParm(6, v6);
  If (v1.v_type <> V_INTEGER) then RSLError('SetExStyle(Window, Style, X, Y, Width, Height:Integer)', []);
  If (v2.v_type <> V_INTEGER) then RSLError('SetExStyle(Window, Style, X, Y, Width, Height:Integer)', []);
  If (v3.v_type <> V_INTEGER) then RSLError('SetExStyle(Window, Style, X, Y, Width, Height:Integer)', []);
  If (v4.v_type <> V_INTEGER) then RSLError('SetExStyle(Window, Style, X, Y, Width, Height:Integer)', []);
  If (v5.v_type <> V_INTEGER) then RSLError('SetExStyle(Window, Style, X, Y, Width, Height:Integer)', []);
  If (v6.v_type <> V_INTEGER) then RSLError('SetExStyle(Window, Style, X, Y, Width, Height:Integer)', []);
  if (isLocal) then
  begin
    obj.SetExStyle(v1.intval, v2.intval);
    obj.SetPos(v1.intval, v3.intval, v4.intval, v5.intval, v6.intval);
  end
  else
  begin
    //получаем указатель на буфер для пересылки данных
    put:=RSLfs_getSendBuff(SizeOf(TStyleBuffer), TermDlmName, CMD_SetExStyle);
    PStyleBuffer(put).obj:=obj;
    PStyleBuffer(put).hwin:=v1.intval;
    PStyleBuffer(put).Style:=v2.intval;
    PStyleBuffer(put).X:=v3.intval;
    PStyleBuffer(put).Y:=v4.intval;
    PStyleBuffer(put).W:=v5.intval;
    PStyleBuffer(put).H:=v6.intval;
    //ставим запрос в очередь
    RSLfs_transactMessage(put, sz);
  end;
End;

function TWinObj.RSLGetStyle(ret:PVALUE):Integer;
var v:PVALUE;
    i:LongInt;
Begin
  Result:=0;
  RSLGetParm(1, v);
  If (v.v_type <> V_INTEGER) then RSLError('GetStyle(Window:Integer):Integer', []);
  i:=obj.GetStyle(v.intval);
  RSLValueClear(ret);
  RSLValueSet(ret, i);
End;

function TWinObj.RSLGetExStyle(ret:PVALUE):Integer;
var v:PVALUE;
    i:LongInt;
Begin
  Result:=0;
  RSLGetParm(1, v);
  If (v.v_type <> V_INTEGER) then RSLError('GetExStyle(Window:Integer):Integer', []);
  i:=obj.GetExStyle(v.intval);
  RSLValueClear(ret);
  RSLValueSet(ret, i);
End;

function TWinObj.RSLSendMsg(ret:PVALUE):Integer;
var v1, v2, v3, v4:PVALUE;
    i:LongInt;
begin
  Result:=0;
  RSLGetParm(1, v1);
  RSLGetParm(2, v2);
  RSLGetParm(3, v3);
  RSLGetParm(4, v4);
  If (v1.v_type <> V_INTEGER) then RSLError('SendMsg(Window, Msg, wParam, lParam:Integer)', []);
  If (v2.v_type <> V_INTEGER) then RSLError('SendMsg(Window, Msg, wParam, lParam:Integer)', []);
  If (v3.v_type <> V_INTEGER) then RSLError('SendMsg(Window, Msg, wParam, lParam:Integer)', []);
  If (v4.v_type <> V_INTEGER) then RSLError('SendMsg(Window, Msg, wParam, lParam:Integer)', []);
  i:=SendMessage(v1.intval, v2.intval, v3.intval, v4.intval);
  RSLValueClear(ret);
  RSLValueSet(ret, i);
end;

function TWinObj.RSLPostMsg(ret:PVALUE):Integer;
var v1, v2, v3, v4:PVALUE;
    i:Boolean;
begin
  Result:=0;
  RSLGetParm(1, v1);
  RSLGetParm(2, v2);
  RSLGetParm(3, v3);
  RSLGetParm(4, v4);
  If (v1.v_type <> V_INTEGER) then RSLError('PostMsg(Window, Msg, wParam, lParam:Integer)', []);
  If (v2.v_type <> V_INTEGER) then RSLError('PostMsg(Window, Msg, wParam, lParam:Integer)', []);
  If (v3.v_type <> V_INTEGER) then RSLError('PostMsg(Window, Msg, wParam, lParam:Integer)', []);
  If (v4.v_type <> V_INTEGER) then RSLError('PostMsg(Window, Msg, wParam, lParam:Integer)', []);
  i:=PostMessage(v1.intval, v2.intval, v3.intval, v4.intval);
  RSLValueClear(ret);
  RSLValueSet(ret, i);
end;

function TWinObj.RSLSetText(ret:PVALUE):Integer;
var v1, v2:PVALUE;
    i:Boolean;
begin
  Result:=0;
  RSLGetParm(1, v1);
  RSLGetParm(2, v2);
  If (v1.v_type <> V_INTEGER) then RSLError('SetText(Window:Integer; Text:String)', []);
  If (v2.v_type <> V_STRING) then RSLError('SetText(Window:Integer; Text:String)', []);
  if (isLocal) Then
  Begin
    i:=SetWindowText(v1.intval, v2.RSLString);
  End Else
  Begin
  End;
  RSLValueClear(ret);
  RSLValueSet(ret, i);
end;

function TWinObj.RSLGetText(ret:PVALUE):Integer;
var v:PVALUE;
    str:AnsiString;
begin
  Result:=0;
  RSLGetParm(1, v);
  If (v.v_type <> V_INTEGER) then RSLError('GetText(Window:Integer)', []);
  if (isLocal) then
  Begin
    GetWindowText(v.intval, PChar(str), GetWindowTextLength(v.intval));
  End Else
  Begin
  End;
  RSLValueClear(ret);
  RSLValueSet(ret, str);
end;

function TWinObj.RSLEnable(ret:PVALUE):Integer;
var v:PVALUE;
    res:Boolean;
begin
  Result:=0;
  RSLGetParm(1, v);
  If (v.v_type <> V_INTEGER) then RSLError('Enable(Window:Integer)', []);
  res:=EnableWindow(v.intval, TRUE);
  RSLValueClear(ret);
  RSLValueSet(ret, res);
end;

function TWinObj.RSLDisable(ret:PVALUE):Integer;
var v:PVALUE;
    res:Boolean;
begin
  Result:=0;
  RSLGetParm(1, v);
  If (v.v_type <> V_INTEGER) then RSLError('Disable(Window:Integer)', []);
  res:=EnableWindow(v.intval, FALSE);
  RSLValueClear(ret);
  RSLValueSet(ret, res);
end;

function TWinObj.RSLEnabled(ret:PVALUE):Integer;
var v:PVALUE;
    res:Boolean;
begin
  Result:=0;
  RSLGetParm(1, v);
  If (v.v_type <> V_INTEGER) then RSLError('Enabled(Window:Integer)', []);
  res:=IsWindowEnabled(v.intval);
  RSLValueClear(ret);
  RSLValueSet(ret, res);
end;

function TWinObj.RSLVisible(ret:PVALUE):Integer;
var v:PVALUE;
    res:Boolean;
begin
  Result:=0;
  RSLGetParm(1, v);
  If (v.v_type <> V_INTEGER) then RSLError('Visible(Window:Integer)', []);
  res:=IsWindowVisible(v.intval);
  RSLValueClear(ret);
  RSLValueSet(ret, res);
end;

function TWinObj.RSLSetTimer(ret:PVALUE):Integer;
var v1, v2:PVALUE;
    res:LongWord;
begin
  Result:=0;
  RSLGetParm(1, v1);
  RSLGetParm(2, v2);
  If (v1.v_type <> V_INTEGER) then RSLError('SetTimer(TimeOut, TimerID:Integer)', []);
  If (v2.v_type <> V_INTEGER) then RSLError('SetTimer(TimeOut, TimerID:Integer)', []);
  res:=SetTimer(WndHandle, v2.intval, v1.intval, NIL);
  RSLValueClear(ret);
  RSLValueSet(ret, res);
end;

function TWinObj.RSLKillTimer(ret:PVALUE):Integer;
var v:PVALUE;
    res:Boolean;
begin
  Result:=0;
  RSLGetParm(1, v);
  If (v.v_type <> V_INTEGER) then RSLError('KillTimer(TimerID:Integer)', []);
  res:=KillTimer(WndHandle, v.intval);
  RSLValueClear(ret);
  RSLValueSet(ret, res);
end;

{*****************************************************************************

			                           Свойства

*****************************************************************************}
Function TWinObj.get_MsgHandler(ret:PVALUE):LongInt;
Begin
  RSLValueClear(ret);
  RSLValueSet(ret, obj.RSLMsgHandler);
  Result:=0;
End;

Function TWinObj.put_MsgHandler(new:PVALUE):LongInt;
Begin
  if (new.v_type <> V_STRING) Then RSLError('MsgHandler:STRING', []);
  RSLMsgHandler:=new.RSLString;
  RslObjMemberFromName(RSLObject, PChar(RSLMsgHandler), RSLMsgHandlerId);
  If (isLocal) Then
  Begin
    obj.RSLMsgHandler:=new.RSLString;
    obj.RSLMsgHandlerId:=RSLMsgHandlerId;
  End;
  Result:=0;
End;

Function TWinObj.get_WndHandle(ret:PVALUE):LongInt;
Begin
  RSLValueClear(ret);
  RSLValueSet(ret, WndHandle);
  Result:=0;
End;

Function TWinObj.get_isLocal(ret:PVALUE):LongInt;
Begin
  Result:=0;
  RSLValueClear(ret);
  RSLValueSet(ret, isLocal);
End;

Function TWinObj.put_isLocal(new:PVALUE):LongInt;
Begin
  Result:=0;
  if (new.v_type <> V_BOOL) Then RSLError('isLocal:STRING', []);
  isLocal:=new.boolval;
End;

 
Initialization
  New(PWinObjTable);
  TWinObjEntrys[0]:=RSL_METH('Show', @TWinObj.RSLShow);
  TWinObjEntrys[1]:=RSL_METH('AddChild', @TWinObj.RSLAddChild);
  TWinObjEntrys[2]:=RSL_METH('AddChildEx', @TWinObj.RSLAddChildEx);
  TWinObjEntrys[3]:=RSL_PROP_METH('MsgHandler', @TWinObj.get_MsgHandler, @TWinObj.put_MsgHandler);
  TWinObjEntrys[4]:=RSL_METH('Run', @TWinObj.RSLRun);
  TWinObjEntrys[5]:=RSL_METH('MsgBox', @TWinObj.RSLMsgBox);
  TWinObjEntrys[6]:=RSL_PROP_METH('WndHandle', @TWinObj.get_WndHandle, NIL);
  TWinObjEntrys[7]:=RSL_METH('Close', @TWinObj.RSLClose);
  TWinObjEntrys[8]:=RSL_METH('SetStyle', @TWinObj.RSLSetStyle);
  TWinObjEntrys[9]:=RSL_METH('SetExStyle', @TWinObj.RSLSetExStyle);
  TWinObjEntrys[10]:=RSL_METH('GetStyle', @TWinObj.RSLGetStyle);
  TWinObjEntrys[11]:=RSL_METH('GetExStyle', @TWinObj.RSLGetExStyle);
  TWinObjEntrys[12]:=RSL_METH('SendMsg', @TWinObj.RSLSendMsg);
  TWinObjEntrys[13]:=RSL_METH('PostMsg', @TWinObj.RSLPostMsg);
  TWinObjEntrys[14]:=RSL_METH('SetText', @TWinObj.RSLSetText);
  TWinObjEntrys[15]:=RSL_METH('GetText', @TWinObj.RSLGetText);
  TWinObjEntrys[16]:=RSL_METH('Enable', @TWinObj.RSLEnable);
  TWinObjEntrys[17]:=RSL_METH('Disable', @TWinObj.RSLDisable);
  TWinObjEntrys[18]:=RSL_PROP_METH('isLocal', @TWinObj.get_isLocal, @TWinObj.put_isLocal);
  TWinObjEntrys[19]:=RSL_METH('isEnabled', @TWinObj.RSLEnabled);
  TWinObjEntrys[20]:=RSL_METH('isVisible', @TWinObj.RSLVisible);
  TWinObjEntrys[21]:=RSL_METH('SetTimer', @TWinObj.RSLSetTimer);
  TWinObjEntrys[22]:=RSL_METH('KillTimer', @TWinObj.RSLKillTimer);
  TWinObjEntrys[23]:=RSL_INIT(@TWinObj.Init);
  TWinObjEntrys[24]:=RSL_CTRL(@TWinObj.RSLCreate);
  TWinObjEntrys[25]:=RSL_DSTR(@TWinObj.RSLDone);
  TWinObjEntrys[26]:=RSL_TBL_END();

  PWinObjTable^.clsName:='TWinObj';
  PWinObjTable^.userSize:=SizeOf(TWinObj);
  PWinObjTable^.Entrys:=@TWinObjEntrys[0];
  PWinObjTable^.canInherit:=TRUE;
  PWinObjTable^.canCvtToIDisp:=TRUE;
  PWinObjTable^.Ver:=1;
  PWinObjTable^.autoPtr:=NIL;

Finalization
  Dispose(PWinObjTable);
End.