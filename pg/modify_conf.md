# PostgreSQL 14 settings

## postgresql.conf

### 1. basic

```bash
# basic
sed -i -E "s/^#?(listen_addresses\s=\s)('\S+')(\s.*)/\1'*'\3/g" postgresql.conf
sed -i -E "s/^#?(port\s=\s)(\S+)(\s.*)/\15432\3/g" postgresql.conf
sed -i -E "s/^#?(max_connections\s=\s)(\S+)(\s.*)/\1400\3/g" postgresql.conf

sed -i -E "s/^#?(shared_buffers\s=\s)(\S+)(\s.*)/\14GB\3/g" postgresql.conf
sed -i -E "s/^#?(temp_buffers\s=\s)(\S+)(\s.*)/\1128MB\3/g" postgresql.conf
sed -i -E "s/^#?(max_prepared_transactions\s=\s)(\S+)(\s.*)/\1128\3/g" postgresql.conf

sed -i -E "s/^#?(work_mem\s=\s)(\S+)(\s.*)/\116MB\3/g" postgresql.conf
sed -i -E "s/^#?(maintenance_work_mem\s=\s)(\S+)(\s.*)/\1128MB\3/g" postgresql.conf
sed -i -E "s/^#?(max_stack_depth\s=\s)(\S+)(\s.*)/\16MB\3/g" postgresql.conf

sed -i -E "s/^#?(wal_level\s=\s)(\S+)(\s.*)/\1replica\3/g" postgresql.conf

# archive
sed -i -E "s/^#?(archive_mode\s=\s)(\S+)(\s.*)/\1on\3/g" postgresql.conf
sed -i -E "s|^#?(archive_command\s=\s)('.*')(\s.*)|\1'cp -i %p /var/lib/postgresql/14/archive/%f </dev/null'\3|g" postgresql.conf
# sed -i -E "s|^#?(restore_command\s=\s)('.*')(\s.*)|\1'cp /var/lib/postgresql/14/archive/%f %p'\3|g" postgresql.conf

sed -i -E "s/^#?(logging_collector\s=\s)(\S+)(\s.*)/\1on\3/g" postgresql.conf
sed -i -E "s|^#?(log_directory\s=\s)('\S+')(\s.*)|\1'/var/log/postgresql'\3|g" postgresql.conf
sed -i -E "s/^#?(log_filename\s=\s)('\S+')(\s.*)/\1'postgresql-14-main-%Y%m%d.log'\3/g" postgresql.conf
sed -i -E "s/^#?(log_rotation_age\s=\s)(\S+)(\s.*)/\11d\3/g" postgresql.conf
sed -i -E "s/^#?(log_rotation_size\s=\s)(\S+)(\s.*)/\10\3/g" postgresql.conf
sed -i -E "s/^#?(log_min_messages\s=\s)(\S+)(\s.*)/\1info\3/g" postgresql.conf
sed -i -E "s/^#?(log_min_error_statement\s=\s)(\S+)(\s.*)/\1notice\3/g" postgresql.conf
sed -i -E "s/^#?(log_min_duration_statement\s=\s)(\S+)(\s.*)/\11000\3/g" postgresql.conf

sed -i -E "s/^#?(log_connections\s=\s)(.*)/\1off/g" postgresql.conf
sed -i -E "s/^#?(log_disconnections\s=\s)(.*)/\1off/g" postgresql.conf

sed -i -E "s/^#?(log_line_prefix\s=\s)('.+')(\s.*)/\1'%d %p %l %m '\3/g" postgresql.conf
sed -i -E "s/^#?(log_statement\s=\s)('\S+')(\s.*)/\1'mod'\3/g" postgresql.conf
sed -i -E "s/^#?(datestyle\s=\s)('.+')(.*)/\1'iso, ymd'\3/g" postgresql.conf

sed -i -E "s/^#?(lc_messages\s=\s)('\S+')(\s.*)/\1'en_CA.UTF-8'\3/g" postgresql.conf
sed -i -E "s/^#?(lc_monetary\s=\s)('\S+')(\s.*)/\1'en_CA.UTF-8'\3/g" postgresql.conf
sed -i -E "s/^#?(lc_numeric\s=\s)('\S+')(\s.*)/\1'en_CA.UTF-8'\3/g" postgresql.conf
sed -i -E "s/^#?(lc_time\s=\s)('\S+')(\s.*)/\1'en_CA.UTF-8'\3/g" postgresql.conf
```

### 2. standby
```bash
sed -i -E "s/^#?(primary_slot_name\s=\s)('.*')(\s.*)/\1'slot_node2'\3/g" postgresql.conf
sed -i -E "s/^#?(hot_standby\s=\s)(\S+)(\s.*)/\1on\3/g" postgresql.conf
```

## pg_hba.conf

```bash
cat >> pg_hba.conf <<EOF
host    replication     repl             192.168.56.86/32                 trust
host    replication     repl             192.168.56.87/32                 trust
host    replication     repl             192.168.56.88/32                 trust
EOF

sed -i -E "/host(\s+)replication(\s+)repl(\s+).+/d" pg_hba.conf
```

