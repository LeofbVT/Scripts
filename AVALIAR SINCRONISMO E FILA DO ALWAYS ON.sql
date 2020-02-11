/*AVALIAR SINCRONISMO E FILA DO ALWAYS ON */
SELECT r.replica_server_name as Servidor, db_name(rs.database_id) as Banco, 
rs.synchronization_state_desc as StatusAlwaysOn,
isnull(convert(varchar(20),rs.last_commit_time,103) + ' ' + convert(varchar(20),rs.last_commit_time,108),'n/a') as UltimaDataHoraSinc,
isnull(rs.log_send_rate,0) as FilaEnvio,isnull(rs.log_send_queue_size,0) as FilaExecReplica
FROM sys.availability_replicas r
join sys.dm_hadr_database_replica_states rs on r.replica_id = rs.replica_id
WHERE 1=1
ORDER BY r.replica_server_name, db_name(rs.database_id)