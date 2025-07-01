
- https://www.cybertec-postgresql.com/en/pgbouncer-authentication-made-easy/
- https://medium.com/@dmitry.romanoff/using-pgbouncer-to-improve-performance-and-reduce-the-load-on-postgresql-b54b78deb425

```bash
pgbench -i test -h 127.0.0.1 -p 5432 -U marcus
pgbench -c 1000 -T 60 test -h 127.0.0.1 -p 5432 -U marcus

pgbench -c 20 -t 100 -S test -h 127.0.0.1 -p 5432 -U marcus -C -f mysql.sql
pgbench -c 20 -t 100 -S test -h 127.0.0.1 -p 6432 -U marcus -C -f mysql.sql

ps -ef | grep "[p]ostgres: 14/main: www"
ps -ef | grep "postgres: 14/main"  | grep "192.168.12.42" | awk -F '/' '{print $2}' | sort | less
ps -ef | grep "postgres: 14/main"  | grep "192.168.12.42" | awk -F '/' '{print $2}' | sort | less
```

### 

```bash
# connect to the pgbouncer manage database
psql -p 6432 -U pgbouncer

# test connect
psql -h 127.0.0.1 -p 6432 -U marcus test
```
