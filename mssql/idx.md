<a name="Table-of-Contents"></a>
# Table of Contents

- [Job](#Job)
- [Log](#Log)
- [Misc](#Misc)

### index

https://www.sqlshack.com/gathering-sql-server-indexes-statistics-and-usage-information/

```sql
select tab.name               table_name,
       ix.name                index_name,
       ix.type_desc           index_type,
       col.name               index_column_name,
       ixc.is_included_column is_included_column
  from sys.indexes ix
       inner join sys.index_columns ixc on ix.object_id = ixc.object_id and ix.index_id = ixc.index_id
       inner join sys.columns col on ix.object_id = col.object_id and ixc.column_id = col.column_id
       inner join sys.tables tab on ix.object_id = tab.object_id
 order by index_type;

select tab.name               table_name,
       ix.name                index_name,
       ix.type_desc           index_type,
       col.name               index_column_name,
       ixc.is_included_column is_included_column,
       ix.fill_factor,
       ix.is_disabled,
       ix.is_primary_key,
       ix.is_unique
  from sys.indexes ix
       inner join sys.index_columns ixc on ix.object_id = ixc.object_id and ix.index_id = ixc.index_id
       inner join sys.columns col on ix.object_id = col.object_id and ixc.column_id = col.column_id
       inner join sys.tables tab on ix.object_id = tab.object_id;

select t.name             tablename,
       ind.name           indexname,
       ind.index_id       indexid,
       ic.index_column_id columnid,
       col.name           columnname,
       ind.*,
       ic.*,
       col.*
  from sys.indexes ind
       inner join sys.index_columns ic on ind.object_id = ic.object_id and ind.index_id = ic.index_id
       inner join sys.columns col on ic.object_id = col.object_id and ic.column_id = col.column_id
       inner join sys.tables t on ind.object_id = t.object_id
 where ind.is_primary_key = 0
   and ind.is_unique = 0
   and ind.is_unique_constraint = 0
   and t.is_ms_shipped = 0
 order by t.name, ind.name, ind.index_id, ic.index_column_id;
```
