#include <Array.au3> ; Required for _ArrayDisplay() only.

Local $registeredMobileName = 'Redmi Note 5 Pro'
Local $vpnUrl = 'VPN url'
Local $device_no = 0
Local $text = WinGetText("Cisco AnyConnect | "& $vpnUrl)
ConsoleWrite($text)

$Value=StringSplit($text,@CRLF)
For $i=1 To $Value[0]
	If StringInStr($Value[$i], $registeredMobileName) Then
        ;$device_no = $Value[$i][1] ;Assuming the first charachter will be option
		ConsoleWrite("Line : " & $i & " " & $Value[$i])
		Local $aArray = StringToASCIIArray($Value[$i])
		;_ArrayDisplay($aArray)
		$device_no = Chr ($aArray[0])
		ExitLoop
	EndIf
Next
