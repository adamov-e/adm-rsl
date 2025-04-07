{
Набор библиотек на языке Delphi для разработки модулей проблемно-ориентированного языка RSL

  Версия: 1.0.0

  Разработчик: Адамов Ербулат, adamov.e.n@gmail.com
  Дата последней модификации: 2009 год

  Набор разрабатывался автором в учебно-познавательных целях.
  Разрешается свободное использование набора без каких либо ограничений.
  Набор предоставляется как есть, без какой-либо ответственности и претензий к автору.
}

Unit fsevent;
InterFace

uses rslfs, rsltype;

Type

  PRSLEvent = ^TRSLEvent;
  TRSLEvent = Packed Object
    public
    ev:TFSEvent;
    KeyEvent:Byte; //1 - событие от клавиатуры, 2 - событие от мышки
    KeyCode:LongInt; //код клавиши
    Xm, Ym:LongInt;  //координаты мышки
    ShiftKeyDown:Boolean;
    K_Shift:Boolean;
    K_Ctrl:Boolean;
    K_Alt:Boolean;
    K_Scroll:Boolean;
    K_NumLock:Boolean;
    K_CapsLock:Boolean;
    retVal:LongInt;
    Constructor Create();
    function GetEvent(tm:Integer):LongInt;
    Procedure ClearEvent();

    private
    wait_st:Integer;
    prev_SHKey:Integer;
  End;

Var
  RSLEvent:PRSLEvent;

Implementation

Constructor TRSLEvent.Create();
begin
  inherited;
  ShiftKeyDown:=FALSE;
  K_Shift:=FALSE;
  K_Ctrl:=FALSE;
  K_Alt:=FALSE;
  K_Scroll:=FALSE;
  K_NumLock:=FALSE;
  K_CapsLock:=FALSE;
  KeyEvent:=0;
  prev_SHKey:=0;
  wait_st:=500;
  KeyCode:=0;
  Xm:=0;
  Ym:=0;
  ev.Key:=0;
  ev.kbflags:=0;
  ev.scan:=0;
  ev.Xm:=0;
  ev.Ym:=0;
  ev.butn:=0;
end;

function TRSLEvent.GetEvent(tm:Integer):LongInt;
begin
  retVal:=RSLfs_event(ev, wait_st);
  If (retVal <> 0) Then
    Case (retVal) Of
      1..K_MINMOUSE-1:Begin KeyEvent:=1; KeyCode:=ev.key; End;
      K_MINMOUSE..K_MAXMOUSE:Begin KeyEvent:=2; Ym:=ev.Ym; Xm:=ev.Xm; End;
    End;
  If (prev_SHKey <> ev.kbflags )
    Then Begin
      If( prev_SHKey <> -1 ) Then ShiftKeyDown := TRUE;
      prev_shkey := ev.kbflags;
      K_Shift := Boolean(ev.kbflags and SH_SHIFT);
      K_Ctrl := Boolean(ev.kbflags and SH_CTRL);
      K_Alt := Boolean(ev.kbflags and SH_ALT);
      K_Scroll := Boolean(ev.kbflags and SH_SCROLL);
      K_NumLock := Boolean(ev.kbflags and SH_NUMLOCK);
      K_CapsLock := Boolean(ev.kbflags and SH_CAPSLOCK);
    End;
  Result:=retVal;
end;

procedure TRSLEvent.ClearEvent();
begin
  KeyEvent:=0;
  KeyCode:=0;
  Xm:=0;
  Ym:=0;
  ShiftKeyDown:=FALSE;
  K_Shift:=FALSE;
  K_Ctrl:=FALSE;
  K_Alt:=FALSE;
  K_Scroll:=FALSE;
  K_NumLock:=FALSE;
  K_CapsLock:=FALSE;
  prev_SHKey:=0;
end;

End.