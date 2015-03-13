--
-- This script inserts default data to tables in database.
--
-- @By: Tom Chen
-- @Created on: 6/20/2013
-- @Last modified: 6/20/2013
--
-- Reference:
-- - HASHBYTES: Returns the MD2, MD4, MD5, SHA, SHA1, or SHA2 hash of its input.
--   http://msdn.microsoft.com/en-us/library/ms174415.aspx
--

--:setvar dbname "CI35"

USE $(dbname)
GO

--PRINT 'Load data into table User ...'
INSERT INTO [User] (first_name, last_name, email, login, passwd, note, gid) VALUES (
  'Demo', 'Admin', 'txchen@gmail.com', 'admin', HASHBYTES('MD5', 'password'), '', 0
)
INSERT INTO [User] (first_name, last_name, email, login, passwd, note, gid) VALUES (
  'Demo', 'User', 'test@gmail.com', 'user', HASHBYTES('MD5', 'password'), 'Test special char <''>".', 1
)

--PRINT 'Load data into table UserGroup ...'
INSERT INTO UserGroup (ID, [name]) VALUES (0, 'admin')
INSERT INTO UserGroup (ID, [name]) VALUES (1, 'user')

PRINT 'Load data finished.'
GO

--SELECT * FROM [User] GO
