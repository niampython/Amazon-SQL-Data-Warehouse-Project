/*
===================================
Stored Procedure: Load Silver Layer (Bronze to silver)
===================================

Script Purpose:
	This stored procedure performs the ETL (Extract, Transform, Load) process to 
	populate the 'silver schema tables from the 'bronze' schema.
   Actions performed:
   -Truncates Silver tables
   -Inserts transformed and cleansed data from Bronze into Silver tables.
Parameters
	None.
	This stored procedure does not accept any parameters or return any values.

stored procedure execution code: exec [silver].[load_silver]
*/



CREATE OR ALTER PROCEDURE silver.load_silver AS

BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME,@batch_start_time DATETIME,@batch_end_time DATETIME
	BEGIN TRY
		PRINT '=============================================='
		PRINT 'Loading Silver Layer'
		PRINT '=============================================='

		PRINT 'Loading CSV files'


	--Get the most recent create date for rows with duplicates primary keys
	SET @start_time = GETDATE();
	PRINT'>> Truncating Table: [bronze].[Amazon_Data_Set_customers]'
	TRUNCATE TABLE [silver].[Amazon_Data_Set_customers]

	PRINT '>> Inserting Data Into: [bronze].[Amazon_Data_Set_customers]'
	INSERT INTO [silver].[Amazon_Data_Set_customers](
	[Customer_ID],[first_name], [last_name],[state],[cst_create_date]
	)
	
	SELECT[Customer_ID],TRIM([first_name]), TRIM([last_name]),[state],[cst_create_date]
	FROM
	(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY [Customer_ID] ORDER BY [cst_create_date] DESC) Flag_Most_Recent_date
	FROM [bronze].[Amazon_Data_Set_customers]
	) B
	WHERE Flag_Most_Recent_date = 1 and [Customer_ID] IS NOT NULL
	
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds'
	PRINT '>> -------------';
	
	--loading bronze product table in silver product table
	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: [bronze].[Amazon_Data_Set_products]'
	TRUNCATE TABLE [silver].[Amazon_Data_Set_products]

	PRINT '>> Inserting Data Into: [bronze].[Amazon_Data_Set_products]'
	INSERT INTO [silver].[Amazon_Data_Set_products](
	[product_id],[product_name],[price],[cogs],[category_id]
	)
	
	SELECT *
	FROM [bronze].[Amazon_Data_Set_products]
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds'
	PRINT '>> -------------';
	
	--conducting normalization on order status column
	--loading orders data from bronze to silver table
	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: [bronze].[Amazon_Data_Set_orders]'
	TRUNCATE TABLE [silver].[Amazon_Data_Set_orders]

	PRINT '>> Inserting Data Into: [bronze].[Amazon_Data_Set_orders]'
	INSERT INTO [silver].[Amazon_Data_Set_orders]
	([order_id],[order_date],[customer_id],[seller_id], order_status)
	select [order_id],[order_date],[customer_id],[seller_id],
	CASE WHEN [order_status] = 'in-p' THEN 'In Progress' 
	WHEN [order_status] = 'r' THEN 'return' 
	WHEN [order_status] = 'c' THEN 'cancelled' 
	WHEN [order_status] = 'comp' THEN 'complete' 
	END order_status
	FROM [bronze].[Amazon_Data_Set_orders]
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds'
	PRINT '>> -------------';
	
	--loading data from bronze category table to silver category table
	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: [silver].[Amazon_Data_Set_category]'
	TRUNCATE TABLE [silver].[Amazon_Data_Set_category]

	PRINT '>> Inserting Data Into: [bronze].[Amazon_Data_Set_category]'
	INSERT INTO [silver].[Amazon_Data_Set_category]
	([category_id],[category_name])
	SELECT *
	FROM [bronze].[Amazon_Data_Set_category]
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds'
	PRINT '>> -------------';
	
	--loading data from orders_item bronze category table to silver category table
	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: [bronze].[Amazon_Data_Set_order_items]'
	TRUNCATE TABLE [silver].[Amazon_Data_Set_orders_items]

	PRINT '>> Inserting Data Into: [bronze].[Amazon_Data_Set_orders_items]'
	INSERT INTO [silver].[Amazon_Data_Set_orders_items]
	([order_item_id],[order_id], [product_id], [quantity], [price_per_unit])
	SELECT *
	FROM [bronze].[Amazon_Data_Set_orders_items]
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds'
	PRINT '>> -------------';
	END TRY
	BEGIN CATCH
		PRINT'========================================='
		PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT'Error message'  + ERROR_MESSAGE();
		PRINT'Error Message'  + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT'Error Message'  + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT'========================================='
	END CATCH

END

