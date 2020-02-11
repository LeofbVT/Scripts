SELECT login_name, [program_name],No_of_Connections = COUNT(session_id)
			FROM sys.dm_exec_sessions WITH (NOLOCK)
			WHERE session_id > 50 GROUP BY login_name, [program_name] ORDER BY COUNT(session_id) DESC