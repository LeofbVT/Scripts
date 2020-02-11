--Verificar fragmentação do index.
--USE database;
SELECT DB_NAME() AS banco
	, B.Object_id AS Object_id
	, S.name AS schema_name
	, object_name(B.Object_id) AS nome_tabela
	, B.index_id
	, B.name AS [IndexName]
	, avg_fragmentation_in_percent AS porcentagem
	, 0 AS tipo_execucao
	, CASE  
		WHEN avg_fragmentation_in_percent  > 30 THEN 'ALTER INDEX [' + B.Name + '] ON ['+ S.name +'].[' + object_name(B.Object_id) + '] REBUILD PARTITION = ALL WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, ONLINE = ON, SORT_IN_TEMPDB = OFF );'
		WHEN avg_fragmentation_in_percent <= 30 THEN 'ALTER INDEX [' + B.Name + '] ON ['+ S.name +'].[' + object_name(B.Object_id) + '] REORGANIZE WITH ( LOB_COMPACTION = ON );'
	END AS [sql]
FROM sys.dm_db_index_physical_stats(db_id(),null,null,null,null) A
	JOIN sys.indexes B ON A.object_id = B.Object_id AND A.index_id = B.index_id AND B.name IS NOT NULL
	JOIN sys.tables T ON A.object_id = T.Object_id
	JOIN sys.schemas S ON    T.schema_id = S.schema_id
--WHERE avg_fragmentation_in_percent > 5
ORDER BY nome_tabela 