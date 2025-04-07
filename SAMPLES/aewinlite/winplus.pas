Unit winplus;
InterFace

Uses
    windows,
    messages,
    zWinLite,
    rsltype,
    rsldll,
    rslfs;

Type
  TWinPlusClass = Class(TLiteWindow)
    RSLMsgHandler:String;
    RSLObject:Pointer;
    RSLMsgHandlerId:LongInt;
    Constructor Create(AWndParent: HWND); override;
    Procedure   WindowProcedure(var Msg: TMessage); Override;
    Procedure   Run();
  End;

Implementation
Uses
  SysUtils;

Constructor TWinPlusClass.Create(AWndParent: HWND);
Begin
  Inherited;
  RSLMsgHandler:='';
  RSLObject:=NIL;
  RSLMsgHandlerId:=0;
End;

Procedure TWinPlusClass.WindowProcedure(var Msg: TMessage);
Var retVal:VALUE;
    parms:Packed Array[0..6] of VALUE;
Begin
  Inherited;
  If (RSLMsgHandlerId <> 0) Then
  Begin
    RSLValueMake(@retVal);
{**************************************************************************
    //Вариант с использованием GenRun
    RSLValueSet(@parms[0], V_STRING, PChar('OnMessage'));
    RSLValueSet(@parms[1], V_GENOBJ, RSLObj);
    RslCallInstSymbol(GenRunHandle, RSL_DISP_RUN, 2, @parms[0], retVal);
**************************************************************************}
    //Вариант с использованием функций юнипровайдера
    RSLValueSet(@parms[0], Msg.LParamLo);
    RSLValueSet(@parms[1], Msg.WParamHi);
    RSLValueSet(@parms[2], Msg.WParamLo);
    RSLValueSet(@parms[3], Msg.WParamHi);
    RSLValueSet(@parms[4], Msg.LParam);
    RSLValueSet(@parms[5], Msg.WParam);
    RSLValueSet(@parms[6], Msg.Msg);
    RslObjInvoke (RSLObject, RSLMsgHandlerId, RSL_DISP_RUN, 7, @parms[0], retVal);
    //if (retVal.v_type <> V_BOOL) Then RSLError('RSLMsgHandler:Boolean',[]);
  End;
End;

Procedure TWinPlusClass.Run();
Var Msg: TMsg;
Begin
  Show(SW_SHOW);
  While (GetMessage(Msg, 0, 0, 0)) Do Begin
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  End;
End;

Initialization

Finalization

End.
