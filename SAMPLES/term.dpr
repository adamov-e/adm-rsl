{Шаблон проекта для ДЛМ терминала}
library termdlm;
{отключаем выравнивание в рекордах}
{$A1}
{устанавливаем расширение файла}
{$E d32}
{включаем оптимизацию}
{$O+}

Uses
    sysutils, 
    windows,
    clipbrd,
    printers,
    rsltype,
    termext,
    aeconst;


Const BUFF_SIZE = 1024;


{*****************************************************************


******************************************************************}

function TestTermDLM(inMes:Pointer; outMes:Pointer):LongInt;
begin
  MessageBox(0, 'Test DLM', 'Test Term DLM', 0);
  Result:=0;
end;

{вызывается при загрузке модуля в память}
procedure mes_Load();
begin
  GetConsoleTitle(Buff, BUFF_SIZE);   //запоминаем старый заголовок
  SetConsoleTitle(PChar(str));  //Устанавливаем временный заголовок чтобы найти окно
  hWindowHandle:=FindWindow(NIL, PChar(str));   //Находим окно по закголовку
end;

{вызывается при выгрузке модуля из памяти}
procedure mes_UnLoad();
begin
end;

procedure mes_Version (inMes:PTermVersion);
begin
end;


{*****************************************************************


******************************************************************}

function RslExtMessageProc(cmd:LongInt; inMes:Pointer; outMes:Pointer):LongInt; cdecl;
begin
  Case (cmd) Of
     CMD_TestTerm:Begin Result:=TestTermDLM(inMes, outMes); End;
    -1:Begin mes_Load(); Result:=0; End;
    -2:Begin mes_UnLoad(); Result:=0; End;
    -4:Begin mes_Version(PTermVersion(inMes)); Result:=0; End;
  Else
    Result:=0;
  End;
end;

Exports
RslExtMessageProc;

Begin
  str:='_____RSBANK07303_____';
  GetMem(Buff, BUFF_SIZE);       //выделяем память под строку заголовка
End.
