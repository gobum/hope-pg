# hope-pg
The SQL testing libaray for Postgres databases.
## Usage:
### 0. Write Test Case Script
#### ./test/test.sql
```sql
-- Include the hope.sql.
\ir ../hope.sql

-- Clear all objects to keep the database clean.
:hope /* Clear Schema: */
  drop schema if exists public cascade \;
  create schema public
:done

-- Include the SQL script file to test.
:include struct.sql
:include init.sql

-- Begin Testing:
:hope /* Select from Person: */
  select *
    from Person
    where age <70
  :success
  :row_count = 2
:done

:hope /* Insert into Person failure: */
  insert into Person
    values ('P001', 'Li Zhan', 55)
  :failure
:done

:hope /* Assert Expression: */
  select age=55 as :assert
    from Person
    where name = 'Leadzen'
:done

-- Run this SQL script with psql to get a test report.
```
### 1. Run Test Case Script
```bash
$ psql -f ./test/test.sql
```
### 2. Get Test Report
```
Import hope.sql
Time: 0.621 ms

/* Clear Schema: */
  drop schema if exists public cascade ;
  create schema public 
psql:test/test.sql:8: NOTICE:  drop cascades to table person
Time: 20.683 ms
done.
Time: 13.957 ms
Time: 5.275 ms

/* Select from Person: */
  select *
    from Person
    where age <70
   
Time: 1.283 ms
[✔] Hope to execute SQL command successful.
Read row count.
Time: 0.456 ms
[✔] Hope row_count=2
done.

/* Insert into Person failure: */
  insert into Person
    values ('P001', 'Li Zhan', 55)
   
psql:test/test.sql:26: ERROR:  duplicate key value violates unique constraint "person_pkey"
DETAIL:  Key (id)=(P001) already exists.
Time: 0.792 ms
[✔] Hope to execute SQL command failed.
done.

/* Assert Expression: */
  select age=55 as  assert_ 
    from Person
    where name = 'Leadzen' 
Time: 1.118 ms
[✔] Check assertion.
done.
```
