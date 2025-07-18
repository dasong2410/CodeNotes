
- https://www.cybertec-postgresql.com/en/pgbouncer-authentication-made-easy/
- https://medium.com/@dmitry.romanoff/using-pgbouncer-to-improve-performance-and-reduce-the-load-on-postgresql-b54b78deb425

```bash
# mysql.sql
select 1;
```

```bash
pgbench -i test -h 127.0.0.1 -p 5432 -U marcus
pgbench -c 1000 -T 60 test -h 127.0.0.1 -p 5432 -U marcus
pgbench -c 1000 -T 60 test -h 127.0.0.1 -p 5432 -U marcus

pgbench -c 20 -t 100 -S test -h 127.0.0.1 -p 5432 -U marcus -C -f mysql.sql
pgbench -c 20 -t 100 -S test -h 127.0.0.1 -p 6432 -U marcus -C -f mysql.sql
pgbench -c 20 -t 100 -S test -h 127.0.0.1 -p 5000 -U marcus -C -f mysql.sql

ps -ef | grep "[p]ostgres: 17-test"  | grep "127.0.0.1" | awk -F ':' '{print $6}' | sort | less
```

### 

```bash
# connect to "Admin console"
# https://www.pgbouncer.org/usage.html#admin-console
psql -p 6432 -U pgbouncer

# test connect
psql -h 127.0.0.1 -p 6432 -U marcus test
```
