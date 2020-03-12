@echo off
REM *************** Backup des repositories Subversion (tous les codes sources des projets FGA) sur le r�seau **************

set REPO_DIR=C:\DATA\GIT
set BONOBO_DIR=C:\inetpub\wwwroot
REM ne pas utiliser les pseudos lecteurs pour les partages r�seau (surtout si la tache est planifi�e hors d une session
set DESTINATION=\\vill1\partage\,FGA Soft\DEVELOPPEMENT\GIT_repositories
set ZIP="C:\Program Files (x86)\7-Zip\7z.exe"

REM ************************************************************************************************************************

SET YYYYMMDD=%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%
REM inverse la variable %DATE% pour obtenir une date en Ann�e mois jour bien plus facile � trier

for /F "tokens=1,2,3,4,5,6 delims==:.-/, " %%A in ("%TIME%") do SET MYTIME=%%A%%B%%C%%D%%E%%F
REM cette boucle permet de filtrer la variable %TIME% afin d'en �liminer tout caract�re ind�sirable
REM dans un nom de fichier. On suppose que %TIME% se divise en 6 parties d�limit�es par [:.-/, ].
REM le nombre de parties et les d�limiteurs n'ont pas � �tre exactes, il suffit qu'ils couvrent  
REM le probl�me.
     

REM creation du r�pertoire de backup
mkdir "%DESTINATION%\

REM *******************************************GIT REPOS***********************************************
cd %REPO_DIR%
REM pour tous les repositories:
FOR /D %%i IN (*) do (

REM sauvegarde Repository
 %ZIP% a "%DESTINATION%\%YYYYMMDD%_%MYTIME%_%%i.zip" "%REPO_DIR%\%%i\*"

echo  "%REPO_DIR%\%%i dans "
echo "%DESTINATION%\%YYYYMMDD%_%MYTIME%_%%i.zip"
)

REM ************************************************************************************************************************
REM ******************************************Bonobo Server*********************************************************************
%ZIP% a "%DESTINATION%\%YYYYMMDD%_%MYTIME%_BonoboGitServer.zip" "%BONOBO_DIR%\*"

:end
echo 0



