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

; Calcul d une date à J+x
; prendre 5 jours suivant la date aujourd hui
Local $sNewDate = _DateAdd('D', 5, _NowCalcDate())
; utiliser une librairie externe pour formatter en JJ/MM/AAAA
Local $sEngagDate =   _DateTimeFormat($sNewDate, 2) ;$sEngagDate = StringReplace($sEngagDate,"/","")
Local $sNowDate =   StringReplace(_NowCalcDate(),"/","")
Local $sdate = StringReplace($sEngagDate,"/","")

; Demarrer Omega
$pid = GoOmega()

;=================================BASE_LIQUID MANDATS====================================================
Local $group = "MO"
Local $SavePath1 = $SavePath & "\TAUX\SUIVI_MANDAT\" & $sNowDate & "\" 
DirCreate($SavePath1)
If( @error ) Then
   ConsoleWrite("ERREUR"&@CRLF&"Impossible de creer le repertoire destination: "&$SavePath1);
   Exit 1
EndIf
Local $sFilePath1 = $SavePath1 & "Base_Liquid_"&$sdate&".xls" 

ConsoleWrite("declenchement de la sortie Etat des Liquidités pour le groupe :"&$group&" a la date "&$sEngagDate&@CRLF)
EtatDesLiquidites($group,$sFilePath1)
ConsoleWrite("BASE LQUID Finie:"&$group&" a la date "&$sEngagDate&@CRLF)
;=================================BASE_LIQUID OPCVM====================================================

Local $group = "OO"
Local $SavePath2 = $SavePath & "\TAUX\SUIVI_OPCVM\" & $sNowDate & "\" 
DirCreate($SavePath2)
If( @error ) Then
   ConsoleWrite("ERREUR"&@CRLF&"Impossible de creer le repertoire destination: "&$SavePath2);
   Exit 1
EndIf
Local $sFilePath2 = $SavePath2 & "Base_Liquid_"&$sdate&".xls" 

ConsoleWrite("declenchement de la sortie Etat des Liquidités pour le groupe :"&$group&" a la date "&$sEngagDate&@CRLF)
EtatDesLiquidites($group,$sFilePath2)
ConsoleWrite("BASE LQUID:"&$group&" a la date "&$sEngagDate&@CRLF)
;==================================================================================================

; Attent la fin du process
;ProcessWaitClose($pid)
FileCopy ( $sFilePath1,"\\vill1\partage\,FGA Front Office\04_Gestion_Taux\01_Gestion\01_Mandats\SYNTHESE\BASE LIQUID MANDAT.xls", 1)


;*********************************************FIN********************************************************************
Exit

;************************************** EXECUTION DE L ETAT DES LIQUIDITES ************************************************
; Ouverture de la fenetre dans reporting Analyse-Rapport De controle-Etat des liquidités
; Param: $Groupe : code du groupe 
; Param: $sFilePath : chemin vers le fichier pour la sauvegarde
; retour :  fenetre de la valorisation
Func EtatDesLiquidites($Groupe,$sFilePath)
   
   ; ouvrir la fenetre de l etat des liquidites
   If( not WinExists("[CLASS:TFrmEtatLiq]") ) Then
	  ; Etendre le noeud Omega
	  ControlTreeView("[CLASS:TFrmMenu]","","[CLASS:TMenuTreeView; INSTANCE:1]","Expand","#0")
 	  ; Noeud ReportingAnalyses
	  ControlTreeView("[CLASS:TFrmMenu]","","[CLASS:TMenuTreeView; INSTANCE:1]","Expand","#0|#7")
	  ; Noeud Rapport de controles
	  ControlTreeView("[CLASS:TFrmMenu]","","[CLASS:TMenuTreeView; INSTANCE:1]","Expand","#0|#7|#1")

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
	  MouseClick("left", $TreeView[0]+145, $TreeView[1]+282, 2)
 	  ; Noeud ReportingAnalyses
	  ControlTreeView("[CLASS:TFrmMenu]","","[CLASS:TMenuTreeView; INSTANCE:1]","Collapse","#0|#7")
	  ; Noeud Rapport de controles
	  ControlTreeView("[CLASS:TFrmMenu]","","[CLASS:TMenuTreeView; INSTANCE:1]","Collapse","#0|#7|#1")
	  ; Noeud Par Groupe	  
	  Sleep(500)
	  ;La fenetre de l etat des liquidités s ouvre
	  WinWait("[CLASS:TFrmEtatLiq]")	  
   EndIf   
   ConsoleWrite("Fenetre etat des liquidités disponible"&@CRLF)
      
	; Taper le code du groupe dans la case (MO / Mandats Obligataires par exemple ou OO / OPCVM Obligataires)
	ControlSetText("[CLASS:TFrmEtatLiq]", "", "[CLASS:TMaskEdit; INSTANCE:2]",$Groupe)
	  
	;Click sur le bouton de selection des comptes
	ControlClick("[CLASS:TFrmEtatLiq]", "N", "[CLASS:TColorButton; INSTANCE:1]")
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
   Local $hHandleValo = ControlGetHandle("[CLASS:TFrmEtatLiq]", "", "[CLASS:TFinoToolBar; INSTANCE:1]")
   Local $Panel = WinGetPos($hHandleValo,"")
   MouseClick("left", $Panel[0]+218, $Panel[1]+17, 1)
   Sleep(1000)
   ConsoleWrite("Exporter le contenu"&@CRLF)

   If( not WinExists("[CLASS:TFRMDUALLIST]") ) Then   
     WinActivate("[CLASS:TFrmEtatLiq]")
     ; recuperation de la position relative de l ecran Detail de valorisation par groupe
     Local $hHandleValo = ControlGetHandle("[CLASS:TFrmEtatLiq]", "", "[CLASS:TFinoDDBGrid; INSTANCE:1]")
     ; position sur le tree view, 	$array[0] = X position $array[1] = Y position $array[2] = Width $array[3] = Height
     Local $DataGrid = WinGetPos($hHandleValo,"")
     ;Local $DataGrid = ControlGetPos("[CLASS:TFrmDetValoGrp]", "", "[CLASS:TFinoDDBGrid; INSTANCE:1]")
     MouseClick("right", $DataGrid[0]+127, $DataGrid[1]+155, 1)
	 Sleep(300)
     ;click sur exporter
     MouseClick("left", $DataGrid[0]+137, $DataGrid[1]+165, 1)
   EndIf
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
       Sleep(1000)
       send("{TAB}{ENTER}")
       ControlClick("[CLASS:#32770]","Microsoft Office Excel","[CLASS:Button; INSTANCE:1]","left",1)
     EndIf
   ConsoleWrite("Fichier excel Sauve dans "&$sFilePath&@CRLF)
   WinClose("[CLASS:XLMAIN]")

   WinClose("[CLASS:TFrmEtatLiq]")
   ConsoleWrite("Etat des liquidites  FINIE"&@CRLF)
   
EndFunc
;**************************************FIN EXECUTION DE LA etat des liquidites ************************************************
