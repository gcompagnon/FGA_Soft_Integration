
--------------------------------------------------------------------------------------------------------------
-- Script de suppression pour la base Backup FGA Soft. 

-- DROP DATABASE
DECLARE @backupDB_NAME varchar(20)
set @backupDB_NAME = N'FGA_JMOINS1'


declare @sqlstring nvarchar(500)
set @sqlstring = 
 N'ALTER DATABASE ['+ @backupDB_NAME + N'] '
+N' SET SINGLE_USER WITH ROLLBACK IMMEDIATE '

--select @sqlstring 
EXECUTE sp_executesql @sqlstring 


set @sqlstring = 
 N'DROP DATABASE ['+ @backupDB_NAME + N'] '
--select @sqlstring 
EXECUTE sp_executesql @sqlstring 

DROP LOGIN E2FGATP
DROP LOGIN E2FGALECT
DROP LOGIN E2FGABCK