@echo off
REM *************** Backup des repositories Subversion (tous les codes sources des projets FGA) sur le réseau **************

set REPO_DIR=C:\FGA_SOFT_INTEGRATION\csvn\data\repositories
REM ne pas utiliser les pseudos lecteurs pour les partages réseau (surtout si la tache est planifiée hors d une session
set DESTINATION=\\vill1\partage\,FGA Soft\DEVELOPPEMENT\SubVersion_repositories
set ZIP=c:\LOgiciel\7-Zip\7z.exe

REM ************************************************************************************************************************

SET YYYYMMDD=%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%
REM inverse la variable %DATE% pour obtenir une date en Année mois jour bien plus facile à trier

for /F "tokens=1,2,3,4,5,6 delims==:.-/, " %%A in ("%TIME%") do SET MYTIME=%%A%%B%%C%%D%%E%%F
REM cette boucle permet de filtrer la variable %TIME% afin d'en éliminer tout caractère indésirable
REM dans un nom de fichier. On suppose que %TIME% se divise en 6 parties délimitées par [:.-/, ].
REM le nombre de parties et les délimiteurs n'ont pas à être exactes, il suffit qu'ils couvrent  
REM le problème.
     

REM creation du répertoire de backup
mkdir "%DESTINATION%\%YYYYMMDD%_%MYTIME%"


cd %REPO_DIR%
REM pour tous les repositories:
FOR /D %%i IN (*) do (

REM sauvegarde Repository sans les logs inutiles
svnadmin hotcopy %REPO_DIR%\%%i "%DESTINATION%\%YYYYMMDD%_%MYTIME%\%%i" --clean-logs

echo  "%REPO_DIR%\%%i dans"
echo "%DESTINATION%\%YYYYMMDD%_%MYTIME%\%%i"
)

REM ************************************************************************************************************************
REM compression

echo "ZIP de %DESTINATION%\%YYYYMMDD%_%MYTIME%\*"
%ZIP% a "%DESTINATION%\%YYYYMMDD%_%MYTIME%.zip" "%DESTINATION%\%YYYYMMDD%_%MYTIME%\*"

if not exist "%DESTINATION%\%YYYYMMDD%_%MYTIME%.zip" goto end
rmdir /s /q "%DESTINATION%\%YYYYMMDD%_%MYTIME%

REM ************************************************************************************************************************


:end
echo 0



