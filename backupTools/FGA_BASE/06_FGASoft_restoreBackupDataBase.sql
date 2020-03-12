
--------------------------------------------------------------------------------------------------------------
-- Script de restauration pour la base Backup FGA Soft. 

DECLARE @backupDB_NAME varchar(20)
set @backupDB_NAME = N'FGA_JMOINS1'

DECLARE @backupDB_DATE datetime
set @backupDB_DATE = getdate()
set @backupDB_DATE = '07/09/2013'


DECLARE @backupFile varchar(255)
--set @backupFile = '\\vill1\partage\,FGA Soft\DEVELOPPEMENT\mantisSqlserverBackup\'+str(year(getdate()),4)+str(month(getdate()),2)+str(day(getdate()),2)+ '_bugtracker.bak'
--set @backupFile = '\\Mepapp042_r\Partage\' +str(year(getdate()),4)+str(month(getdate()),2)+str(day(getdate()),2)+ '_E2DBFGA01.bak'
set @backupFile = 'C:\DATA\' +convert(varchar, @backupDB_DATE, 112) + '_'+@backupDB_NAME+'.bak'

select @backupFile


-- verification du backup
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=@backupDB_NAME and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=@backupDB_NAME )
if @backupSetId is null begin raiserror(N'Échec de la vérification. Les informations de sauvegarde pour la base de données « %s » sont introuvables.', 16, 1,@backupDB_NAME) end
RESTORE DATABASE @backupDB_NAME FROM  
DISK = @backupFile
WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
