# hope-pg
Postgres数据库的SQL测试框架。The SQL testing framework for Postgres databases.
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
```
