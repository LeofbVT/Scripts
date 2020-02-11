SELECT A.session_id,B.host_name, B.Login_Name ,
(user_objects_alloc_page_count + internal_objects_alloc_page_count)*1.0/128 as TotalalocadoMB,
D.Text
FROM sys.dm_db_session_space_usage A
JOIN sys.dm_exec_sessions B  ON A.session_id = B.session_id
JOIN sys.dm_exec_connections C ON C.session_id = B.session_id
CROSS APPLY sys.dm_exec_sql_text(C.most_recent_sql_handle) As D
WHERE A.session_id > 50
and (user_objects_alloc_page_count + internal_objects_alloc_page_count)*1.0/128 > 100 
ORDER BY totalalocadoMB desc

USE tempdb
 
SELECT
 ssu.session_id,
 (ssu.internal_objects_alloc_page_count + sess_alloc) AS allocated,
 (ssu.internal_objects_dealloc_page_count + sess_dealloc) AS deallocated,
 stm.TEXT
FROM sys.dm_db_session_space_usage AS ssu,
 sys.dm_exec_requests req
 CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS stm,
 (SELECT
 session_id,
 SUM(internal_objects_alloc_page_count) AS sess_alloc,
 SUM(internal_objects_dealloc_page_count) AS sess_dealloc
 FROM sys.dm_db_task_space_usage
 GROUP BY session_id) AS tsk
WHERE ssu.session_id = tsk.session_id
AND ssu.session_id > 50
AND ssu.session_id = req.session_id
AND ssu.database_id = 2
ORDER BY allocated DESC