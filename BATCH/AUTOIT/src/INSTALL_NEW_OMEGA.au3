;
; AutoIt Version: 3.0
; Author:         Guillaume COMPAGNON
;
; Script Function:
;   Installation des "drivers" SQL Native client pour OMEGA
; Installation d un lien OMEGA nouvelle version
#include "include/LOGIN_PROPERTIES.au3"
#include <File.au3>
; Includes the GuiConstants (required for GUI function usage)
#include <GuiConstants.au3>
#include <StaticConstants.au3>

Global Const $DriverPath = "\\vill1\PARTAGE\,FGA Soft\PROGICIEL\Omega\"
Global Const $VersionPath = $DriverPath&"Version092012\"
Global Const $OmegaPath = "\\mepapp042_R\OMEGA\RECETTE\"
; Hides tray icon
#NoTrayIcon
; Change to OnEvent mode
Opt('GUIOnEventMode', 1)
; GUI Creation
GuiCreate("FEDERIS GA: Installation OMEGA Nouvelle version", 400, 300)
GuiSetIcon("fga.ico")
; Runs the GUIExit() function if the GUI is closed
GUISetOnEvent($GUI_EVENT_CLOSE, 'CLOSEClicked')
; Logo / Pic
GuiCtrlCreatePic("OMEGA.png",110,5,180,181)
; Instructions
GUICtrlCreateLabel("Cliquer sur le bouton:", 50, 180, 300, 15, $SS_CENTER)
GUICtrlSetColor(-1,0xFF0000) ; Makes instructions Red
; Button1
Dim $bouton = GUICtrlCreateButton("Installer OMEGA Nouvelle Version", 100, 210, 200, 30)
GUICtrlSetOnEvent($bouton, 'Go') 
; Button2
Dim $quitter = GUICtrlCreateButton("Quitter", 100, 250, 200, 30)
GUICtrlSetOnEvent($quitter, 'CLOSEClicked') ; Runs email() when pressed
GUISetState(@SW_SHOW)

While 1
Local $guimsg = GUIGetMsg()
Select
Case $guimsg = $GUI_EVENT_CLOSE
Exit
EndSelect
Wend


;===================================================================================================================================
;=====================================================BOUTON GO ====================================================================
;===================================================================================================================================
Func Go()
;desactiver les boutons
GUICtrlSetState($bouton, $GUI_DISABLE)
GUICtrlSetState($quitter, $GUI_DISABLE)

; installer les 2 drivers l un apres lautre
InstallDriverBat("installOmega_SQLNative1.bat")
InstallDriverBat("installOmega_SQLNative2.bat")

; creer un raccourci sur Omega
FileCreateShortcut($OmegaPath&"Omega.exe", @DesktopDir & "\Omega Version 092012.lnk", $OmegaPath, "", "Version de test Omega 09/2012", $OmegaPath&"Omega.exe", "^!O", "0", @SW_MINIMIZE)

_FileWriteLog($VersionPath&"LOG_OK.txt", ";"&@UserName&";"&@ComputerName&";"&" FIN OK")

ConfigureOmegaRecette()

MsgBox(0x40, "FIN NORMALE", "FIN de l installation")
Exit
EndFunc


Func InstallDriverBat($scriptbat)
   
Local $error = RunWait ($DriverPath&$scriptbat,$DriverPath,@SW_MINIMIZE )
if( @error <> 0 or $error<>0) Then
   ; executer l installation des drivers avec un compte Admibnistrateur 
   $error = RunAsWait ( $sUserName, $sGroup, $sPassword, 0, $DriverPath&$scriptbat,$DriverPath,@SW_MINIMIZE )
EndIf

if( @error <> 0 or $error<>0) Then
   _FileWriteLog($VersionPath&"LOG_ERREURS.txt", ";"&@UserName&";"&@ComputerName&";"&" Probleme pour "&$scriptbat&" avec l erreur:"&$error)
   MsgBox(0x10, "FIN ANORMALE", "FIN de l installation")
   Exit(1)
Else   
   _FileWriteLog($VersionPath&"LOG_OK.txt", ";"&@UserName&";"&@ComputerName&";"&" "&$scriptbat&" Installe")
EndIf
   
EndFunc


;===================================================================================================================================
;=====================================================Ouvrir omega recette et Mettre un fond d ecran ===============================
;===================================================================================================================================
Func ConfigureOmegaRecette()
   local $titreOmega = WinGetTitle("[CLASS:TFrmMenu]", "")
   Local $pid = 0
   if Not( StringInStr( $titreOmega, "MEPAPP042_R") )Then
	  ; executer la fenetre OMEGA
	  $pid = RunWait ( $OmegaPath&"Omega.exe",$OmegaPath,@SW_MAXIMIZE )
   
	  If( $pid = 0 or @error <> 0) Then
		 _FileWriteLog($VersionPath&"LOG_ERREURS.txt", ";"&@UserName&";"&@ComputerName&";"&" Probleme pour "&$OmegaPath&"Omega.exe avec l erreur:")		     
		 Exit(1)
	  EndIf	
	  WinWait("[CLASS:TFrmMenu]")
   Else
	     $pid = ProcessExists("Omega.exe")
   EndIf
	  
   $titreOmega = WinGetTitle("[CLASS:TFrmMenu]", "")
   if Not( StringInStr( $titreOmega, "MEPAPP042_R") )Then
	  Exit
   EndIf
   
   WinSetState("[CLASS:TFrmMenu]","",@SW_MAXIMIZE)
   WinActivate("[CLASS:TFrmMenu]")
   ConsoleWrite("Fenetre Principale Omega Disponible"&@CRLF)
   ; recuperation de la position relative du noeud Par Groupe afin de double clicker sur ce noeud
   Local $hHandle = ControlGetHandle("[CLASS:TFrmMenu]", "", "[CLASS:TDataListView; INSTANCE:1]")

   Local $pos = WinGetPos($hHandle,"")
   MouseMove($pos[0]+$pos[2]/2, $pos[1]+$pos[3]/2)
   ControlClick("[CLASS:TFrmMenu]","","[CLASS:TDataListView; INSTANCE:1]","right")   
   
   MouseClick("left", $pos[0]+$pos[2]/2+70, $pos[1]+$pos[3]/2+65, 1)
   ControlClick("[CLASS:#32770]","","[CLASS:ComboBox; INSTANCE:2]")
   Send($VersionPath&"OMEGA_RECETTE092012.bmp")
   Send("{ENTER}")
   WinSetState("[CLASS:TFrmMenu]","",@SW_MINIMIZE)
EndFunc

;===================================================================================================================================
;=====================================================BOUTON QUITTER ===============================================================
;===================================================================================================================================
Func CLOSEClicked()
  ;Note: at this point @GUI_CTRLID would equal $GUI_EVENT_CLOSE, 
  ;and @GUI_WINHANDLE would equal $mainwindow 
  Exit
EndFunc