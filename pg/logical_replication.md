### Logical Replication Quick Setup

- https://www.postgresql.org/docs/14/logical-replication-quick-setup.html
- https://www.postgresql.org/docs/14/logical-replication-security.html
- https://www.postgresql.org/docs/14/logical-replication-config.html
- https://www.postgresql.org/docs/14/sql-createsubscription.html
- https://www.postgresql.org/docs/14/sql-altersubscription.html

### The postgresql.conf(Primary server)
```bash
wal_level = logical
```

### Database(Primary server)
```sql
-- primary
create user repl with replication encrypted password '2wsx@WSX';
grant pg_read_all_data to repl;

create publication mypub for table s1.t_test1, s1.t_test1;
-- create publication mypub for all tables;
alter publication mypub add table s1.t_test3;
```

```sql
-- secondary
create subscription mysub connection 'dbname=can host=127.0.0.1 user=repl' publication mypub;

-- need to refresh sub after adding new tables to pub
alter subscription mysub refresh publication;
```

### The pg_hba.conf(Primary server)
```bash
# you can only sepecify the database you want to sync, plus replication
host    all     repl             192.168.56.84/32            scram-sha-256
```

### The password file(Secondary server)

- https://www.postgresql.org/docs/14/libpq-pgpass.html

```bash
# database you want to sync, plus replication
chmod 0600 ~/.pgpass
```

### Errors

```sql
-- the user used for the replication connection must be superuser or replication role
ERROR:  could not connect to the publisher: connection to server at "127.0.0.1", port 5432 failed: FATAL:  must be superuser or replication role to start walsender

-- the user used for the replication connection must has select privilege on the published tables
2024-02-13 22:29:15.102 UTC [4035] ERROR:  could not start initial contents copy for table "s1.t_test1": ERROR:  permission denied for schema s1
```
