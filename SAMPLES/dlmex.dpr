{������ �஥�� ��� DLM}
library ;
{�⪫�砥� ��ࠢ������� � ४�ठ�}
{$A1}
{��⠭�������� ���७�� 䠩��}
{$E d32}
{����砥� ��⨬�����}
{$O+}

Uses
    rsltype,
    rsldll;

const
  DLL_PROCESS_DETACH = 0;
  DLL_PROCESS_ATTACH = 1;
  DLL_THREAD_ATTACH  = 2;
  DLL_THREAD_DETACH  = 3;

{*****************************************************************

******************************************************************}

procedure TestProc; cdecl;
begin
end;

{*****************************************************************

******************************************************************}

procedure InitExec; stdcall;
begin
end;

procedure DoneExec; stdcall;
begin
end;

function RslDllMain(isLoad:Integer; anyL:Pointer):Integer; stdcall;
begin
{*******************************************
�� ��楤�� ���� � DLM �� �++
�� ����� ��� �� ࠡ�⠥� �� ����
��᪮��� � �� ���� ��� ��� ⠬ ॠ��������
���⮬� � �� �� �ᯮ�����
********************************************}
  result:=0;
end;


procedure DLLEntryPoint(Reason: DWORD); 
begin 
  case Reason of 
    Dll_Process_Attach: //������祭�� �����
    Dll_Thread_Attach: //������祭�� ��⮪�
    Dll_Thread_Detach: //�⪫�祭�� ��⮪�
    Dll_Process_Detach: //�⪫�祭�� �����
  end; // case 
end;

procedure AddModuleObjects(); stdcall;
begin
end;


Exports
InitExec,
DoneExec,
AddModuleObjects;

begin
// ��ᯮ������� ����� ��� �믮������ � ����� 
// ��।� �� ������ �맮�� DLL ��� exe-䠩���.
  if (Not Assigned(DllProc)) then begin 
    DllProc := @DLLEntryPoint; 
    DllEntryPoint(Dll_Process_Attach); 
  end;
end.
