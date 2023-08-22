# hope-pg
The SQL testing libaray for Postgres databases.
## Usage:
### 0. Write Test Case Script
#### ./test/test.sql
```sql
-- Include the Hope.sql.
\ir ../hope.sql

-- Clear all objects to keep the database clean.
:Hope /* Clear Schema: */
  drop schema if exists public cascade \;
  create schema public
:Done

-- Include the SQL script file to test.
:Include struct.sql
:Include init.sql

-- Begin Testing:
:Hope /* Select from Person: */
  select *
    from Person
    where age <70
  :Pass
  :Row_Count = 5
:Done

:Hope /* Insert into Person failure: */
  insert into Person
    values ('P001', 'Li Zhan', 55)
  :Fail
:Done

:Hope /* Assert Expression: */
  select age=55 as :Assert
    from Person
    where name = 'Leadzen'
:Done

-- Run this SQL script with psql to get a test report.
```
### 1. Run Test Case Script
```bash
$ psql -f ./test/test.sql
```
### 2. Get Test Report
```
Import hope.sql


Hope: /* Clear Schema: */
  drop schema if exists public cascade ;
  create schema public
psql:test/test.sql:8: NOTICE:  drop cascades to table person
Time: 5.205 ms
Done.

Include Script File.
create table Person (
  id      varchar(16) primary key,
  name    varchar(32),
  age     int
);
Include Script File.
insert into Person values
  ('P001', 'Leadzen', 55),
  ('P002', 'Jack Ma', 60),
  ('P003', 'Bill Gates', 79)
;

Hope: /* Select from Person: */
  select *
    from Person
    where age <70
  
Time: 0.447 ms
[✔] Hope to execute SQL passed.
[✘] Hope Row_Count=5
Done.


Hope: /* Insert into Person failure: */
  insert into Person
    values ('P001', 'Li Zhan', 55)
  
psql:test/test.sql:26: ERROR:  duplicate key value violates unique constraint "person_pkey"
DETAIL:  Key (id)=(P001) already exists.
Time: 0.418 ms
[✔] Hope to execute SQL failed.
Done.


Hope: /* Assert Expression: */
  select age=55 as assert 
    from Person
    where name = 'Leadzen'
Time: 0.674 ms
[✔] Check assertion.
Done.
```
