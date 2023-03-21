# PostgreSQL Extensions

## Install postgresql15-contrib

```bash
sudo dnf install -y postgresql15-server
```

will not install extensions, you have to install "postgresql15-contrib" manually as following(Unbuntu handles all those well):

```bash
sudo dnf install -y postgresql15-contrib
```
or there will be only one single row in "pg_available_extensions"


## List all available extensions

```sql
-- installed
select * from pg_extension;

-- available
select * from pg_available_extensions order by name;
```

## Create extension in database

```sql
create extension pg_freespacemap;
```
