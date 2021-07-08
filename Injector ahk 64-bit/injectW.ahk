#NoEnv

File := "test_.dll"
str := "test.exe"

WinGet, id, PID, ahk_exe test.exe

hModule := DllCall("LoadLibrary", "Str", "gh_injector", "Ptr")
InjectW := DllCall("GetProcAddress", "Ptr", hModule, "Astr", "InjectW", "Ptr")
;msgbox % InjectW

VarSetCapacity(ParamStruct, 1200, 0)

NumPut(0, &ParamStruct, "Uint")
StrPut(File, &ParamStruct + 4, "UTF-16")
NumPut(&str, &ParamStruct, 8 + 520*2)
NumPut(id, ParamStruct, 4 + 520*2 + 12, "Uint")
NumPut(2, ParamStruct, 4 + 520*2 + 16, "Uint")
NumPut(0, ParamStruct, 4 + 520*2 + 20, "Uint")

DllCall(InjectW, "Ptr", &ParamStruct)