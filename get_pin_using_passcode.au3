#include <AutoItConstants.au3>
#include <Misc.au3>
;Now we should open passcode application and fetch the latest code

If Not WinExists("Passcode") Then
	Run("C:\Program Files (x86)\Passcode\Passcode.exe")
	Sleep(5000) ;Lets wait for 5 seconds to passcode flash screen to finish
	WinWaitActive("Passcode")
EndIf

If Not WinActive("Passcode") Then WinActivate("Passcode")
ConsoleWrite("Sending password to window")
Send("1234")
Send("{ENTER}")

; Click at the 518,142 position (click "copy" button)
If Not WinActive("Passcode") Then WinActivate("Passcode")
MouseClick($MOUSE_CLICK_LEFT, 853, 249, 1)
Sleep(1000) ; sleep a second to clip to be updated
Local $code = ClipGet()
$code = ClipGet()

ConsoleWrite(@CRLF & "Code is " & $code & @CRLF )




