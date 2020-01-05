#include <AutoItConstants.au3>

;Add below path in Environment so that full path is not required.
Local $vpncli = "C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpncli.exe"

; Retrieve the system environment variable called %PATH%.
Local $sEnvVar = EnvGet("PATH")

; Assign the system environment variable called %PATH% with its current value as well as the script directory.
;  When you assign an environment variable you do so minus the percentage signs (%).
    EnvSet("PATH", $sEnvVar & ";C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\")


;$Local $processID = Run(@ComSpec & " /c " & 'vpncli.exe', "", @SW_HIDE,  $STDOUT_CHILD)
;Local $processID = Run($vpncli, "", "",  $STDOUT_CHILD)
Local $processID = ShellExecute($vpncli, " "," ","open" )
sleep(1000)
$activate_status = WinActivate($vpncli)
Local $commandOut = StdoutRead($processID)

ConsoleWrite($commandOut)
ConsoleWrite($processID)
