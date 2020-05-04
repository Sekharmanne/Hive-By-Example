
-- Simple Table Structure
DROP TABLE IF EXISTS employee;
CREATE EXTERNAL TABLE IF NOT EXISTS employee (
EmpID INT,
NamePrefix STRING,
FirstName STRING,
MiddleInitial STRING,
LastName STRING,
Gender STRING,
EMail STRING,
FatherName STRING,
MotherName STRING,
MotherMaidenName STRING,
DateofBirth STRING,
TimeofBirth STRING,
AgeinYrs FLOAT,
WeightinKgs FLOAT,
DateofJoining STRING,
QuarterofJoining STRING,
HalfofJoining STRING,
YearofJoining STRING,
MonthofJoining STRING,
MonthNameofJoining STRING,
ShortMonth STRING,
DayofJoining STRING,
DOWofJoining STRING,
ShortDOW STRING,
AgeinCompanyYrs FLOAT,
Salary INT,
LastHike STRING,
SSN STRING,
PhoneNo STRING,
PlaceName STRING,
County STRING,
City STRING,
State STRING,
Zip STRING,
Region STRING,
UserName STRING,
Password STRING
)
COMMENT 'Description of the table'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/cloudera/labs/landing/employee'
TBLPROPERTIES (
    'skip.header.line.count' = '1')
;