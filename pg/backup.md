## Backup and Restore test

### 1. Create base backup, back up pg_wal dir manually if need

    # pg_basebackup -h localhost -p 80 -U postgres -D D:\Apps\DBBackup -Ft -z -Xs -P
    # pg_basebackup -F t -z -P -c fast -D /var/lib/postgresql/15/backup/main/20230727
    # exec on standby server
    pg_basebackup -R -h 192.168.56.61 -U repl -D /var/lib/postgresql/15/main

### 2. setting paramter

    archive_mode = on
    archive_command = 'test ! -f /var/lib/postgresql/15/archive/%f && cp %p /var/lib/postgresql/14/archive/%f'
    restore_command = 'cp /var/lib/postgresql/15/archive/%f %p'

    # The default value of this parameter is not 'immediate'(don't know what it is), it will restore and recovery db cluster to as far as possible, try not to modify it unless you know exactly what you're doing.
    #recovery_target = 'immediate'

### 3. clean env, restore, create signal file

    rm -rf /var/lib/pgsql/15/data/*

    tar -xvf /var/lib/pgsql/backup/base.tar -C /var/lib/pgsql/15/data
    tar -xvf /var/lib/pgsql/backup/pg_wal.tar -C /var/lib/pgsql/15/data/pg_wal

    touch recovery.signal

### 4. start db cluster

    /usr/pgsql-15/bin/postgres "-D" "/var/lib/pgsql/15/data/"

### Other

    /usr/pgsql-15/bin/initdb -D /var/lib/pgsql/15/data

    cp ~/postgresql.conf ~/15/data/

    create table t_t1(c1 int, c2 int);

    insert into t_t1 select generate_series, generate_series from generate_series(1, 10);

    select count(1) from t_t1;




    record with incorrect prev-link 0/301B030 at 0/4000028


    /var/lib/pgsql/15/data/pg_wal

