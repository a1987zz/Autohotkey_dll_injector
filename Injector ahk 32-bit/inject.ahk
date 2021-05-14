#NoEnv

File := "test_.dll"
WinGet, id, PID, ahk_exe test.exe

hModule := DllCall("LoadLibrary", "Str", "gh_injector.dll")
funcA := DllCall("GetProcAddress","Ptr", hModule, "Astr","InjectA")
;msgbox % funcA

VarSetCapacity(ParamStruct, 540, 0)
DllCall("ZeroMemory", "Ptr", &ParamStruct, "UInt", 540)

;INJ_ERASE_HEADER := 0x0001
;INJ_SHIFT_MODULE := 0x0008
;INJ_UNLINK_FROM_PEB := 0x0004

;uFlags := INJ_ERASE_HEADER | INJ_SHIFT_MODULE | INJ_UNLINK_FROM_PEB

NumPut(2, ParamStruct, 528, "Uint") ; 2 - метод инжекта ManualMap
NumPut(0, ParamStruct, 532, "Uint") ; 0 - NtCreateThreadEx
;NumPut(uFlags, ParamStruct, 536, "UInt")
NumPut(id, ParamStruct, 524, "Uint")

StrPut(File, &ParamStruct + 4, "CP0")

DllCall(funcA, "Ptr", &ParamStruct)
;DllCall("FreeLibrary", "Ptr", hModule)
