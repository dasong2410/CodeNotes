# AG related tables

https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/always-on-availability-groups-dynamic-management-views-functions?view=sql-server-ver15

```sql
sys.availability_replicas
sys.availability_groups

sys.dm_hadr_ag_threads
sys.dm_hadr_auto_page_repair
sys.dm_hadr_automatic_seeding
sys.dm_hadr_availability_group_states
sys.dm_hadr_availability_replica_cluster_nodes
sys.dm_hadr_availability_replica_cluster_states
sys.dm_hadr_availability_replica_states
sys.dm_hadr_cluster
sys.dm_hadr_cluster_members
sys.dm_hadr_cluster_networks
sys.dm_hadr_database_replica_cluster_states
sys.dm_hadr_database_replica_states
sys.dm_hadr_db_threads
sys.dm_hadr_instance_node_map
sys.dm_hadr_name_id_map
sys.dm_hadr_physical_seeding_stats
sys.dm_tcp_listener_states
```

https://www.sqlshack.com/sql-server-2016-always-availability-group-direct-seeding/

```sql
SELECT
    AVGrp.name as group_name,
    AVGRep.replica_server_name as replica_name,
    AVGRep.endpoint_url,
    AVGRep.availability_mode_desc,
    AVGRep.failover_mode_desc,
    AVGRep.seeding_mode_desc as seeding_mode
FROM sys.availability_replicas as AVGRep
JOIN sys.availability_groups as AVGrp
    ON AVGRep.group_id = AVGrp.group_id;
```
