SELECT d.name AS DatabaseName, t.name AS TableName, i.name AS IndexName, ius.*
FROM sys.dm_db_index_usage_stats ius
JOIN sys.databases d ON d.database_id = ius.database_id
JOIN sys.tables t ON t.object_id = ius.object_id
JOIN sys.indexes i ON i.object_id = ius.object_id AND i.index_id = ius.index_id
WHERE d.database_id = db_id()
--AND t.name = 'TABLE_NAME' 
ORDER BY user_updates DESC