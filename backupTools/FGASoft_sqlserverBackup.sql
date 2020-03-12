USE E2DBFGA01;
GO
--------------------------------------------------------------------------------------------------------------
-- Script de backup full pour la base FGA Soft. 
-- Necessite de d�marrer le serveur SQL avec un compte MALAKOFFMEDERIC pour pouvoir ecrire sur les repertoires r�seau ou meme le C:\
-- On fait le choix de laisser le service SQLServer etre d�marr� en tant que NT AUTHORITY\NetworkService
-- et le script .bat d�place le fichier de sauvegarde et les logs sur le r�seau
--------------------------------------------------------------------------------------------------------------

DECLARE @backupFile varchar(255)
--set @backupFile = '\\vill1\partage\,FGA Soft\DEVELOPPEMENT\mantisSqlserverBackup\'+str(year(getdate()),4)+str(month(getdate()),2)+str(day(getdate()),2)+ '_bugtracker.bak'
set @backupFile = '\\Mepapp042_r\Partage\' +str(year(getdate()),4)+str(month(getdate()),2)+str(day(getdate()),2)+ '_E2DBFGA01.bak'

BACKUP DATABASE E2DBFGA01
FILE=N'E2DBFGA01'
--TO DISK = 'bugtracker.Bak'  -- sauvegarde dans C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Backup par defaut
TO DISK = @backupFile 
   WITH FORMAT, -- nouveau fichier
	  INIT, 
      STATS = 20,
      --COMPRESSION,  disponible en SQL SERVER 2008
      MEDIANAME = 'E2DBFGA01_SQLServerBackups',
      NAME = 'File Backup SQL SERVER2005 E2DBFGA01';


-- verification du backup
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N'E2DBFGA01' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'E2DBFGA01' )
if @backupSetId is null begin raiserror(N'�chec de la v�rification. Les informations de sauvegarde pour la base de donn�es ��E2DBFGA01�� sont introuvables.', 16, 1) end
RESTORE VERIFYONLY FROM  
DISK = @backupFile
WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
