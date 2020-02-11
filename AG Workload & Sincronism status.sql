/* AVALIAR WORKLOAD & STATUS DE SINCRONISMO DO AG */
SELECT ag.name AS 'AG Name', ar.replica_server_name AS 'Replica Instance', dr_state.database_id as 'Database ID',
Location = CASE
WHEN ar_state.is_local = 1 THEN N'LOCAL'
ELSE 'REMOTE' END , 
Role = CASE
WHEN ar_state.role_desc IS NULL THEN N'DISCONNECTED'
ELSE ar_state.role_desc END,
dr_state.log_send_queue_size AS 'Log Send Queue Size', dr_state.redo_queue_size AS 'Redo Queue Size',
dr_state.log_send_rate AS 'Log Send Rate', dr_state.redo_rate AS 'Redo Rate' FROM (( sys.availability_groups AS ag JOIN sys.availability_replicas AS ar ON ag.group_id = ar.group_id )
JOIN sys.dm_hadr_availability_replica_states AS ar_state ON ar.replica_id = ar_state.replica_id)
JOIN sys.dm_hadr_database_replica_states dr_state on ag.group_id = dr_state.group_id and dr_state.replica_id = ar_state.replica_id;