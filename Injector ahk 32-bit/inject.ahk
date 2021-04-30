#NoEnv

File := "test_.dll"
WinGet, id, PID, ahk_exe test.exe

hModule := DllCall("LoadLibrary", "Str", "gh_injector.dll", "Prt")
funcA := DllCall("GetProcAddress","Ptr", hModule, "Astr","InjectA", "Prt")
;msgbox % funcA

VarSetCapacity(ParamStruct, 540, 0)
DllCall("ZeroMemory", "Ptr", &ParamStruct, "UInt", 540)

NumPut(2, ParamStruct, 528, "Uint") ; 2 - метод инжекта ManualMap
NumPut(0, ParamStruct, 532, "Uint") ; 0 - NtCreateThreadEx
NumPut(id, ParamStruct, 524, "Uint")

StrPut(File, &ParamStruct + 4, "CP0")

DllCall(funcA, "Ptr", &ParamStruct)
;DllCall("FreeLibrary", "Ptr", hModule)
