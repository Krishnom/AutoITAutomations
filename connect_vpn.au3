; Script to connect to VPN with Cisco AnyConnect VPN client
;Update your username, password and registeredMobileName(for 2fa)

#include <MsgBoxConstants.au3>
#include <Array.au3> ; Required for _ArrayDisplay() only.

Local $username = 'username'
Local $password = 'password'
Local $registeredMobileName = 'mobile'
Local $connectURL = 'url'

ConsoleWrite ( "Using username " & $username &  @CRLF)
ConsoleWrite ( "Using username " & $password & @CRLF)

Run("C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpnui.exe")
WinWaitActive("Cisco AnyConnect Secure Mobility Client")

WinWaitActive("Cisco AnyConnect Secure Mobility Client", "Connect")
Send("{ENTER}")


WinWaitActive("Cisco AnyConnect | " & $connectURL)

ControlFocus("Cisco AnyConnect | " & $connectURL, "Password:", "")

ControlSend("Cisco AnyConnect | " & $connectURL, "Password:", "", $password)
ControlFocus("Cisco AnyConnect | " & $connectURL, "OK", "")
Send("{ENTER}")

WinWaitActive("Cisco AnyConnect | " & $connectURL)
ControlFocus("Cisco AnyConnect | " & $connectURL, "Answer:", "")
ControlSend("Cisco AnyConnect | " & $connectURL, "Answer:", "", 1)
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

WinWaitActive("Cisco AnyConnect")
ControlClick("Cisco AnyConnect", "", "[CLASS:Button; TEXT:Accept; INSTANCE:1]")

Exit