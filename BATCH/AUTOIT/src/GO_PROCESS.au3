;
; AutoIt Version: 3.0
; Author:         Guillaume COMPAGNON
;
; Script Function:
;   script permettant de faire un runas avec parametres 
;
#include "include/LOGIN_PROPERTIES.au3"
#include <File.au3>
if( $CmdLine[0] =0 )Then 
	$ScriptPath = "C:\FGA_SOFT\DEVELOPPEMENT\PROJET\FGA_Soft_Integration\BATCH\AUTOIT\OMEGA_DETAIL_FIFO.exe"
Else
	$ScriptPath = $CmdLine[1]
Endif
;$ScriptPath = "C:\TEST_PROCESS.exe"


ConsoleWrite("LAUNCHER"&@CRLF)
_FileWriteLog($LogPath,"LAUNCHER RunAs "&$sGroup&"\"&$sUserName&": "&$ScriptPath&@CRLF)


Local $pid = RunAs ( $sUserName, $sGroup, $sPassword, 4, $ScriptPath)
If( $pid = 0 and @error <> 0 ) Then
     ConsoleWriteError("impossible de démarrer , vérifier le compte: "&$sGroup&"\"&$sUserName&@CRLF&$sPassword&@CRLF)	 
	 _FileWriteLog($LogPath,"impossible de démarrer , vérifier le compte: "&$sGroup&"\"&$sUserName&@CRLF)
	 Exit(1)
EndIf