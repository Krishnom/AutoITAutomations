; check if a window with text exists
If WinExists("Cisco AnyConnect Secure Mobility Client", "disconnect") Then
	Local handle = WinGetHandle("Cisco AnyConnect Secure Mobility Client")
	Local text = ControlGetText("Cisco AnyConnect Secure Mobility Client")
	ControlGetText("Cisco AnyConnect Secure Mobility Client", "disconnect")
	msgbox(0,"Debug","Window not found")
Else
	msgbox(0,"Debug","Window found")
EndIf