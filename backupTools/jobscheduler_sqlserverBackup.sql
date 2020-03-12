USE jobscheduler;
GO
--------------------------------------------------------------------------------------------------------------
-- Script de backup full pour la base Jobscheduler. 
-- Necessite de démarrer le serveur SQL avec un compte MALAKOFFMEDERIC pour pouvoir ecrire sur les repertoires réseau ou meme le C:\
-- On fait le choix de laisser le service SQLServer etre démarré en tant que NT AUTHORITY\NetworkService
-- et le script .bat déplace le fichier de sauvegarde et les logs sur le réseau
--------------------------------------------------------------------------------------------------------------

DECLARE @backupFile varchar(255)
--set @backupFile = '\\vill1\partage\,FGA Soft\DEVELOPPEMENT\mantisSqlserverBackup\'+str(year(getdate()),4)+str(month(getdate()),2)+str(day(getdate()),2)+ '_bugtracker.bak'
--set @backupFile = 'C:\Backup\'+convert(varchar(10),GETDATE(),112)+ '_jobscheduler.bak'
set @backupFile = convert(varchar(10),GETDATE(),112)+ '_jobscheduler.bak'


BACKUP DATABASE jobscheduler
--TO DISK = 'bugtracker.Bak'  -- sauvegarde dans C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Backup par defaut
TO DISK = @backupFile 
   WITH FORMAT, -- nouveau fichier
	  INIT, 
      STATS = 20,
      --COMPRESSION,  disponible en SQL SERVER 2008
      MEDIANAME = 'JOBSCHEDULER_SQLServerBackups',
      NAME = 'Full Backup SQL SERVER2005 jobscheduler';


-- verification du backup
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N'jobscheduler' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'jobscheduler' )
if @backupSetId is null begin raiserror(N'Échec de la vérification. Les informations de sauvegarde pour la base de données « jobscheduler » sont introuvables.', 16, 1) end
RESTORE VERIFYONLY FROM  
DISK = @backupFile
WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
