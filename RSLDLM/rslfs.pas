{
Набор библиотек на языке Delphi для разработки модулей проблемно-ориентированного языка RSL

  Версия: 1.0.0

  Разработчик: Адамов Ербулат, adamov.e.n@gmail.com
  Дата последней модификации: 2009 год

  Набор разрабатывался автором в учебно-познавательных целях.
  Разрешается свободное использование набора без каких либо ограничений.
  Набор предоставляется как есть, без какой-либо ответственности и претензий к автору.
}

unit RSLfs;

Interface
Uses
    sysutils,
    rsltype,
    rsltbl;

Const
   SH_SHIFT         = 3;
   SH_CTRL          = 4;
   SH_ALT           = 8;
   SH_SCROLL        = 16;
   SH_NUMLOCK       = 32;
   SH_CAPSLOCK      = 64;

   K_RESIZE         = 500;

//  Mouse codes
   K_MINMOUSE       = 513;
   K_PRESS          = K_MINMOUSE;
   K_APRESS         = 514;
   K_DEPRESS        = 515;
   K_MOVE           = 516;
   K_PRESSR         = 517;
   K_DEPRESSR       = 518;
   K_MOVER          = 519;
   K_DPRESS         = 520;
   K_MAXMOUSE       = K_DPRESS;


// Keyboard codes
   K_SHTAB          = $010F;

   K_TAB            = $0009;
   K_ESC            = $001B;
   K_ENTER          = $000D;
   K_BS             = $0008;
   K_INS            = $0152;
   K_DEL            = $0153;
   K_HOME           = $0147;
   K_END            = $014F;
   K_PGUP           = $0149;
   K_PGDN           = $0151;
   K_UP             = $0148;
   K_DOWN           = $0150;
   K_LEFT           = $014B;
   K_RIGHT          = $014D;

   K_CTRLTAB        = $0194;
   K_CTRLENTER      = $000A;
   K_CTRLBS         = $007F;
   K_CTRLINS        = $0192;
   K_CTRLDEL        = $0193;
   K_CTRLHOME       = $0177;
   K_CTRLEND        = $0175;
   K_CTRLPGUP       = $0184;
   K_CTRLPGDN       = $0176;
   K_CTRLUP         = $018D;
   K_CTRLDOWN       = $0191;
   K_CTRLLEFT       = $0174;
   K_CTRLRIGHT      = $0173;

   K_ALTBS          = $010E;
   K_ALTINS         = $01A2;
   K_ALTDEL         = $01A3;
   K_ALTHOME        = $0197;
   K_ALTEND         = $019F;
   K_ALTPGUP        = $0199;
   K_ALTPGDN        = $01A1;
   K_ALTUP          = $0198;
   K_ALTDOWN        = $01A0;
   K_ALTLEFT        = $019B;
   K_ALTRIGHT       = $019D;

   K_ALT1           = $0178;
   K_ALT2           = $0179;
   K_ALT3           = $017A;
   K_ALT4           = $017B;
   K_ALT5           = $017C;
   K_ALT6           = $017D;
   K_ALT7           = $017E;
   K_ALT8           = $017F;
   K_ALT9           = $0180;
   K_ALT0           = $0181;
   K_ALTMIN         = $0182;
   K_ALTPLUS        = $0183;

   K_CTRL2          = $0103;
   K_CTRL6          = $001E;
   K_CTRLMIN        = $001F;

   K_F1             = $013B;
   K_F2             = $013C;
   K_F3             = $013D;
   K_F4             = $013E;
   K_F5             = $013F;
   K_F6             = $0140;
   K_F7             = $0141;
   K_F8             = $0142;
   K_F9             = $0143;
   K_F10            = $0144;
   K_F11            = $0185;
   K_F12            = $0186;

   K_CTRLF1         = $015E;
   K_CTRLF2         = $015F;
   K_CTRLF3         = $0160;
   K_CTRLF4         = $0161;
   K_CTRLF5         = $0162;
   K_CTRLF6         = $0163;
   K_CTRLF7         = $0164;
   K_CTRLF8         = $0165;
   K_CTRLF9         = $0166;
   K_CTRLF10        = $0167;
   K_CTRLF11        = $0189;
   K_CTRLF12        = $018A;

   K_SHF1           = $0154;
   K_SHF2           = $0155;
   K_SHF3           = $0156;
   K_SHF4           = $0157;
   K_SHF5           = $0158;
   K_SHF6           = $0159;
   K_SHF7           = $015A;
   K_SHF8           = $015B;
   K_SHF9           = $015C;
   K_SHF10          = $015D;
   K_SHF11          = $0187;
   K_SHF12          = $0188;

   K_ALTF1          = $0168;
   K_ALTF2          = $0169;
   K_ALTF3          = $016A;
   K_ALTF4          = $016B;
   K_ALTF5          = $016C;
   K_ALTF6          = $016D;
   K_ALTF7          = $016E;
   K_ALTF8          = $016F;
   K_ALTF9          = $0170;
   K_ALTF10         = $0171;
   K_ALTF11         = $018B;
   K_ALTF12         = $018C;

   K_ALTQ           = $0110;
   K_ALTW           = $0111;
   K_ALTE           = $0112;
   K_ALTR           = $0113;
   K_ALTT           = $0114;
   K_ALTY           = $0115;
   K_ALTU           = $0116;
   K_ALTI           = $0117;
   K_ALTO           = $0118;
   K_ALTP           = $0119;
   K_ALTLSQBR       = $011A;
   K_ALTRSQBR       = $011B;
   K_ALTOBR         = $00EC;
   K_ALTCBR         = $00EA;
   K_ALTA           = $011E;
   K_ALTS           = $011F;
   K_ALTD           = $0120;
   K_ALTF           = $0121;
   K_ALTG           = $0122;
   K_ALTH           = $0123;
   K_ALTJ           = $0124;
   K_ALTK           = $0125;
   K_ALTL           = $0126;
   K_ALTCOL         = $00E9;
   K_ALTCOM         = $00ED;
   K_ALTZ           = $012C;
   K_ALTX           = $012D;
   K_ALTC           = $012E;
   K_ALTV           = $012F;
   K_ALTB           = $0130;
   K_ALTN           = $0131;
   K_ALTM           = $0132;
   K_ALTLT          = $0133;
   K_ALTGR          = $0134;

   K_CTRLA          = $0001;
   K_CTRLB          = $0002;
   K_CTRLC          = $0003;
   K_CTRLD          = $0004;
   K_CTRLE          = $0005;
   K_CTRLF          = $0006;
   K_CTRLG          = $0007;
   K_CTRLH          = $0008;
   K_CTRLI          = $0009;
   K_CTRLJ          = $000A;
   K_CTRLK          = $000B;
   K_CTRLL          = $000C;
   K_CTRLM          = $000D;
   K_CTRLN          = $000E;
   K_CTRLO          = $000F;
   K_CTRLP          = $0010;
   K_CTRLQ          = $0011;
   K_CTRLR          = $0012;
   K_CTRLS          = $0013;
   K_CTRLT          = $0014;
   K_CTRLU          = $0015;
   K_CTRLV          = $0016;
   K_CTRLW          = $0017;
   K_CTRLX          = $0018;
   K_CTRLY          = $0019;
   K_CTRLZ          = $001A;

   K_LAST_ASCII_CTRL = K_ESC;

   K_CTRLLT         = $00E8;
   K_CTRLGR         = $00EF;
   K_USER           = 1000;

Var
    sWidth, sHeight:LongInt;         //размеры экрана

function MakeAttr(bcolor:COLORS; fcolor:COLORS):Integer;
function Makecha(at:Integer; ch:Integer):Integer;

procedure RSLfs_screenSize(var numcols, numrows:LongInt);
function  RSLfs_saveStat():Pointer;
procedure RSLfs_restStat(buff:Pointer);
function  RSLfs_event(var ev:TFSEvent; waitTime:LongInt):LongInt; 
procedure RSLfs_wrtnatr(x:LongInt; y:LongInt; number:LongInt; attr:LongInt); 
procedure RSLfs_setattr(color:LongWord);       // Set default attribute
function  RSLfs_curattr():LongWord;             // Вернуть текущий атрибут    
procedure RSLfs_wrtstr(x:LongInt; y:LongInt; str:PChar); 
procedure RSLfs_wrtncell(x:LongInt; y:LongInt; number:LongInt; charattr:LongInt); 
procedure RSLfs_gettext(x1:LongInt; y1:LongInt; x2:LongInt; y2:LongInt; buf:Pointer); 
procedure RSLfs_puttext(x1:LongInt; y1:LongInt; x2:LongInt; y2:LongInt; buf:Pointer); 
procedure RSLfs_movetext(x1:LongInt; y1:LongInt; x2:LongInt; y2:LongInt; dx:LongInt; dy:LongInt); 
procedure RSLfs_clr(ch:LongInt; atr:LongInt); 
procedure RSLfs_bar(x1:LongInt; y1:LongInt; x2:LongInt; y2:LongInt; ch:LongInt; atr:LongInt); 
procedure RSLfs_box(style:BORD; attr:LongInt; lcol:LongInt; trow:LongInt; rcol:LongInt; brow:LongInt); 
procedure RSLfs_setcurtype(cur:LongWord); 
procedure RSLfs_setcurpoz(x:LongInt; y:LongInt); 
function  RSLfs_getcurpoz(var x, y:LongInt):LongWord; 
procedure RSLfs_version(var ver:TFsVersion); 
procedure RSLfs_padstr(x:LongInt; y:LongInt; str:PChar; outlen:LongInt); 
procedure RSLfs_wrtItemStr(x:LongInt; y:LongInt; str:PChar; outlen:LongInt; selAtr:LongInt); 
procedure RSLfs_wrtMarkStr(x:LongInt; y:LongInt; str:PChar; outlen:LongInt; num:LongInt; pos:PMarkPos); 
procedure RSLfs_saveStat2(); 
procedure RSLfs_restStat2(); 
procedure RSLfs_statLine(str:PChar; atr:LongInt; selAtr:LongInt); 
function  RSLfs_getBuffSize(x1:LongInt; y1:LongInt; x2:LongInt; y2:LongInt):LongInt; 
function  RSLfs_event2(var ev:TFSEvent; waitTime:LongInt):LongInt; 
procedure RSLfs_screenSize2(var numcols, numrows:LongInt); 
Procedure RSLfs_MakeEvent(var ev:TFSEvent);

implementation

function MakeAttr(bcolor:Colors; fcolor:Colors):LongInt;
begin
  Result:= ((Integer(bcolor) shl 4) xor Integer(fcolor));
end;

function Makecha(at:LongInt; ch:LongInt):LongInt;
begin
  Result:= ((at shl 8) xor (ch and 255));
end;

procedure RSLfs_screenSize(var numcols, numrows:LongInt);
begin
  ExeExports.ptr_fs_screenSize(numcols, numrows);
end;

function RSLfs_saveStat():Pointer;
begin
  Result:=ExeExports.ptr_fs_saveStat();
end;

procedure RSLfs_restStat(buff:Pointer); 
begin
  ExeExports.ptr_fs_restStat(buff);
end;

function  RSLfs_event(var ev:TFSEvent; waitTime:LongInt):LongInt; 
begin
  Result:=ExeExports.ptr_fs_event(ev, waitTime);
end;

procedure RSLfs_wrtnatr(x:LongInt; y:LongInt; number:LongInt; attr:LongInt); 
begin
  ExeExports.ptr_fs_wrtnatr(x, y, number, attr);
end;

procedure RSLfs_setattr(color:LongWord);       // Set default attribute
begin
  ExeExports.ptr_fs_setattr(color);
end;

function  RSLfs_curattr():LongWord;             // Вернуть текущий атрибут    
begin
  Result:=ExeExports.ptr_fs_curattr();
end;

procedure RSLfs_wrtstr(x:LongInt; y:LongInt; str:PChar); 
begin
  ExeExports.ptr_fs_wrtstr(x, y, str);
end;

procedure RSLfs_wrtncell(x:LongInt; y:LongInt; number:LongInt; charattr:LongInt); 
begin
  ExeExports.ptr_fs_wrtncell(x, y, number, charattr);
end;

procedure RSLfs_gettext(x1:LongInt; y1:LongInt; x2:LongInt; y2:LongInt; buf:Pointer); 
begin
  ExeExports.ptr_fs_gettext(x1, y1, x2, y2, buf);
end;

procedure RSLfs_puttext(x1:LongInt; y1:LongInt; x2:LongInt; y2:LongInt; buf:Pointer); 
begin
  ExeExports.ptr_fs_puttext(x1, y1, x2, y2, buf);
end;

procedure RSLfs_movetext(x1:LongInt; y1:LongInt; x2:LongInt; y2:LongInt; dx:LongInt; dy:LongInt); 
begin
  ExeExports.ptr_fs_movetext(x1, y1, x2, y2, dx, dy);
end;

procedure RSLfs_clr(ch:LongInt; atr:LongInt); 
begin
  ExeExports.ptr_fs_clr(ch, atr);
end;

procedure RSLfs_bar(x1:LongInt; y1:LongInt; x2:LongInt; y2:LongInt; ch:LongInt; atr:LongInt); 
begin
  ExeExports.ptr_fs_bar(x1, y1, x2, y2, ch, atr);
end;

procedure RSLfs_box(style:BORD; attr:LongInt; lcol:LongInt; trow:LongInt; rcol:LongInt; brow:LongInt); 
begin
  ExeExports.ptr_fs_box(style, attr, lcol, trow, rcol, brow);
end;

procedure RSLfs_setcurtype(cur:LongWord); 
begin
  ExeExports.ptr_fs_setcurtype(cur);
end;

procedure RSLfs_setcurpoz(x:LongInt; y:LongInt); 
begin
  ExeExports.ptr_fs_setcurpoz(x, y);
end;

function  RSLfs_getcurpoz(var x, y:LongInt):LongWord; 
begin
  Result:=ExeExports.ptr_fs_getcurpoz(x, y);
end;

procedure RSLfs_version(var ver:TFsVersion); 
begin
  ExeExports.ptr_fs_version(ver);
end;

procedure RSLfs_padstr(x:LongInt; y:LongInt; str:PChar; outlen:LongInt); 
begin
  ExeExports.ptr_fs_padstr(x, y, str, outlen);
end;

procedure RSLfs_wrtItemStr(x:LongInt; y:LongInt; str:PChar; outlen:LongInt; selAtr:LongInt); 
begin
  ExeExports.ptr_fs_wrtItemStr(x, y, str, outlen, selAtr);
end;

procedure RSLfs_wrtMarkStr(x:LongInt; y:LongInt; str:PChar; outlen:LongInt; num:LongInt; pos:PMarkPos); 
begin
  ExeExports.ptr_fs_wrtMarkStr(x, y, str, outlen, num, pos);
end;

procedure RSLfs_saveStat2(); 
begin
  ExeExports.ptr_fs_saveStat2();
end;

procedure RSLfs_restStat2(); 
begin
  ExeExports.ptr_fs_restStat2();
end;

procedure RSLfs_statLine(str:PChar; atr:LongInt; selAtr:LongInt); 
begin
  ExeExports.ptr_fs_statLine(str, atr, selAtr);
end;

function  RSLfs_getBuffSize(x1:LongInt; y1:LongInt; x2:LongInt; y2:LongInt):LongInt; 
begin
  Result:=ExeExports.ptr_fs_getBuffSize(x1, y1, x2, y2);
end;

function  RSLfs_event2(var ev:TFSEvent; waitTime:LongInt):LongInt; 
begin
  Result:=ExeExports.ptr_fs_event2(ev, waitTime);
end;

procedure RSLfs_screenSize2(var numcols, numrows:LongInt); 
begin
  ExeExports.ptr_fs_screenSize2(numcols, numrows);
end;

Procedure RSLfs_MakeEvent(var ev:TFSEvent);
Begin 
  ExeExports.ptr_makeEvent(ev);
End;

Begin

End.