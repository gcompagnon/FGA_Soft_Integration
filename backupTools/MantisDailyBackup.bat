@echo off
REM *************** Backup de la base mantis (toutes les demandes des projets FGA) sur le réseau **************


set BACKUP_DIR=C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Backup
REM ne pas utiliser les pseudos lecteurs pour les partages réseau (surtout si la tache est planifiée hors d une session
set DESTINATION=\\vill1\partage\,FGA Soft\DEVELOPPEMENT\mantisSqlserverBackup
set BACKUPSCRIPT=C:\FGA_SOFT_INTEGRATION\backupTools\Mantis_sqlserverBackup.sql 

SET YYYYMMDD=%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%
REM inverse la variable %DATE% pour obtenir une date en Année mois jour bien plus facile à trier

for /F "tokens=1,2,3,4,5,6 delims==:.-/, " %%A in ("%TIME%") do SET MYTIME=%%A%%B%%C%%D%%E%%F
REM cette boucle permet de filtrer la variable %TIME% afin d'en éliminer tout caractère indésirable
REM dans un nom de fichier. On suppose que %TIME% se divise en 6 parties délimitées par [:.-/, ].
REM le nombre de parties et les délimiteurs n'ont pas à être exactes, il suffit qu'ils couvrent  
REM le problème.
     

REM creation du répertoire de backup
mkdir "%DESTINATION%\%YYYYMMDD%_%MYTIME%"



sqlcmd.exe -S FX007119M\SQLEXPRESS -d bugtracker -i %BACKUPSCRIPT% -o "%BACKUP_DIR%\%YYYYMMDD%_messages.txt" -X

xcopy "%BACKUP_DIR%" "%DESTINATION%\%YYYYMMDD%_%MYTIME%" /D/E

del "%BACKUP_DIR%\*bugtracker.bak"
del "%BACKUP_DIR%\%YYYYMMDD%_messages.txt"

REM ************************************************************************************************************************

