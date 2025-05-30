/*
================================
quality checks
================================
Script Purpose:
	This script performs various quality checks for data consistency, accuracy,
	and standardization across the 'silver' schema.  It includes checks for:
	-duplicate primary keys or nulls for primary keys
	-missing data
	-inconsitencies and the need for normalization
	-unwanted spaces in string fields
Usage Notes:
	Run these queries if you want to check for any quality issues in silver layer.
*/

--===============================================
--quality check customer table
--=================================================
--Finding duplicates and nulls for Primary Key column for customer table
SELECT [Customer_ID],COUNT(*) count_of_duplicates_
FROM [DataWarehouse].[silver].[Amazon_Data_Set_customers]
GROUP BY [Customer_ID]
HAVING COUNT(*) > 1 OR [Customer_ID] IS NULL


--Checking for any extra white space between columns for customer table
--first_name and last_name have unwanted white space
SELECT [Customer_ID],[first_name], [last_name],[state],[cst_create_date]
FROM [silver].[Amazon_Data_Set_customers]
where first_name <> trim(first_name) or last_name <> trim(last_name)
or state <> trim(state)  

--===============================================
--quality check products table
--=================================================

--checking for negative numbers in product table
select *
from [bronze].[Amazon_Data_Set_products]
WHERE price = -(price) or cogs = -(cogs)

--Checking for any extra white space between columns in product table
--first_name and last_name have unwanted white space
SELECT [product_id],[product_name],[price],[cogs],[category_id]
FROM [bronze].[Amazon_Data_Set_products]
where [product_name] <> trim([product_name])


--===============================================
--quality check orders table
--=================================================
--checking for unwanted white spaces in orders table
SELECT * 
FROM [bronze].[Amazon_Data_Set_orders]
WHERE [order_status]<> trim([order_status])
