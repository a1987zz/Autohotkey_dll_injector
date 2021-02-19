#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

File := "test_.dll"
WinGet, id, PID, ahk_exe test.exe

hModule := DllCall("LoadLibrary", "Str", "gh_injector.dll")
funcA := DllCall("GetProcAddress","Ptr", hModule, "Astr","InjectA")
;msgbox % funcA

VarSetCapacity(ParamStruct, 540, 0)
DllCall("ZeroMemory", Ptr, &ParamStruct, "UInt", 540)

NumPut(2, ParamStruct, 528, "Uint") ; 2 - метод инжекта ManualMap
NumPut(0, ParamStruct, 532, "Uint") ; 0 - NtCreateThreadEx
NumPut(id, ParamStruct, 524, "Uint")

StrPut(File, &ParamStruct + 4, "CP0")

DllCall(funcA, "Ptr", &ParamStruct)
