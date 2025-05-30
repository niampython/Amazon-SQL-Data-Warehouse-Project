/*
=========================================
DDL Script: Create Silver Tables
=========================================
Script Purpose:
	This script creates tables in the 'silver' schema, dropping existing tables
	if they already exist.
	 Run this script to re-define the DDL structure of 'bronze' Tables
=========================================
*/

IF OBJECT_ID ('silver.Amazon_Data_Set_category', 'U') IS NOT NULL
	DROP TABLE silver.Amazon_Data_Set_category;
CREATE TABLE silver.Amazon_Data_Set_category
(
category_id INT,	
category_name VARCHAR(30),
[dwh_create_date] DATE
);

GO 

IF OBJECT_ID ('silver.Amazon_Data_Set_products', 'U') IS NOT NULL
	DROP TABLE silver.Amazon_Data_Set_products;
CREATE TABLE silver.Amazon_Data_Set_products
(
product_id	INT,
product_name VARCHAR(50),
price	DECIMAL(10,2),
cogs	DECIMAL(10,2),
category_id INT,
[dwh_create_date] DATE
)

GO

IF OBJECT_ID ('silver.Amazon_Data_Set_orders', 'U') IS NOT NULL
	DROP TABLE silver.Amazon_Data_Set_orders;
CREATE TABLE silver.Amazon_Data_Set_orders
(
order_id INT,
order_date	DATE,
customer_id	INT,
seller_id	INT,
order_status VARCHAR(11),
[dwh_create_date] DATE
)

GO

IF OBJECT_ID ('silver.Amazon_Data_Set_orders_items', 'U') IS NOT NULL
	DROP TABLE silver.Amazon_Data_Set_orders_items;
CREATE TABLE silver.Amazon_Data_Set_orders_items
(
order_item_id INT,	
order_id INT,	
product_id INT,	
quantity INT,	
price_per_unit DECIMAL(10,2),
[dwh_create_date] DATE
)

GO

IF OBJECT_ID ('silver.Amazon_Data_Set_customers', 'U') IS NOT NULL
	DROP TABLE silver.Amazon_Data_Set_customers;
CREATE TABLE silver.Amazon_Data_Set_customers
(
Customer_ID	 INT,
first_name	VARCHAR(25),
last_name	VARCHAR(25),
state      VARCHAR(25),
[dwh_create_date] DATE
)
