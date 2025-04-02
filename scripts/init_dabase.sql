/*
================================================================
Creating Database and Schema
================================================================
Script Purpose:
	This script creates the database "DataWarehouse" after checking if it already exists.
	Sets up the schema "bronze","silver", and "gold" in the database

WARNING:
	Running this script will drop the entire database if it exists.
	All data in the database will be permanently deleted.
	Proceed with caution and ensure proper backups when running this script

*/


-- Drop and recreate DataWarehouse
use master;
if exists (select 1 from sys.databases where name= 'DataWarehouse')
begin
	alter database DataWarehouse set single_user with rollback immediate;
	drop database DataWarehouse;
end
go

-- Create database
create database DataWarehouse;
go
use DataWarehouse;
go

-- Create Schema
create schema bronze;
go
create schema silver;
go
create schema gold;
go
