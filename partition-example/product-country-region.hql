-- Simple Table Structure
DROP TABLE IF EXISTS labs.product_region;

CREATE EXTERNAL TABLE IF NOT EXISTS labs.product_region (
ProductID INT,
Name STRING,
MfgPrice FLOAT,
MfgDate STRING,
MfgPlant STRING,
MfgRegion STRING
)
COMMENT 'This is simple product table'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;


-- Just describe the table
describe formatted labs.product_region;

-- load the data
-- Now load the data to the table
LOAD DATA INPATH 'labs/landing/products/product-all-by-region.csv' INTO TABLE labs.product_region;

--- Now introduce particition

DROP TABLE IF EXISTS labs.product_region_d_partition;

CREATE EXTERNAL TABLE IF NOT EXISTS labs.product_region_d_partition (
ProductID INT,
Name STRING,
price FLOAT,
dt STRING,
plant STRING,
region STRING
)
COMMENT 'This is simple product table'
PARTITIONED BY (plants STRING, regions STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

  
insert into labs.product_region_d_partition PARTITION (mfgregion,mfgplant  )
select ProductID, Name, MfgPrice,MfgDate, mfgplant , mfgregion from labs.product_region;

