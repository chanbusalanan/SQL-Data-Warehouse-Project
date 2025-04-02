/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist. Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

-- Create table bronze.crm_cust_info
drop table if exists bronze.crm_cust_info;
create table bronze.crm_cust_info(
	cst_id			nvarchar(50),
	cst_key			nvarchar(50),
	cst_firstname		nvarchar(50),
	cst_lastname		nvarchar(50),
	cst_marital_status	nvarchar(50),
	cst_gender		nvarchar(50),
	cst_crate_date		date
);

-- Create table bronze.crm_prd_info
drop table if exists bronze.crm_prd_info;
create table bronze.crm_prd_info(
	prd_id		nvarchar(50),
	prd_key		nvarchar(50),
	prd_nm		nvarchar(50),
	prd_cost	nvarchar(50),
	prd_line	nvarchar(50),
	prd_start_dt	date,
	prd_end_dt	date
);

-- Create table bronze.crm_sales_details
drop table if exists bronze.crm_sales_details;
create table bronze.crm_sales_details(
	sls_order_num	nvarchar(50),
	sls_prd_key	nvarchar(50),
	sls_cust_id	nvarchar(50),
	sls_order_dt	nvarchar(50),
	sls_ship_dt	nvarchar(50),
	sls_due_dt	nvarchar(50),
	sls_sales	int,
	sls_qty		int,
	sls_price	int
);

-- Create table bronze.erp_cust_az12
drop table if exists bronze.erp_cust_az12;
create table bronze.erp_cust_az12(
	cid	nvarchar(50),
	bdate	date,
	gen	nvarchar(50)
)


-- Create table bronze.erp_loc_a101
drop table if exists  bronze.erp_loc_a101;
create table  bronze.erp_loc_a101(
	cid	nvarchar(50),
	cntry	nvarchar(50)
)

-- Create table bronze.erp_px_cat_g1v2
drop table if exists bronze.erp_px_cat_g1v2
create table bronze.erp_px_cat_g1v2(
	id		nvarchar(50),
	cat		nvarchar(50),
	subcat		nvarchar(50),
	maintenance 	nvarchar(50)
)
