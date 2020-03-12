
--------------------------------------------------------------------------------------------------------------
-- Script de creation pour la base Backup FGA Soft. 
-- Necessite de démarrer un serveur SQL avec le compte MALAKOFFMEDERIC pour pouvoir ecrire sur les repertoires réseau ou meme le C:\
-- et pour pouvoir se connecter en authentification "Windows"

-- Ensuite la base doit permettre l authentification Windows ET SQL Server (menu Properties>Security : Server Authentification - SQL Server and Windows Authentification mode

-- MS SQL Server express a comme limite de 4Go max

--------------------------------------------------------------------------------------------------------------
DECLARE @backupDB_NAME varchar(20)
DECLARE @backupDB_PATH varchar(255)
DECLARE @ParmDef nvarchar(500)

set @backupDB_PATH = N'C:\FGA_SOFT\DEVELOPPEMENT\DATA\sqlServerExpress'
set @backupDB_NAME = N'FGA_JMOINS1'

-- configurer la base pour mettre en francais (date format ..)
execute sp_configure 'default language', 2
reconfigure with override

declare @sqlstring nvarchar(500)
set @sqlstring = 
 N'CREATE DATABASE ['+ @backupDB_NAME + N'] '
+N' ON PRIMARY '
+N'( NAME = ''FGA_Data'', FILENAME = '''+  @backupDB_PATH+ N'\FGA_Data.mdf'' , SIZE = 1024MB , MAXSIZE = UNLIMITED, FILEGROWTH = 10% ) '
+N' LOG ON '
+N' ( NAME = ''FGA_Data_log'', FILENAME = '''+ @backupDB_PATH +N'\FGA_Data_log.ldf'' , SIZE = 3136KB , MAXSIZE = 2048GB , FILEGROWTH = 10%) '
+N' COLLATE SQL_Latin1_General_CP1_CI_AS'

--select @sqlstring 
EXECUTE sp_executesql @sqlstring 


-- parametrage des backups complet pourles logs :
set @sqlstring = 
N'ALTER DATABASE ['+@backupDB_NAME+N'] SET RECOVERY FULL'
EXECUTE sp_executesql @sqlstring 


-- parametrage de la compatibilité en SQL Server 2005 :
set @sqlstring = 
N'ALTER DATABASE ['+@backupDB_NAME+N'] SET COMPATIBILITY_LEVEL = 90'
EXECUTE sp_executesql @sqlstring 

set @sqlstring = 
N'use '+@backupDB_NAME+ ' '
+N'CREATE LOGIN E2FGATP WITH PASSWORD = ''E2FGATP25'' '
+N'CREATE USER E2FGATP FOR LOGIN E2FGATP WITH DEFAULT_SCHEMA = dbo '
+N'CREATE LOGIN E2FGALECT WITH PASSWORD = ''E2FGALECT25'' '
+N'CREATE USER E2FGALECT FOR LOGIN E2FGALECT WITH DEFAULT_SCHEMA = dbo '
+N'CREATE LOGIN E2FGABCK WITH PASSWORD = ''E2FGABCK25'' '
+N'CREATE USER E2FGABCK FOR LOGIN E2FGABCK WITH DEFAULT_SCHEMA = dbo '
EXECUTE sp_executesql @sqlstring 


set @sqlstring = 
N'use '+@backupDB_NAME+ ' '
+N'EXECUTE sp_addrolemember ''db_owner'', ''E2FGATP'' '
+N'EXECUTE sp_addrolemember ''db_datareader'', ''E2FGALECT'' '
+N'EXECUTE sp_addrolemember ''db_backupoperator'', ''E2FGABCK'' '
EXECUTE sp_executesql @sqlstring 

-- test que la base a bien été crée
IF( EXISTS (select name from master.sys.databases where
    ( '['+name+']' = @backupDB_NAME or
    name = @backupDB_NAME )))
    PRINT 'OK DATABASE created'


