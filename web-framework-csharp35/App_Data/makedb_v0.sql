--
-- @Decription: 
--   This T-SQL script create a default database for the Ci35 C#.NET project.
--   If the database already exists, it will be dropped and recreated from scratch.
-- @Usage: sqlcmd -E -b -S localhost -i makedb.sql
--   
-- @Help: Use sqlcmd /? to see meaning of switches. 
--   -E: trusted connection
--   -b: On error batch abort
--   -S: server
--   -i: input file
--   -o: output file
--   -e: echo input
--   -v var="value" ...: input parameter.
--
-- @Created by: X.C.
-- @First created on: 6/20/2013
-- @Last modified on: 6/20/2013
--
-- Reference:
-- - Create a database in T-SQL:
--   http://msdn.microsoft.com/en-us/library/ms176061.aspx
-- - Database recovery mode:
--   http://msdn.microsoft.com/en-us/library/ms189272.aspx
--

:setvar dbname "CI35"


--
-- Create database.
--

USE MASTER
GO

DECLARE @DB AS sysname --= 'CI35' -- '$(DB)': DB is specified in bat file as command line parameter.
DECLARE @sql as nvarchar(1024)

set @DB = '$(dbname)' --'CI35'

-- DROP DATABASE if exists.
IF EXISTS (SELECT * FROM sys.databases WHERE name = @DB)
BEGIN
    PRINT 'Database $(dbname) already exists. '
    --PRINT 'Abort.'
    --RETURN
    --ALTER DATABASE $(dbname) SET OFFLINE WITH ROLLBACK IMMEDIATE   -- This does not work.
    ALTER DATABASE $(dbname) SET SINGLE_USER WITH ROLLBACK IMMEDIATE -- close connections.
    
    SET @sql = N'DROP DATABASE ' + @DB -- 'N' not needed here since @sql is declared as nvarchar.
    EXECUTE sp_executesql @sql
    PRINT 'Database ' + @DB + ' dropped'
END

-- CREATE DATABASE if not already exists.
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = @DB)
BEGIN
    SET @sql = N'CREATE DATABASE ' + @DB
    EXECUTE sp_executesql @sql
    PRINT 'Database ' + @DB + ' created'
END

-- ALTER DATABASE CI35 SET RECOVERY SIMPLE -- simple/full/bulk-logged.
--SET @sql = N'ALTER DATABASE ' + @DB + N' SET RECOVERY SIMPLE'
--EXECUTE sp_executesql @sql
ALTER DATABASE $(dbname) SET RECOVERY SIMPLE


--
-- Create tables in the database.
--

-- Change current database to the new database.
USE $(dbname)
GO

IF OBJECT_ID('User', 'U') IS NOT NULL 
    DROP TABLE [User]
GO
CREATE TABLE [User] (
    ID         int NOT NULL IDENTITY(1, 1), -- AUTO_INCREMENT,
    first_name varchar(50) NOT NULL,
    last_name  varchar(50) NOT NULL,
    email      varchar(100) NOT NULL,
    login      varchar(50) NOT NULL UNIQUE,
    passwd     varchar(32) NOT NULL,             -- MD5 value, 32 bits.
    note       varchar(50),
    gid        int NOT NULL DEFAULT 1            -- UserGroup ID.
    CONSTRAINT PK_User PRIMARY KEY CLUSTERED  (ID)
)
GO
-- OR: ALTER TABLE [User] ADD ID int NOT NULL IDENTITY (1,1) PRIMARY KEY


IF OBJECT_ID('UserGroup', 'U') IS NOT NULL 
    DROP TABLE [UserGroup]
GO
CREATE TABLE [UserGroup] (
    ID int NOT NULL PRIMARY KEY,
    [name] varchar(20) -- 'group' is a reserved word.
)
GO


--
-- This table can be used to construct view/edit form.
-- Could use result from "show columns from [table]", but title is the same as field name.
-- Use ` to delimit reserved words.
--
IF OBJECT_ID('Schema_TblCol', 'U') IS NOT NULL 
    DROP TABLE [Schema_TblCol]
GO
CREATE TABLE [Schema_TblCol] (
    ID        int NOT NULL IDENTITY(1, 1),
    TableName varchar(100) NOT NULL,
    Title     varchar(100),
    Field     varchar(100) NOT NULL,
    Type      varchar(100) NOT NULL,
    [Null]    varchar(100),
    [Key]     varchar(100),
    [Default] varchar(100),
    Extra     varchar(100),
    --CONSTRAINT PK_Schema_TblCol PRIMARY KEY CLUSTERED  (ID)
    CONSTRAINT PK_Schema_TblCol_TableName_Field PRIMARY KEY CLUSTERED ([TableName], [Field])
)
GO

