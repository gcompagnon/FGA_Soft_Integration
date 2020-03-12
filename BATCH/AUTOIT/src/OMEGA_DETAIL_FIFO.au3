;
; AutoIt Version: 3.0
; Author:         Guillaume COMPAGNON
;
; Script Function:
;   Ouverture d OMEGA et lancement des Valorisations Sauvegardées sur les groupes 
;
#RequireAdmin
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

;=================================DETAIL FIFO MANDATS==================================================
Local $group = "MO"
Local $SavePath1 = $SavePath & "\TAUX\SUIVI_MANDAT\" & $sNowDate & "\" 
DirCreate($SavePath1)
If( @error ) Then
   ConsoleWrite("ERREUR"&@CRLF&"Impossible de creer le repertoire destination: "&$SavePath1);
   _FileWriteLog($LogPath,"ERREUR"&@CRLF&"Impossible de creer le repertoire destination: "&$SavePath1);
   Exit 1
EndIf
Local $sFilePath1 = $SavePath1 & "Detail_Fifo_"&$sdate&".xls" 

ConsoleWrite("declenchement de la sortie Detail FIFO pour le groupe :"&$group&" a la date "&$sEngagDate&@CRLF)
_FileWriteLog($LogPath,"declenchement de la sortie Detail FIFO pour le groupe :"&$group&" a la date "&$sEngagDate&@CRLF)
DetailFifo($group,$sEngagDate)

; Mettre une attente en dur: car rien ne permet de detecter la fin du traitement
Sleep(60000)
Local $traitement_En_Cours = True
Local $nbIO_En_Cours = 0
While $traitement_En_Cours
 Sleep(20000)	  
 Local $IO= ProcessGetStats($pid,1)
 ConsoleWrite("DEBUG"&@CRLF&$pid&" "&$IO&" "&$nbIO_En_Cours&@CRLF)
 ;_FileWriteLog($LogPath,"DEBUG"&@CRLF&$pid&" "&$IO&" "&$nbIO_En_Cours&@CRLF) 
 if( $IO[2] == $nbIO_En_Cours ) Then
	$traitement_En_Cours = False
 EndIf 
 $nbIO_En_Cours = $IO[2] 
Wend


ExporterDetailFifo($sFilePath1)
ConsoleWrite("DETAIL FIFO Finie:"&$group&" a la date "&$sEngagDate&@CRLF)
_FileWriteLog($LogPath,"DETAIL FIFO Finie:"&$group&" a la date "&$sEngagDate&@CRLF)
;====================================FIN =================================================
FileCopy ( $sFilePath1,"\\vill1\Partage\,FGA Gestion Taux\OMEGA\FIFO\detailfifo.xls",1)

;*********************************************FIN********************************************************************
Exit

;************************************** EXECUTION DE DETAIL FIFO ************************************************
; Ouverture de la fenetre dans Assurance, pour le detail FIFO
; Param: $Groupe : code du groupe 
; Param: $sEngagDate date engagement (NOW+ qqs jours)
; retour :  fichier detail Fifo
Func DetailFIFO($Groupe,$sEngagDate)
   
   ; ouvrir la fenetre du detail fifo
   If( not WinExists("[CLASS:TFrmJourPos1]") ) Then
	  ; Etendre le noeud Omega
	  ControlTreeView("[CLASS:TFrmMenu]","","[CLASS:TMenuTreeView; INSTANCE:1]","Expand","#0")
 	  ; Noeud Assurance
	  ControlTreeView("[CLASS:TFrmMenu]","","[CLASS:TMenuTreeView; INSTANCE:1]","Expand","#0|#12")

      ; recuperation de la position relative du noeud Par Groupe afin de double clicker sur ce noeud
	  Local $hHandle = ControlGetHandle("[CLASS:TFrmMenu]", "", "[CLASS:TMenuTreeView; INSTANCE:1]")
	  ; position sur le tree view, 	$array[0] = X position $array[1] = Y position $array[2] = Width $array[3] = Height
	  Local $TreeView = WinGetPos($hHandle,"")
   
	  ;Local $TreeView = ControlGetPos("[CLASS:TFrmMenu]", "", "[CLASS:TMenuTreeView; INSTANCE:1]")	  
	  ConsoleWrite("Position du TreeView "&$TreeView[0] & " " & $TreeView[1] & " " & $TreeView[2] & " " & $TreeView[3]&@CRLF)
	  _FileWriteLog($LogPath,"Position du TreeView "&$TreeView[0] & " " & $TreeView[1] & " " & $TreeView[2] & " " & $TreeView[3]&@CRLF)
	  if @error=1 Then  
		 Exit 1;  
	  EndIf  
	  ; Double click sur Par Groupe
	  MouseClick("left", $TreeView[0]+114, $TreeView[1]+298, 2)
 	  ; Noeud Assurance
	  ControlTreeView("[CLASS:TFrmMenu]","","[CLASS:TMenuTreeView; INSTANCE:1]","Collapse","#0|#12")

	  Sleep(500)
	  ;La fenetre de l etat des liquidités s ouvre
	  WinWait("[CLASS:TFrmJourPos1]")	  
   EndIf   
   
   	; Taper le code du groupe dans la case (MO / Mandats Obligataires par exemple ou OO / OPCVM Obligataires)
	ControlSetText("[CLASS:TFrmJourPos1]", "", "[CLASS:TEdit; INSTANCE:1]",$Groupe)
	
   	; Taper le numero de compte pour avoir l ensemble des comptes du groupe ( les comptes vont de '0001031' à 'TEST 4' 
	ControlSetText("[CLASS:TFrmJourPos1]", "", "[CLASS:TMaskEdit; INSTANCE:3]","0001031")
	ControlSetText("[CLASS:TFrmJourPos1]", "", "[CLASS:TEdit; INSTANCE:2]","TEST 4")
	
   	; Taper le numero de compte pour avoir l ensemble des comptes du groupe ( les comptes vont de '0001031' à 'TEST 4' 
	ControlSetText("[CLASS:TFrmJourPos1]", "", "[CLASS:TMaskEdit; INSTANCE:4]",$sEngagDate)

   ; recuperation de la position relative du bouton GO
   ConsoleWrite("GO pour l etat"&@CRLF)
   _FileWriteLog($LogPath,"GO pour l etat"&@CRLF)
   Local $hHandleValo = ControlGetHandle("[CLASS:TFrmJourPos1]", "", "[CLASS:TFinoToolBar; INSTANCE:1]")
   Local $Panel = WinGetPos($hHandleValo,"")
   MouseClick("left", $Panel[0]+218, $Panel[1]+17, 1)
   
   ; attendre la fin du calcul 
   WinWaitActive("[CLASS:TFrmJourPos1]")
   ; Non fiable car le calcul continue
   
 
   
EndFunc
;************************************** FIN DE DETAIL FIFO ************************************************      
;************************************** EXPORT DE DETAIL FIFO ************************************************
; Ouverture de la fenetre dans Assurance, pour le detail FIFO
; Param: $sFilePath : chemin vers le fichier pour la sauvegarde
; retour :  fichier detail Fifo
Func ExporterDetailFIFO($sFilePath)
   ConsoleWrite("Exporter dans"&$sFilePath&@CRLF)
   _FileWriteLog($LogPath,"Exporter dans"&$sFilePath&@CRLF)
   
   WinActivate("[CLASS:TFrmJourPos1]")
   ; recuperation de la position relative de l ecran Detail de valorisation par groupe
   Local $hHandleValo = ControlGetHandle("[CLASS:TFrmJourPos1]", "", "[CLASS:TFinoDDBGrid; INSTANCE:1]")
   ; position sur le tree view, 	$array[0] = X position $array[1] = Y position $array[2] = Width $array[3] = Height
   Local $DataGrid = WinGetPos($hHandleValo,"")
   ;Local $DataGrid = ControlGetPos("[CLASS:TFrmDetValoGrp]", "", "[CLASS:TFinoDDBGrid; INSTANCE:1]")
   MouseClick("right", $DataGrid[0]+127, $DataGrid[1]+155, 1)
   Sleep(300)
   ;click sur exporter
   MouseClick("left", $DataGrid[0]+137, $DataGrid[1]+165, 1)

   ConsoleWrite("Exporter disponible"&@CRLF)
   _FileWriteLog($LogPath,"Exporter disponible"&@CRLF)
   WinWaitActive("[CLASS:TFRMDUALLIST]")
   
   ; recuperation de la position relative de l ecran Liste des colonnes pour selectionner toutes les colonnes
   ConsoleWrite("Selectionner toutes les colonnes"&@CRLF)
   _FileWriteLog($LogPath,"Selectionner toutes les colonnes"&@CRLF)
   Local $hHandleValo = ControlGetHandle("[CLASS:TFRMDUALLIST]", "", "[CLASS:TPanel; INSTANCE:1]")
   Local $Panel = WinGetPos($hHandleValo,"")
   MouseClick("left", $Panel[0]+310, $Panel[1]+125, 1)
   
   ConsoleWrite("Exporter excel"&@CRLF)
   _FileWriteLog($LogPath,"Exporter excel"&@CRLF)
   Local $hHandleValo = ControlGetHandle("[CLASS:TFRMDUALLIST]", "", "[CLASS:TToolBar; INSTANCE:1]")
   Local $ToolBar = WinGetPos($hHandleValo,"")
   MouseClick("left", $ToolBar[0]+146, $ToolBar[1]+18, 1)

   ;Attente de la fin du traitement: excel s ouvre
   WinWaitActive("Microsoft Excel - Feuil1")
   ConsoleWrite("Fichier excel disponible @error="&@error&@CRLF)   
   _FileWriteLog($LogPath,"Fichier excel disponible @error="&@error&@CRLF)
   Local $title = WinGetTitle("[active]")
   Local $HandleExcel = ControlGetHandle($title, "", "[CLASS:MsoCommandBar; INSTANCE:3]")
   Local $ExcelPos = WinGetPos($HandleExcel)

   ;Local $oExcel = _ExcelBookOpen($sFilePath1)
   ConsoleWrite("Sauvegarde du fichier excel dans "&$sFilePath&@CRLF)
   _FileWriteLog($LogPath,"Sauvegarde du fichier excel dans "&$sFilePath&@CRLF)
   MouseClick("left", $ExcelPos[0]+68, $ExcelPos[1]+13, 1)
   WinWaitActive("[CLASS:bosa_sdm_XL9]")
   ControlSetText("[CLASS:bosa_sdm_XL9]", "Enregistrer sous", "[CLASS:RichEdit20W; INSTANCE:2]",$sFilePath)
   Send("{ENTER}")
   if(WinExists("[CLASS:#32770]"))Then ; il y a une fenetre pour demander la confirmation pour ecraser un fichier existant: mettre OUI
      ConsoleWrite("Fichier excel Ecrase "& @CRLF)
	  _FileWriteLog($LogPath,"Fichier excel Ecrase "& @CRLF)
      Sleep(300)
      send("{TAB}{ENTER}")
      ControlClick("[CLASS:#32770]","Microsoft Office Excel","[CLASS:Button; INSTANCE:1]","left",1)
   EndIf
   ConsoleWrite("Fichier excel Sauve dans "&$sFilePath&@CRLF)
   _FileWriteLog($LogPath,"Fichier excel Sauve dans "&$sFilePath&@CRLF)
   WinClose("[CLASS:XLMAIN]")
   ; fermeture de la fenetre detail fifo
   WinClose("[CLASS:TFrmJourPos1]")
   
   ConsoleWrite("Fenetre Detail FIFO fermee"&@CRLF)
   _FileWriteLog($LogPath,"Fenetre Detail FIFO fermee"&@CRLF)
EndFunc
;************************************** FIN DE DETAIL FIFO ************************************************      