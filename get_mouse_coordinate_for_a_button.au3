#include <Misc.au3>
#include <AutoItConstants.au3>
;wait untill left mouse is clicked
While _IsPressed("02") == False
WEnd

$MousePos = MouseGetPos()
;$MousePos[0]  Mouse X position
;$MousePos[1]  Mouse Y position
msgbox(0,"Debug","Cursor located at " & $MousePos[0] & "," & $MousePos[1])
