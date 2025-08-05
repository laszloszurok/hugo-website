---
title: "PostgreSQL notes"
date: 2024-02-26T19:03:42+01:00
pagefind_index_page: true
---

## Export a postgresql database

```terminal
pg_dump -c -h $host -p $port -U $user --password -d $db_name > exported_db.sql
```

Flags:
* -c: drop and recreate existing objects, when importing into an other postgres instance

## Import a postgresql database

```terminal
psql -h $host -p $port -U $user --password -d $db_name < exported_db.sql
```
