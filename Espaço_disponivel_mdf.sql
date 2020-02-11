--SQL - QUERY ESPAÇO DISPONÍVEL NOS ARQUIVOS MDF DO BANCO

SELECT
--substring(s.name, 1,8) AS [Name],
s.name AS [Name],
s.physical_name AS [FileName],
sum(s.size * CONVERT(float,8)/1024) AS [Size],
sum(CAST(CASE s.type WHEN 2 THEN 0 ELSE CAST(FILEPROPERTY(s.name, 'SpaceUsed') AS float)* CONVERT(float,8) END AS float)/1024) AS [UsedSpace],
sum(s.size * CONVERT(float,8)/1024 - CAST(CASE s.type WHEN 2 THEN 0 ELSE CAST(FILEPROPERTY(s.name, 'SpaceUsed') AS float)* CONVERT(float,8) END AS float)/1024) AS [AvailableSpace],
s.file_id AS [ID]
FROM
sys.filegroups AS g
INNER JOIN sys.master_files AS s ON ((s.type = 2 or s.type = 0) and s.database_id = db_id() and (s.drop_lsn IS NULL)) AND (s.data_space_id=g.data_space_id)
--WHERE (CAST(cast(g.name as varbinary(256)) AS sysname)='PRIMARY')
--ORDER BY
group by s.name, s.physical_name, s.file_id

UNION 

SELECT
s.name AS [Name],
s.physical_name AS [FileName],
s.size * CONVERT(float,8)/1024 AS [Size],
CAST(FILEPROPERTY(s.name, 'SpaceUsed') AS float)* CONVERT(float,8)/1024 AS [UsedSpace],
s.size * CONVERT(float,8)/1024 -
CAST(FILEPROPERTY(s.name, 'SpaceUsed') AS float)* CONVERT(float,8)/1024 AS [AvailableSpace],
s.file_id AS [ID]
FROM
sys.master_files AS s
WHERE
(s.type = 1 and s.database_id = db_id())
