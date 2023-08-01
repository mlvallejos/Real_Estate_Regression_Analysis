-- --------------------------------------------------------------------------------

-- 					MID PROJECT SQL QUESTIONS - REGRESSION

-- --------------------------------------------------------------------------------

-- INSTRUCTIONS
-- (Use sub queries or views wherever necessary)


-- 1. Create a database called house_price_regression.

CREATE DATABASE IF NOT EXISTS house_price_regression;

USE house_price_regression;


-- 2. Create a table house_price_data with the same columns as given in the csv file. 
-- Please make sure you use the correct data types for the columns.

-- IMPORT DATA FROM CSV FILE: 
-- Create table with matching column number as import data and specify data format.
-- DO NOT specify primary key since, in this case, property_id doesn't have unique number.

DROP TABLE IF EXISTS house_price_data;

CREATE TABLE house_price_data (
	property_id BIGINT DEFAULT NULL,
    date TEXT DEFAULT NULL,
    bedrooms INT DEFAULT NULL,
    bathrooms DOUBLE DEFAULT NULL,
    sqft_living INT DEFAULT NULL,
    sqft_lot INT DEFAULT NULL,
    floors INT DEFAULT NULL,
    waterfront INT DEFAULT NULL,
    `view` INT DEFAULT NULL,
    `condition` INT DEFAULT NULL,
    grade INT DEFAULT NULL,
    sqft_above INT DEFAULT NULL,
    sqft_basement INT DEFAULT NULL,
    yr_built INT DEFAULT NULL,
    yr_renovated INT DEFAULT NULL,
    zip_code INT DEFAULT NULL,
    lat DOUBLE DEFAULT NULL,
    lon DOUBLE DEFAULT NULL,
    sqft_living15 INT DEFAULT NULL,
    sqft_lot15 INT DEFAULT NULL,
    price INT DEFAULT NULL
);


-- 3. Import the data from the csv file into the table. 
-- 		Before importing the data into the empty table, make sure that you have deleted the headers from the csv file. 
-- 		To not modify the original data, if you want you can create a copy of the csv file as well. 
-- 		Note you might have to use the following queries to give permission to SQL to import data from csv files in bulk:

-- 		SHOW VARIABLES LIKE 'local_infile'; 
-- 		This query would show you the status of the variable ‘local_infile’. If it is off, use the next command, 
-- 		otherwise you should be good to go
-- 		SET GLOBAL local_infile = 1;


-- Since local_infile didn't work:

-- Refresh table schema to view created table, right click on created table and click Table Data Import Wizard.
-- Select csv file and match format (8 UTI).
-- Data file should not have headers. 


-- Create new column id set on autoincrement to assign specific identifier for each row. Set as primary key.

ALTER TABLE house_price_data ADD COLUMN `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;


-- Change column names that are reserved words in MySQL

ALTER TABLE house_price_data CHANGE COLUMN `view` `house_view` INT;
ALTER TABLE house_price_data CHANGE COLUMN `condition` `house_condition` INT;


-- 4. Select all the data from table house_price_data to check if the data was imported correctly

SELECT * FROM house_price_data;


-- 5. Use the alter table command to drop the column date from the database, as we would not use it in the analysis with SQL. 
-- Select all the data from the table to verify if the command worked. Limit your returned results to 10.

ALTER TABLE house_price_data DROP COLUMN `date`;
SELECT * FROM house_price_data
LIMIT 10;


-- 6. Use sql query to find how many rows of data you have.

SELECT COUNT(*) FROM house_price_data;


-- 7. Now we will try to find the unique values in some of the categorical columns:

-- What are the unique values in the column bedrooms?
SELECT DISTINCT(bedrooms) FROM house_price_data;

-- What are the unique values in the column bathrooms?
SELECT DISTINCT(bathrooms) FROM house_price_data;

-- What are the unique values in the column floors?
SELECT DISTINCT(floors) FROM house_price_data;

-- What are the unique values in the column condition?
SELECT DISTINCT(house_condition) FROM house_price_data;

-- What are the unique values in the column grade?
SELECT DISTINCT(grade) FROM house_price_data;



-- 8. Arrange the data in a decreasing order by the price of the house. Return only the IDs of the top 10 most expensive houses in your data.

SELECT * FROM house_price_data
ORDER BY price DESC
LIMIT 10;


-- 9. What is the average price of all the properties in your data?

SELECT ROUND(AVG(price), 2) FROM house_price_data;


-- 10. In this exercise we will use simple group by to check the properties of some of the categorical variables in our data
-- What is the average price of the houses grouped by bedrooms? The returned result should have only two columns, 
-- bedrooms and Average of the prices. Use an alias to change the name of the second column.

SELECT bedrooms, ROUND(AVG(price), 2) AS average_price
FROM house_price_data
GROUP BY bedrooms
ORDER BY average_price DESC;

SELECT DISTINCT bedrooms, COUNT(*) AS total_houses, ROUND(AVG(price), 2) AS average_price 
FROM house_price_data
GROUP BY bedrooms
ORDER BY average_price;

-- There is only 1 house with 11 bedrooms and 1 house with 33 bedrooms. This is probably a data entry mistake.


-- What is the average sqft_living of the houses grouped by bedrooms? The returned result should have only two columns, 
-- bedrooms and Average of the sqft_living. Use an alias to change the name of the second column.

SELECT bedrooms, ROUND(AVG(sqft_living), 2) as average_sqft_living
FROM house_price_data
GROUP BY bedrooms
ORDER BY average_sqft_living;


-- What is the average price of the houses with a waterfront and without a waterfront? The returned result should have only two columns, 
-- waterfront and Average of the prices. Use an alias to change the name of the second column.

SELECT ROUND(AVG(price), 2) as average_price, waterfront
FROM house_price_data
GROUP BY waterfront
ORDER BY average_price;


-- --------------------------------------------------------------------------------
-- CHECK!!!!!!! 
-- Is there any correlation between the columns condition and grade? You can analyse this by grouping the data by one of the variables and then 
-- aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation 
-- between the variables.

SELECT house_condition, ROUND(AVG(grade), 2) AS average_grade
FROM house_price_data
GROUP BY house_condition
ORDER BY house_condition;

-- The results are ambiguous and cannot determine the nature of the relation between house_condition and grade. 
-- For the lowest house_condition scores grade seems to increase, from house_condition 3 to 5, average_grade tendency slightle decreases from 7.83 to 7.38 to 7.32

SELECT grade , ROUND(AVG(house_condition), 2) AS average_housecondition
FROM house_price_data
GROUP BY grade
ORDER BY grade;

-- --------------------------------------------------------------------------------

-- 11. One of the customers is only interested in the following houses:
-- Number of bedrooms either 3 or 4
-- Bathrooms more than 3
-- One Floor
-- No waterfront
-- Condition should be 3 at least
-- Grade should be 5 at least
-- Price less than 300000
-- For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them?

SELECT * FROM house_price_data
WHERE
	bedrooms = 3 OR bedrooms = 4 AND
    bathrooms > 3 AND
    floors = 1 AND
    waterfront = 0 AND
    house_condition >= 3 AND
    grade >= 5 AND
    price < 300000
;


-- 12. Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database. 
-- Write a query to show them the list of such properties. You might need to use a sub query for this problem.

SELECT * FROM house_price_data
WHERE price = 2 * (
	SELECT AVG(price) AS average_price
    FROM house_price_data);

-- There are no properties with price equal to twice the average price of all houses. 

-- Following query returns houses with price greater than or equal to twice the average houses price:

SELECT * FROM house_price_data
WHERE price >= 2 * (
	SELECT AVG(price) AS average_price
    FROM house_price_data);


-- 13. Since this is something that the senior management is regularly interested in, create a view of the same query.

CREATE VIEW twice_averageprice_houses AS
SELECT * FROM house_price_data
WHERE price >= 2 * (
	SELECT AVG(price) AS average_price
    FROM house_price_data);
    
SELECT * FROM twice_averageprice_houses;


-- 14. Most customers are interested in properties with three or four bedrooms. 
-- What is the difference in average prices of the properties with three and four bedrooms?

-- Average price of houses with 3 and 4 bedrooms
SELECT bedrooms, ROUND(AVG(price)) as average_price
FROM house_price_data
WHERE bedrooms = 3 OR bedrooms = 4
GROUP BY bedrooms;

-- Difference in average prices of houses with 3 and 4 bedrooms
SELECT
  AVG(CASE WHEN bedrooms = 4 THEN price END) -
  AVG(CASE WHEN bedrooms = 3 THEN price END) AS price_difference
FROM house_price_data
WHERE bedrooms IN (3, 4);


-- 15. What are the different locations where properties are available in your database? (distinct zip codes)

SELECT DISTINCT(zip_code) FROM house_price_data
ORDER BY zip_code DESC;


-- 16. Show the list of all the properties that were renovated.

SELECT * FROM house_price_data
WHERE yr_renovated <> 0;


-- 17. Provide the details of the property that is the 11th most expensive property in your database.

SELECT * FROM house_price_data
ORDER BY price DESC
LIMIT 1 OFFSET 10;



select * from house_price_data
where bedrooms = 33;
