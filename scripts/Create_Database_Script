/*
==========================================
Create Database and Schemas
==========================================

SQL Code Purpose:
	This SQL script is to first check if the database named 'DataWarehouse' exists.  If the database indeed exist,
	the original database shold be dropped and the new database created.  Additionally, The script creates three 
	schemas within the DataWarehouse database, which are named: 'bronze', 'silver', and 'gold'.

Caution:
	Running this script will drop the existing 'DataWarehouse' database and replacing it with a new one.
	That would permanently remove all the data that is in the current database.  Please make sure you have backups
	before running this script.
*/


--Drop and recreate the 'DataWarehouse' database
IF EXISTS( SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;

GO

-- Create Database 'DataWarehouse'

CREATE DATABASE DataWarehouse

GO

USE DataWarehouse

GO

--Create Schema

CREATE SCHEMA bronze;
GO
CREATE SCHEMA gold;
GO
CREATE SCHEMA silver;
