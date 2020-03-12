@echo off
REM *************** Backup de la base mantis (toutes les demandes des projets FGA) sur le réseau **************


set TO_BACKUP_DIR=C:\DATA\jobscheduler\fga_js_1\config\live\
set TO_BACKUP_DIR2=C:\FGA_SOFT_INTEGRATION\

set BACKUP_DIR=C:\TEMP
REM ne pas utiliser les pseudos lecteurs pour les partages réseau (surtout si la tache est planifiée hors d une session
set DESTINATION=\\vill1\partage\,FGA Soft\DEVELOPPEMENT\jobschedulerSqlserverBackup

SET YYYYMMDD=%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%
REM inverse la variable %DATE% pour obtenir une date en Année mois jour bien plus facile à trier

for /F "tokens=1,2,3,4,5,6 delims==:.-/, " %%A in ("%TIME%") do SET MYTIME=%%A%%B%%C%%D%%E%%F
REM cette boucle permet de filtrer la variable %TIME% afin d'en éliminer tout caractère indésirable
REM dans un nom de fichier. On suppose que %TIME% se divise en 6 parties délimitées par [:.-/, ].
REM le nombre de parties et les délimiteurs n'ont pas à être exactes, il suffit qu'ils couvrent  
REM le problème.
     

REM creation du répertoire de backup
mkdir "%DESTINATION%\%YYYYMMDD%_%MYTIME%"


"c:\Program Files (x86)\7-Zip\7z.exe" a -t7z %BACKUP_DIR%\live_directory.7z %TO_BACKUP_DIR%
"c:\Program Files (x86)\7-Zip\7z.exe" a -t7z %BACKUP_DIR%\FGA_SOFT_INTEGRATION_TOOLS.7z %TO_BACKUP_DIR2%

xcopy "%BACKUP_DIR%\live_directory.7z" "%DESTINATION%\%YYYYMMDD%_%MYTIME%" /D
xcopy "%BACKUP_DIR%\FGA_SOFT_INTEGRATION_TOOLS.7z" "%DESTINATION%\%YYYYMMDD%_%MYTIME%" /D

del "%BACKUP_DIR%\live_directory.7z"
del "%BACKUP_DIR%\FGA_SOFT_INTEGRATION_TOOLS.7z"

REM ************************************************************************************************************************

