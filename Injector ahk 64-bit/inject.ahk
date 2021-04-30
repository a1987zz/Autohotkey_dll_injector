#NoEnv

setSeDebugPrivilege(Enable)
File := "test_.dll"
WinGet, id, PID, ahk_exe test.exe

hModule := DllCall("LoadLibrary", "Str", "gh_injector.dll", "Ptr")
funcA := DllCall("GetProcAddress","Ptr", hModule, "AStr","InjectA", "Ptr")
;msgbox % funcA


VarSetCapacity(ParamStruct, 540, 0)
DllCall("ZeroMemory", "Ptr", &ParamStruct, "UInt", 540)

NumPut(2, ParamStruct, 528, "Uint") ; 2 - метод инжекта ManualMap
NumPut(0, ParamStruct, 532, "Uint") ; 0 - NtCreateThreadEx
NumPut(id, ParamStruct, 524, "Uint")

StrPut(File, &ParamStruct + 4, "CP0")

DllCall(funcA, "Ptr", &ParamStruct)
DllCall("FreeLibrary", "Ptr", hModule)

setSeDebugPrivilege(enable := True)
{
    h := DllCall("OpenProcess", "UInt", 0x0400, "Int", false, "UInt", DllCall("GetCurrentProcessId"), "Ptr")
    ; Open an adjustable access token with this process (TOKEN_ADJUST_PRIVILEGES = 32)
    DllCall("Advapi32.dll\OpenProcessToken", "Ptr", h, "UInt", 32, "PtrP", t)
    VarSetCapacity(ti, 16, 0)  ; structure of privileges
    NumPut(1, ti, 0, "UInt")  ; one entry in the privileges array...
    ; Retrieves the locally unique identifier of the debug privilege:
    DllCall("Advapi32.dll\LookupPrivilegeValue", "Ptr", 0, "Str", "SeDebugPrivilege", "Int64P", luid)
    NumPut(luid, ti, 4, "Int64")
    if enable
    	NumPut(2, ti, 12, "UInt")  ; enable this privilege: SE_PRIVILEGE_ENABLED = 2
    ; Update the privileges of this process with the new access token:
    r := DllCall("Advapi32.dll\AdjustTokenPrivileges", "Ptr", t, "Int", false, "Ptr", &ti, "UInt", 0, "Ptr", 0, "Ptr", 0)
    DllCall("CloseHandle", "Ptr", t)  ; close this access token handle to save memory
    DllCall("CloseHandle", "Ptr", h)  ; close this process handle to save memory
    return r
}

