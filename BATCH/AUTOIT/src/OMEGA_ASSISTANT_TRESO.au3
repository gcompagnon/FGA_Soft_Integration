;
; AutoIt Version: 3.0
; Author:         Guillaume COMPAGNON
;
; Script Function:
;   Ouverture d OMEGA et lancement des Valorisations Sauvegardées sur les groupes 
;
#include<Date.au3>
#include <Excel.au3>
#include "include/LOGIN_PROPERTIES.au3"
;==================================================================================================


; Calcul d une date à J+x
; prendre 5 jours suivant la date aujourd hui
Local $sNewDate = _DateAdd('D', 5, _NowCalcDate())
; utiliser une librairie externe pour formatter en JJ/MM/AAAA
Local $sEngagDate =   _DateTimeFormat($sNewDate, 2) ;$sEngagDate = StringReplace($sEngagDate,"/","")
Local $sNowDate =   StringReplace(_NowCalcDate(),"/","")
Local $sdate = StringReplace($sEngagDate,"/","")

; Demarrer Omega
$pid = GoOmega()
;=================================ASSISTANT TRESORERIE==================================================
Local $group = "MO"
; prendre 1 jour suivant la date aujourd hui
Local $sHierDate = _DateAdd('D', -1, _NowCalcDate())
; utiliser une librairie externe pour formatter en JJ/MM/AAAA
Local $sTresoDate =   _DateTimeFormat($sHierDate, 2) ;$sEngagDate = StringReplace($sEngagDate,"/","")

Local $SavePath1 = $SavePath & "\TAUX\SUIVI_MANDAT\" & $sNowDate & "\" 
DirCreate($SavePath1)
If( @error ) Then
   ConsoleWrite("ERREUR"&@CRLF&"Impossible de creer le repertoire destination: "&$SavePath1);
   Exit 1
EndIf
Local $sFilePath1 = $SavePath1 & "assistantTresorerie_"&$sdate&".xls" 

ConsoleWrite("declenchement de la sortie Assitant Tresorie pour le groupe :"&$group&" a la date "&$sTresoDate&@CRLF)
AssistantTresorie($group,$sTresoDate,$sFilePath1)
ConsoleWrite("Assitant Tresorie Finie:"&$group&" a la date "&$sTresoDate&@CRLF)
;==================================================================================================
;=================================ASSISTANT TRESORERIE==================================================
Local $group = "OO"
; prendre 1 jour suivant la date aujourd hui
Local $sHierDate = _DateAdd('D', -1, _NowCalcDate())
; utiliser une librairie externe pour formatter en JJ/MM/AAAA
Local $sTresoDate =   _DateTimeFormat($sHierDate, 2) ;$sEngagDate = StringReplace($sEngagDate,"/","")

Local $SavePath1 = $SavePath & "\TAUX\SUIVI_OPCVM\" & $sNowDate & "\" 
DirCreate($SavePath1)
If( @error ) Then
   ConsoleWrite("ERREUR"&@CRLF&"Impossible de creer le repertoire destination: "&$SavePath1);
   Exit 1
EndIf
Local $sFilePath1 = $SavePath1 & "assistantTresorerie_"&$sdate&".xls" 

ConsoleWrite("declenchement de la sortie Assitant Tresorie pour le groupe :"&$group&" a la date "&$sTresoDate&@CRLF)
AssistantTresorie($group,$sTresoDate,$sFilePath1)
ConsoleWrite("Assitant Tresorie Finie:"&$group&" a la date "&$sTresoDate&@CRLF)
;==================================================================================================

Exit

;************************************** EXECUTION DE Assitant Tresorie ************************************************
; Ouverture de la fenetre dans Transactions, AsistantTresorie
; Param: $Groupe : code du groupe 
; Param: $sTresoDate date utilisée (à priori NOW 1J)
; Param: $sFilePath : chemin vers le fichier pour la sauvegarde
; retour :  fichier detail Fifo
Func AssistantTresorie($Groupe,$sTresoDate,$sFilePath)
   
   ; ouvrir la fenetre du detail fifo
   If( not WinExists("[CLASS:TFrmAssTreso]") ) Then
	  ; Etendre le noeud Omega
	  ControlTreeView("[CLASS:TFrmMenu]","","[CLASS:TMenuTreeView; INSTANCE:1]","Expand","#0")
 	  ; Noeud Assurance
	  ControlTreeView("[CLASS:TFrmMenu]","","[CLASS:TMenuTreeView; INSTANCE:1]","Expand","#0|#3")

      ; recuperation de la position relative du noeud Par Groupe afin de double clicker sur ce noeud
	  Local $hHandle = ControlGetHandle("[CLASS:TFrmMenu]", "", "[CLASS:TMenuTreeView; INSTANCE:1]")
	  ; position sur le tree view, 	$array[0] = X position $array[1] = Y position $array[2] = Width $array[3] = Height
	  Local $TreeView = WinGetPos($hHandle,"")
   
	  ;Local $TreeView = ControlGetPos("[CLASS:TFrmMenu]", "", "[CLASS:TMenuTreeView; INSTANCE:1]")	  
	  ConsoleWrite("Position du TreeView "&$TreeView[0] & " " & $TreeView[1] & " " & $TreeView[2] & " " & $TreeView[3]&@CRLF)
	  if @error=1 Then  
		 Exit 1;  
	  EndIf  
	  ; Double click sur Par Groupe
	  MouseClick("left", $TreeView[0]+118, $TreeView[1]+299, 2)
 	  ; Noeud Assurance
	  ControlTreeView("[CLASS:TFrmMenu]","","[CLASS:TMenuTreeView; INSTANCE:1]","Collapse","#0|#3")

	  Sleep(500)
	  ;La fenetre de l assistant tresorie s ouvre
	  WinWait("[CLASS:TFrmAssTreso]")	  
   EndIf   
   
   	; Taper le code du groupe dans la case (MO / Mandats Obligataires par exemple ou OO / OPCVM Obligataires)
	ControlSetText("[CLASS:TFrmAssTreso]", "", "[CLASS:TMaskEdit; INSTANCE:2]",$Groupe)
	
   	; Taper le numero de compte pour avoir l ensemble des comptes du groupe ( les comptes vont de '0001031' à 'TEST 4' 
	ControlSetText("[CLASS:TFrmAssTreso]", "", "[CLASS:TMaskEdit; INSTANCE:8]",$sTresoDate)

	;Click sur le bouton de selection des comptes
	ControlClick("[CLASS:TFrmAssTreso]", "N", "[CLASS:TColorButton; INSTANCE:2]")
	;Attente de la fin du traitement
	WinWaitActive("[CLASS:TfrmChoixFonds]")	  

   ; recuperation de la position relative de l ecran Liste des fonds pour selectionner tous les fonds
   ConsoleWrite("Selectionner tous les fonds"&@CRLF)
   Local $hHandleValo = ControlGetHandle("[CLASS:TfrmChoixFonds]", "", "[CLASS:TPanel; INSTANCE:2]")
   Local $Panel = WinGetPos($hHandleValo,"")
   MouseClick("left", $Panel[0]+258, $Panel[1]+132, 1)
   WinClose("[CLASS:TfrmChoixFonds]")	  


   ; recuperation de la position relative du bouton GO
   ConsoleWrite("GO pour l etat"&@CRLF)
   Local $hHandleValo = ControlGetHandle("[CLASS:TFrmAssTreso]", "", "[CLASS:TFinoToolBar; INSTANCE:1]")
   Local $Panel = WinGetPos($hHandleValo,"")
   MouseClick("left", $Panel[0]+218, $Panel[1]+17, 1)
   
   ; attendre la fin du calcul 
   WinWaitActive("[CLASS:TFrmAssTreso]")
   While Not ControlCommand("[CLASS:TFrmAssTreso]","","[CLASS:TBitBtn; INSTANCE:3]", "IsEnabled")
	  ;Attente de la fin du traitement
	  Sleep(1000)
   WEnd 
   
      
   ConsoleWrite("Exporter le contenu"&@CRLF)
     WinActivate("[CLASS:TFrmAssTreso]")
     ; recuperation de la position relative de l ecran Detail de valorisation par groupe
     Local $hHandleValo = ControlGetHandle("[CLASS:TFrmAssTreso]", "", "[CLASS:TDBGrid; INSTANCE:1]")
     ; position sur le tree view, 	$array[0] = X position $array[1] = Y position $array[2] = Width $array[3] = Height
     Local $DataGrid = WinGetPos($hHandleValo,"")
     ;Local $DataGrid = ControlGetPos("[CLASS:TFrmDetValoGrp]", "", "[CLASS:TFinoDDBGrid; INSTANCE:1]")
     MouseClick("right", $DataGrid[0]+127, $DataGrid[1]+155, 1)
	 Sleep(300)
     ;click sur exporter
     MouseClick("left", $DataGrid[0]+137, $DataGrid[1]+165, 1)

   ConsoleWrite("Exporter disponible"&@CRLF)
   WinWaitActive("[CLASS:TFRMDUALLIST]")
   
   ; recuperation de la position relative de l ecran Liste des colonnes pour selectionner toutes les colonnes
   ConsoleWrite("Selectionner toutes les colonnes"&@CRLF)
   Local $hHandleValo = ControlGetHandle("[CLASS:TFRMDUALLIST]", "", "[CLASS:TPanel; INSTANCE:1]")
   Local $Panel = WinGetPos($hHandleValo,"")
   MouseClick("left", $Panel[0]+310, $Panel[1]+125, 1)
   
   ConsoleWrite("Exporter excel"&@CRLF)
   Local $hHandleValo = ControlGetHandle("[CLASS:TFRMDUALLIST]", "", "[CLASS:TToolBar; INSTANCE:1]")
   Local $ToolBar = WinGetPos($hHandleValo,"")
   MouseClick("left", $ToolBar[0]+146, $ToolBar[1]+18, 1)

   ;Attente de la fin du traitement: excel s ouvre
   WinWaitActive("Microsoft Excel - Feuil1")
   ConsoleWrite("Fichier excel disponible @error="&@error&@CRLF)   

   Local $title = WinGetTitle("[active]")
   Local $HandleExcel = ControlGetHandle($title, "", "[CLASS:MsoCommandBar; INSTANCE:3]")
   Local $ExcelPos = WinGetPos($HandleExcel)

   ;Local $oExcel = _ExcelBookOpen($sFilePath1)
   ConsoleWrite("Sauvegarde du fichier excel dans "&$sFilePath&@CRLF)

   MouseClick("left", $ExcelPos[0]+68, $ExcelPos[1]+13, 1)
   WinWaitActive("[CLASS:bosa_sdm_XL9]")
   ControlSetText("[CLASS:bosa_sdm_XL9]", "Enregistrer sous", "[CLASS:RichEdit20W; INSTANCE:2]",$sFilePath)
   Send("{ENTER}")
   if(WinExists("[CLASS:#32770]"))Then ; il y a une fenetre pour demander la confirmation pour ecraser un fichier existant: mettre OUI
      ConsoleWrite("Fichier excel Ecrase "& @CRLF)
      Sleep(300)
      send("{TAB}{ENTER}")
      ControlClick("[CLASS:#32770]","Microsoft Office Excel","[CLASS:Button; INSTANCE:1]","left",1)
   EndIf
   ConsoleWrite("Fichier excel Sauve dans "&$sFilePath&@CRLF)
   WinClose("[CLASS:XLMAIN]")
   ; fermeture de la fenetre Assistant Treso
   WinClose("[CLASS:TFrmAssTreso]")
   
   ConsoleWrite("Fenetre Assistant Tresorier fermee"&@CRLF)
   
EndFunc