/*
===================================
Stored Procedure: Load Silver Layer (silver to gold)
===================================

Script Purpose:
	This stored procedure performs loading transformed data to its final stage in gold layer.
   Actions performed:
   -Inserts transformed and cleansed data from silver into gold tables.
Parameters
	None.
	This stored procedure does not accept any parameters or return any values.

***CAUTION The tables consist of foreign keys so you cannot update tables 
until foreign keys are temporarily disabled.***

stored procedure execution code: exec [gold].[load_gold]
*/



CREATE OR ALTER PROCEDURE gold.load_gold AS

BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME,@batch_start_time DATETIME,@batch_end_time DATETIME
	BEGIN TRY
		PRINT '=============================================='
		PRINT 'Loading gold Layer'
		PRINT '=============================================='

		PRINT 'Loading CSV files'

    --load into gold customer table

	SET @start_time = GETDATE();

	PRINT '>> Inserting Data Into: [gold].[Amazon_Data_Set_customers]'
	INSERT INTO [gold].[Amazon_Data_Set_customers](
	[Customer_ID],[first_name], [last_name],[state],[dwh_create_date] 
	)
	SELECT*
	FROM [silver].[Amazon_Data_Set_customers]
	
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds'
	PRINT '>> -------------';
	
	--loading silver product table in gold product table
	SET @start_time = GETDATE();
	
	PRINT '>> Inserting Data Into: [gold].[Amazon_Data_Set_products]'
	INSERT INTO [gold].[Amazon_Data_Set_products](
	[product_id],[product_name],[price],[cogs],[category_id],[dwh_create_date]
	)
	
	SELECT *
	FROM [silver].[Amazon_Data_Set_products]
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds'
	PRINT '>> -------------';
	
	--conducting normalization on order status column
	--loading orders data from silver to silver table
	SET @start_time = GETDATE();


	PRINT '>> Inserting Data Into: [gold].[Amazon_Data_Set_orders]'
	INSERT INTO [gold].[Amazon_Data_Set_orders]
	([order_id],[order_date],[customer_id],[seller_id], order_status,[dwh_create_date] )
	select*
	FROM [silver].[Amazon_Data_Set_orders]
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds'
	PRINT '>> -------------';
	
	--loading data from silver category table to silver category table
	SET @start_time = GETDATE();

	PRINT '>> Inserting Data Into: [gold].[Amazon_Data_Set_category]'
	INSERT INTO [gold].[Amazon_Data_Set_category]
	([category_id],[category_name], [dwh_create_date])
	SELECT *
	FROM [silver].[Amazon_Data_Set_category]
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds'
	PRINT '>> -------------';
	
	--loading data from orders_item silver category table to silver category table
	SET @start_time = GETDATE();

	PRINT '>> Inserting Data Into: [gold].[Amazon_Data_Set_orders_items]'
	INSERT INTO [gold].[Amazon_Data_Set_orders_items]
	([order_item_id],[order_id], [product_id], [quantity], [price_per_unit],[dwh_create_date])
	SELECT *
	FROM [silver].[Amazon_Data_Set_orders_items]
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds'
	PRINT '>> -------------';
	END TRY
	BEGIN CATCH
		PRINT'========================================='
		PRINT'ERROR OCCURED DURING LOADING silver LAYER'
		PRINT'Error message'  + ERROR_MESSAGE();
		PRINT'Error Message'  + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT'Error Message'  + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT'========================================='
	END CATCH

END
