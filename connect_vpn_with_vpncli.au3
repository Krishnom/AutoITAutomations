#include <AutoItConstants.au3>

;This is not fully functional. 
;Make sure that no cli is already running
$list = ProcessList("vpncli.exe")
for $i = 1 to $list[0][0]
  ProcessClose( $list[1][1] )
Next

Local $installHome = 'C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\'
Local $vpncli = 'C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpncli.exe'
Local $connectURL = 'vpn url'
Local $username = 'username'
Local $password = 'password'
Local $registeredMobileName = 'mobile registered for 2 way auth' ;for e.g. 'Redmi Note 5 Pro'


;Add InstallHome path in Environment so that full path is not required.
; Retrieve the system environment variable called %PATH%.
Local $sEnvVar = EnvGet("PATH")

; Assign the system environment variable called %PATH% with its current value as well as the INSTALL HOME directory where vpn utilities are present.
;  When you assign an environment variable you do so minus the percentage signs (%).
    EnvSet("PATH", $sEnvVar & ";" & $installHome")


; Disconnect any already established session
ShellExecute($vpncli, " "," ","open" )
sleep(1000)
$activate_status = WinActivate($vpncli)
send("disconnect{enter}")
$activate_status = WinActivate($vpncli)
send("exit{enter}")
sleep(3000)
; if I am not dead yet, kill Me
WinKill($vpncli)


; connect to vpn

Local $processID = Run($vpncli & "  connect " & $connectURL , "", @SW_SHOW,  $STDOUT_CHILD)
;Local $processID = ShellExecute($vpncli, " connect " & $connectURL ," ","open" )
sleep(3000)

$activate_status = WinActivate($vpncli)
send($username & "{enter}")

sleep(2000)
$activate_status = WinActivate($vpncli)

send($password & "{enter}")
Sleep(8000)
;ControlClick("Security Alert","","[CLASS:Button;INSTANCE:4]","primary")

;1 for SEND LOGIN REQUEST TO PHONE
$activate_status = WinActivate($vpncli)
send("1{enter}")
Sleep(8000)
$activate_status = WinActivate($vpncli)

;Wait till the registerMobileName appears in stdout.
Local $commandOut = WaitTillTextAppearInStdOut($registeredMobileName)
Local $device_no = 0

$Value=StringSplit($commandOut,@CRLF)
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

$activate_status = WinActivate($vpncli)

send($device_no & "{enter}")




;;;;;;;; Funtions ;;;;;;;;;;;;;;;
Func WaitTillTextAppearInStdOut($text)

Local $commandOut = StdoutRead($processID, True)

While StringInStr($commandOut, $text) = 0
		$commandOut = StdoutRead($processID, True)
WEnd
	Return $commandOut
EndFunc   ;==>MyDouble
