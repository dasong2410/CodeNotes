# Replication

### Related views/functions

```sql
# the current WAL write location on the primary
select pg_current_wal_lsn();

# the last WAL location received by the standby
select pg_last_wal_receive_lsn();

# a list of WAL sender processes
select * from pg_stat_replication;

# the status of the WAL receiver process, on a hot standby
select * from pg_stat_wal_receiver;

select * from pg_replication_slots;
```

### Create slot

```sql
SELECT * FROM pg_create_physical_replication_slot('node_a_slot');

SELECT slot_name, slot_type, active FROM pg_replication_slots;
```

To configure the standby to use this slot, primary_slot_name should be configured on the
standby.

    primary_conninfo = 'host=192.168.1.50 port=5432 user=foo password=foopass'
    primary_slot_name = 'node_a_slot'


### Monitor

- pg_current_wal_lsn
- pg_last_wal_receive_lsn
- pg_stat_replication.sent_lsn
- pg_stat_wal_receiver.flushed_lsn
- pg_last_wal_replay_lsn

    An important health indicator of streaming replication is the amount of WAL records generated in the
    primary, but not yet applied in the standby. You can calculate this lag by comparing the current WAL
    write location on the primary with the last WAL location received by the standby. These locations can
    be retrieved using pg_current_wal_lsn on the primary and pg_last_wal_receive_lsn
    on the standby, respectively (see Table 9.85 and Table 9.86 for details). The last WAL receive location
    in the standby is also displayed in the process status of the WAL receiver process, displayed using the
    ps command (see Section 27.1 for details).
    You can retrieve a list of WAL sender processes via the pg_stat_replication view.
    Large differences between pg_current_wal_lsn and the view's sent_lsn field might
    indicate that the master server is under heavy load, while differences between sent_lsn and
    pg_last_wal_receive_lsn on the standby might indicate network delay, or that the standby
    is under heavy load.
    On a hot standby, the status of the WAL receiver process can be retrieved via the
    pg_stat_wal_receiver view. A large difference between pg_last_wal_replay_lsn and
    the view's flushed_lsn indicates that WAL is being received faster than it can be replayed.
