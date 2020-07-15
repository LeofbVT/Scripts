--***********************************************************
--*** Criar a procedure Move_Index_To_FileGroup.sql antes ***
--***********************************************************

/*Get Details of Object on different filegroup
Finding User Created Tables*/
SELECT o.[name], o.[type], i.[name], i.[index_id], f.[name] FROM sys.indexes i
INNER JOIN sys.filegroups f
ON i.data_space_id = f.data_space_id
INNER JOIN sys.all_objects o
ON i.[object_id] = o.[object_id] WHERE i.data_space_id = f.data_space_id
AND o.type = 'U' -- User Created Tables
--AND o.[name] = 'APPLICATION'
AND f.[name] = 'PRIMARY'
AND i.[name] IS NOT NULL
GO


SELECT 
s.object_id AS [ObjectID]
,OBJECT_NAME(s.object_id) AS [TableName]
,s.index_id AS [IndexID]
,i.name AS [IndexName]
,i.type_desc
FROM sys.dm_db_partition_stats AS s
JOIN sys.indexes i ON s.[object_id] = i.[object_id]
WHERE s.index_id = 0


SELECT 'EXEC MoveIndexToFileGroup '''
    +TABLE_CATALOG+''','''
    +TABLE_SCHEMA+''','''
    +TABLE_NAME+''',NULL,''FG1'';'
    +char(13)+char(10)
    +'GO'+char(13)+char(10)
SELECT TOP 1 *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME;



SELECT 'EXEC MoveIndexToFileGroup '''
    +TABLE_CATALOG+''','''
    +TABLE_SCHEMA+''','''
    +TABLE_NAME+''',NULL,''FG1'';'
    +char(13)+char(10)
    +'GO'+char(13)+char(10)
FROM sys.indexes i
INNER JOIN sys.filegroups f
ON i.data_space_id = f.data_space_id
INNER JOIN sys.all_objects o
ON i.[object_id] = o.[object_id] WHERE i.data_space_id = f.data_space_id
AND o.type = 'U' -- User Created Tables
--AND o.[name] = 'APPLICATION'
AND f.[name] = 'PRIMARY'
AND i.[name] IS NOT NULL
GO
