DROP TABLE hist_fragmentacao_indice
GO 

-- Criando a tabela.

create table [dbo].[hist_fragmentacao_indice](
[id_hit_fragmentacao_indice] [int] IDENTITY(1,1) not null,
[dt_referencia] [datetime] null,
[num_servidor] [varchar](20) null,
[num_database] [varchar](20) null,
[num_tabela] [varchar](50) null,
[num_indice] [varchar](70) null,
[avg_fragmentation_in_percent] [numeric](5, 2) null,
[page_count] [int] null,
[fill_factor] [tinyint] null)
GO

CREATE CLUSTERED INDEX pk_hist_fragmentacao_indice_ID1
ON dbo.hist_fragmentacao_indice(id_hit_fragmentacao_indice)
GO

-- Populando a tabela.

DECLARE @id_db int
SET @id_db = 5
WHILE (SELECT database_id FROM sys.databases WHERE database_id = @id_db) <= 14
	BEGIN

	INSERT INTO DBAs..hist_fragmentacao_indice(dt_Referencia,nome_database,nome_tabela,nome_indice,Avg_Fragmentation_In_Percent,
	Page_Count,Fill_Factor)
	SELECT getdate(), db_name(@id_db), object_name(B.Object_id), B.Name, avg_fragmentation_in_percent,page_Count,fill_factor
	FROM sys.dm_db_index_physical_stats(@id_db,null,null,null,null) A
	join sys.indexes B on a.object_id = B.Object_id and A.index_id = B.index_id
	ORDER BY object_name(B.Object_id), B.index_id
	SET @id_db = @id_db+1


	IF @id_db >= 14
	BREAK
	      
	ELSE
	CONTINUE
	END
PRINT 'SUCESSO';

-- Query que gera os dados para a planilha:

declare @Dt_Referencia datetime
set @Dt_Referencia = cast(floor(cast( getdate() as float)) as datetime)

SELECT Nm_Servidor, Nm_Database, Nm_Tabela, Nm_Indice, Avg_Fragmentation_In_Percent, Page_Count, Fill_Factor
FROM Hitorico_Fragmentacao_Indice (nolock)
WHERE Avg_Fragmentation_In_Percent > 5
AND page_count > 1000   – Eliminar índices pequenos
AND Dt_Referencia >= @Dt_Referencia

SELECT getdate(), @@servername,  db_name(db_id()), object_name(B.Object_id), B.Name,  avg_fragmentation_in_percent,page_Count,fill_factor
FROM sys.dm_db_index_physical_stats(82,null,null,null,null) A
join sys.indexes B on a.object_id = B.Object_id and A.index_id = B.index_id
ORDER BY object_name(B.Object_id), B.index_id

SELECT * FROM hist_fragmentacao_indice
GO

SELECT TOP 100 * 
FROM sys.databases
WHERE database_id BETWEEN 5 and 15

DECLARE @id_db int
SET @id_db = 83
SET @id_db = @id_db+1
SELECT @id_db