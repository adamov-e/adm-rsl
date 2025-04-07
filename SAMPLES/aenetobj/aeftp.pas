unit aeftp;
InterFace

Uses
    sysutils,
    NMftp,
    provider,
    rsltype,
    rsldll,
    aesock;

Const
  aeTFTPMethods = 17;
  aeTFTPProps   = 3;

Type

  aePFTP = ^aeTFTP;
  aeTFTP = Packed Object(aeTSocket)
    public

    Constructor Create;
    procedure   Done(); virtual;
    procedure RSLInit(ParmNum:LongInt); virtual;
    function  RslSet(parm:PChar; val:PVALUE; var id:LongInt):LongInt; virtual; cdecl;
    function  Get(parm:PChar; val:PVALUE; var id:LongInt):LongInt; virtual; cdecl;
    function  Run(method:PChar; var id:LongInt):LongInt; virtual; cdecl;
    function  typeName():PChar; virtual; cdecl;
    function  RunId(id:LongInt):LongInt; virtual; cdecl;
    function  PropOrMethod(parm:PChar):LongInt; virtual;

    procedure RSLHelp(); virtual;
    procedure RSLAllocate(); virtual;
    procedure RSLChangeDir(); virtual;
    procedure RSLDelete(); virtual;
    procedure RSLDoCommand(); virtual;
    procedure RSLDownload(); virtual;
    procedure RSLDownloadRestore(); virtual;
    procedure RSLList(); virtual;
    procedure RSLMakeDir(); virtual;
    procedure RSLMode(); virtual;
    procedure RSLNList(); virtual;
    procedure RSLReinitialize(); virtual;
    procedure RSLRemoveDir(); virtual;
    procedure RSLRename(); virtual;
    procedure RSLUpload(); virtual;
    procedure RSLUploadAppend(); virtual;
    procedure RSLUploadRestore(); virtual;
    procedure RSLUploadUnique(); virtual;

    procedure set_UserName(newVal:PVALUE); virtual;
    procedure get_UserName(retVal:PVALUE); virtual;
    procedure set_Password(newVal:PVALUE); virtual;
    procedure get_Password(retVal:PVALUE); virtual;
    procedure get_CurrentDir(retVal:PVALUE); virtual;
  end;

function MakeaeTFTP():Pointer;
procedure CreateaeTFTP();

Var
  aeTFTPTypeTable:IRslTypeInfo;
  aePFTPTypeTable:PRslTypeInfo;

{*****************************************************************


******************************************************************}
Implementation

function aeTFTPTypeName():PChar; cdecl;
begin
  Result:='TaeFTP';
end;

function aeTFTPgetNProps():Integer; cdecl;
begin
  Result:=aeTFTPProps+aeTSocketProps;
end;

function aeTFTPgetNMethods():Integer; cdecl;
begin
  Result:=aeTFTPMethods+aeTSocketMethods;
end;

function aeTFTPcanInherit():Integer; cdecl;
begin
  Result:=1;
end;

{
Если parm - метод необходимп вернуть 0,
если parm - свойство - вернуть 1,
иначе вернуть -1
}
function aeTFTPisProp(parm:PChar; Var id:LongInt):Integer; cdecl; 
var i:Integer;
begin
  i:=aeTSocketisProp(parm, id);
  if (i <> -1) Then Begin Result:=i; Exit; End;

  id:=-1;
  Result:=-1;
  if (StrIComp('Allocate', parm) = 0)        Then Begin Result:=0; Exit; end;
  if (StrIComp('ChangeDir', parm) = 0)       Then Begin Result:=0; Exit; end;
  if (StrIComp('Delete', parm) = 0)          Then Begin Result:=0; Exit; end;
  if (StrIComp('DoCommand', parm) = 0)       Then Begin Result:=0; Exit; end;
  if (StrIComp('Download', parm) = 0)        Then Begin Result:=0; Exit; end;
  if (StrIComp('DownloadRestore', parm) = 0) Then Begin Result:=0; Exit; end;
  if (StrIComp('List', parm) = 0)            Then Begin Result:=0; Exit; end;
  if (StrIComp('MakeDir', parm) = 0)         Then Begin Result:=0; Exit; end;
  if (StrIComp('Mode', parm) = 0)            Then Begin Result:=0; Exit; end;
  if (StrIComp('NList', parm) = 0)           Then Begin Result:=0; Exit; end;
  if (StrIComp('Reinitialize', parm) = 0)    Then Begin Result:=0; Exit; end;
  if (StrIComp('RemoveDir', parm) = 0)       Then Begin Result:=0; Exit; end;
  if (StrIComp('Rename', parm) = 0)          Then Begin Result:=0; Exit; end;
  if (StrIComp('Upload', parm) = 0)          Then Begin Result:=0; Exit; end;
  if (StrIComp('UploadAppend', parm) = 0)    Then Begin Result:=0; Exit; end;
  if (StrIComp('UploadRestore', parm) = 0)   Then Begin Result:=0; Exit; end;
  if (StrIComp('UploadUnique', parm) = 0)    Then Begin Result:=0; Exit; end;

  if (StrIComp('UserName', parm) = 0)      Then Begin Result:=1; Exit; end;
  if (StrIComp('Password', parm) = 0)      Then Begin Result:=1; Exit; end;
  if (StrIComp('CurrentDir', parm) = 0)    Then Begin Result:=1; Exit; end;
end;

{*****************************************************************


******************************************************************}

{
Функция возвращает -1 если parm не имя метода или свойства
или 0 если parm имя метода
или 1  если parm имя свойства
}
function aeTFTP.PropOrMethod(parm:PChar):LongInt;
  var i:LongInt;
begin
  Result:=aeTFTPisProp(parm, i);
end;

function aeTFTP.RslSet(parm:PChar; val:PVALUE; var id:LongInt):LongInt;
  var res:LongInt;
begin
  id:=-1;  Result:=-1;

  res:=PropOrMethod(parm);
  if (res = -1) Then begin Result:=-1; Exit; end;
  if (res = 0) Then begin Result:=1; Exit; end;

  res:=inherited Get(parm, val, id);
  if (res=0) Then Begin Result:=res;  Exit; End;

  if (StrIComp('UserName', parm) = 0)      Then Begin set_UserName(val); Result:=0; Exit; end;
  if (StrIComp('Password', parm) = 0)  Then Begin set_Password(val); Result:=0; Exit; end;
end;

function aeTFTP.Get(parm:PChar; val:PVALUE; var id:LongInt):LongInt;
  var res:LongInt;
begin
  id:=-1;  Result:=-1;

  res:=PropOrMethod(parm);
  if (res = -1) Then begin Result:=-1; Exit; end;
  if (res = 0) Then begin Result:=1; Exit; end;

  res:=inherited Get(parm, val, id);
  if (res=0) Then Begin Result:=res;  Exit; End;

  if (StrIComp('UserName', parm) = 0)     Then Begin get_UserName(val); Result:=0; Exit; end;
  if (StrIComp('Password', parm) = 0)     Then Begin get_Password(val); Result:=0; Exit; end;
  if (StrIComp('CurrentDir', parm) = 0)   Then Begin get_CurrentDir(val); Result:=0; Exit; end;
end;

function aeTFTP.Run(method:PChar; var id:LongInt):LongInt;
  var res:LongInt;
   v1, v2:PVALUE;
begin
  id:=-1;  Result:=-1;

  res:=PropOrMethod(method);
  if (res <> 0) Then begin Result:=-1; Exit; end;

  res:=inherited Run(method, id);
  if (res=0) Then Begin Result:=res;  Exit; End;

  If (StrIComp('Allocate', method) = 0)   Then Begin  RSLAllocate(); Result:=0;  Exit; end;
  If (StrIComp('ChangeDir', method) = 0)  Then Begin  RSLChangeDir(); Result:=0;  Exit; end;
  If (StrIComp('Delete', method) = 0)     Then Begin  RSLDelete(); Result:=0;  Exit; end;
  If (StrIComp('DoCommand', method) = 0)  Then Begin  RSLDoCommand(); Result:=0;  Exit; end;
  If (StrIComp('Download', method) = 0)   Then Begin  RSLDownload(); Result:=0;  Exit; end;
  If (StrIComp('DownloadRestore', method) = 0) Then Begin  RSLDownloadRestore(); Result:=0;  Exit; end;
  If (StrIComp('List', method) = 0)       Then Begin  RSLList(); Result:=0;  Exit; end;
  If (StrIComp('MakeDir', method) = 0)    Then Begin  RSLMakeDir(); Result:=0;  Exit; end;
  If (StrIComp('Mode', method) = 0)       Then Begin  RSLMode(); Result:=0;  Exit; end;
  If (StrIComp('NList', method) = 0)      Then Begin  RSLNList(); Result:=0;  Exit; end;
  If (StrIComp('Reinitialize', method) = 0) Then Begin RSLReinitialize();  Result:=0; Exit; end;
  If (StrIComp('RemoveDir', method) = 0)  Then Begin RSLRemoveDir();  Result:=0; Exit; end;
  If (StrIComp('Rename', method) = 0)     Then Begin RSLRename();  Result:=0; Exit; end;
  If (StrIComp('Upload', method) = 0)     Then Begin RSLUpload();  Result:=0; Exit; end;
  If (StrIComp('UploadAppend', method) = 0)  Then Begin RSLUploadAppend();  Result:=0; Exit; end;
  If (StrIComp('UploadRestore', method) = 0) Then Begin RSLUploadRestore();  Result:=0; Exit; end;
  If (StrIComp('UploadUnique', method) = 0)  Then Begin RSLUploadUnique();  Result:=0; Exit; end;
end;

function aeTFTP.RunId(id:LongInt):LongInt;
  var ob:PVALUE;
begin
  Result:=-1;
  If (id = -3) Then Begin 
    RSLGetParm(0, @ob);
    if (ob.v_type = V_GENOBJ) Then RSLObject:=ob.obj Else RSLError('Ошибка получения указателя на потомка',[]);
    RSLInit(1); Result:=0;  
  End;
end;

function aeTFTP.TypeName():PChar; 
begin
  Result:=aeTFTPTypeName();
end;

{*****************************************************************

                       МЕТОДЫ

******************************************************************}

constructor aeTFTP.Create();
Begin
  Inherited;        
  _vtbl.rslSet:=@aeTFTP.rslSet;
  _vtbl.Get:=@aeTFTP.Get;
  _vtbl.Run:=@aeTFTP.Run;
  _vtbl.TypeName:=@aeTFTP.TypeName;
  _vtbl.RunId:=@aeTFTP.RunId;
end;

procedure  aeTFTP.Done();
begin
  TNMFTP(aeobj).Free();
end;

procedure aeTFTP.RSLInit(ParmNum:LongInt);
var 
  i:LongInt;
begin
  i:=ParmNum;
  aeObj:=TNMFTP.Create(NIL);
  aeObj.Proxy:='';
  aeObj.ProxyPort:=0;
  aeObj.TimeOut:=10000;
  aeObj.ReportLevel:=0;
end;

procedure aeTFTP.RSLHelp();
Begin
  inherited;
  RSLPrint('TaeFTP %s', [PChar(#10+#13)]);
  RSLPrint('procedure Allocate(FileSize: Integer) %s', [PChar(#10+#13)]);
  RSLPrint('procedure ChangeDir(DirName: string) %s', [PChar(#10+#13)]);
  RSLPrint('procedure Delete(Filename: string) %s', [PChar(#10+#13)]);
  RSLPrint('procedure DoCommand(CommandStr: string) %s', [PChar(#10+#13)]);
  RSLPrint('procedure Download(RemoteFile, LocalFile: string) %s', [PChar(#10+#13)]);
  RSLPrint('procedure DownloadRestore(RemoteFile, LocalFile: string) %s', [PChar(#10+#13)]);
  RSLPrint('procedure List() %s', [PChar(#10+#13)]);
  RSLPrint('procedure MakeDir(DirectoryName: string) %s', [PChar(#10+#13)]);
  RSLPrint('procedure Mode(TheMode: Integer) %s', [PChar(#10+#13)]);
  RSLPrint('procedure NList() %s', [PChar(#10+#13)]);
  RSLPrint('procedure Reinitialize() %s', [PChar(#10+#13)]);
  RSLPrint('procedure RemoveDir(DirectoryName: string) %s', [PChar(#10+#13)]);
  RSLPrint('procedure Rename(Filename, FileName2: string) %s', [PChar(#10+#13)]);
  RSLPrint('procedure Upload(LocalFile, RemoteFile: string) %s', [PChar(#10+#13)]);
  RSLPrint('procedure UploadAppend(LocalFile, RemoteFile: string) %s', [PChar(#10+#13)]);
  RSLPrint('procedure UploadRestore(LocalFile, RemoteFile: string; Position: Integer) %s', [PChar(#10+#13)]);
  RSLPrint('procedure UploadUnique(LocalFile: string) %s', [PChar(#10+#13)]);
  RSLPrint('property UserName:STRING %s', [PChar(#10+#13)]);
  RSLPrint('property Password:STRING %s', [PChar(#10+#13)]);
  RSLPrint('property CurrentDir:STRING %s', [PChar(#10+#13)]);
  RSLPrint('-------------------------------------------%s',[PChar(#10+#13)]);
End;

procedure aeTFTP.RSLAllocate();
var
  v:PVALUE;
Begin
  RSLGetParm(1, @v);
  if (v.v_type<>V_INTEGER) Then RSLError('INTEGER',[]);
  Try
    TNMFTP(aeobj).Allocate(v.intval);
  Except
    RSLError('Allocate failed', []);
  End;
End;

procedure aeTFTP.RSLChangeDir();
var
  v:PVALUE;
Begin
  RSLGetParm(1, @v);
  if (v.v_type<>V_STRING) Then RSLError('STRING',[]);
  Try
    TNMFTP(aeobj).ChangeDir(String(v.RSLString));
  Except
    RSLError('ChangeDir failed', []);
  End;
End;

procedure aeTFTP.RSLDelete();
var
  v:PVALUE;
Begin
  RSLGetParm(1, @v);
  if (v.v_type<>V_STRING) Then RSLError('STRING',[]);
  Try
    TNMFTP(aeobj).Delete(String(v.RSLString));
  Except
    RSLError('Delete failed', []);
  End;
End;

procedure aeTFTP.RSLDoCommand();
var
  v:PVALUE;
Begin
  RSLGetParm(1, @v);
  if (v.v_type<>V_STRING) Then RSLError('STRING',[]);
  Try
    TNMFTP(aeobj).DoCommand(String(v.RSLString));
  Except
    RSLError('DoCommand failed', []);
  End;
End;

procedure aeTFTP.RSLDownload();
var
  v1, v2:PVALUE;
Begin
  RSLGetParm(1, @v1);
  RSLGetParm(2, @v2);
  if (v1.v_type<>V_STRING) Then RSLError('STRING',[]);
  if (v2.v_type<>V_STRING) Then RSLError('STRING',[]);
  Try
    TNMFTP(aeobj).Download(String(v1.RSLString), String(v2.RSLString));
  Except
    RSLError('Download failed', []);
  End;
End;

procedure aeTFTP.RSLDownloadRestore();
var
  v1, v2:PVALUE;
Begin
  RSLGetParm(1, @v1);
  RSLGetParm(2, @v2);
  if (v1.v_type<>V_STRING) Then RSLError('STRING',[]);
  if (v2.v_type<>V_STRING) Then RSLError('STRING',[]);
  Try
    TNMFTP(aeobj).DownloadRestore(String(v1.RSLString), String(v2.RSLString));
  Except
    RSLError('DownloadRestore failed', []);
  End;
End;

procedure aeTFTP.RSLList();
Begin
  Try
    TNMFTP(aeobj).List();
  Except
    RSLError('List failed', []);
  End;
End;

procedure aeTFTP.RSLMakeDir();
var
  v:PVALUE;
Begin
  RSLGetParm(1, @v);
  if (v.v_type<>V_STRING) Then RSLError('STRING',[]);
  Try
    TNMFTP(aeobj).MakeDirectory(String(v.RSLString));
  Except
    RSLError('MakeDir failed', []);
  End;
End;

procedure aeTFTP.RSLMode();
var
  v:PVALUE;
Begin
  RSLGetParm(1, @v);
  if (v.v_type<>V_INTEGER) Then RSLError('INTEGER',[]);
  Try
    Case (v.intval) of
      0:TNMFTP(aeobj).Mode(MODE_ASCII);
      1:TNMFTP(aeobj).Mode(MODE_IMAGE);
      2:TNMFTP(aeobj).Mode(MODE_BYTE);
    End;
  Except
    RSLError('Mode failed', []);
  End;
End;

procedure aeTFTP.RSLNList();
Begin
  Try
    TNMFTP(aeobj).NList();
  Except
    RSLError('NList failed', []);
  End;
End;

procedure aeTFTP.RSLReinitialize();
Begin
  Try
    TNMFTP(aeobj).Reinitialize();
  Except
    RSLError('Reinitialize failed', []);
  End;
End;

procedure aeTFTP.RSLRemoveDir();
var
  v:PVALUE;
Begin
  RSLGetParm(1, @v);
  if (v.v_type<>V_STRING) Then RSLError('STRING',[]);
  Try
    TNMFTP(aeobj).RemoveDir(String(v.RSLString));
  Except
    RSLError('RemoveDir failed', []);
  End;
End;

procedure aeTFTP.RSLRename();
var
  v1, v2:PVALUE;
Begin
  RSLGetParm(1, @v1);
  RSLGetParm(2, @v2);
  if (v1.v_type<>V_STRING) Then RSLError('STRING',[]);
  if (v2.v_type<>V_STRING) Then RSLError('STRING',[]);
  Try
    TNMFTP(aeobj).Rename(String(v1.RSLString), String(v2.RSLString));
  Except
    RSLError('Rename failed', []);
  End;
End;

procedure aeTFTP.RSLUpload();
var
  v1, v2:PVALUE;
Begin
  RSLGetParm(1, @v1);
  RSLGetParm(2, @v2);
  if (v1.v_type<>V_STRING) Then RSLError('STRING',[]);
  if (v2.v_type<>V_STRING) Then RSLError('STRING',[]);
  Try
    TNMFTP(aeobj).Upload(String(v1.RSLString), String(v2.RSLString));
  Except
    RSLError('Upload failed', []);
  End;
End;

procedure aeTFTP.RSLUploadAppend();
var
  v1, v2:PVALUE;
Begin
  RSLGetParm(1, @v1);
  RSLGetParm(2, @v2);
  if (v1.v_type<>V_STRING) Then RSLError('STRING',[]);
  if (v2.v_type<>V_STRING) Then RSLError('STRING',[]);
  Try
    TNMFTP(aeobj).UploadAppend(String(v1.RSLString), String(v2.RSLString));
  Except
    RSLError('UploadAppend failed', []);
  End;
End;

procedure aeTFTP.RSLUploadRestore();
var
  v1, v2, v3:PVALUE;
Begin
  RSLGetParm(1, @v1);
  RSLGetParm(2, @v2);
  if (v1.v_type<>V_STRING) Then RSLError('STRING',[]);
  if (v2.v_type<>V_STRING) Then RSLError('STRING',[]);
  if (v3.v_type<>V_INTEGER) Then RSLError('INTEGER',[]);
  Try
    TNMFTP(aeobj).UploadRestore(String(v1.RSLString), String(v2.RSLString), v3.intval);
  Except
    RSLError('UploadRestore failed', []);
  End;
End;

procedure aeTFTP.RSLUploadUnique();
var
  v:PVALUE;
Begin
  RSLGetParm(1, @v);
  if (v.v_type<>V_STRING) Then RSLError('STRING',[]);
  Try
    TNMFTP(aeobj).UploadUnique(String(v.RSLString));
  Except
    RSLError('UploadUnique failed', []);
  End;
End;

{*****************************************************************

                       СВОЙСТВА

******************************************************************}

procedure aeTFTP.set_UserName(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  TNMFTP(aeobj).UserID:=String(newVal.RSLString);
end;

procedure aeTFTP.get_UserName(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(TNMFTP(aeobj).UserID));
end;

procedure aeTFTP.set_Password(newVal:PVALUE);
begin
  if (newVal.v_type <> V_STRING) Then RSLError('String',[]);
  TNMFTP(aeobj).Password:=String(newVal.RSLString);
end;

procedure aeTFTP.get_Password(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(TNMFTP(aeobj).Password));
end;

procedure aeTFTP.get_CurrentDir(retVal:PVALUE);
begin
  RSLValueClear(retVal);
  RSLValueSet(retVal, V_STRING, PChar(TNMFTP(aeobj).CurrentDir));
end;

{*****************************************************************

******************************************************************}

function MakeaeTFTP():Pointer;
  var P:aePFTP;
begin
  P:=RSLiNewMemNULL(SizeOf(aeTFTP));
  If (P = NIL) Then RSLError('Недостаточно памяти для создания TaeTFTP', []);
  P.Create;
  Result:=P;
end;

procedure CreateaeTFTP();
  var obj:aePFTP;
begin
  obj:=MakeaeTFTP();
  obj.RSLInit(0);
  RSLReturnVal(V_GENOBJ, obj);
end;

Begin
  aeTFTPTypeTable.size:=SizeOf(IRslTypeInfo);
  aeTFTPTypeTable.isProp:=@aeTFTPisProp;
  aeTFTPTypeTable.getNProps:=@aeTFTPgetNProps;
  aeTFTPTypeTable.getNMethods:=@aeTFTPgetNMethods;
  aeTFTPTypeTable.canInherit:=@aeTFTPcanInherit;
  aeTFTPTypeTable.create:=NIL;
  aeTFTPTypeTable.typeName:=@aeTFTPTypeName;
  aePFTPTypeTable:=@aeTFTPTypeTable;
End.
