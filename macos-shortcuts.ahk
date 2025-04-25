; This script assumes that Alt and Ctrl characters have been swapped using a third-party tool (such as PowerToys)

; -----KEY GUIDE-----
; # Win. (the key with the Windows logo) therefore `Send #e` would hold down Win and then press E.
; + Shift. For example, `Send, +abC` would send the text "AbC", and `Send, !+a` would press Alt+Shift+A.
; ^ Alt (because of remapkey). For example, `Send, This is text!a` would send the keys "This is text" and then press Alt+A. Note: !A produces a different effect in some programs than !a. This is because !A presses Alt+Shift+A and !a presses Alt+A. If in doubt, use lowercase.
; ! Ctrl (because of remapkey). For example, `Send, ^!a` would press Ctrl+Alt+A, and Send, ^{Home} would send Ctrl+Home. Note: ^A produces a different effect in some programs than ^a. This is because ^A presses Ctrl+Shift+A and ^a presses Ctrl+A. If in doubt, use lowercase.Sends Ctrl. For example, Send, ^!a would press Ctrl+Alt+A, and Send, ^{Home} would send Ctrl+Home. Note: ^A produces a different effect in some programs than ^a. This is because ^A presses Ctrl+Shift+A and ^a presses Ctrl+A. If in doubt, use lowercase.
; & An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey.

; #Warn  ; Uncomment to enable warnings to assist with detecting common errors.
SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.

; Uncomment for key history
; #InstallKeybdHook
; KeyHistory

; App and tab switching
Ctrl & Tab::AltTab
!Tab::Send("^{Tab}")

; Quit the active app
^q::Send("!{f4}")

; NOTE: These Suspend + Unsuspend operations enable user to press the key repeatedly without releasing and pressing it again

; Insertion point movement
^Left:: {
    Suspend(true)
    Send("{Home}")
    Suspend(false)
    return
}
^Right:: {
    Suspend(true)
    Send("{End}")
    Suspend(false)
    return
}
^Up:: {
    if WinActive("ahk_exe explorer.exe") {
        Send("!{Up}") ; Move up a folder in File Explorer
    }
    else {
        Suspend(true)
        Send("^{Home}")
        Suspend(false)
    }
    return
}
^Down:: {
    if WinActive("ahk_exe explorer.exe") {
        Send("{Enter}") ; Move down a folder in File Explorer
    }
    else {
        Suspend(true)
        Send("^{End}")
        Suspend(false)
    }
    return
}
;Enter:: {
;    focusedControl := ControlGetFocus("A")
;    if WinActive("ahk_exe explorer.exe") && (focusedControl != "Edit1") {
;        Send("{F2}") ; Rename file/folder in File Explorer
;    }
;    else {
;        Send("{Enter}")
;    }
;    return
;}
+^Left:: {
    Suspend(true)
    Send("+{Home}")
    Suspend(false)
    return
}
+^Right:: {
    Suspend(true)
    Send("+{End}")
    Suspend(false)
    return
}
+^Up:: {
    Suspend(true)
    Send("+^{Home}")
    Suspend(false)
    return
}
+^Down:: {
    Suspend(true)
    Send("+^{End}")
    Suspend(false)
    return
}
#Left:: {
    Suspend(true)
    Send("^{Left}")
    Suspend(false)
    return
}
#Right:: {
    Suspend(true)
    Send("^{Right}")
    Suspend(false)
    return
}
+#Left:: {
    Suspend(true)
    Send("+^{Left}")
    Suspend(false)
    return
}
+#Right:: {
    Suspend(true)
    Send("+^{Right}")
    Suspend(false)
    return
}
^#!Left:: {  ; Move window to next monitor
    Suspend(true)
    Send("#+{Left}")
    Suspend(false)
    return
}
^#!Right:: {  ; Move window to next monitor (other way)
    Suspend(true)
    Send("#+{Right}")
    Suspend(false)
    return
}
#^Left:: {  ; Snap window to the left
    Suspend(true)
    Send("#{Left}")
    Suspend(false)
    return
}
#^Right:: {  ; Snap window to the right
    Suspend(true)
    Send("#{Right}")
    Suspend(false)
    return
}
#^Up:: {  ; Snap window to the top or maximize
    Suspend(true)
    Send("#{Up}")
    Suspend(false)
    return
}
#^Down:: {  ; Snap window to the bottom or minimize
    Suspend(true)
    Send("#{Down}")
    Suspend(false)
    return
}

; CMD + Backspace = delete line to the left of cursor
^Backspace::Send("+{Home}{Del}")
; CMD + Delete = delete line to the right of cursor
^Delete::Send("+{End}{Del}")

; OPTION + Backspace = delete word to the left of cursor
#Backspace::Send("^+{Left}{Del}")
; OPTION + Delete = delete word to the right of cursor
#Delete::Send("^+{Right}{Del}")

; Replace characters on the keyboard to macOS keyboard
^!í:: {
    Suspend(true)
    SendText("{")
    Suspend(false)
    return
}

^!é:: {
    Suspend(true)
    SendText("}")
    Suspend(false)
    return
}

^!§:: {
    Suspend(true)
    SendText("'")
    Suspend(false)
    return
}

!Space::Send("^+{Space}")

; CMD + ; = switch windows of the same application
GroupAdd("explorer_exe", "ahk_class CabinetWClass ahk_exe explorer.exe",, "Program Manager")  ; adds all CabinetWClass (= File Explorer) windows to a group explorer_exe to mitigate being in the same process as taskbar and desktop
^;:: {
    static winGP := Map("explorer.exe", GroupActivate.Bind("explorer_exe"))
    if !winGP.Has(pName := WinGetProcessName("A"))
        gName := StrReplace(StrReplace(StrReplace(pName, ".", "_"), "-", "_"), " ", "_"),  ; replace dot, dash and space chars with underscore
        GroupAdd(gName, "ahk_exe " pName),
        winGP[pName] := GroupActivate.Bind(gName)
    winGP[pName]()
}
