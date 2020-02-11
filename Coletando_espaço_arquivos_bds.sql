select db_name(dbid), convert(varchar, name) as Nome ,Filename ,
cast(Size * 8 as bigint) / 1024 AS [Size in MB],
case when MaxSize = -1 then MaxSize else cast(MaxSize as bigint)* 8 / 1024 end MaxSize,
--case when MaxSize = -1 then -1 else cast((MaxSize as bigint)* 8 /1024 as varchar) + ' MB' end MaxSize,
case when substring(cast(Status as varchar),1,2) = 10 then cast(Growth as varchar) + ' %'
else cast (cast((Growth * 8 )/1024 as numeric(15,2)) as varchar) + ' MB'end Growth
from master..sysaltfiles with(nolock)
order by Nome

--268435456
--2097152


--(cast((MaxSize * 8 )/1024 as numeric(15,2)) as varchar) + ' MB'