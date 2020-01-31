; Script to connect to VPN with Cisco AnyConnect VPN client
;Update config file path. See example vpn_config.ini.example.
;If using cisco passcode app than install and register for passcode authentication

#include <MsgBoxConstants.au3>
#include <Array.au3> ; Required for _ArrayDisplay() only.

;START

Local $config = "D:\workspace\learnings\autoit-v3\config\vpn_config.ini"
Local $username = IniRead($config, "ALL", "username",Null)
;~ ConsoleWrite($username & @CRLF);
Local $password = IniRead($config, "ALL", "password",Null)
;~ ConsoleWrite($password & @CRLF);
Local $passcodePin = IniRead($config, "ALL", "passcode_pin",Null)
;~ ConsoleWrite($passcodePin & @CRLF);
Local $connectURL = IniRead($config, "ALL", "url",Null)
;~ ConsoleWrite($connectURL & @CRLF);
Local $registeredMobileName = IniRead($config, "ALL", "registered_mobile_num",Null)
;~ ConsoleWrite($registeredMobileName & @CRLF);

Local $anyConnectWinName = 'Cisco AnyConnect Secure Mobility Client'
Local $vpnuiExe = "C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpnui.exe"

If Not WinExists($anyConnectWinName, "disconnect") Then
	;~ ConsoleWrite("Running " & $vpnuiExe & @CRLF)
	Run($vpnuiExe)
	;~ ConsoleWrite("Waiting for vpnui to open" &  @CRLF)
	WinWaitActive($anyConnectWinName)
	ControlClick($anyConnectWinName, "", "[CLASS:Button; TEXT:Connect; INSTANCE:1]")
	;~ Send("{ENTER}")
Else
	ConsoleWrite("VPN is already connected")
	Exit
EndIf

;~ ConsoleWrite("Connecting..." & @CRLF)

WinWaitActive("Cisco AnyConnect | " & $connectURL)
ControlFocus("Cisco AnyConnect | " & $connectURL, "Password:", "")
ControlSend("Cisco AnyConnect | " & $connectURL, "Password:", "", $password)
ControlFocus("Cisco AnyConnect | " & $connectURL, "OK", "")
Send("{ENTER}")

WinWaitActive("Cisco AnyConnect | " & $connectURL)

;Now we should open passcode application and fetch the latest code
authenticateUsingPasscodeApp($passcodePin)
; authenticateOnMobile($connectURL, $registeredMobileName)

Sleep(5000)
WinWaitActive("Cisco AnyConnect")
If Not WinActive("Cisco AnyConnect") Then 
	WinActivate("Cisco AnyConnect")
EndIf
ControlClick("Cisco AnyConnect", "", "[CLASS:Button; TEXT:Accept; INSTANCE:1]")
Exit

;END

;==================================================Functions===============================================
;Retrieve auth code from passcode app
;Pass the pincode to for passcode app auth
Func authenticateUsingPasscodeApp($pincode)
	If Not WinExists("Passcode") Then
			Run("C:\Program Files (x86)\Passcode\Passcode.exe")
			Sleep(5000) ;Lets wait for 5 seconds to passcode flash screen to finish
			WinWaitActive("Passcode")
	EndIf

	If Not WinActive("Passcode") Then WinActivate("Passcode")
	Send($pincode)
	Send("{ENTER}")

	; Click at the 518,142 position (click "copy" button)
	If Not WinActive("Passcode") Then WinActivate("Passcode")
	
	MouseClick($MOUSE_CLICK_LEFT, 853, 249, 1)

	Sleep(1000) ; sleep a second to clip to be updated
	Local $code = ClipGet()
	$code = ClipGet()

	;WinWaitActive("Cisco AnyConnect | " & $connectURL)
	Sleep(2000)
	If Not WinActive("Cisco AnyConnect | " & $connectURL) Then WinActivate("Cisco AnyConnect | " & $connectURL)
	ControlFocus("Cisco AnyConnect | " & $connectURL, "Answer:", "")
	ControlSend("Cisco AnyConnect | " & $connectURL, "Answer:", "", $code)
	ControlClick("Cisco AnyConnect | " & $connectURL,"","[CLASS:Button; TEXT:Continue; INSTANCE:1]")
	Return
EndFunc   ;==>getPinFromPasscodeApp


Func authenticateOnMobile(Const $connectURL, Const $registeredMobileName)
	ControlFocus("Cisco AnyConnect | " & $connectURL, "Answer:", "")
	ControlSend("Cisco AnyConnect | " & $connectURL, "Answer:", "", 1) ;1 is to send auth request on mobile
	ControlFocus("Cisco AnyConnect | " & $connectURL, "Continue", "")
	Send("{ENTER}")

	WinWaitActive("Cisco AnyConnect | " & $connectURL)

	Local $device_no = 0
	Local $text = WinGetText("Cisco AnyConnect | " & $connectURL)
	;ConsoleWrite($text)

	$Value=StringSplit($text,@CRLF)
	For $i=1 To $Value[0]
		If StringInStr($Value[$i], $registeredMobileName) Then
			Local $aArray = StringToASCIIArray($Value[$i])
			;_ArrayDisplay($aArray)
			$device_no = Chr ($aArray[0])
			ExitLoop
		EndIf
	Next

	if $device_no = 0 Then
		ConsoleWrite("Your device " & $registeredMobileName & " is not listed ")
		ConsoleWrite("Procceed Manually ")
		Exit
	EndIf

	ConsoleWrite("Your device " & $registeredMobileName & " options is " & $device_no)

	ControlSend("Cisco AnyConnect | " & $connectURL, "Answer:", "", $device_no)
	ControlClick("Cisco AnyConnect | " & $connectURL, "", "[CLASS:Button; TEXT:Continue; INSTANCE:1]")
	msgbox(0,"Debug","Please check your " & $registeredMobileName & " for auth request")
EndFunc ;==> authenticateOnMobile