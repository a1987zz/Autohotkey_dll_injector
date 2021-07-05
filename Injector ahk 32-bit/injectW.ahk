#NoEnv

File := "test_.dll"
str := "0"

WinGet, id, PID, ahk_exe test.exe

hModule := DllCall("LoadLibrary", "Str", "gh_injector.dll")
InjectW := DllCall("GetProcAddress", "Ptr", hModule, "Astr", "InjectW", "Ptr")
;msgbox % InjectW

VarSetCapacity(ParamStruct, 542 * 2, 0)

NumPut(&str, &ParamStruct + 522 * 2)
NumPut(id, ParamStruct, 524 * 2, "Uint")
NumPut(2, ParamStruct, 526 * 2, "Uint")
NumPut(0, ParamStruct, 528 * 2, "Uint") ; 0 - NtCreateThreadEx
StrPut(File, &ParamStruct + 4, "UTF-16")

DllCall(InjectW, "Ptr", &ParamStruct)