

-- define some default properties
set hive.cli.print.header=true;
set hive.cli.print.header=true;

-- Complex Data Type Example

drop table if exists employee_internal;
CREATE TABLE employee_internal
(
name string,
work_place ARRAY<string>,
gender_age STRUCT<gender:string,age:smallint>,
skills_score MAP<string,smallint>,
depart_title MAP<string,ARRAY<string>>
)
COMMENT 'This is an internal table'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
COLLECTION ITEMS TERMINATED BY ','
MAP KEYS TERMINATED BY ':'
STORED AS TEXTFILE;

describe formatted employee_internal;


Sample Data File : employee.txt

Michael|Montreal,Toronto|Male,30|DB:80|Product:Developer^DLead
Will|Montreal|Male,35|Perl:85|Product:Lead,Test:Lead
Shelley|New York|Female,27|Python:80|Test:Lead,COE:Architect
Lucy|Vancouver|Female,57|Sales:89,HR:94|Sales:Lead

LOAD DATA LOCAL INPATH 'labs/map-reduce/hive-lab/complex-data/employee.txt' 
OVERWRITE INTO TABLE employee_internal;


LOAD DATA LOCAL INPATH 'employee3.txt' OVERWRITE INTO TABLE employee_internal; 
--get all the data 
SELECT * FROM employee_internal;

--get work place which is array of string
SELECT name, work_place FROM employee;

SELECT name, work_place[0] AS col_1, work_place[1] AS col_2, work_place[2] AS col_3 FROM employee_internal;

-- get the gender and age structure
SELECT name, gender_age FROM employee_internal;

-- get the gender and age as separate column
SELECT name, gender_age.gender, gender_age.age FROM employee_internal;

--get the skill score
SELECT skills_score FROM employee_internal;


SELECT name, skills_score['DB'] AS DB, skills_score['Perl'] AS Perl,  skills_score['Python'] AS Python, skills_score['Sales'] as Sales, skills_score['HR'] as HR  FROM employee_internal;

SELECT name, depart_title['Product'] AS Product, depart_title['Test'] AS Test, depart_title['COE'] AS COE, depart_title['Sales'] AS Sales FROM employee_internal;


-- External Table

drop table if exists employee_external;
CREATE TABLE employee_external 
(
name string,
work_place ARRAY<string>,
gender_age STRUCT<gender:string,age:smallint>,
skills_score MAP<string,smallint>,
depart_title MAP<string,ARRAY<string>>
)
COMMENT 'This is an internal table'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
COLLECTION ITEMS TERMINATED BY ','
MAP KEYS TERMINATED BY ':'
STORED AS TEXTFILE
LOCATION '/user/cloudera/labs/map-reduce/hive-lab/complex-data/employee.txt';

-- Other supported format
-- SEQUENCEFILE, RCFILE, ORC, AVRO


-- Partitioned
drop table if exists employee_partitioned;
CREATE TABLE employee_partitioned  (
name string,
work_place ARRAY<string>,
gender_age STRUCT<gender:string,age:smallint>,
skills_score MAP<string,int>,
depart_title MAP<STRING,ARRAY<STRING>>
 )
PARTITIONED BY (Year INT, Month INT)
ROW FORMAT DELIMITED
 FIELDS TERMINATED BY '|'
COLLECTION ITEMS TERMINATED BY ','
MAP KEYS TERMINATED BY ':';

SHOW PARTITIONS employee_partitioned;
-- this does not result any data

The partition is not enabled automatically. We have to use ALTER TABLE ADD PARTITION to add partitions to a table. 
ALTER TABLE employee_partitioned ADD
PARTITION (year=2017, month=10)
PARTITION (year=2017, month=11);

SHOW PARTITIONS employee_partitioned;

-- Drop a partition
ALTER TABLE employee_partitioned
DROP IF EXISTS PARTITION (year=2017, month=10);


Sample Data File : employee_partitioned.txt

Michael|Montreal,Toronto|Male,30|DB:80|Product:Developer^DLead
Will|Montreal|Male,35|Perl:85|Product:Lead,Test:Lead
Shelley|New York|Female,27|Python:80|Test:Lead,COE:Architect
Lucy|Vancouver|Female,57|Sales:89,HR:94|Sales:Lead


LOAD DATA LOCAL INPATH  'employee_partitioned.txt'  OVERWRITE INTO TABLE employee_partitioned PARTITION (year=2017, month=10);
SELECT name, year, month FROM employee_partitioned;

describe formatted employee_external;


-------------
BUCKET
-------------
Sample Data File : employee_id.txt

100|Michael|Montreal,Toronto|Male,30|DB:80|Product:Developer^DLead
100|Will|Montreal|Male,35|Perl:85|Product:Lead,Test:Lead
100|Shelley|New York|Female,27|Python:80|Test:Lead,COE:Architect
100|Lucy|Vancouver|Female,57|Sales:89,HR:94|Sales:Lead
100|Michael2|Montreal,Toronto|Male,30|DB:80|Product:Developer^DLead
100|Will2|Montreal|Male,35|Perl:85|Product:Lead,Test:Lead
200|Shelley2|New York|Female,27|Python:80|Test:Lead,COE:Architect
200|Lucy2|Vancouver|Female,57|Sales:89,HR:94|Sales:Lead
200|Michael3|Montreal,Toronto|Male,30|DB:80|Product:Developer^DLead
200|Will3|Montreal|Male,35|Perl:85|Product:Lead,Test:Lead
200|Shelley3|New York|Female,27|Python:80|Test:Lead,COE:Architect
200|Lucy3|Vancouver|Female,57|Sales:89,HR:94|Sales:Lead


drop table if exists employee_id;
CREATE TABLE employee_id
(
emp_id int,
name string,
work_place ARRAY<string>,
gender_age STRUCT<gender:string,age:smallint>,
skills_score MAP<string,smallint>,
depart_title MAP<string,ARRAY<string>>
)
COMMENT 'This is an internal table'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
COLLECTION ITEMS TERMINATED BY ','
MAP KEYS TERMINATED BY ':'
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH  'employee_id.txt'  OVERWRITE INTO TABLE employee_id ;

drop table if exists employee_id_bucket;
CREATE TABLE employee_id_bucket
(
emp_id int,
name string,
work_place ARRAY<string>,
gender_age STRUCT<gender:string,age:smallint>,
skills_score MAP<string,smallint>,
depart_title MAP<string,ARRAY<string>>
)
COMMENT 'This is an internal table'
CLUSTERED BY (emp_id) INTO 2 BUCKETS
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
COLLECTION ITEMS TERMINATED BY ','
MAP KEYS TERMINATED BY ':'
STORED AS TEXTFILE;

-- Note: if clustered column string does not match with any of the column, it may throw error;
set map.reduce.tasks = 2;
set hive.enforce.bucketing = true;

INSERT OVERWRITE TABLE employee_id_bucket SELECT * FROM employee_id;


--- 
View
--
CREATE VIEW employee_skills
AS
 SELECT name, skills_score['DB'] AS DB,
 skills_score['Perl'] AS Perl,
skills_score['Python'] AS Python,
skills_score['Sales'] as Sales,
FROM employee;
No rows affected (0.253 seconds)