
set hive.cli.print.header=true;
-- Simple Table Structure
DROP TABLE IF EXISTS labs.product;

CREATE EXTERNAL TABLE IF NOT EXISTS labs.product (
ProductID INT,
Name STRING,
MfgPrice FLOAT,
MfgDate STRING,
MfgPlant STRING
)
COMMENT 'This is simple product table'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Just describe the table
describe formatted labs.product;

-- Now load the data to the table
LOAD DATA INPATH 'labs/landing/products/product-all.csv' INTO TABLE labs.products

-- Now run the query
SELECT * FROM labs.product;


--- Now introduce particition but in static partition, the column should not exist
-- since we know in advance that data is already coming from a particular plant, it will be placed directly under that file

DROP TABLE IF EXISTS labs.product_static_partition;

CREATE EXTERNAL TABLE IF NOT EXISTS labs.product_static_partition (
ProductID INT,
Name STRING,
MfgPrice FLOAT,
MfgDate STRING
)
COMMENT 'This is simple product table'
PARTITIONED BY (plant STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Just describe the table
describe formatted labs.product_static_partition;


-- Now load the data
LOAD DATA INPATH 'labs/landing/products/product-usa.csv' INTO TABLE labs.product_static_partition PARTITION(plant = 'USA');
LOAD DATA INPATH 'labs/landing/products/product-japan.csv' INTO TABLE labs.product_static_partition PARTITION(plant = 'Japan');
LOAD DATA INPATH 'labs/landing/products/product-india.csv' INTO TABLE labs.product_static_partition PARTITION (plant = 'India');
LOAD DATA INPATH 'labs/landing/products/product-australia.csv' INTO TABLE labs.product_static_partition PARTITION (plant = 'Australia');

select * from labs.product;
