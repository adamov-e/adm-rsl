library aetools;
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
    rslbdate,
    btintf,
    rsltype,
    rslfs,
    rsldll;

var 
  dic:BDHANDLE;
  tbl:BTHANDLE;

procedure OpenTable(name:PChar; mode:Integer; key:Integer; filename:PChar);
begin
  tbl := RSLBtOpenTable (dic, name, mode, key, filename);
  If (tbl = NIL) Then RslError('Ошибка открытия таблицы!', []);
end;

procedure CloseTable();
begin
  RSLBtUnbindAll(tbl);
  RSLBtCloseTable(tbl);
end;

procedure aeAccountName(); cdecl;
  var v1, v2, v3:PVALUE;
      acc, name:PChar;
      cur, chap:SmallInt;
      numparm:Integer;
begin
  numparm:=RSLGetNumParm();
  if (numparm <> 3) Then RSLError('Неверное количество параметров = 3',[]);
  GetMem(acc, 26);
  GetMem(name, 121);
  RSLGetParm(0, @v1);
  RSLGetParm(1, @v2);
  RSLGetParm(2, @v3);
  if (v1.v_type <> V_STRING) Then RslError('aeAccountName(STR, INT, INT)', []);
  if (v2.v_type <> V_INTEGER) Then RslError('aeAccountName(STR, INT, INT)', []);
  if (v3.v_type <> V_INTEGER) Then RslError('aeAccountName(STR, INT, INT)', []);
  StrCopy(acc, v1.RSLString);
  cur:=v2.intval;
  chap:=v3.intval;
  Case Chap Of
    0..1:Case Cur Of
           0:Begin 
               OpenTable('account.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'nameaccount', name, FT_STRING, 121);
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_STRING, name);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('account$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'nameaccount', name, FT_STRING, 121);
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_STRING, name);
             CloseTable();
             Exit;
           End;
         End;
  Else   Case Cur Of
           0:Begin 
               OpenTable('obacnt.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
               RSLBtBindField(tbl, 'nameaccount', name, FT_STRING, 121);
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_STRING, name);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('obacnt$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
           RSLBtBindField(tbl, 'nameaccount', name, FT_STRING, 121);
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_STRING, name);
             CloseTable();
             Exit;
           End;
         End;
  End;
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
end;

procedure aeAccountKind(); cdecl;
  var v1, v2, v3:PVALUE;
      acc, ackind:PChar;
      cur, chap:SmallInt;
      numparm:Integer;
begin
  numparm:=RSLGetNumParm();
  if (numparm <> 3) Then RSLError('Неверное количество параметров = 3',[]);
  GetMem(acc, 26);
  GetMem(ackind, 3);
  RSLGetParm(0, @v1);
  RSLGetParm(1, @v2);
  RSLGetParm(2, @v3);
  if (v1.v_type <> V_STRING) Then RslError('aeAccountKind(STR, INT, INT)', []);
  if (v2.v_type <> V_INTEGER) Then RslError('aeAccountKind(STR, INT, INT)', []);
  if (v3.v_type <> V_INTEGER) Then RslError('aeAccountKind(STR, INT, INT)', []);
  StrCopy(acc, v1.RSLString);
  cur:=v2.intval;
  chap:=v3.intval;
  Case Chap Of
    0..1:Case Cur Of
           0:Begin 
               OpenTable('account.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'kind_account', ackind, FT_STRING, 3);
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_STRING, ackind);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('account$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'kind_account', ackind, FT_STRING, 3);
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_STRING, ackind);
             CloseTable();
             Exit;
           End;
         End;
  Else   Case Cur Of
           0:Begin 
               OpenTable('obacnt.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
               RSLBtBindField(tbl, 'kind_account', ackind, FT_STRING, 3);
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_STRING, ackind);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('obacnt$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
           RSLBtBindField(tbl, 'kind_account', ackind, FT_STRING, 3);
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_STRING, ackind);
             CloseTable();
             Exit;
           End;
         End;
  End;
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
end;


procedure aeAccountType(); cdecl;
  var v1, v2, v3:PVALUE;
      acc, actype:PChar;
      cur, chap:SmallInt;
      numparm:Integer;
begin
  GetMem(acc, 26);
  GetMem(actype, 17);
  numparm:=RSLGetNumParm();
  if (numparm <> 3) Then RSLError('Неверное количество параметров = 3',[]);
  RSLGetParm(0, @v1);
  RSLGetParm(1, @v2);
  RSLGetParm(2, @v3);
  if (v1.v_type <> V_STRING) Then RslError('aeAccountType(STR, INT, INT)', []);
  if (v2.v_type <> V_INTEGER) Then RslError('aeAccountType(STR, INT, INT)', []);
  if (v3.v_type <> V_INTEGER) Then RslError('aeAccountType(STR, INT, INT)', []);
  StrCopy(acc, v1.RSLString);
  cur:=v2.intval;
  chap:=v3.intval;
  Case Chap Of
    0..1:Case Cur Of
           0:Begin 
               OpenTable('account.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'type_account', actype, FT_STRING, 17);
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_STRING, actype);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('account$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'type_account', actype, FT_STRING, 17);
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_STRING, actype);
             CloseTable();
             Exit;
           End;
         End;
  Else   Case Cur Of
           0:Begin 
               OpenTable('obacnt.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
               RSLBtBindField(tbl, 'type_account', actype, FT_STRING, 17);
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_STRING, actype);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('obacnt$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
           RSLBtBindField(tbl, 'type_account', actype, FT_STRING, 17);
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_STRING, actype);
             CloseTable();
             Exit;
           End;
         End;
  End;
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
end;

procedure aeAccountOpen(); cdecl;
  var v1, v2, v3:PVALUE;
      acc, opcl:PChar;
      cur, chap:SmallInt;
      numparm:Integer;
begin
  GetMem(acc, 26);
  GetMem(opcl, 1);
  numparm:=RSLGetNumParm();
  if (numparm <> 3) Then RSLError('Неверное количество параметров = 3',[]);
  RSLGetParm(0, @v1);
  RSLGetParm(1, @v2);
  RSLGetParm(2, @v3);
  if (v1.v_type <> V_STRING) Then RslError('aeAccountOpen(STR, INT, INT)', []);
  if (v2.v_type <> V_INTEGER) Then RslError('aeAccountOpen(STR, INT, INT)', []);
  if (v3.v_type <> V_INTEGER) Then RslError('aeAccountOpen(STR, INT, INT)', []);
  StrCopy(acc, v1.RSLString);
  cur:=v2.intval;
  chap:=v3.intval;
  Case Chap Of
    0..1:Case Cur Of
           0:Begin 
               OpenTable('account.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'open_close', opcl, FT_STRING, 1);
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_STRING, opcl);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('account$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'open_close', opcl, FT_STRING, 1);
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_STRING, opcl);
             CloseTable();
             Exit;
           End;
         End;
  Else   Case Cur Of
           0:Begin 
               OpenTable('obacnt.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
               RSLBtBindField(tbl, 'open_close', opcl, FT_STRING, 1);
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_STRING, opcl);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('obacnt$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
           RSLBtBindField(tbl, 'open_close', opcl, FT_STRING, 1);
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_STRING, opcl);
             CloseTable();
             Exit;
           End;
         End;
  End;
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
end;

procedure aeAccountBalance(); cdecl;
  var v1, v2, v3:PVALUE;
      acc, bal:PChar;
      cur, chap:SmallInt;
      numparm:Integer;
begin
  GetMem(acc, 26);
  GetMem(bal, 13);
  numparm:=RSLGetNumParm();
  if (numparm <> 3) Then RSLError('Неверное количество параметров = 3',[]);
  RSLGetParm(0, @v1);
  RSLGetParm(1, @v2);
  RSLGetParm(2, @v3);
  if (v1.v_type <> V_STRING) Then RslError('aeAccountBalance(STR, INT, INT)', []);
  if (v2.v_type <> V_INTEGER) Then RslError('aeAccountBalance(STR, INT, INT)', []);
  if (v3.v_type <> V_INTEGER) Then RslError('aeAccountBalance(STR, INT, INT)', []);
  StrCopy(acc, v1.RSLString);
  cur:=v2.intval;
  chap:=v3.intval;
  Case Chap Of
    0..1:Case Cur Of
           0:Begin 
               OpenTable('account.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'balance', bal, FT_STRING, 13);
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_STRING, bal);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('account$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'balance', bal, FT_STRING, 13);
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_STRING, bal);
             CloseTable();
             Exit;
           End;
         End;
  Else   Case Cur Of
           0:Begin 
               OpenTable('obacnt.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
               RSLBtBindField(tbl, 'balance', bal, FT_STRING, 13);
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_STRING, bal);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('obacnt$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
           RSLBtBindField(tbl, 'balance', bal, FT_STRING, 13);
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_STRING, bal);
             CloseTable();
             Exit;
           End;
         End;
  End;
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
end;

procedure aeAccountClient(); cdecl;
  var v1, v2, v3:PVALUE;
      acc:PChar;
      cur, chap:SmallInt;
      client:LongInt;
      numparm:Integer;
begin
  GetMem(acc, 26);
  client:=0;
  numparm:=RSLGetNumParm();
  if (numparm <> 3) Then RSLError('Неверное количество параметров = 3',[]);
  RSLGetParm(0, @v1);
  RSLGetParm(1, @v2);
  RSLGetParm(2, @v3);
  if (v1.v_type <> V_STRING) Then RslError('aeAccountClient(STR, INT, INT)', []);
  if (v2.v_type <> V_INTEGER) Then RslError('aeAccountClient(STR, INT, INT)', []);
  if (v3.v_type <> V_INTEGER) Then RslError('aeAccountClient(STR, INT, INT)', []);
  StrCopy(acc, v1.RSLString);
  cur:=v2.intval;
  chap:=v3.intval;
  Case Chap Of
    0..1:Case Cur Of
           0:Begin 
               OpenTable('account.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'client', @client, FT_LONG, 4);
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_INTEGER, @client);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('account$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'client', @client, FT_LONG, 4);
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_INTEGER, @client);
             CloseTable();
             Exit;
           End;
         End;
  Else   Case Cur Of
           0:Begin 
               OpenTable('obacnt.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
               RSLBtBindField(tbl, 'client', @client, FT_LONG, 4);
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_INTEGER, @client);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('obacnt$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
           RSLBtBindField(tbl, 'client', @client, FT_LONG, 4);
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_INTEGER, @client);
             CloseTable();
             Exit;
           End;
         End;
  End;
  client:=0;
  RSLReturnVal(V_INTEGER, @client);
  CloseTable();
end;

procedure aeAccountDepartment(); cdecl;
  var v1, v2, v3:PVALUE;
      acc:PChar;
      cur, chap:SmallInt;
      numparm, dep:Integer;
begin
  GetMem(acc, 26);
  dep:=0;
  numparm:=RSLGetNumParm();
  if (numparm <> 3) Then RSLError('Неверное количество параметров = 3',[]);
  RSLGetParm(0, @v1);
  RSLGetParm(1, @v2);
  RSLGetParm(2, @v3);
  if (v1.v_type <> V_STRING) Then RslError('aeAccountDepartment(STR, INT, INT)', []);
  if (v2.v_type <> V_INTEGER) Then RslError('aeAccountDepartment(STR, INT, INT)', []);
  if (v3.v_type <> V_INTEGER) Then RslError('aeAccountDepartment(STR, INT, INT)', []);
  StrCopy(acc, v1.RSLString);
  cur:=v2.intval;
  chap:=v3.intval;
  Case Chap Of
    0..1:Case Cur Of
           0:Begin 
               OpenTable('account.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'department', @dep, FT_INT, 2);
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_INTEGER, @dep);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('account$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'department', @dep, FT_INT, 2);
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_INTEGER, @dep);
             CloseTable();
             Exit;
           End;
         End;
  Else   Case Cur Of
           0:Begin 
               OpenTable('obacnt.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
               RSLBtBindField(tbl, 'department', @dep, FT_INT, 2);
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_INTEGER, @dep);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('obacnt$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
           RSLBtBindField(tbl, 'deperment', @dep, FT_INT, 2);
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_INTEGER, @dep);
             CloseTable();
             Exit;
           End;
         End;
  End;
  dep:=0;
  RSLReturnVal(V_INTEGER, @dep);
  CloseTable();
end;

procedure aeAccountOper(); cdecl;
  var v1, v2, v3:PVALUE;
      acc:PChar;
      cur, chap:SmallInt;
      numparm, oper:LongInt;
begin
  GetMem(acc, 26);
  oper:=0;
  numparm:=RSLGetNumParm();
  if (numparm <> 3) Then RSLError('Неверное количество параметров = 3',[]);
  RSLGetParm(0, @v1);
  RSLGetParm(1, @v2);
  RSLGetParm(2, @v3);
  if (v1.v_type <> V_STRING) Then RslError('aeAccountOper(STR, INT, INT)', []);
  if (v2.v_type <> V_INTEGER) Then RslError('aeAccountOper(STR, INT, INT)', []);
  if (v3.v_type <> V_INTEGER) Then RslError('aeAccountOper(STR, INT, INT)', []);
  StrCopy(acc, v1.RSLString);
  cur:=v2.intval;
  chap:=v3.intval;
  Case Chap Of
    0..1:Case Cur Of
           0:Begin 
               OpenTable('account.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'oper', @oper, FT_INT, 2);
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_INTEGER, @oper);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('account$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'oper', @oper, FT_INT, 2);
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_INTEGER, @oper);
             CloseTable();
             Exit;
           End;
         End;
  Else   Case Cur Of
           0:Begin 
               OpenTable('obacnt.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
               RSLBtBindField(tbl, 'oper', @oper, FT_INT, 2);
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_INTEGER, @oper);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('obacnt$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
           RSLBtBindField(tbl, 'oper', @oper, FT_INT, 2);
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_INTEGER, @oper);
             CloseTable();
             Exit;
           End;
         End;
  End;
  oper:=0;
  RSLReturnVal(V_INTEGER, @oper);
  CloseTable();
end;

procedure aeAccountOpenDate(); cdecl;
  var v1, v2, v3:PVALUE;
      acc:PChar;
      dt:TRSLDate;
      cur, chap:SmallInt;
      numparm:Integer;
begin
  GetMem(acc, 26);
  dt.Year:=0;
  dt.Month:=0;
  dt.Day:=0;
  numparm:=RSLGetNumParm();
  if (numparm <> 3) Then RSLError('Неверное количество параметров = 3',[]);
  RSLGetParm(0, @v1);
  RSLGetParm(1, @v2);
  RSLGetParm(2, @v3);
  if (v1.v_type <> V_STRING) Then RslError('aeAccountOpenDate(STR, INT, INT)', []);
  if (v2.v_type <> V_INTEGER) Then RslError('aeAccountOpenDate(STR, INT, INT)', []);
  if (v3.v_type <> V_INTEGER) Then RslError('aeAccountOpenDate(STR, INT, INT)', []);
  StrCopy(acc, v1.RSLString);
  cur:=v2.intval;
  chap:=v3.intval;
  Case Chap Of
    0..1:Case Cur Of
           0:Begin 
               OpenTable('account.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'open_date', @dt, FT_DATE, SizeOf(TRSLDate));
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_DATE, @dt);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('account$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'open_date', @dt, FT_DATE, SizeOf(TRSLDate));
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_DATE, @dt);
             CloseTable();
             Exit;
           End;
         End;
  Else   Case Cur Of
           0:Begin 
               OpenTable('obacnt.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
               RSLBtBindField(tbl, 'open_date', @dt, FT_DATE, SizeOf(TRSLDate));
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_DATE, @dt);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('obacnt$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
           RSLBtBindField(tbl, 'open_date', @dt, FT_DATE, SizeOf(TRSLDate));
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_DATE, @dt);
             CloseTable();
             Exit;
           End;
         End;
  End;
  dt.Year:=0;
  dt.Month:=0;
  dt.Day:=0;
  RSLReturnVal(V_DATE, @dt);
  CloseTable();
end;

procedure aeAccountCloseDate(); cdecl;
  var v1, v2, v3:PVALUE;
      acc:PChar;
      dt:TRSLDate;
      cur, chap:SmallInt;
      numparm:Integer;
begin
  GetMem(acc, 26);
  dt.Year:=0;
  dt.Month:=0;
  dt.Day:=0;
  numparm:=RSLGetNumParm();
  if (numparm <> 3) Then RSLError('Неверное количество параметров = 3',[]);
  RSLGetParm(0, @v1);
  RSLGetParm(1, @v2);
  RSLGetParm(2, @v3);
  if (v1.v_type <> V_STRING) Then RslError('aeAccountCloseDate(STR, INT, INT)', []);
  if (v2.v_type <> V_INTEGER) Then RslError('aeAccountCloseDate(STR, INT, INT)', []);
  if (v3.v_type <> V_INTEGER) Then RslError('aeAccountCloseDate(STR, INT, INT)', []);
  StrCopy(acc, v1.RSLString);
  cur:=v2.intval;
  chap:=v3.intval;
  Case Chap Of
    0..1:Case Cur Of
           0:Begin 
               OpenTable('account.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'close_date', @dt, FT_DATE, SizeOf(TRSLDate));
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_DATE, @dt);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('account$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'close_date', @dt, FT_DATE, SizeOf(TRSLDate));
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_DATE, @dt);
             CloseTable();
             Exit;
           End;
         End;
  Else   Case Cur Of
           0:Begin 
               OpenTable('obacnt.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt.dbt');
               RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
               RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
               RSLBtBindField(tbl, 'close_date', @dt, FT_DATE, SizeOf(TRSLDate));
               if (RSLBtGetEQ(tbl) = 0) Then Begin
                 RSLReturnVal(V_DATE, @dt);
                 CloseTable();
                 Exit;
               End;
             End;
         Else
           OpenTable('obacnt$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt$.dbt');
           RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
           RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
           RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
           RSLBtBindField(tbl, 'close_date', @dt, FT_DATE, SizeOf(TRSLDate));
           if (RSLBtGetEQ(tbl) = 0) Then Begin
             RSLReturnVal(V_DATE, @dt);
             CloseTable();
             Exit;
           End;
         End;
  End;
  dt.Year:=0;
  dt.Month:=0;
  dt.Day:=0;
  RSLReturnVal(V_DATE, @dt);
  CloseTable();
end;

procedure aeAccountCurrency(); cdecl;
  var v1, v2:PVALUE;
      acc:PChar;
      chap:SmallInt;
      numparm, cur:Integer;
begin
  GetMem(acc, 26);
  cur:=0;
  numparm:=RSLGetNumParm();
  if (numparm <> 2) Then RSLError('aeAccountCurrency(STR, INT)',[]);
  RSLGetParm(0, @v1);
  RSLGetParm(1, @v2);
  if (v1.v_type <> V_STRING) Then RslError('aeAccountCurrency(STR, INT)', []);
  if (v2.v_type <> V_INTEGER) Then RslError('aeAccountCurrency(STR, INT)', []);
  StrCopy(acc, v1.RSLString);
  chap:=v2.intval;
  Case chap Of
    0..1:Begin 
        OpenTable('account$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\account$.dbt');
        RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
        RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
        RSLBtGetGE(tbl);
        if (StrIComp(acc, v1.RSLString) = 0) Then Begin
          RSLReturnVal(V_INTEGER, @cur);
          CloseTable();
          Exit;
        End;
      End;
    Else
        OpenTable('obacnt$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obacnt$.dbt');
        RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
        RSLBtBindField(tbl, 'account', acc, FT_STRING, 26);
        RSLBtBindField(tbl, 'code_currency', @cur, FT_INT, 2);
        RSLBtGetGE(tbl);
        if (StrIComp(acc, v1.RSLString) = 0) Then Begin
          RSLReturnVal(V_INTEGER, @cur);
          CloseTable();
          Exit;
        End;
  End;
  cur:=0;
  RSLReturnVal(V_INTEGER, @cur);
  CloseTable();
end;

{*******************************************************

********************************************************}
Procedure aeClientName() cdecl;
  Var v:PVALUE;
      client:LongInt;
      name:PChar;
      numparm:Integer;
Begin
  GetMem(name, 161);
  numparm:=RSLGetNumParm();
  if (numparm <> 1) Then RSLError('Неверное кол-во параметров!', []);
  RSLGetParm(0, @v);
  client:=v.intval;
  OpenTable('client.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\client.dbt');
  RSLBtBindField(tbl, 'client', @client, FT_LONG, 4);
  RSLBtBindField(tbl, 'name_client', name, FT_STRING, 161);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_STRING, name); 
    CloseTable();  
    Exit; 
  End; 
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;

Procedure aeClientShortName() cdecl;
  Var v:PVALUE;
      client:LongInt;
      name:PChar;
      numparm:Integer;
Begin
  GetMem(name, 21);
  numparm:=RSLGetNumParm();
  if (numparm <> 1) Then RSLError('Неверное кол-во параметров!', []);
  RSLGetParm(0, @v);
  client:=v.intval;
  OpenTable('client.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\client.dbt');
  RSLBtBindField(tbl, 'client', @client, FT_LONG, 4);
  RSLBtBindField(tbl, 'szshortname', name, FT_STRING, 21);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_STRING, name); 
    CloseTable();
    Exit;  
  End; 
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;

Procedure aeClientINN() cdecl;
  Var v:PVALUE;
      client:LongInt;
      inn:PChar;
      numparm:Integer;
Begin
  GetMem(inn, 16);
  numparm:=RSLGetNumParm();
  if (numparm <> 1) Then RSLError('Неверное кол-во параметров!', []);
  RSLGetParm(0, @v);
  client:=v.intval;
  OpenTable('client.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\client.dbt');
  RSLBtBindField(tbl, 'client', @client, FT_LONG, 4);
  RSLBtBindField(tbl, 'inn', inn, FT_STRING, 16);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_STRING, inn);  
    CloseTable();
    Exit; 
  End; 
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;

Procedure aeClientCarryOper() cdecl;
  Var v:PVALUE;
      client, oper:LongInt;
      numparm:Integer;
Begin
  oper:=0;
  numparm:=RSLGetNumParm();
  if (numparm <> 1) Then RSLError('Неверное кол-во параметров!', []);
  RSLGetParm(0, @v);
  client:=v.intval;
  OpenTable('client.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\client.dbt');
  RSLBtBindField(tbl, 'client', @client, FT_LONG, 4);
  RSLBtBindField(tbl, 'iCarryOper', @oper, FT_INT, 2);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_INTEGER, @oper);
    CloseTable();
    Exit;
  End;
  oper:=0;
  RSLReturnVal(V_INTEGER, @oper);
  CloseTable();
End;

Procedure aeClientCreditOper() cdecl;
  Var v:PVALUE;
      client, oper:LongInt;
      numparm:Integer;
Begin
  oper:=0;
  numparm:=RSLGetNumParm();
  if (numparm <> 1) Then RSLError('Неверное кол-во параметров!', []);
  RSLGetParm(0, @v);
  client:=v.intval;
  OpenTable('client.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\client.dbt');
  RSLBtBindField(tbl, 'client', @client, FT_LONG, 4);
  RSLBtBindField(tbl, 'iCreditOper', @oper, FT_INT, 2);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_INTEGER, @oper);
    CloseTable();
    Exit;
  End;
  oper:=0;
  RSLReturnVal(V_INTEGER, @oper);
  CloseTable();
End;

Procedure aeClientGroup() cdecl;
  Var v:PVALUE;
      client:LongInt;
      group:Integer;
Begin
  group:=0;
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б. INTEGER!', []);
  client:=v.intval;
  OpenTable('client.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\client.dbt');
  RSLBtBindField(tbl, 'client', @client, FT_LONG, 4);
  RSLBtBindField(tbl, 'iGroup', @group, FT_INT, 2);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_INTEGER, @group);
    CloseTable();
    Exit;
  End;
  group:=0;
  RSLReturnVal(V_INTEGER, @group);
  CloseTable();
End;

Procedure aeClientPropertyKind() cdecl;
  Var v:PVALUE;
      client:LongInt;
      p_kind:Integer;
Begin
  p_kind:=0;
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б. INTEGER!', []);
  client:=v.intval;
  OpenTable('client.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\client.dbt');
  RSLBtBindField(tbl, 'client', @client, FT_LONG, 4);
  RSLBtBindField(tbl, 'iPropertyKind', @p_kind, FT_INT, 2);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_INTEGER, @p_kind);
    CloseTable();
    Exit;
  End;
  p_kind:=0;
  RSLReturnVal(V_INTEGER, @p_kind);
  CloseTable();
End;

Procedure aeClientOrgForm() cdecl;
  Var v:PVALUE;
      client:LongInt;
      o_form:Integer;
Begin
  o_form:=0;
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б. INTEGER!', []);
  client:=v.intval;
  OpenTable('client.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\client.dbt');
  RSLBtBindField(tbl, 'client', @client, FT_LONG, 4);
  RSLBtBindField(tbl, 'iOrgForm', @o_form, FT_INT, 2);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_INTEGER, @o_form);
    CloseTable();
    Exit;
  End;
  o_form:=0;
  RSLReturnVal(V_INTEGER, @o_form);
  CloseTable();
End;

Procedure aeClientActivitiesSphere() cdecl;
  Var v:PVALUE;
      client:LongInt;
      a_sphere:Integer;
Begin
  a_sphere:=0;
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б. INTEGER!', []);
  client:=v.intval;
  OpenTable('client.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\client.dbt');
  RSLBtBindField(tbl, 'client', @client, FT_LONG, 4);
  RSLBtBindField(tbl, 'iActivitiesSphere', @a_sphere, FT_INT, 2);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_INTEGER, @a_sphere);
    CloseTable();
    Exit;
  End;
  a_sphere:=0;
  RSLReturnVal(V_INTEGER, @a_sphere);
  CloseTable();
End;

Procedure aeClientOKPO() cdecl;
  Var v:PVALUE;
      client:LongInt;
      okpo:PChar;
      numparm:Integer;
Begin
  GetMem(okpo, 16);
  numparm:=RSLGetNumParm();
  if (numparm <> 1) Then RSLError('Неверное кол-во параметров!', []);
  RSLGetParm(0, @v);
  client:=v.intval;
  OpenTable('client.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\client.dbt');
  RSLBtBindField(tbl, 'client', @client, FT_LONG, 4);
  RSLBtBindField(tbl, 'szOKPO', okpo, FT_STRING, 16);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_STRING, okpo);  
    CloseTable();
    Exit; 
  End; 
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;

Procedure aeClientCodes() cdecl;
  Var v:PVALUE;
      client:LongInt;
      group:Integer;
      rez:PChar;
      res:String;
Begin
  group:=0;
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б. INTEGER!', []);
  client:=v.intval;
  OpenTable('client.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\client.dbt');
  RSLBtBindField(tbl, 'client', @client, FT_LONG, 4);
  RSLBtBindField(tbl, 'iGroup', @group, FT_INT, 2);
  RSLBtBindField(tbl, 'NotResident', rez, FT_STRING, SizeOf(Char));
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    if (rez = 'X') Then res:='2' Else res:='1';
    res:=res+IntToStr(group);
    RSLReturnVal(V_STRING, PChar(res)); 
    CloseTable();
    Exit;
  End; 
  RSLReturnVal(V_STRING, PChar('')); 
  CloseTable();
End;

Procedure aeClientStartDate() cdecl;
  Var v:PVALUE;
      client:LongInt;
      dtval:TRSLDate;
Begin
  dtval.year:=0;
  dtval.month:=0;
  dtval.day:=0;
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('aeClientStartDate', []);
  client:=v.intval;
  OpenTable('client.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\client.dbt');
  RSLBtBindField(tbl, 'client', @client, FT_LONG, 4);
  RSLBtBindField(tbl, 'bdStartDate', @dtval, FT_DATE, 4);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_DATE, @dtval); 
    CloseTable();
    Exit;
  End; 
  dtval.year:=0;
  dtval.month:=0;
  dtval.day:=0;
  RSLReturnVal(V_DATE, @dtval); 
  CloseTable();
End;

Procedure aeClientFinishDate() cdecl;
  Var v:PVALUE;
      client:LongInt;
      dtval:TRSLDate;
Begin
  dtval.year:=0;
  dtval.month:=0;
  dtval.day:=0;
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('aeClientStartDate', []);
  client:=v.intval;
  OpenTable('client.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\client.dbt');
  RSLBtBindField(tbl, 'client', @client, FT_LONG, 4);
  RSLBtBindField(tbl, 'bdFinishDate', @dtval, FT_DATE, 4);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_DATE, @dtval); 
    CloseTable();
    Exit;
  End; 
  dtval.year:=0;
  dtval.month:=0;
  dtval.day:=0;
  RSLReturnVal(V_DATE, @dtval); 
  CloseTable();
End;

{*******************************************************

********************************************************}
Procedure aeOperName() cdecl;
  Var v:PVALUE;
      oper:SmallInt;
      name:PChar;
Begin
  GetMem(name, 36);
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  oper:=v.intval;
  OpenTable('person.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\person.dbt');
  RSLBtBindField(tbl, 'oper', @oper, FT_INT, 2);
  RSLBtBindField(tbl, 'name', name, FT_STRING, 36);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_STRING, name); 
    CloseTable();
    Exit; 
  End; 
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;

Procedure aeOperDepartment() cdecl;
  Var v:PVALUE;
      oper, dep:SmallInt;
Begin
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  oper:=v.intval;
  OpenTable('person.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\person.dbt');
  RSLBtBindField(tbl, 'oper', @oper, FT_INT, 2);
  RSLBtBindField(tbl, 'CodeDepart', @dep, FT_INT, 2);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_INTEGER, @dep); 
    CloseTable();
    Exit; 
  End; 
  dep:=0;
  RSLReturnVal(V_INTEGER, @dep);
  CloseTable();
End;

Procedure aeOperType() cdecl;
  Var v:PVALUE;
      oper:SmallInt;
      ctype:PChar;
Begin
  GetMem(ctype, 1);
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  oper:=v.intval;
  OpenTable('person.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\person.dbt');
  RSLBtBindField(tbl, 'oper', @oper, FT_INT, 2);
  RSLBtBindField(tbl, 'cTypePerson', ctype, FT_STRING, 1);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_STRING, ctype); 
    CloseTable();
    Exit; 
  End; 
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;

Procedure aeOperGroupO() cdecl;
  Var v1, v2:PVALUE;
      oper1, oper2, op1, op2:SmallInt;
      ret:Boolean;
Begin
  ret:=FALSE;
  RSLGetParm(0, @v1);
  RSLGetParm(0, @v2);
  if (v1.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  if (v2.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  oper1:=v1.intval;
  oper2:=v2.intval;
  OpenTable('person.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\person.dbt');
  RSLBtBindField(tbl, 'oper', @oper1, FT_INT, 2);
  RSLBtBindField(tbl, 'GroupOperFO', @op1, FT_INT, 2);
  RSLBtBindField(tbl, 'GroupOperLO', @op2, FT_INT, 2);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    if ((oper2 >= op1) or (oper2 <=op2)) Then ret:=TRUE;
    RSLReturnVal(V_BOOL, @ret);
    CloseTable();
    Exit; 
  End; 
  RSLReturnVal(V_BOOL, @ret);
  CloseTable();
End;

Procedure aeOperGroupC() cdecl;
  Var v1, v2:PVALUE;
      oper1, oper2, op1, op2:SmallInt;
      ret:Boolean;
Begin
  ret:=FALSE;
  RSLGetParm(0, @v1);
  RSLGetParm(0, @v2);
  if (v1.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  if (v2.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  oper1:=v1.intval;
  oper2:=v2.intval;
  OpenTable('person.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\person.dbt');
  RSLBtBindField(tbl, 'oper', @oper1, FT_INT, 2);
  RSLBtBindField(tbl, 'GroupOperFC', @op1, FT_INT, 2);
  RSLBtBindField(tbl, 'GroupOperLC', @op2, FT_INT, 2);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    if ((oper2 >= op1) or (oper2 <=op2)) Then ret:=TRUE;
    RSLReturnVal(V_BOOL, @ret);
    CloseTable();
    Exit; 
  End; 
  RSLReturnVal(V_BOOL, @ret);
  CloseTable();
End;

{*******************************************************

********************************************************}

Procedure aeDepartmentName() cdecl;
  Var v:PVALUE;
      dep:ShortInt;
      name:PChar;
Begin
  GetMem(name, 13);
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  dep:=v.intval;
  OpenTable('dp_dep.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\dp_dep.dbt');
  RSLBtBindField(tbl, 'code', @dep, FT_INT, 2);
  RSLBtBindField(tbl, 'name', name, FT_STRING, 13);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_STRING, name); 
    CloseTable();
    Exit; 
  End; 
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;

Procedure aeDepartmentComment() cdecl;
  Var v:PVALUE;
      dep:LongInt;
      comment:PChar;
Begin
  GetMem(comment, 60);
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  dep:=v.intval;
  OpenTable('dp_dep.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\dp_dep.dbt');
  RSLBtBindField(tbl, 'code', @dep, FT_INT, 2);
  RSLBtBindField(tbl, 'comment', comment, FT_STRING, 60);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_STRING, comment); 
    CloseTable();
    Exit; 
  End; 
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;

Procedure aeDepartmentBIC() cdecl;
  Var v:PVALUE;
      dep:LongInt;
      bic:PChar;
Begin
  GetMem(bic, 41);
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  dep:=v.intval;
  OpenTable('dp_dep.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\dp_dep.dbt');
  RSLBtBindField(tbl, 'code', @dep, FT_INT, 2);
  RSLBtBindField(tbl, 'userfield2', bic, FT_STRING, 41);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_STRING, bic); 
    CloseTable();
    Exit; 
  End; 
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;

Procedure aeDepartmentRNN() cdecl;
  Var v:PVALUE;
      dep:LongInt;
      rnn:PChar;
Begin
  GetMem(rnn, 81);
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  dep:=v.intval;
  OpenTable('dp_dep.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\dp_dep.dbt');
  RSLBtBindField(tbl, 'code', @dep, FT_INT, 2);
  RSLBtBindField(tbl, 'userfield3', rnn, FT_STRING, 81);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_STRING, rnn); 
    CloseTable();
    Exit; 
  End; 
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;

Procedure aeDepartmentStatus() cdecl;
  Var v:PVALUE;
      dep:LongInt;
      status:LongInt;
Begin
  status:=0;
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  dep:=v.intval;
  OpenTable('dp_dep.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\dp_dep.dbt');
  RSLBtBindField(tbl, 'code', @dep, FT_INT, 2);
  RSLBtBindField(tbl, 'status', @status, FT_INT, 2);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_INTEGER, @status); 
    CloseTable();
    Exit; 
  End; 
  status:=0;
  RSLReturnVal(V_INTEGER, @status);
  CloseTable();
End;


{*****************************************************************

******************************************************************}

Procedure aeBankName() cdecl;
  Var v:PVALUE;
      mfo:PChar;
      name:PChar;
      cor:PChar;
Begin
  GetMem(mfo, 10);
  GetMem(cor, 26);
  GetMem(name, 81);
  StrCopy(name, '');
  StrCopy(cor, '');
  RSLGetParm(0, @v);
  if (v.v_type <> V_STRING) Then RSLError('Параметр д.б.:STRING!', []);
  StrCopy(mfo, v.RSLString);
  OpenTable('bankdprt.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\bankdprt.dbt');
  RSLBtBindField(tbl, 'mfo_depart', mfo, FT_STRING, 10);
  RSLBtBindField(tbl, 'corr_acc', cor, FT_STRING, 26);
  RSLBtBindField(tbl, 'name_depart', name, FT_STRING, 81);
  RSLBtGetGE(tbl);
  If (StrIComp(mfo, v.RSLString) = 0) Then Begin 
    RSLReturnVal(V_STRING, name); 
    CloseTable();
    Exit; 
  End; 
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;

{*****************************************************************

******************************************************************}

Procedure aeChapterName() cdecl;
  Var v:PVALUE;
      chap:LongInt;
      name:PChar;
Begin
  GetMem(name, 50);
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  chap:=v.intval;
  OpenTable('obchaptr.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obchaptr.dbt');
  RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
  RSLBtBindField(tbl, 'name', name, FT_STRING, 50);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_STRING, name); 
    CloseTable();
    Exit; 
  End; 
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;

Procedure aeChapterShortName() cdecl;
  Var v:PVALUE;
      chap:LongInt;
      name:PChar;
Begin
  GetMem(name, 12);
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  chap:=v.intval;
  OpenTable('obchaptr.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obchaptr.dbt');
  RSLBtBindField(tbl, 'chapter', @chap, FT_INT, 2);
  RSLBtBindField(tbl, 'shortname', name, FT_STRING, 12);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_STRING, name); 
    CloseTable();
    Exit; 
  End; 
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;

{*****************************************************************

******************************************************************}
Procedure aeBalanceName() cdecl;
  Var v1, v2, v3, v4:PVALUE;
      nplan, chap, cur:SmallInt;
      bal:PChar;
      name:PChar;
      numparm:Integer;
Begin
  numparm:=RSLGetNumParm();
  if (numparm <> 4) Then RSLError('Неверное количество параметров = 4',[]);
  GetMem(bal, 13);
  GetMem(name, 181);
  RSLGetParm(0, @v1);
  RSLGetParm(1, @v2);
  RSLGetParm(2, @v3);
  RSLGetParm(3, @v4);
  if (v1.v_type <> V_INTEGER) Then RSLError('aeBalanceName(INT, STR, INT, INT)', []);
  if (v2.v_type <> V_STRING) Then RSLError('aeBalanceName(INT, STR, INT, INT)', []);
  if (v3.v_type <> V_INTEGER) Then RSLError('aeBalanceName(INT, STR, INT, INT)', []);
  if (v4.v_type <> V_INTEGER) Then RSLError('aeBalanceName(INT, STR, INT, INT)', []);
  nplan:=v1.intval;
  StrCopy(bal, v2.RSLString);
  cur:=v3.intval;
  chap:=v4.intval;
  Case chap Of
    0..1:Begin
           Case cur Of
             0:Begin
                 OpenTable('balance.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\balance.dbt');
                 RSLBtBindField(tbl, 'iNumPlan', @nplan, FT_INT, 2);
                 RSLBtBindField(tbl, 'Balance', bal, FT_STRING, 13);
                 RSLBtBindField(tbl, 'Name_Part', name, FT_STRING, 181);
                 If (RSLBtGetEQ(tbl) = 0) Then Begin 
                   RSLReturnVal(V_STRING, name);
                   CloseTable();
                   Exit; 
                 End; 
               End;
           Else
             OpenTable('balance$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\balance$.dbt');
             RSLBtBindField(tbl, 'iNumPlan', @nplan, FT_INT, 2);
             RSLBtBindField(tbl, 'Balance', bal, FT_STRING, 13);
             RSLBtBindField(tbl, 'Name_Part', name, FT_STRING, 181);
             If (RSLBtGetEQ(tbl) = 0) Then Begin 
               RSLReturnVal(V_STRING, name);
               CloseTable();
               Exit; 
             End; 
           End;
         End;
  Else
    Case cur Of
      0:Begin
          OpenTable('obalanc.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obalanc.dbt');
          RSLBtBindField(tbl, 'Chapter', @chap, FT_INT, 2);
          RSLBtBindField(tbl, 'iNumPlan', @nplan, FT_INT, 2);
          RSLBtBindField(tbl, 'Balance', bal, FT_STRING, 13);
          RSLBtBindField(tbl, 'Name_Part', name, FT_STRING, 181);
          If (RSLBtGetEQ(tbl) = 0) Then Begin 
            RSLReturnVal(V_STRING, name);
            CloseTable();
            Exit; 
          End; 
        End;
    Else
      OpenTable('obalanc$.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\obalanc$.dbt');
      RSLBtBindField(tbl, 'Chapter', @chap, FT_INT, 2);
      RSLBtBindField(tbl, 'iNumPlan', @nplan, FT_INT, 2);
      RSLBtBindField(tbl, 'Balance', bal, FT_STRING, 13);
      RSLBtBindField(tbl, 'Name_Part', name, FT_STRING, 181);
      If (RSLBtGetEQ(tbl) = 0) Then Begin 
        RSLReturnVal(V_STRING, name);
        CloseTable();
        Exit; 
      End; 
    End;
  End;
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;

{*****************************************************************

******************************************************************}

Procedure aeCurrencyName() cdecl;
  Var v:PVALUE;
      code:SmallInt;
      name:PChar;
Begin
  GetMem(name, 26);
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  code:=v.intval;
  OpenTable('currency.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\currency.dbt');
  RSLBtBindField(tbl, 'code_currency', @code, FT_INT, 2);
  RSLBtBindField(tbl, 'name_currency', name, FT_STRING, 26);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_STRING, name); 
    CloseTable();
    Exit; 
  End; 
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;

Procedure aeCurrencyShortName() cdecl;
  Var v:PVALUE;
      code:SmallInt;
      name:PChar;
Begin
  GetMem(name, 4);
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  code:=v.intval;
  OpenTable('currency.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\currency.dbt');
  RSLBtBindField(tbl, 'code_currency', @code, FT_INT, 2);
  RSLBtBindField(tbl, 'short_name', name, FT_STRING, 4);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_STRING, name); 
    CloseTable();
    Exit; 
  End; 
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;

Procedure aeISOCur() cdecl;
  Var v:PVALUE;
      code, name:PChar;
Begin
  GetMem(name, 4);
  GetMem(code, 4);
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  code:=PChar(IntToStr(v.intval));
  OpenTable('isocur.dbt', BT_OPEN_READONLY, 1, '..\\dbfile\\isocur.dbt');
  RSLBtBindField(tbl, 'NumberCode', code, FT_STRING, 4);
  RSLBtBindField(tbl, 'ISOCode', name, FT_STRING, 4);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_STRING, name); 
    CloseTable();
    Exit; 
  End; 
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;

Procedure aeCurrencyISOCode() cdecl;
  Var v:PVALUE;
      code, name:PChar;
Begin
  GetMem(name, 4);
  GetMem(code, 4);
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  code:=PChar(IntToStr(v.intval));
  OpenTable('isocur.dbt', BT_OPEN_READONLY, 1, '..\\dbfile\\isocur.dbt');
  RSLBtBindField(tbl, 'NumberCode', code, FT_STRING, 4);
  RSLBtBindField(tbl, 'ISOCode', name, FT_STRING, 4);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_STRING, name); 
    CloseTable();
    Exit; 
  End; 
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;

{*****************************************************************

******************************************************************}

Procedure aeResCarryName() cdecl;
  Var v:PVALUE;
      code:SmallInt;
      name:PChar;
Begin
  GetMem(name, 43);
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  code:=v.intval;
  OpenTable('rescarry.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\rescarry.dbt');
  RSLBtBindField(tbl, 'Result_Carry', @code, FT_INT, 2);
  RSLBtBindField(tbl, 'Name', name, FT_STRING, 43);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_STRING, name); 
    CloseTable();
    Exit; 
  End; 
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;

Procedure aeResCarryShortName() cdecl;
  Var v:PVALUE;
      code:SmallInt;
      name:PChar;
Begin
  GetMem(name, 21);
  RSLGetParm(0, @v);
  if (v.v_type <> V_INTEGER) Then RSLError('Параметр д.б.:INTEGER!', []);
  code:=v.intval;
  OpenTable('rescarry.dbt', BT_OPEN_READONLY, 0, '..\\dbfile\\rescarry.dbt');
  RSLBtBindField(tbl, 'Result_Carry', @code, FT_INT, 2);
  RSLBtBindField(tbl, 'Short_Name', name, FT_STRING, 21);
  If (RSLBtGetEQ(tbl) = 0) Then Begin 
    RSLReturnVal(V_STRING, name); 
    CloseTable();
    Exit; 
  End; 
  RSLReturnVal(V_STRING, PChar(''));
  CloseTable();
End;


{*****************************************************************

******************************************************************}

procedure InitExec; stdcall;
begin
  dic := RSLBtOpenDataBase(RSLGetStdDataBase (), RSLGetStdDataPath (), 'ser00000', 1);
  if (dic = NIL) Then RslError('Не могу открыть словарь!', []);
  RSLBtSetBlobType(dic, BT_NOBLOB);
end;

procedure DoneExec; stdcall;
begin
  if (dic <> NIL) Then  RSLBtCloseDataBase(dic);
end;

function DlmMain(isLoad:Integer; anyL:Pointer):Integer;  stdcall;
begin
  result:=0;
end;

procedure AddModuleObjects(); stdcall;
begin
  {*******************************************************}
  RSLAddStdProc(V_STRING, PChar('aeAccountName'), @aeAccountName, 0);
  RSLAddStdProc(V_STRING, PChar('aeAccountKind'), @aeAccountKind, 0);
  RSLAddStdProc(V_STRING, PChar('aeAccountType'), @aeAccountType, 0);
  RSLAddStdProc(V_STRING, PChar('aeAccountOpen'), @aeAccountOpen, 0);
  RSLAddStdProc(V_STRING, PChar('aeAccountBalance'), @aeAccountBalance, 0);
  RSLAddStdProc(V_INTEGER, PChar('aeAccountClient'), @aeAccountClient, 0);
  RSLAddStdProc(V_INTEGER, PChar('aeAccountDepartment'), @aeAccountDepartment, 0);
  RSLAddStdProc(V_INTEGER, PChar('aeAccountCurrency'), @aeAccountCurrency, 0);
  RSLAddStdProc(V_INTEGER, PChar('aeAccountOper'), @aeAccountOper, 0);
  RSLAddStdProc(V_DATE, PChar('aeAccountOpenDate'), @aeAccountOpenDate, 0);
  RSLAddStdProc(V_DATE, PChar('aeAccountCloseDate'), @aeAccountCloseDate, 0);
  {*******************************************************}
  RSLAddStdProc(V_STRING, PChar('aeClientName'), @aeClientName, 0);
  RSLAddStdProc(V_STRING, PChar('aeClientShortName'), @aeClientShortName, 0);
  RSLAddStdProc(V_STRING, PChar('aeClientINN'), @aeClientINN, 0);
  RSLAddStdProc(V_INTEGER, PChar('aeClientGroup'), @aeClientGroup, 0);
  RSLAddStdProc(V_INTEGER, PChar('aeClientPropertyKind'), @aeClientPropertyKind, 0);
  RSLAddStdProc(V_INTEGER, PChar('aeClientOrgForm'), @aeClientOrgForm, 0);
  RSLAddStdProc(V_INTEGER, PChar('aeClientActivitiesSphere'), @aeClientActivitiesSphere, 0);
  RSLAddStdProc(V_INTEGER, PChar('aeClientOKPO'), @aeClientOKPO, 0);
  RSLAddStdProc(V_STRING, PChar('aeClientCodes'), @aeClientCodes, 0);
  RSLAddStdProc(V_INTEGER, PChar('aeClientCarryOper'), @aeClientCarryOper, 0);
  RSLAddStdProc(V_INTEGER, PChar('aeClientCreditOper'), @aeClientCreditOper, 0);
  RSLAddStdProc(V_DATE, PChar('aeClientStartDate'), @aeClientStartDate, 0);
  RSLAddStdProc(V_DATE, PChar('aeClientFinishDate'), @aeClientFinishDate, 0);
  {*******************************************************}
  RSLAddStdProc(V_STRING, PChar('aeOperName'), @aeOperName, 0);
  RSLAddStdProc(V_INTEGER, PChar('aeOperDepartment'), @aeOperDepartment, 0);
  RSLAddStdProc(V_INTEGER, PChar('aeOperType'), @aeOperType, 0);
  RSLAddStdProc(V_INTEGER, PChar('aeOperGroupO'), @aeOperGroupO, 0);
  RSLAddStdProc(V_INTEGER, PChar('aeOperGroupC'), @aeOperGroupC, 0);
  {*******************************************************}
  RSLAddStdProc(V_STRING, PChar('aeDepartmentName'), @aeDepartmentName, 0);
  RSLAddStdProc(V_STRING, PChar('aeDepartmentComment'), @aeDepartmentComment, 0);
  RSLAddStdProc(V_STRING, PChar('aeDepartmentBIC'), @aeDepartmentBIC, 0);
  RSLAddStdProc(V_STRING, PChar('aeDepartmentRNN'), @aeDepartmentRNN, 0);
  RSLAddStdProc(V_INTEGER, PChar('aeDepartmentStatus'), @aeDepartmentStatus, 0);
  {*******************************************************}
  RSLAddStdProc(V_STRING, PChar('aeBankName'), @aeBankName, 0);
  {*******************************************************}
  {aeChapterName(Chapter)}
  RSLAddStdProc(V_STRING, PChar('aeChapterName'), @aeChapterName, 0);
  {aeChapterShortName(Chapter)}
  RSLAddStdProc(V_STRING, PChar('aeChapterShortName'), @aeChapterShortName, 0);
  {*******************************************************}
  {aeBalanceName(iNumPlan, Balance, Currency, Chapter)}
  RSLAddStdProc(V_STRING, PChar('aeBalanceName'), @aeBalanceName, 0);
  {*******************************************************}
  {aeCurrencyName(Code_Currency)}
  RSLAddStdProc(V_STRING, PChar('aeCurrencyName'), @aeCurrencyName, 0);
  RSLAddStdProc(V_STRING, PChar('aeCurrencyShortName'), @aeCurrencyShortName, 0);
  RSLAddStdProc(V_STRING, PChar('aeISOCur'), @aeISOCur, 0);
  RSLAddStdProc(V_INTEGER, PChar('aeCurrencyISOCode'), @aeCurrencyISOCode, 0);
  {*******************************************************}
  {aeResCarryName(Code)}
  RSLAddStdProc(V_STRING, PChar('aeResCarryName'), @aeResCarryName, 0);
  RSLAddStdProc(V_STRING, PChar('aeResCarryShortName'), @aeResCarryShortName, 0);
end;


Exports
InitExec,
DoneExec,
DlmMain,
AddModuleObjects;

begin

end.
