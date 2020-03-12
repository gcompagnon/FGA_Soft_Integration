#include <File.au3>
; RESOLUTION : 1280 par 1024 pixels
; PARAMETRES du compte exécutant OMEGA FS
Global $ScriptPath = "C:\FGA_SOFT\DEVELOPPEMENT\PROJET\FGA_Soft_Integration\BATCH\AUTOIT\OMEGA_TACHES.bat"
Global $sUserName = "KRG"
Global $sGroup = "MALAKOFFMEDERIC"
Global $sPassword = "kokoll07"
Global $SavePath = "\\vill1\PARTAGE\,FGA Soft\BASE"
Global $OmegaPath = "\\winprodfga\OMEGA\PROD"

Global Const $LogPath = @ScriptDir & "\LOG\" &  @YEAR & @MON & @MDAY & "_Omega_Auto.log"
DirCreate(@ScriptDir & "\LOG\")
; parametres dans la ligne de commande:
; le 1er est le chemin du script à executer
;et le 2eme  le trigramme utilisé
; 3ème: le mot de passe 
; le 4ème est le repertoire de sortie des extractions 
Local $no_read_cmd_line = EnvGet("NO_CMD_LINE")
if( $no_read_cmd_line ) Then
   ; Si la variable d environnement NO_CMD_LINE est flaggué, ne pas lire la ligne de commande
Else   
   if( $CmdLine[0] >= 1) Then
	  Local $var = $CmdLine[1]
	  If( $var <> "" ) Then
		 $ScriptPath = $var
	  EndIf
   EndIf
   if( $CmdLine[0] >= 2) Then
	  Local $var = $CmdLine[2]
	  If( $var <> "" ) Then
		 $sUserName = $var
	  EndIf
   EndIf
   if( $CmdLine[0] >= 3) Then
	  Local $var = $CmdLine[3]
	  If( $var <> "" ) Then
		 $sPassword = $var
	  EndIf
   EndIf
   if( $CmdLine[0] >= 4) Then
	  Local $var = $CmdLine[4]
	  If( $var <> "" ) Then
		 $SavePath = $var
	  EndIf
   EndIf
EndIf


;Global Const $var = EnvGet("SAVE_PATH")

;************************************** LANCEMENT D OMEGA ************************************************
; Executer Omega
; retour :   $pid
Func GoOmega()
   ConsoleWrite("Omega process : recherche"&@CRLF)
   _FileWriteLog($LogPath, "Omega process : recherche"&@CRLF)
   ; executer la fenetre OMEGA
   Local $pid = ProcessExists("Omega.exe")      
   ; lancer Omega
   ConsoleWrite("Omega process "&$pid&@CRLF)
   _FileWriteLog($LogPath,"Omega process "&$pid&@CRLF)
   If( $pid = 0 Or not WinExists("[CLASS:TFrmMenu]") ) Then	  
	  $pid = RunAs ( $sUserName, $sGroup, $sPassword, 4, $OmegaPath&"\Omega.exe",$OmegaPath,@SW_MAXIMIZE )
	  If( $pid = 0 and @error <> 0 ) Then
		     ConsoleWriteError("OMEGA impossible de démarrer , vérifier le compte: "&$sGroup&"\"&$sUserName&@CRLF)
			 _FileWriteLog($LogPath,"OMEGA impossible de démarrer , vérifier le compte: "&$sGroup&"\"&$sUserName&@CRLF)
			 Exit(1)
      EndIf			 
	  WinWait("[CLASS:TFrmMenu]")
   EndIf
   
	  
   WinActivate("[CLASS:TFrmMenu]")
   WinSetState("[CLASS:TFrmMenu]","",@SW_MAXIMIZE)
   ConsoleWrite("Fenetre Principale Omega Disponible"&@CRLF)
   _FileWriteLog($LogPath,"Fenetre Principale Omega Disponible"&@CRLF)
   return $pid
EndFunc
;************************************** LANCEMENT D UTILITAIRE OMEGA: ImportFichier ************************************************
; Executer 
; retour :   $pid
Func ImportFichierOmega($command)
   ConsoleWrite("Omega ImportFichier process : recherche"&@CRLF)
   _FileWriteLog($LogPath, "Omega ImportFichier process : recherche"&@CRLF)
   
   Local $pid = ProcessExists("ImportFichier.exe")      
   ; lancer Omega
   ConsoleWrite("Omega ImportFichier process "&$pid&@CRLF)
   _FileWriteLog($LogPath,"Omega ImportFichier process "&$pid&@CRLF)
   If( $pid = 0 ) Then	  
	  ConsoleWrite("Omega ImportFichier process  RUNAS "&$sUserName&" "&$sGroup&" "&$sPassword&" "&$OmegaPath&"\ImportFichier.exe "&$command&@CRLF)
	  $pid = RunAs ( $sUserName, $sGroup, $sPassword, 4, $OmegaPath&"\ImportFichier.exe "&$command,$OmegaPath,@SW_MAXIMIZE )
	  
	  If( $pid = 0 and @error <> 0 ) Then
		     ConsoleWriteError("OMEGA ImportFichier impossible de démarrer , vérifier le compte: "&$sGroup&"\"&$sUserName&@CRLF)
			 _FileWriteLog($LogPath,"OMEGA ImportFichier impossible de démarrer , vérifier le compte: "&$sGroup&"\"&$sUserName&@CRLF)
			 Exit(1)
      EndIf			 
   EndIf
   
	  
   ConsoleWrite("ImportFichier Omega Terminé"&@CRLF)
   _FileWriteLog($LogPath,"ImportFichier Omega Terminé"&@CRLF)
   return $pid
EndFunc

;************************************** FERMETURE D OMEGA ************************************************
; Executer Omega
; retour :   $pid
Func EndOmega()
   
   ; executer la fenetre OMEGA
   Local $pid = ProcessExists("Omega.exe")      
   ; lancer Omega   
   If( $pid <> 0 Or  WinExists("[CLASS:TFrmMenu]") ) Then	  
	  WinClose("[CLASS:TFrmMenu]")	  
	  Sleep(1000)
	  if( WinExists("[CLASS:#32770]")) Then
		 ControlClick("[CLASS:#32770]","","[CLASS:Button; INSTANCE:1]")
	  EndIf
	  Sleep(1000)
	  ; Attent la fin du process
      ProcessClose($pid)
   EndIf
   ConsoleWrite("Fenetre Principale Omega FERMEE"&@CRLF)
   _FileWriteLog($LogPath,"Fenetre Principale Omega FERMEE"&@CRLF)
EndFunc