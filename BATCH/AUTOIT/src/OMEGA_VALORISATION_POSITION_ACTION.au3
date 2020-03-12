;
; AutoIt Version: 3.0
; Author:         Guillaume COMPAGNON
;
; Script Function:
;   Ouverture d OMEGA et lancement des Valorisations Sauvegardées sur les groupes OO et MO
;
#include <Date.au3>
#include <Excel.au3>
#include "include/LOGIN_PROPERTIES.au3"
;==================================================================================================

ConsoleWrite(@CRLF&"Execution d extraction/valo automatique OMEGA compte:"& $sGroup&"\"&$sUserName&@CRLF)

; 
; prendre la date d aujourd hui
Local $sNewDate =  _NowCalcDate()
; utiliser une librairie externe pour formatter en JJ/MM/AAAA
Local $sEngagDate =   _DateTimeFormat($sNewDate, 2) ;$sEngagDate = StringReplace($sEngagDate,"/","")
Local $sNowDate =   StringReplace(_NowCalcDate(),"/","")
Local $sdate = StringReplace($sEngagDate,"/","")

; Demarrer Omega
$pid = GoOmega()

;=================================BASE_OBLIG MANDATS===(VALORISATION)=================================================
Local $group = "TA"
Local $SavePath1 = $SavePath & "\ACTION\SUIVI_MANDAT\" & $sNowDate & "\" 
DirCreate($SavePath1)
If( @error ) Then
   ConsoleWrite("ERREUR"&@CRLF&"Impossible de creer le repertoire destination: "&$SavePath1);
   Exit 1
EndIf
ConsoleWrite("declenchement de la Valorisation pour le groupe :"&$group&" a la date "&$sEngagDate&@CRLF)
ValorisationGroupe($group,$sEngagDate)
ConsoleWrite("Valorisation Finie:"&$group&" a la date "&$sEngagDate&@CRLF)
;==================================================================================================
Local $sFilePath1 = $SavePath1 & "Base_Action_"&$sdate&".xls" 
ConsoleWrite("Export Detail dans "&$sFilePath1&@CRLF)
ExportValorisationGroupe($sFilePath1)


;=================================BASE_OBLIG OPCVM===(VALORISATION)=================================================
Local $group = "OP"
Local $SavePath2 = $SavePath & "\ACTION\SUIVI_OPCVM\" & $sNowDate & "\" 
DirCreate($SavePath2)
If( @error ) Then
   ConsoleWrite("ERREUR"&@CRLF&"Impossible de creer le repertoire destination: "&$SavePath2);
   Exit 1
EndIf

ConsoleWrite("declenchement de la Valorisation pour le groupe :"&$group&" a la date "&$sEngagDate&@CRLF)
ValorisationGroupe($group,$sEngagDate)
ConsoleWrite("Valorisation Finie:"&$group&" a la date "&$sEngagDate&@CRLF)
;==================================================================================================
Local $sFilePath2 = $SavePath2 & "Base_Action_"&$sdate&".xls" 
ConsoleWrite("Export Detail dans "&$sFilePath1&@CRLF)
ExportValorisationGroupe($sFilePath2)
;==================================================================================================
WinClose("[CLASS:TFrmEtValoGroupe]")

;*********************************************FIN********************************************************************
;*********************************************FIN********************************************************************
Exit


;************************************** EXECUTION DE LA VALORISATION ************************************************
; Ouverture de la fenetre de Valorisation par groupe et execution de la valo sauvegardee
; Param: $Groupe : code du groupe 
;        $sEngagDate 
; retour :  fenetre de la valorisation et $pid
Func ValorisationGroupe($Groupe, $sEngagDate)
   
   ; ouvrir la fenetre de la valrisation
   If( not WinExists("[CLASS:TFrmEtValoGroupe]") ) Then
	  ; Etendre le noeud Omega
	  ControlTreeView("[CLASS:TFrmMenu]","","[CLASS:TMenuTreeView; INSTANCE:1]","Expand","#0")
	  ; Noeud Valorisation Positions
	  ControlTreeView("[CLASS:TFrmMenu]","","[CLASS:TMenuTreeView; INSTANCE:1]","Expand","#0|#4")
	  ; Noeud Valorisations
	  ControlTreeView("[CLASS:TFrmMenu]","","[CLASS:TMenuTreeView; INSTANCE:1]","Expand","#0|#4|#0")
	  ; Noeud Par Groupe
	  ControlTreeView("[CLASS:TFrmMenu]","","[CLASS:TMenuTreeView; INSTANCE:1]","Expand","#0|#4|#0|#2")
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
	  MouseClick("left", $TreeView[0]+127, $TreeView[1]+155, 2)
	  Sleep(500)
	  
	  ; fermer les noeuds du treeview
	  ; Noeud Valorisation Positions
	  ControlTreeView("[CLASS:TFrmMenu]","","[CLASS:TMenuTreeView; INSTANCE:1]","Collapse","#0|#4")
	  ; Noeud Valorisations
	  ControlTreeView("[CLASS:TFrmMenu]","","[CLASS:TMenuTreeView; INSTANCE:1]","Collapse","#0|#4|#0")
	  ; Noeud Par Groupe
	  ControlTreeView("[CLASS:TFrmMenu]","","[CLASS:TMenuTreeView; INSTANCE:1]","Collapse","#0|#4|#0|#2")

	  
	  ;La fenetre de valorisation s ouvre
	  WinWait("[CLASS:TFrmEtValoGroupe]")	  
   EndIf   
   ConsoleWrite("Fenetre Valorisation disponible"&@CRLF)
   ; si le bouton Detail n est pas actif/est gris , lancer la valorisation (et aussi si le groupe utilisée n est pas celui demandée)
   If( not ControlCommand("[CLASS:TFrmEtValoGroupe]","","[CLASS:TButton; INSTANCE:3]", "IsEnabled") or ControlGetText("[CLASS:TFrmEtValoGroupe]", "", "[CLASS:TMaskEdit; INSTANCE:5]")<> $Groupe ) Then
	  ConsoleWrite("Declenchement de la Valorisation"&@CRLF)
	  ; Taper le code du groupe dans la case (MO / Mandats Obligataires par exemple ou OO / OPCVM Obligataires)
	  ControlSetText("[CLASS:TFrmEtValoGroupe]", "", "[CLASS:TMaskEdit; INSTANCE:6]",$Groupe)
	  ; mettra la date (avec le format JJ/MM/AAAA
	  ControlSetText("[CLASS:TFrmEtValoGroupe]", "", "[CLASS:TMaskEdit; INSTANCE:7]",$sEngagDate)

	  ; Selectionner la methode de valorisation: Sauvegardée
	  ControlClick("Par groupe ...", "Sauvegardée", "[CLASS:TGroupButton; INSTANCE:6]")

	  ;Click sur le bouton Valorisation   
	  ControlClick("Par groupe ...", "&Valorisation", "[CLASS:TButton; INSTANCE:8]")
	  WinWaitActive("[CLASS:TFrmEtValoGroupe]")
	  While Not ControlCommand("[CLASS:TFrmEtValoGroupe]","","[CLASS:TButton; INSTANCE:3]", "IsEnabled")
	    ;Attente de la fin du traitement
		Sleep( 5000)
	  WEnd 
   EndIf
   ConsoleWrite("Valorisation FINIE"&@CRLF)
   
EndFunc
;**************************************FIN EXECUTION DE LA VALORISATION ************************************************



;************************************** EXPORT DU DETAIL DE VALORISATION ************************************************
; Ouverture de la fenetre detail pour faire un export
; Param: $sFilePath : chemin complet du fichier
; retour :  rien
Func ExportValorisationGroupe($sFilePath)
; ouvrir la fenetre du detail de valorisation
If( not WinExists("[CLASS:TFrmDetValoGrp]") ) Then
   Sleep(1000)   
   ConsoleWrite("Fenetre detail de valorisation en cours"&@CRLF)
   ;Click sur le bouton detail
   ControlClick("[CLASS:TFrmEtValoGroupe]", "&Détail", "[CLASS:TButton; INSTANCE:3]")
   Sleep(1000)
   ;Attente de la fin du traitement
   WinWait("[CLASS:TFrmDetValoGrp]")
EndIf

ConsoleWrite("Detail de la valorisation disponible"&@CRLF)


While Not WinExists("[CLASS:TFRMDUALLIST]")
   Sleep(5000)
  ConsoleWrite("Click Droit sur la Datagrid pour Exporter "&@CRLF)
  WinActivate("[CLASS:TFrmDetValoGrp]")
  ; recuperation de la position relative de l ecran Detail de valorisation par groupe
  Local $hHandleValo = ControlGetHandle("[CLASS:TFrmDetValoGrp]", "", "[CLASS:TFinoDDBGrid; INSTANCE:1]")
  ; position sur le tree view, 	$array[0] = X position $array[1] = Y position $array[2] = Width $array[3] = Height
  Local $DataGrid = WinGetPos($hHandleValo,"")
  ;Local $DataGrid = ControlGetPos("[CLASS:TFrmDetValoGrp]", "", "[CLASS:TFinoDDBGrid; INSTANCE:1]")
  ;Exporter
  MouseClick("right", $DataGrid[0]+127, $DataGrid[1]+155, 1)   
  Sleep(300)
  ;click sur exporter
  MouseClick("left", $DataGrid[0]+137, $DataGrid[1]+165, 1)
  Sleep(500)
Wend

ConsoleWrite("Exporter disponible"&@CRLF)
WinActivate("[CLASS:TFRMDUALLIST]")

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
Sleep(500)
if(WinExists("[CLASS:#32770]"))Then ; il y a une fenetre pour demander la confirmation pour ecraser un fichier existant: mettre OUI
   ConsoleWrite("Fichier excel Ecrase "& @CRLF)
   WinActivate("[CLASS:#32770]","Microsoft Office Excel")
   Sleep(500)
   send("{TAB}{ENTER}")
   ;ControlClick("[CLASS:#32770]","Microsoft Office Excel","[CLASS:Button; INSTANCE:1]","left",1)
EndIf
ConsoleWrite("Fichier excel Sauve dans "&$sFilePath&@CRLF)
WinClose("[CLASS:XLMAIN]")
; fermeture de la fenetre detail
WinClose("[CLASS:TFrmDetValoGrp]")

; fermeture de la fenetre valo
WinClose("[CLASS:TFrmEtValoGroupe]")
EndFunc
;************************************** FIN EXPORT DU DETAIL DE VALORISATION ************************************************
