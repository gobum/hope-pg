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
  :Rows = 2
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

:Hope /* Columns Assert */
  select name, age
    from Person
  :Columns = 2
:Done

:Hope /* Set Variable */
  select generate_series(8, 8) age
  :Variable
:Done

:Hope /* Check Variable */
  select :age = 8 as :Assert
:Done

:Hope
  select 'Leadzen' name
  :Variable
:Done

:Hope
  select age=55 as :Assert
    from Person
    where name = :'name'
:Done

-- Run this SQL script with psql to get a test report.