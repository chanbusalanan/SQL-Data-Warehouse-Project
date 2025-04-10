/*
===============================================================================
Stored Procedure: Load Gold Layer (Silver -> Gold)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'gold' schema from the 'silver' schema. 
    It performs the following actions:
        - Joins & Denormalization 
        - Filtering
        - Schema Alignment
	- Inserting data into the tables in the gold schema
Parameters:
    None. 
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC gold.load_gold;
===============================================================================
*/


CREATE OR ALTER PROCEDURE gold.load_gold AS
BEGIN
	-- =============================================================================
	-- Table: gold.customers
	-- =============================================================================
	TRUNCATE TABLE gold.customers
	INSERT INTO gold.customers(
		customer_id,
		customer_key,
		first_name,
		last_name,
		birthday,
		marital_status,
		gender,
		country,
		create_date
	)
	SELECT
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		bdate,
		cst_marital_status,
		COALESCE(cst_gender, gen, 'N/A') AS gender,
		cntry,
		cst_crate_date
	FROM silver.crm_cust_info AS cust_info
	LEFT JOIN silver.erp_loc_a101 AS loc
		ON cust_info.cst_key = loc.cid
	LEFT JOIN silver.erp_cust_az12 AS cust_az12
		ON cust_info.cst_key = cust_az12.cid
	WHERE cst_id IS NOT NULL;

	-- =============================================================================
	-- Table: gold.sales 
	-- =============================================================================
	TRUNCATE TABLE gold.sales
	INSERT INTO gold.sales(
		order_number,
		customer_id,
		product_key,
		order_date,
		ship_date,
		due_date,
		quantity,
		unit_price,
		total_sales
	)
	SELECT 
		sls_order_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_qty,
		sls_price,
		sls_sales
	FROM silver.crm_sales_details AS sales
	LEFT JOIN gold.customers AS cust
		ON sales.sls_cust_id = cust.customer_id
	WHERE cust.customer_id IS NOT NULL;

	-- =============================================================================
	-- Table: gold.products
	-- =============================================================================
	TRUNCATE TABLE gold.products
	INSERT INTO gold.products(
		product_id,
		category_id,
		product_key,
		product_name,
		product_line,
		start_date,
		cost
	)
	SELECT 	
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_line,
		prd_start_dt,
		prd_cost
	FROM silver.crm_prd_info AS prd
	LEFT JOIN silver.erp_px_cat_g1v2 AS cat
		ON prd.cat_id = cat.id
	WHERE prd.prd_end_dt IS NULL AND cat.id IS NOT NULL;

	-- =============================================================================
	-- Table: gold.categories
	-- =============================================================================
	TRUNCATE TABLE gold.categories
	INSERT INTO gold.categories(
		category_id,
		category,
		sub_category,
		maintenance
	)
	SELECT 
		id,
		cat,
		subcat,
		maintenance
	FROM silver.erp_px_cat_g1v2;
END
