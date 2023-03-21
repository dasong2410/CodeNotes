

https://stackoverflow.com/questions/40044796/update-heap-table-deadlock-on-rid

https://www.sqlshack.com/locking-sql-server/

https://blog.coeo.com/overview-of-locks-in-sql-server

https://docs.microsoft.com/en-us/sql/relational-databases/sql-server-transaction-locking-and-row-versioning-guide?view=sql-server-ver15

https://www.sqlshack.com/troubleshooting-the-cxpacket-wait-type-in-sql-server/


## Query blocking

```sql
select t1.resource_type,
       t1.resource_database_id,
       t1.resource_associated_entity_id,
       t1.request_mode,
       t1.request_session_id,
       t2.blocking_session_id
  from sys.dm_tran_locks as t1
       inner join sys.dm_os_waiting_tasks as t2 on t1.lock_owner_address = t2.resource_address;

select sqltext.text, req.session_id, req.status, req.command, req.cpu_time, req.total_elapsed_time
  from sys.dm_exec_requests req
       cross apply sys.dm_exec_sql_text(sql_handle) as sqltext

select wt.blocking_session_id                as blockingsessesionid,
       sp.program_name                       as programname,
       coalesce(sp.loginame, sp.nt_username) as hostname,
       ec1.client_net_address                as clientipaddress,
       db.name                               as databasename,
       wt.wait_type                          as waittype,
       ec1.connect_time                      as blockingstarttime,
       wt.wait_duration_ms / 1000            as waitduration,
       ec1.session_id                        as blockedsessionid,
       h1.text                               as blockedsqltext,
       h2.text                               as blockingsqltext
  from sys.dm_tran_locks as tl
       inner join sys.databases db on db.database_id = tl.resource_database_id
       inner join sys.dm_os_waiting_tasks as wt on tl.lock_owner_address = wt.resource_address
       inner join sys.dm_exec_connections ec1 on ec1.session_id = tl.request_session_id
       inner join sys.dm_exec_connections ec2 on ec2.session_id = wt.blocking_session_id
       left outer join master.dbo.sysprocesses sp on sp.spid = wt.blocking_session_id
       cross apply sys.dm_exec_sql_text(ec1.most_recent_sql_handle) as h1
       cross apply sys.dm_exec_sql_text(ec2.most_recent_sql_handle) as h2;

```
