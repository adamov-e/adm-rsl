{
Набор библиотек на языке Delphi для разработки модулей проблемно-ориентированного языка RSL

  Версия: 1.0.0

  Разработчик: Адамов Ербулат, adamov.e.n@gmail.com
  Дата последней модификации: 2009 год

  Набор разрабатывался автором в учебно-познавательных целях.
  Разрешается свободное использование набора без каких либо ограничений.
  Набор предоставляется как есть, без какой-либо ответственности и претензий к автору.
}

Unit WinEvent;
InterFace

//class TEvent
//{
//public:
//   TEvent () : hd (0) {}
//
//   void create (bool isMan = true,bool isSign = false)
//      {  if (!hd) hd = CreateEvent (NULL,(BOOL)isMan,(BOOL)isSign,NULL);   }
//   ~TEvent () { if (hd) CloseHandle (hd); }
//   void reset () { ResetEvent (hd); }
//   void signal () { SetEvent (hd); }
//   bool isValid () const { return (hd != NULL); }
//   bool operator ! () const { return !isValid (); }
//   operator HANDLE () const { return hd; }
//private:
//   HANDLE  hd;
//};

Type 

 
PEvent = ^TEvent;
TEvent  = Class
  Public
    hd:THandle;
    Constructor Create( isMan:Boolean = true; isSign:Boolean = false); virtual;
    Destructor Destroy(); virtual;
    Procedure Reset();
    Procedure Signal();
    Function isValid():Boolean;
End;

Implementation
Uses windows;

Constructor TEvent.Create( isMan:Boolean = true; isSign:Boolean = false);
Begin
  Inherited Create();
  hd := CreateEvent(NIL, isMan, isSign,NIL);
End;

Destructor TEvent.Destroy();
Begin
  CloseHandle(hd);
  Inherited Destroy();
End;

Procedure TEvent.Reset();
Begin
  ResetEvent(hd);
End;

Procedure TEvent.Signal();
Begin
  SetEvent(hd);
End;

Function TEvent.isValid():Boolean;
Begin
  Result:=TRUE;
  If (hd = 0) Then  Result:=FALSE;
End;

Initialization

Finalization

End.
