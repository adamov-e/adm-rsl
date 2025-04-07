{
Набор библиотек на языке Delphi для разработки модулей проблемно-ориентированного языка RSL

  Версия: 1.0.0

  Разработчик: Адамов Ербулат, adamov.e.n@gmail.com
  Дата последней модификации: 2009 год

  Набор разрабатывался автором в учебно-познавательных целях.
  Разрешается свободное использование набора без каких либо ограничений.
  Набор предоставляется как есть, без какой-либо ответственности и претензий к автору.
}

unit RSLType;

interface
  uses RSLbdate;

Const 
  RSL_Version     =  304;
  
  DLL_PROCESS_DETACH = 0;
  DLL_PROCESS_ATTACH = 1;
  DLL_THREAD_ATTACH  = 2;
  DLL_THREAD_DETACH  = 3;

  TRMDLM_LOAD     = -1;
  TRMDLM_UNLOAD   = -2;
  EXIT_APPARTMENT = -3;
  TRMDLM_VERSION  = -4;

  RSL_KIND_RUN  =  1;
  RSL_KIND_GET  =  2;
  RSL_KIND_SET  =  4;
  RSL_KIND_VAR  =  8;

  VAL_FLAG_RDONLY  = 1;
  VAL_FLAG_OPTINAL = 2;  // For parms
  VAL_FLAG_HIDE    = 4;

  GOBJ_GETTYPEINFO   = 100;
  GOBJ_FREETYPEINFO  = 101;
  GOBJ_GETPROPBYIND  = 102;
  GOBJ_GETVARBYIND   = 103;
  GOBJ_GETFUNCBYIND  = 104;
  GOBJ_MEMBERBYID    = 105;
  GOBJ_FREEMEMBER    = 106;

  GOBJ_INITENUM   = 0;
  GOBJ_FREEENUM   = 1;
  GOBJ_GETPROP    = 2;
  GOBJ_ERRMODE    = 3;
  GOBJ_INITENUM2  = 4;
  GOBJ_GETPROP2   = 5;
  GOBJ_GETPROPID  = 6;
  GOBJ_FREEPROP   = 7;

  RSL_DISP_INITEXT = -2;
  RSL_DISP_CTRL    = -3;
  RSL_DISP_ENUM    = -4;
  RSL_ADVISE       = -5;
  RSL_UNADVISE     = -6;
  RSL_DISP_DTRL    = -7;
  RSL_DISP_MAKE    = -8;
  RSL_DISP_MAKE2   = -9;

  RSL_DISP_RUN  = 0;
  RSL_DISP_GET  = 1;
  RSL_DISP_SET  = 2;
  RSL_DISP_GET_OR_RUN = 3;

  vaCONST     = 1;
  vaDECLARED  = 2;
  vaPERSIST   = 32;

  alCenter = 0;
  alLeft   = 1;
  alRight  = 2;

  NORMCUR = $0607;          {* Обычный курсор     *}
  BARCUR  = $0106;           {* Большой курсор     *}
  MIDCUR  = $0307;
  NOCUR   = $2000;          {* Невидимый курсор   *}

Type
SIZE_T = WORD;

BORD = (BORDOFF,     {* Отсутствует      *}
        BORDDUBL,    {* Двойная          *}
        BORDSING,    {* Одинарная        *}
        BORDSOL,     {*                  *}
        BORHDVS,     {*                  *}
        BORVSHD);    {*                  *}

COLORS =
  (BLACK,      {* dark colors *}
   BLUE,
   GREEN,
   CYAN,
   RED,
   MAGENTA,
   BROWN,
   LIGHTGRAY,
   DARKGRAY,    {* light colors *}
   LIGHTBLUE,
   LIGHTGREEN,
   LIGHTCYAN,
   LIGHTRED,
   LIGHTMAGENTA,
   YELLOW,
   WHITE);

  VALTYPE = (V_UNDEF=0,
             V_INTEGER=1,
             V_MONEY=2,
             V_DOUBLE=3,
             V_MONEYL=4,
             V_DOUBLEL=5,
             V_STRING=6,
             V_BOOL=7, 
             V_UNUSED=8, 
             V_DATE=9, 
             V_TIME=10,
             V_FREF=11, 
             V_BINST=12, 
             V_SREF=13, 
             V_SINST=14, 
             V_AREF=15, 
             V_AINST=16,
             V_TREF=17, 
             V_TINST=18, 
             V_GENOBJ=19,
             V_PROC=20,
             V_UNUSED5=21,
             V_UNUSED6=22,
             V_DTTM=23, 
             V_MEMADDR=24,
             V_R2M=25,
             V_ENDLIST = 100);

  RSLString = Array[0..255] of Char;

  LPVALUE=^PVALUE;
  PVALUE=^VALUE;
  
//typedef struct
//{  char           *name;       // Имя символа
//} ISYMBOL;
  PISYMBOL = ^ISYMBOL;
  ISYMBOL=packed Record
    name:PChar;// Имя символа
  end;


//typedef struct
//{  int dummy;
//} SYMPROC;
  PSYMPROC=^SYMPROC;
  SYMPROC=packed Record
    dummy:Integer;
  end;

//typedef struct
//{  int dummy;
//} SYMSTRUC;
  SYMSTRUC = Packed Record
    dummy:LongInt;
  end;

//typedef struct
//{  int dummy;
//} SYMCLASS;
  SYMCLASS = Packed Record
    dummy:LongInt;
  end;

//typedef struct
//{  int dummy;
//} SYMMODULE;
  SYMMODULE = Packed Record
    dummy:LongInt;
  end;

//typedef struct
//{  int dummy;
//} ISTREAMDATA;
  ISTREAMDATA = Packed Record
    dummy:LongInt;
  end;

//typedef struct   
//{  int key;
//   int kbflags;
//   int scan;
//   int Xm;
//   int Ym;
//   int Butn;
//} TFSEvent;
  PFSEvent = ^TFSEvent;
  TFSEvent=packed Record
    key:LongInt;
    kbflags:LongInt;
    scan:LongInt;
    Xm:LongInt;
    Ym:LongInt;
    Butn:LongInt;
  end;

//typedef struct 
//{  short int number;
//   short int revision ;
//   unsigned long buildNumber;
//   short int cmdll;         // true if communication DLL
//   unsigned long reserved;  // must be 0
//} TFsVersion;

  PFsVersion = ^TFsVersion;
  TFsVersion = packed Record
    number:smallint;
    revision:smallint;
    buildNumber:LongWord;
    cmdll:smallint;         // true if communication DLL
    reserved:LongWord;          // must be 0
  end;

//typedef struct
//{
//   char      magic  [18];
//   unsigned short  build;
//   unsigned short  verHi;
//   unsigned short verLow;
//}  TTermVersion;
  PTermVersion = ^TTermVersion;
  TTermVersion = packed Record
   magic:array [0..17] of char;
   build:Word;
   verHi:Word;
   verLow:Word;
  end;

//typedef struct tagTFsComplete
//{   HANDLE         ev;
//   void    *asyncObj;
//   char reserv   [8];
//} TFsComplete;
  PFsComplete = ^TFsComplete;
  TFsComplete = packed record
    ev:THandle;
    asyncObj:Pointer;
    reserv:array[0..7] of char;
  end;

//typedef struct 
//{  unsigned short xB;
//   unsigned short xE;
//   unsigned char attr;
//} TMarkPos;   

  PMarkPos = ^TMarkPos;
  TMarkPos = packed Record
    xB:Word;
    xE:Word;
    attr:Byte;
  End;

//typedef struct FDecimal_t
//{   unsigned long m_Lo;
//   unsigned long m_Hi;
//} FDecimal_t;
  PFDecimal_t = ^FDecimal_t;
  FDecimal_t = packed record
    m_Lo:LongWord;
    m_Hi:LongWord;
  end;

  TLDMon=record
    LI1, LI2:LongInt; { или LongInt }
    SI:SmallInt; { или Word }
  end;

//typedef struct
//{   void *sym; } // pointer to SYMPROC
//  PROCREF;
  TPROCREF=packed record
    sym:Pointer; // pointer to SYMPROC
  end;

//typedef struct
//{   VALUE *array;  // Элементы массива
//   int     size;  // Количество элементов массива
//}  AINST;
  PAINST=^AINST;
  AINST=packed record
    RSLArray:PVALUE; // Элементы массива
    size:LongInt; // Кол-во эл. массива
  end;

//typedef struct
//{   void      *sym;  
//   AINST    *inst;
//}  AREF;
  TAREF=packed record
    sym:Pointer;
    inst:PAINST;
  end;

//typedef struct
//{   int id;
//   int system;
//   char *cmdArgs;
//}  RSL_SYSTEM_CALL;
  PRSL_SYSTEM_CALL = ^TRSL_SYSTEM_CALL;
  TRSL_SYSTEM_CALL = Packed Record
   id:Integer; //идентификатор модуля подсистемы
   codefor:Integer; //код подсистемы
   cmdArgs:PChar; //параметры для запуска модуля
  End;

  PRSL_HANDLE = ^RSL_HANDLE;
  RSL_HANDLE = Packed Record
   unused:LongInt;
  end;

  CLNT_PRVD_HANDLE = ^RSL_HANDLE;
  PCLNT_PRVD_HANDLE = ^CLNT_PRVD_HANDLE;

  BDHANDLE = PRSL_HANDLE;
  BTHANDLE = PRSL_HANDLE;
  BNDHANDLE = PRSL_HANDLE;
  
//typedef struct
//{    BTHANDLE hd;
//} BINST;
  BINST = Packed Record
    hd:BTHANDLE;
  End;

//typedef struct
//{   void *file; // SYMFILE
//   BINST *inst;
//} FREF;
  FREF = Packed Record
    SYMFILE:Pointer;
    inst:BINST;
  End;

  PVALDATA=^VALDATA;
  VALDATA=packed Record
    intval:LongInt; //4
    doubval:Double; //8
    RSLString:PChar;//4
    boolval:Boolean;//1
    doubvalL:Extended; //10
    RSLDate:TRSLDate; //4
    RSLTime:TRSLTime; //4
    obj:Pointer; //4
    aref:TAREF; //8
    proc:TPROCREF; // 4
    addr:Pointer; // V_MEMADDR 4
    dttm:TRSLDateTime; // V_DTTM 8
    monval:Double; //8
    monvalL:Extended; //10
    fileref:FREF; // V_FREF
    dummy:array [1..10] of char; // Для обеспечения правильного размера, т.к. sizeof(long double) == 8 in VC
  end;

  VALUE=packed Record  //размер структуры 11 байт
  case v_type:VALTYPE of
    V_INTEGER:(intval:LongInt); //4
    V_DOUBLE:(doubval:double); //8
    V_STRING:(RSLString:PChar);//4
    V_BOOL:(boolval:Boolean);//1
    V_DOUBLEL:(doubvalL:Extended); //10
    V_DATE:(RSLdate:TRSLDate); //4
    V_TIME:(RSLtime:TRSLTime); //4
    V_GENOBJ:(obj:Pointer); //4
    V_AREF:(aref:TAREF); //8
    V_PROC:(proc:TPROCREF);  //4
    V_MEMADDR:(addr:Pointer); // 4
    V_DTTM:(dttm:TRSLDateTime); // 8
    V_MONEY:(monval:double); //8
    V_MONEYL:(monvalL:Extended); //10
    V_FREF:(fileref:FREF);
    V_R2M:(mref:Pointer);
  end;

  TFVT = (  { Новые типы значений   }
    FT_INT = 0,            // 0
    FT_LONG = 1,           // 1
    FT_FLOAT = 2,          // 2
    FT_FLOATG = 3,         // 3
    FT_DOUBLE = 4,         // 4
    FT_DOUBLEG = 5,        // 5
    FT_DOUBLEM = 6,        // 6
    FT_STRING = 7,         // 7
    FT_SNR = 8,            // 8
    FT_DATE = 9,           // 9
    FT_TIME = 10,          // 10
    FT_SHTM = 11,          // 11
    FT_CHR = 12,           // 12
    FT_UCHR = 13,          // 13
    FT_LDMON = 14,         // 14
    FT_LDMONR = 15,        // 15
    FT_DOUBLER = 16,       // 16
    FT_LDOUBLE = 17,       // 17
    FT_NUMSTR = 18         // 18
  ); 

// типы сообщений для BtMesProc
//typedef enum
//{   BT_ERROR,  // Btrieve operation error
//   BT_IN_USE, // File in use. Need asc for continue
//   BT_PAUSE,  // Need make a pause
//   BT_NOMEM,
//   BT_DICT,   // Dictionary check error
//   BT_FILE_PLACE, // Can not locate file in data directories
//   BT_BINDTYPE,   // Bad type used for bind field
//   BT_NOFIELD     // Requested field not found
//} BtMesType;

  BtMesType=(
    BT_ERROR,  // Btrieve operation error
    BT_IN_USE, // File in use. Need asc for continue
    BT_PAUSE,  // Need make a pause
    BT_NOMEM,

    BT_DICT,   // Dictionary check error
    BT_FILE_PLACE, // Can not locate file in data directories
    BT_BINDTYPE,   // Bad type used for bind field
    BT_NOFIELD     // Requested field not found
  );

//typedef struct 
//{   char name [20];
//   long      Code_File;	 	// код файла
//   long      fileFlags;
//   short     maxvarlen;
//   char   comment [40];
//} TBtLoop;

  PBtLoop = ^TBtLoop;
  TBtLoop = Packed Record
    name:Array[0..20] of Char;
    Code_File:LongInt;   // Код файла
    fileFlags:LongInt;
    maxvarlen:ShortInt;
    comment:Array[0..40] of Char;
  end;

//enum { BT_LIB_ERROR, BT_ENGINE_ERROR };
//enum { BT_LIB_OK, BT_LIB_NOMEM, BT_LIB_NOFILE,BT_LIB_NOFIELD,BT_LIB_BINDER,BT_LIB_DICTER };
//enum { RSL_BCNV_NOCNV, RSL_BCNV_DBO_USRA, RSL_BCNV_DBA_USRO };
//typedef struct
//{   int       level;  // BT_LIB_ERROR or BT_ENGINE_ERROR
//   int      erCode;  // Btrieve or LIB errcode.
//   int        btOp;
//   char   info [RSL_BT_INFO_LEN]; // Btrieve file name for RSL_BTLIB_ERROR
//} TBtError;
  PBtError = ^TBtError;
  TBtError = Packed Record
    level:LongInt;  // BT_LIB_ERROR or BT_ENGINE_ERROR
    erCode:LongInt;  // Btrieve or LIB errcode.
    btOp:LongInt;
    info:Array[1..80] of Char; // Btrieve file name for RSL_BTLIB_ERROR
  end;


// Описание полей Btrieve файла nfields штук
//typedef struct
//{   int fieldtype;       // Type of this field
//   int size;            // Size of this field
//   int pos;             // Position of this field (base == 0)
//}  ResBtrField;

  PResBtrField = ^ResBtrField;
  ResBtrField = Packed Record
    fieldtype:LongInt;       // Type of this field
    size:LongInt;            // Size of this field
    pos:LongInt;             // Position of this field (base == 0)
  end;

//  Описание сегментов ключей. nkeyseg штук
//typedef struct
//{   int   key;           // Key number ( 0 is the first key )
//   int   seg;           // Key segment ( 0 is the first segment )
//   int   field;         // Correspondent field index
//}  ResBtrKey;

  PResBtrKey = ^ResBtrKey;
  ResBtrKey = Packed Record
    key:LongInt;           // Key number ( 0 is the first key )
    seg:LongInt;           // Key segment ( 0 is the first segment )
    field:LongInt;         // Correspondent field index
  end;

//typedef struct
//{   char       name[25];   // имя в словаре
//   char         own[9];   // имя владельца
//   int         nfields;
//   ResBtrField *fields;
//   int         nkeyseg;
//   ResBtrKey     *keys;
//} TBtStr

  PBtStructure = ^TBtStructure;
  TBtStructure = Packed Record
    name:Packed Array[1..25] of Char;   // Имя в словаре
    own:Packed Array[1..9] of Char;   // Имя владельца
    nfields:LongInt;
    fields:Packed Array of ResBtrField;
    nkeyseg:LongInt;
    keys:Packed Array of ResBtrKey;
  end;

//Структура для доступа к буферу данных файла
  TBTBuffer=Packed Record
    name:Packed Array [1..80] of Char;
    Pos_blk:Packed Array [1..128] of Char;
    path:Integer; //Curent key path
    Buff:Pointer; //Data buffer
  End;

function FTtoFT(ft:LongInt):TFVT;
function VTtoFT(vt:VALTYPE):TFVT;
function FTtoVT(ft:LongInt; sz:LongInt):VALTYPE;
function VT2Str(vt:ValType):string;

Implementation

function FTtoFT(ft:LongInt):TFVT;
begin
  Case TFVT(ft) Of
    FT_CHR:Result:=FT_STRING;
    FT_SNR:Result:=FT_STRING;
    FT_NUMSTR:Result:=FT_STRING;
    FT_FLOAT:Result:=FT_DOUBLE;
  Else 
    Result:=TFVT(ft);
  End;
end;

function VTtoFT(vt:VALTYPE):TFVT;
begin
  Case vt Of
    V_STRING:Result:=FT_STRING;
    V_INTEGER:Result:=FT_INT;
    V_MONEY:Result:=FT_LDMON;
    V_MONEYL:Result:=FT_LDMON;
    V_DOUBLE:Result:=FT_DOUBLE;
    V_DOUBLEL:Result:=FT_LDOUBLE;
    V_DATE:Result:=FT_DATE;
    V_TIME:Result:=FT_TIME;
  else
    Result:=FT_INT;
  End;
end;

function FTtoVT(ft:LongInt; sz:LongInt):VALTYPE;
begin
  Case TFVT(ft) Of
    FT_STRING:Result:=V_STRING;
    FT_NUMSTR:Result:=V_STRING;
    FT_SNR:Result:=V_STRING;
    FT_CHR:Result:=V_STRING;
    FT_UCHR:Result:=V_INTEGER;
    FT_INT:Result:=V_INTEGER;
    FT_LONG:Result:=V_INTEGER;
    FT_FLOAT:Result:=V_DOUBLE;
    FT_DOUBLE:Result:=V_DOUBLE;
    FT_LDOUBLE:Result:=V_DOUBLEL;
    FT_DOUBLEM:Result:=V_MONEY;
    FT_LDMON:Case sz Of 
               8:Result:=V_MONEY;
              10:Result:=V_MONEYL;
             else Result:=V_MONEY;
             End;
    FT_DATE:Result:=V_DATE;
    FT_TIME:Result:=V_TIME;
  else
    Result:=V_UNDEF;
  End;
end;

function VT2Str(vt:ValType):string;
begin
  case (vt) of
    V_UNDEF:Result:='V_UNDEF';
    V_INTEGER:Result:='V_INTEGER';
    V_MONEY:Result:='V_MONEY';
    V_DOUBLE:Result:='V_DOUBLE';
    V_MONEYL:Result:='V_MONEYL';
    V_DOUBLEL:Result:='V_DOUBLEL';
    V_STRING:Result:='V_STRING';
    V_BOOL:Result:='V_BOOL';
    V_UNUSED:Result:='V_UNUSED';
    V_DATE:Result:='V_DATE';
    V_TIME:Result:='V_TIME';
    V_FREF:Result:='V_FREF';
    V_BINST:Result:='V_BINST';
    V_SREF:Result:='V_SREF';
    V_SINST:Result:='V_SINST';
    V_AREF:Result:='V_AREF';
    V_AINST:Result:='V_AINST';
    V_TREF:Result:='V_TREF';
    V_TINST:Result:='V_TINST';
    V_GENOBJ:Result:='V_GENOBJ';
    V_PROC:Result:='V_PROC';
    V_UNUSED5:Result:='V_UNUSED5';
    V_UNUSED6:Result:='V_UNUSED6';
    V_DTTM:Result:='V_DTTM';
    V_MEMADDR:Result:='V_MEMADDR';
    V_R2M:Result:='V_R2M';
    V_ENDLIST:Result:='V_ENDLIST';
    Else Result:='NOTHING';
  end;
end;

End.
