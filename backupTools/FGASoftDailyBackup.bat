@echo off
REM *************** Backup de la base mantis (toutes les demandes des projets FGA) sur le r�seau **************


REM set BACKUP_DIR=C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Backup
set BACKUP_DIR=\\Mepapp042_r\Partage\
REM ne pas utiliser les pseudos lecteurs pour les partages r�seau (surtout si la tache est planifi�e hors d une session
set DESTINATION=\\vill1\partage\,FGA Soft\DEVELOPPEMENT\FGA_SOFT_BASE
set BACKUPSCRIPT=C:\FGA_SOFT_INTEGRATION\backupTools\FGASoft_sqlserverBackup.sql 

SET YYYYMMDD=%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%
REM inverse la variable %DATE% pour obtenir une date en Ann�e mois jour bien plus facile � trier

for /F "tokens=1,2,3,4,5,6 delims==:.-/, " %%A in ("%TIME%") do SET MYTIME=%%A%%B%%C%%D%%E%%F
REM cette boucle permet de filtrer la variable %TIME% afin d'en �liminer tout caract�re ind�sirable
REM dans un nom de fichier. On suppose que %TIME% se divise en 6 parties d�limit�es par [:.-/, ].
REM le nombre de parties et les d�limiteurs n'ont pas � �tre exactes, il suffit qu'ils couvrent  
REM le probl�me.
     

REM creation du r�pertoire de backup
REM mkdir "%DESTINATION%\%YYYYMMDD%_%MYTIME%"



sqlcmd.exe -U E2FGABCK -P E2FGABCK -S MEPAPP042_R -d E2DBFGA01 -i %BACKUPSCRIPT% -o "%BACKUP_DIR%\%YYYYMMDD%_messages.txt" -X

REM xcopy "%BACKUP_DIR%" "%DESTINATION%\%YYYYMMDD%_%MYTIME%" /D/E

REM del "%BACKUP_DIR%\*E2DBFGA01.bak"
REM del "%BACKUP_DIR%\%YYYYMMDD%_messages.txt"

REM ************************************************************************************************************************

