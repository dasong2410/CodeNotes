# Add/remove database to/from AG

## 1. Remove database from AG

run on node1
```sql
ALTER AVAILABILITY GROUP TestAG remove database testdatabase1; 
```

## 2. Add database to AG

run on node1
```sql
ALTER AVAILABILITY GROUP TestAG add database testdatabase1; 
```

## 3. Set hadr

run on node2
```sql
ALTER DATABASE TestDatabase1 SET HADR AVAILABILITY GROUP = TestAG;
```
