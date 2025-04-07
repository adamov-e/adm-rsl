{
����� ��������� �� ����� Delphi ��� ���������� ������� ���������-���������������� ����� RSL

  ������: 1.0.0

  �����������: ������ �������, adamov.e.n@gmail.com
  ���� ��������� �����������: 2009 ���

  ����� �������������� ������� � ������-�������������� �����.
  ����������� ��������� ������������� ������ ��� ����� ���� �����������.
  ����� ��������������� ��� ����, ��� �����-���� ��������������� � ��������� � ������.
}

Unit RSLApart;
{$ASSERTIONS ON}
InterFace
  Uses WinEvent, Windows, RSLType, TermExt, SysUtils;

Type 

TTermApartment = Class 
  Protected
    threadID:LongWord;
    threadHd:Integer;
    cmd:Integer;
    inBuffer:Pointer;
    outBuffer:Pointer;
    retval:Integer;
    evMessage:TEvent;
    evDone:TEvent;
    timeOut:DWORD;
  Private
    isStarted:Boolean;
    Function Start():Boolean;
    Procedure entryPoint();
  Protected
    Function  sendAsync(inMes:Pointer; sz:LongWord; tblName:PChar; cmdId:Integer):Boolean;
    Function  transactAsync(inMes:Pointer; szIn:LongWord; tblName:PChar; cmdId:Integer; outMes:Pointer; szOut:LongWord; Var szOutPtr:LongWord; timeOut:DWORD):Boolean;
    Function  beginAsync(inBuff:Pointer; sz:LongWord; tblName:PChar; cmdId:Integer; outBuff:Pointer; szOut:LongWord; Var szOutPtr:LongWord; Var cmplPtr:TFsComplete):Boolean;
    Function  resultAsync(Var cmplPtr:TFsComplete; timeOut:LongWord):Boolean;
    Procedure cancelAsync(Var cmplPtr:TFsComplete);
    Procedure setHandled(sz:Integer);
    Function  DispatchCMD(cmd:Integer; inBuf, outBuf:Pointer):Integer; virtual;
    Procedure onIdle(); virtual;
    Procedure runProc(); virtual;
  Public
    Function Create2(tm:DWORD=INFINITE):Boolean;
    Function Process(aCmd:Integer; inBuf, outBuf:Pointer):Integer;
    Constructor CREATE(tm:DWORD=INFINITE);Virtual;
    Destructor DESTROY(); Override;
End;

TTermWinApartment = Class(TTermApartment)
  Protected
    Procedure runProc(); override;
    Procedure mes_Load(); virtual;
    Procedure mes_UnLoad(); virtual;
    Function  DispatchCMD(cmd:Integer; inBuf, outBuf:Pointer):Integer; override;
End;

Implementation

/////////////////////////////////////////////////////////////////////////////////////////
//
//          TTermApartment
//
/////////////////////////////////////////////////////////////////////////////////////////
Constructor TTermApartment.CREATE(tm:DWORD=INFINITE);
Begin
  Inherited CREATE();
  isStarted:=false;
  timeOut:=tm;
  evMessage:=TEvent.Create(false);
  evDone:=TEvent.Create(false);
End;

Function TTermApartment.Create2(tm:DWORD=INFINITE):Boolean;
Begin
  timeOut := tm;
  Result:=Start();
End;

Destructor TTermApartment.DESTROY();
Begin
  CloseHandle(threadHd);
  evMessage.Free;
  evDone.Free;
  Inherited DESTROY();
End;

Function TTermApartment.Start():Boolean;
Begin
   If (NOT isStarted) Then //沫桭㡧ᰳ櫠衯��檠𐯲嗀
   Begin
     If ((NOT evMessage.isValid) OR (NOT evDone.isValid)) Then
        Begin    Result:=false; Exit;  End;
     threadHd:=BeginThread(NIL, 0, @TTermApartment.entryPoint, Self, 0, threadID);
     If (threadHd <> -1) Then  WaitForSingleObject(evDone.hd,10000);
  End;
  Result:=isStarted;
End;

Procedure TTermApartment.entryPoint();
Begin
  isStarted := true;
  evDone.Signal();
  DispatchCMD(TRMDLM_LOAD, NIL, NIL); // Handle as Load
  runProc ();
  dispatchCMD(TRMDLM_UNLOAD, NIL, NIL); // Handle as Unload
  evDone.Signal ();
End;

Function TTermApartment.sendAsync(inMes:Pointer; sz:LongWord; tblName:PChar; cmdId:Integer):Boolean;
Begin
  Result:=RSLSendAsync(inMes,sz,tblName,cmdId);
End;

Function TTermApartment.transactAsync(inMes:Pointer; szIn:LongWord; tblName:PChar; cmdId:Integer; outMes:Pointer; szOut:LongWord; Var szOutPtr:LongWord; timeOut:DWORD):Boolean;
Begin
  Assert(cmd = -1000, 'SetHandled not Called');
  Result:=RSLtransactAsync(inMes,szIn, tblName, cmdId,outMes,szOut,szOutPtr,timeOut);
End;

Function TTermApartment.beginAsync(inBuff:Pointer; sz:LongWord; tblName:PChar; cmdId:Integer; outBuff:Pointer; szOut:LongWord; Var szOutPtr:LongWord; Var cmplPtr:TFsComplete):Boolean;
Begin
  Result:=RSLbeginAsync(inBuff,sz,tblName,cmdId,outBuff,szOut,szOutPtr,cmplPtr);
End;

Function TTermApartment.resultAsync(Var cmplPtr:TFsComplete; timeOut:LongWord):Boolean;
Begin
  Assert(cmd = -1000, 'SetHandled not Called');
  Result:=RSLresultAsync(cmplPtr,timeOut);
End;

Procedure TTermApartment.cancelAsync(Var cmplPtr:TFsComplete);
Begin
  RSLcancelAsync(cmplPtr);
End;

Procedure TTermApartment.setHandled(sz:Integer);
Begin
  retval := sz;
  cmd := -1000;    // Inform runProc
  evDone.signal();
End;

Function TTermApartment.DispatchCMD(cmd:Integer; inBuf, outBuf:Pointer):Integer;
Begin
  Result:=0;
//MessageBox(0, PChar(inttostr(result)), 'TTermApartment', 0);
End;

Procedure TTermApartment.onIdle();
Begin
End;

Procedure TTermApartment.runProc();
Var stat:DWORD;
Begin
  While (TRUE) Do
  Begin
    stat := WaitForSingleObject (evMessage.hd, timeOut);
    case  stat of
      WAIT_OBJECT_0:
        Begin
          If (cmd = EXIT_APPARTMENT) Then Exit;
          retval := DispatchCMD(cmd, inBuffer, outBuffer);
          If (cmd <> -1000)  Then evDone.Signal(); // setHandled was not called
        End;
      WAIT_TIMEOUT:
        Begin
          onIdle();
        end;
    Else  Exit;
    end;
  End;
End;

Function TTermApartment.Process(aCmd:Integer; inBuf, outBuf:Pointer):Integer;
Begin
  If ((aCmd = EXIT_APPARTMENT) AND (NOT isStarted)) Then Begin Result:=0; Exit; End;
  If (NOT Start()) Then Begin Result:=0; Exit; End; //𐼲᦬򽡧ᰳ򳩲 沫桰ᮥ㡭㡡顧ᰳ櫍
  cmd := aCmd;          //򯶰ᮿ檠𐡰᭥󱹠򯯡殨 ﰠ򦱢池
  inBuffer := inBuf;    //򯶰ᮿ檠𐡰᭥󱹠򯯡殨 ﰠ򦱢池
  outBuffer := outBuf;  //򯶰ᮿ檠𐡰᭥󱹠򯯡殨 ﰠ򦱢池
  retval := 0;          //��ꡰᨬ殠㯧㱠᦬󡥠󋈠 evMessage.Signal(); //򩤭ᬨ詰��𐯲﫳 �沲 򯢻󩣍
  WaitForSingleObject(evDone.hd, 10000); //祥ꡮ𡰮󯫠 򯢻󩽠�﫠衢汸驠᢮󫱠ࡲ渥 10 򦨮
  Result:=retval;     //㯧㱠᦬ 񡨬殠塭
End;
/////////////////////////////////////////////////////////////////////////////////////////
//
//          TTermWinApartment
//
/////////////////////////////////////////////////////////////////////////////////////////
Procedure TTermWinApartment.runProc();
Var hd:Array[0..1] of THandle;
    stat:DWORD;
    Msg:TMsg;
Begin
  hd[0] := evMessage.hd;
  While (TRUE) Do
  Begin
    stat := MsgWaitForMultipleObjects(1, hd, FALSE, timeOut, QS_ALLINPUT);
    Case stat of 
      WAIT_OBJECT_0://
        Begin
          If (cmd = EXIT_APPARTMENT) Then Exit;
          retval := DispatchCMD(cmd, inBuffer, outBuffer);
          If (cmd <> -1000) Then evDone.Signal(); // setHandled was not called
        End;
      WAIT_TIMEOUT://򯢻󩣠𐱮騮쬠妫᦬ ᢮󫱠⦧妩򳣨
        Begin onIdle();  End;
      WAIT_OBJECT_0 + 1:
        Begin
          While (PeekMessage(Msg,0,0,0,PM_REMOVE)) Do
            Begin
              TranslateMessage (Msg);
              DispatchMessage (Msg);
            End; 
        End;
      Else Exit;
    End;
  End;
End;


Procedure TTermWinApartment.mes_Load();
Begin   
//  CoInitialize (NULL);
End;

Procedure TTermWinApartment.mes_UnLoad();
Begin   
//  CoUninitialize ();;
End;

Function  TTermWinApartment.DispatchCMD(cmd:Integer; inBuf, outBuf:Pointer):Integer;
Begin
  Case (cmd) Of
    TRMDLM_LOAD:Begin mes_Load(); Result:=0; End;
    TRMDLM_UNLOAD:Begin mes_UnLoad(); Result:=0; End;
  Else
    Result:=0;
  End;
//MessageBox(0, PChar(inttostr(result)), 'TTermWinApartment', 0);
End;

Initialization

Finalization

End.
