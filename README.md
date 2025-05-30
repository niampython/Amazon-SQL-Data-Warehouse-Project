# Amazon-SQL-Data-Warehouse-Project

The purpose of the **Amazon-SQL-Data-Warehouse-Project** is to build knowledge in data warehousing and analytics.  
The project incorporates data modelling, performing ETL processes through SQL,  normalization  of data, creating schemas, databases, and tables in SQL Server.
The objective is to get the data from the data sources to the end users (data analyst, business users, management).

---

##  Project Requirements

### Building The Data Warehouse (Data Engineering)

#### Objective
Create a data warehouse using SQL Server to centralize data from Amazon and provide production ready data to end-users.

#### Specifications
-**Data Sources**: Import data from several different sources in excel files.\n
-**Data Quality**: Cleanse and resolve data quality issues prior to loading data to final stage.
-**Integration**: Combine all sources into a single, user_friendly data model designed for analytical queries.
-**Scope**: Historization is not needed for this project, only updated data is wanted.
-**Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

### BI: Analytics & Reporting 

#### Objective

Develop SQL-Based analytics and Tableau reporting for detailed insights of:

-**Sales Trends**
-**Product Performance**
-**Intelligence on Customer buying trends**

---

**Data Architechture**

The data architecture for this project is using the Medallion model.  Going by Bronze, Silver, and Gold layers:

![image](https://github.com/user-attachments/assets/7be8496e-dfe0-4c6e-adef-b03f1cd9131c)

1. **Bronze Lyaer**: The first layer where the extracted data is loaded too.
     The bronze layer consist of raw data, extracted from a csv file, into SQL server database.
2. **Silver Layer**:  In this layer is where data is normalized, cleansed, standardized, and prepared for the final destination for analysis.
3. **Gold Layer**:  During this phase, the data is production ready and ready to be used by data analyst and business users.
     This data can be used for reporting or ad hoc queries.

