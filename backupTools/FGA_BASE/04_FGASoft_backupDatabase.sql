--------------------------------------------------------------------------------------------------------------
-- Script de backup full pour la base FGA Soft. 
-- Necessite de démarrer le serveur SQL avec un compte MALAKOFFMEDERIC pour pouvoir ecrire sur les repertoires réseau ou meme le C:\
-- ou de mettre des droits sur le répertoire DATA pour tous les utilisateurs du poste

-- ou on fait le choix de laisser le service SQLServer etre démarré en tant que NT AUTHORITY\NetworkService
-- et le script .bat déplace le fichier de sauvegarde et les logs sur le réseau
--------------------------------------------------------------------------------------------------------------

-- BACKUP DATABASE
DECLARE @backupDB_NAME varchar(20)
set @backupDB_NAME = N'FGA_JMOINS1'


DECLARE @backupFile varchar(255)
--set @backupFile = '\\vill1\partage\,FGA Soft\DEVELOPPEMENT\mantisSqlserverBackup\'+str(year(getdate()),4)+str(month(getdate()),2)+str(day(getdate()),2)+ '_bugtracker.bak'
--set @backupFile = '\\Mepapp042_r\Partage\' +str(year(getdate()),4)+str(month(getdate()),2)+str(day(getdate()),2)+ '_E2DBFGA01.bak'
set @backupFile = 'C:\DATA\' +convert(varchar, getdate(), 112) + '_'+@backupDB_NAME+'.bak'

--BACKUP DATABASE @backupDB_NAME TO DISK= @backupFile WITH INIT

BACKUP DATABASE @backupDB_NAME
--FILE=N'FGA_Data'
--TO DISK = 'bugtracker.Bak'  -- sauvegarde dans C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Backup par defaut
TO DISK = @backupFile 
   WITH FORMAT, -- nouveau fichier
	  INIT, 
      STATS = 20,
      --COMPRESSION, -- disponible en SQL SERVER 2008
      MEDIANAME = 'SQLServerBackups',
      NAME = 'File Backup SQL SERVER2005';


-- verification du backup
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=@backupDB_NAME and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=@backupDB_NAME )
if @backupSetId is null begin raiserror(N'Échec de la vérification. Les informations de sauvegarde pour la base de données « %s » sont introuvables.', 16, 1,@backupDB_NAME) end
RESTORE VERIFYONLY FROM  
DISK = @backupFile
WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
