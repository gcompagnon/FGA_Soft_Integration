;
; AutoIt Version: 3.0
; Author:         Guillaume COMPAGNON
;
; Script Function:
;   import fichier Barclays

ConsoleWrite("Omega ImportFichier START avec "&$CmdLine[1]&" "&$CmdLine[2]&" "&$CmdLine[3]&@CRLF)
Global $command = $CmdLine[1]&" "&$CmdLine[2]&" "&$CmdLine[3]
ConsoleWrite("Omega ImportFichier START "&$CmdLine[0]&@CRLF)

EnvSet("NO_CMD_LINE","1")
#include "include/LOGIN_PROPERTIES.au3"
ConsoleWrite("Omega ImportFichier START avec "&$command&@CRLF)

Call("ImportFichierOmega",$Command)

;Sleep(6000)