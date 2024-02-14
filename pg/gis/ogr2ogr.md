# ogr2ogr

- https://gdal.org/programs/ogr2ogr.html
- https://www.bostongis.com/PrinterFriendly.aspx?content_name=ogr_cheatsheet

```bash
# convert gml to kml
# ogr2ogr -f KML lda_000b21g_e.kml lda_000b21g_e.shp
ogr2ogr -f KML lda_000b21g_e.kml lda_000b21g_e.gml

ogr2ogr -f "PostgreSQL" PG:"dbname='' host='' port='' user='' password=''" --cofnig OGR_TRUNCATE YES lda_000b21g_e.kml -nln table_name
```
