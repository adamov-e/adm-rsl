library aestr;
{отключаем выравнивание в рекордах}
{$A1}
{устанавливаем расширение файла}
{$E d32}
{включаем оптимизацию}
{$O+}
{отключаем предупреждения}
{$WARNINGS OFF}
{отключаем хинты}
{$HINTS OFF}
{включаем отладку}
{$DEBUGINFO OFF}

Uses
    sysutils,
    windows,
    rslbdate,
    btintf,
    rsltype,
    rslfs,
    rsldll;


procedure aeUnicodeToAnsi; cdecl;
var parm:PVALUE;
    tmpstr:String;
begin
  RSLGetParm(0, @parm);
  tmpstr:=WideCharToString(PWideChar(parm.RSLString));
  RSLReturnVal(V_STRING, PChar(tmpstr));
end;

procedure aeStringToWideChar; cdecl;
var parm:PVALUE;
    tmpstr:PWideChar;
begin
  RSLGetParm(0, @parm);
  GetMem(tmpstr, (Length(parm.RSLString)+1)*2);
  tmpstr:=StringToWideChar(parm.RSLString, tmpstr, Length(parm.RSLString)*2);
  RSLReturnVal(V_STRING, tmpstr);
  FreeMem(tmpstr);
end;

procedure aeUtf8ToAnsi; cdecl;
var parm:PVALUE;
    tmpstr:String;
begin
  RSLGetParm(0, @parm);
  tmpstr:=Utf8ToAnsi(parm.RSLString);
  RSLReturnVal(V_STRING, PChar(tmpstr));
end;

procedure aeAnsiToUtf8; cdecl;
var parm:PVALUE;
    tmpstr:UTF8String;
begin
  RSLGetParm(0, @parm);
  tmpstr:=AnsiToUtf8(parm.RSLString);
  RSLReturnVal(V_STRING, PChar(tmpstr));
end;

procedure aeAnsiToOem; cdecl;
  var parm:PVALUE;
      tmpstr:PChar;
begin
  RSLGetParm(0, @parm);
  GetMem(tmpstr, Length(parm.RSLString)+1);
  AnsiToOem(parm.RSLString, tmpstr);
  RSLReturnVal(V_STRING, tmpstr);
  FreeMem(tmpstr);
end;

procedure aeOemToAnsi; cdecl;
  var parm:PVALUE;
      tmpstr:PChar;
begin
  RSLGetParm(0, @parm);
  GetMem(tmpstr, Length(parm.RSLString)+1);
  OemToAnsi(parm.RSLString, tmpstr);
  RSLReturnVal(V_STRING, tmpstr);
  FreeMem(tmpstr);
end;

procedure aeOemToUTF8; cdecl;
  var parm:PVALUE;
  tmpstr:PChar;
  utfstr:UTF8String;
begin
  RSLGetParm(0, @parm);
  GetMem(tmpstr, Length(parm.RSLString)+1);
  OemToAnsi(parm.RSLString, tmpstr);
  utfstr:=AnsiToUtf8(tmpstr);
  RSLReturnVal(V_STRING, PChar(utfstr));
  FreeMem(tmpstr);
end;

procedure aeUtf8ToOem; cdecl;
var parm:PVALUE;
    tmpstr:String;
    pstr:PChar;
begin
  RSLGetParm(0, @parm);
  tmpstr:=Utf8ToAnsi(parm.RSLString);
  GetMem(pstr, Length(tmpstr)+1);
  AnsiToOem(PChar(tmpstr), pstr);
  RSLReturnVal(V_STRING, pstr);
  FreeMem(pstr);
end;


{*****************************************************************

******************************************************************}

procedure InitExec; stdcall;
begin
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
  RSLAddStdProc(V_STRING, PChar('aeUnicodeToAnsi'), @aeUnicodeToAnsi, 0);
  RSLAddStdProc(V_STRING, PChar('aeStringToWideChar'), @aeStringToWideChar, 0);
  RSLAddStdProc(V_STRING, PChar('aeUtf8ToAnsi'), @aeUtf8ToAnsi, 0);
  RSLAddStdProc(V_STRING, PChar('aeAnsiToUtf8'), @aeAnsiToUtf8, 0);
  RSLAddStdProc(V_STRING, PChar('aeAnsiToOem'), @aeAnsiToOem, 0);
  RSLAddStdProc(V_STRING, PChar('aeOemToAnsi'), @aeOemToAnsi, 0);
  RSLAddStdProc(V_STRING, PChar('aeOemToUTF8'), @aeOemToUTF8, 0);
  RSLAddStdProc(V_STRING, PChar('aeUTF8ToOem'), @aeUTF8ToOem, 0);
end;


Exports
InitExec,
DoneExec,
DlmMain,
AddModuleObjects;

begin

end.
