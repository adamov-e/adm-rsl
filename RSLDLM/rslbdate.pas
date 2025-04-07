{
Набор библиотек на языке Delphi для разработки модулей проблемно-ориентированного языка RSL

  Версия: 1.0.0

  Разработчик: Адамов Ербулат, adamov.e.n@gmail.com
  Дата последней модификации: 2009 год

  Набор разрабатывался автором в учебно-познавательных целях.
  Разрешается свободное использование набора без каких либо ограничений.
  Набор предоставляется как есть, без какой-либо ответственности и претензий к автору.
}

unit RSLbdate;

interface

Type

  TRSLDate=packed record
    Day:BYTE; // Day of month
    Month:BYTE; // Month
    Year:WORD; // Year (4-digit)
  end;

  TRSLTime=packed record
    MSec:Byte;
    Sec:Byte;
    Min:Byte;
    Hour:Byte;
  end;

//typedef struct   // 2 in 1 :-))
//{   bdate           date;
//   btime           time;
//} RslDtTm;
  TRSLDateTime=packed Record
    RSLdate:TRSLDate;
    RSLtime:TRSLTime;
  end;

//DateTime convert routines
function DateTimeToRSLDate(Date:TDateTime):TRSLDate;
function RSLDateToDateTime(RSLDate:TRSLDate):TDateTime;
function DateTimeToRSLTime(Time:TDateTime):TRSLTime;
function RSLTimeToDateTime(RSLTime:TRSLTime):TDateTime;

function RSLDateTimeToDateTime(RSLDTTM:TRSLDateTime):TDateTime;
function DateTimeToRSLDateTime(Date:TDateTime):TRSLDateTime;

function RSLDateToStr(RSLDate:TRSLDate; Delim:String):String;
function RSLTimeToStr(RSLTime:TRSLTime; Delim:String):String;

function StrToRSLDate(dtstr, delim:String):TRSLDate;

function RSLDateValid(RSLDate:TRSLDate):Boolean;

implementation
  uses SysUtils, DateUtils;
//DateTime convert routines

function DateTimeToRSLDate(Date:TDateTime):TRSLDate;
var Year,Month,Day:word;
begin
  If (Date <> 0) Then Begin
    DecodeDate(Date,Year,Month,Day);
    result.Year:=Year;
    result.Month:=Month;
    result.Day:=Day;
  End Else Begin
    result.Year:=0;
    result.Month:=0;
    result.Day:=0;
  End;
end;

function DateTimeToRSLDateTime(Date:TDateTime):TRSLDateTime;
var Year,Month,Day:word;
    Hour, Min, Sec, MSec:Word;
begin
  If (Date <> 0) Then Begin
    DecodeDateTime(Date,Year,Month, Day, Hour, Min, Sec, MSec);
    result.RSLdate.Year:=Year;
    result.RSLdate.Month:=Month;
    result.RSLdate.Day:=Day;
    Result.RSLtime.Hour:=Hour;
    Result.RSLtime.Min:=Min;
    Result.RSLtime.Sec:=Sec;
    Result.RSLtime.MSec:=MSec;
  End Else Begin
    result.RSLdate.Year:=0;
    result.RSLdate.Month:=0;
    result.RSLdate.Day:=0;
    Result.RSLtime.Hour:=0;
    Result.RSLtime.Min:=0;
    Result.RSLtime.Sec:=0;
    Result.RSLtime.MSec:=0;
  End;
end;

function RSLDateToDateTime(RSLDate:TRSLDate):TDateTime;
begin
{
  If ((RSLDate.year >= 1) and (RSLDate.year <= 9999)) or 
      ((RSLDate.Month >= 1) and (RSLDate.Month <= 12)) or 
      ((RSLDate.Day >= 1) and (RSLDate.Day <= 31)) Then 
  result:=EncodeDate(RSLDate.year,RSLDate.Month,RSLDate.Day)
  Else Result:=0;}
  Try 
    Result:=EncodeDate(RSLDate.year,RSLDate.Month,RSLDate.Day);
  Except 
    on E:EConvertError Do Result:=0;
  End;
end;

function RSLDateTimeToDateTime(RSLDTTM:TRSLDateTime):TDateTime;
begin
  Try 
    Result:=EncodeDateTime(RSLDTTM.RSLDate.year,
                           RSLDTTM.RSLDate.Month,
                           RSLDTTM.RSLDate.Day,
                           RSLDTTM.RSLtime.Hour,
                           RSLDTTM.RSLtime.Min,
                           RSLDTTM.RSLtime.Sec,
                           RSLDTTM.RSLtime.MSec);
  Except
    on E:EConvertError Do Result:=0;
  End;
end;

function DateTimeToRSLtime(Time:TDateTime):TRSLTime;
var Hour,Min,Sec,MSec:Word;
begin
  DecodeTime(Time, Hour, Min, Sec, MSec);
  result.Hour:=Hour;
  result.Min:=Min;
  result.Sec:=Sec;
  result.MSec:=MSec;
end;

function RSLTimeToDateTime(RSLTime:TRSLTime):TDateTime;
begin
  Try
    result:=EncodeTime(RSLTime.Hour,RSLTime.Min,RSLTime.Sec,RSLTime.MSec);
  Except
    on E:EConvertError Do Result:=0;
  End;
end;

function RSLDateToStr(RSLDate:TRSLDate; Delim:String):String;
begin
  Result:=Format('%.2u%s%.2u%s%.4u', [RSLDate.Day, Delim, RSLDate.Month, Delim, RSLDate.Year]);
end;

function RSLTimeToStr(RSLTime:TRSLTime; Delim:String):String;
begin
  Result:=Format('%.2u%s%.2u%s%.2u', [RSLTime.Hour, Delim, RSLTime.Min, Delim, RSLTime.Sec]);
end;

function RSLDateValid(RSLDate:TRSLDate):Boolean;
begin
  Result:=FALSE;
  If ((RSLDate.year >= 0) and (RSLDate.year <= 9999)) or 
      ((RSLDate.Month >= 0) and (RSLDate.Month <= 12)) or 
      ((RSLDate.Day >= 0) and (RSLDate.Day <= 31)) Then Result:=TRUE;
end;

function StrToRSLDate(dtstr, delim:String):TRSLDate;
  var p:LongInt;
      dts:String;
      s:String;
begin
  Result.Day:=0;  Result.Month:=0;  Result.Year:=0;  p:=0;

  dts:=dtstr;
  p:=Pos(delim, dts);
  if (p > 0) Then Begin
    s:=Copy(dts, 1, p-1);
    If (s <> '') Then Result.Day:=StrToInt(s);
  end;

  dts:=Copy(dts, p+1, 10);
  p:=Pos(delim, dts);
  if (p > 0) Then Begin
    s:=Copy(dts, 1, p-1);
    If (s <> '') Then Result.Month:=StrToInt(s);
  end;
  if (p > 0) Then Begin
    s:=Copy(dts, p+1, 10);
    If (s <> '') Then Result.Year:=StrToInt(s);
    If ((Result.Year > 0) and (Result.Year < 100)) Then Result.Year:=Result.Year+2000;
  End Else Begin
    s:=Copy(dts, 1, 10);
    If (s <> '') Then Result.Year:=StrToInt(s);
    If ((Result.Year > 0) and (Result.Year < 100)) Then Result.Year:=Result.Year+2000;
  End;
end;

function StrToRSLTime(tmstr, delim:String):TRSLTime;
  var p:LongInt;
      tms:String;
      s:String[4];
begin
  Result.Hour:=0;  Result.Min:=0;  Result.Sec:=0;  Result.MSec:=0; p:=0;

  tms:=tmstr;
  p:=Pos(delim, tms);
  if (p > 0) Then Begin
    s:=Copy(tms, 1, p-1);
    If (s <> '') Then Result.Hour:=StrToInt(s);
  End;

  tms:=Copy(tms, p+1, 10);
  p:=Pos(delim, tms);
  if (p > 0) Then Begin
    s:=Copy(tms, 1, p-1);
    If (s <> '') Then Result.Min:=StrToInt(s);
  end;

  If (p > 0) Then Begin
    s:=Copy(tms, p+1, 10);
    If (s <> '') Then Result.Sec:=StrToInt(s);
  End Else Begin
    s:=Copy(tms, 1, 10);
    If (s <> '') Then Result.Sec:=StrToInt(s);
  End;
end;

initialization

finalization

end.
