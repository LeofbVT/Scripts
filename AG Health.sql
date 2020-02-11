/* AVALIAR SE O ALWAYS ON ESTÁ HEALTHY */
SELECT n.group_name as GrupoAlwaysOn,n.replica_server_name as Servidor,
db_name(drs.database_id) as BAnco,
drs.synchronization_state_desc as StatusSincronia,
drs.synchronization_health_desc as StatusAlwaysOn
FROM sys.dm_hadr_availability_replica_cluster_nodes n 
join sys.dm_hadr_availability_replica_cluster_states cs on n.replica_server_name = cs.replica_server_name 
join sys.dm_hadr_availability_replica_states rs on rs.replica_id = cs.replica_id 
join sys.dm_hadr_database_replica_states drs on rs.replica_id=drs.replica_id 
ORDER BY n.replica_server_name, db_name(drs.database_id)