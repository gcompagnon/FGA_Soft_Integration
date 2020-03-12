rem la date de la veille est mise au format YYMMDD pour correspondre aux fichiers des FTP
rem on utilise un petit script VBS pour plus de robustesse (les changements de mois et d'année)
echo>_.vbs wscript.echo eval("date-7") 
for /f "tokens=*" %%y in ('C:\WINNT\system32\cscript.exe /nologo _.vbs') do (set y=%%y) 
del _.vbs 2>nul
set date=%y:~8,2%%y:~3,2%%y:~0,2%

\\winprodfga\OMEGA\PROD\IntRDT.exe -u:KRG -d1=%y% -h
