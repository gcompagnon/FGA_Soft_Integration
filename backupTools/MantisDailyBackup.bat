@echo off
REM *************** Backup de la base mantis (toutes les demandes des projets FGA) sur le r�seau **************


set BACKUP_DIR=C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Backup
REM ne pas utiliser les pseudos lecteurs pour les partages r�seau (surtout si la tache est planifi�e hors d une session
set DESTINATION=\\vill1\partage\,FGA Soft\DEVELOPPEMENT\mantisSqlserverBackup
set BACKUPSCRIPT=C:\FGA_SOFT_INTEGRATION\backupTools\Mantis_sqlserverBackup.sql 

SET YYYYMMDD=%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%
REM inverse la variable %DATE% pour obtenir une date en Ann�e mois jour bien plus facile � trier

for /F "tokens=1,2,3,4,5,6 delims==:.-/, " %%A in ("%TIME%") do SET MYTIME=%%A%%B%%C%%D%%E%%F
REM cette boucle permet de filtrer la variable %TIME% afin d'en �liminer tout caract�re ind�sirable
REM dans un nom de fichier. On suppose que %TIME% se divise en 6 parties d�limit�es par [:.-/, ].
REM le nombre de parties et les d�limiteurs n'ont pas � �tre exactes, il suffit qu'ils couvrent  
REM le probl�me.
     

REM creation du r�pertoire de backup
mkdir "%DESTINATION%\%YYYYMMDD%_%MYTIME%"



sqlcmd.exe -S FX007119M\SQLEXPRESS -d bugtracker -i %BACKUPSCRIPT% -o "%BACKUP_DIR%\%YYYYMMDD%_messages.txt" -X

xcopy "%BACKUP_DIR%" "%DESTINATION%\%YYYYMMDD%_%MYTIME%" /D/E

del "%BACKUP_DIR%\*bugtracker.bak"
del "%BACKUP_DIR%\%YYYYMMDD%_messages.txt"

REM ************************************************************************************************************************

