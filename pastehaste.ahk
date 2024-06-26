﻿#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

Gui +AlwaysOnTop
Gui, Color, 282828, 707070
Gui, Font, s12 cWhite, Verdana ; Set the font size to 12 and color to white, and the font to Verdana

Gui, Add, Text, x10 y10 cFFFFFF, Enabled
Gui, Add, CheckBox, x80 y10 vPasteMode cFFFFFF Checked

Gui, Add, Button, x200 y10 w80 h20 gSaveInputs, Save

Gui, Add, Text, x10 y40 cFFFFFF, Key 1:
Gui, Add, Edit, x80 y40 vKey1Input w200 cFFFFFF
Gui, Add, Text, x10 y75 cFFFFFF, Key 2:
Gui, Add, Edit, x80 y75 vKey2Input w200 cFFFFFF
Gui, Add, Text, x10 y110 cFFFFFF, Key 3:
Gui, Add, Edit, x80 y110 vKey3Input w200 cFFFFFF
Gui, Add, Text, x10 y145 cFFFFFF, Key 4:
Gui, Add, Edit, x80 y145 vKey4Input w200 cFFFFFF
Gui, Add, Text, x10 y180 cFFFFFF, Key 5:
Gui, Add, Edit, x80 y180 vKey5Input w200 cFFFFFF

Gui, Show,, Paste Haste
LoadKeyInputs()
Return
SetKeyDelay, 50, 50

!1::
    if (PasteModeChecked())
        KeyWait, Alt, 1
    {
        Gui, Submit, NoHide
        SendInput %Key1Input%
    }
Return

!2::
    if (PasteModeChecked())
    {
        KeyWait, Alt, 2
        Gui, Submit, NoHide
        SendInput %Key2Input%
    }
Return

!3::
    if (PasteModeChecked())
    {
        KeyWait, Alt, 3
        Gui, Submit, NoHide
        SendInput %Key3Input%
    }
Return

!4::
    if (PasteModeChecked())
    {
        KeyWait, Alt, 4
        Gui, Submit, NoHide
        SendInput %Key4Input%
    }
Return

!5::
    if (PasteModeChecked())
    {
        KeyWait, Alt, 5
        Gui, Submit, NoHide
        SendInput %Key5Input%
    }
Return

^!1::
    CopyToClipboardAndSetGuiControl("Key1Input")
Return

^!2::
    CopyToClipboardAndSetGuiControl("Key2Input")
Return

^!3::
    CopyToClipboardAndSetGuiControl("Key3Input")
Return

^!4::
    CopyToClipboardAndSetGuiControl("Key4Input")
Return

^!5::
    CopyToClipboardAndSetGuiControl("Key5Input")
Return

!w::
    KeyWait, Alt, w
    if (PasteModeChecked()) {

        WinGetTitle, activeTitle, A
        RegExMatch(activeTitle, "i)\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b", emailMatch)
        if (emailMatch)
        {
            ; MsgBox, Found email in window title: %emailMatch%
            SendInput %emailMatch%
        } else {
            ; TrayTip, No email found in window title, :(
        }
    }

Return

!e::
    if (PasteModeChecked()) {
        KeyWait, Alt, e
        WinGetTitle, activeTitle, A
        RegExMatch(activeTitle, "i)\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b", emailMatch)

        if (!emailMatch)
        {
            ; TrayTip, No email found in window title, :(
            Return
        }

        FileRead, accounts, accounts.txt

        Loop, Parse, accounts, `n ; Loop through each line of the file
        {
            account := StrSplit(A_LoopField, ",")
            username := account[1]
            password := account[2]

            if (username = emailMatch)
            {
                SendInput %password%
                Return
            }
        }

        ; TrayTip, No account found for email %emailMatch%, :(
    }
Return

CopyToClipboardAndSetGuiControl(controlName)
{
    Send, ^c
    ClipWait, 1
    if (!ErrorLevel) ; If text was successfully copied to the clipboard
    {
        GuiControl,, %controlName%, %ClipBoard%
    }
}

PasteModeChecked()
{
    GuiControlGet, PasteMode
Return PasteMode
}

SaveInputs()
{
    global
    Gui, Submit, NoHide
    if (FileExist("key_inputs.txt")) {
        FileDelete, %A_ScriptDir%\key_inputs.txt
        if (ErrorLevel) {
            MsgBox, Failed to delete key inputs file
            Return
        }
    }

    FileAppend, Key 1: %Key1Input%`nKey 2: %Key2Input%`nKey 3: %Key3Input%`nKey 4: %Key4Input%`nKey 5: %Key5Input%`n, %A_ScriptDir%\key_inputs.txt
    if (ErrorLevel) {
        MsgBox, Failed to save key inputs to file
        Return
    }
}

LoadKeyInputs()
{
    global
    if FileExist("key_inputs.txt")
    {
        Loop, Read, key_inputs.txt
        {
            IfInString, A_LoopReadLine, Key 1:
                Key1Input := SubStr(A_LoopReadLine, 8)
            IfInString, A_LoopReadLine, Key 2:
                Key2Input := SubStr(A_LoopReadLine, 8)
            IfInString, A_LoopReadLine, Key 3:
                Key3Input := SubStr(A_LoopReadLine, 8)
            IfInString, A_LoopReadLine, Key 4:
                Key4Input := SubStr(A_LoopReadLine, 8)
            IfInString, A_LoopReadLine, Key 5:
                Key5Input := SubStr(A_LoopReadLine, 8)
            }
            GuiControl,, Key1Input, %Key1Input%
            GuiControl,, Key2Input, %Key2Input%
            GuiControl,, Key3Input, %Key3Input%
            GuiControl,, Key4Input, %Key4Input%
            GuiControl,, Key5Input, %Key5Input%
        }
    }

    GuiClose:
    ExitApp