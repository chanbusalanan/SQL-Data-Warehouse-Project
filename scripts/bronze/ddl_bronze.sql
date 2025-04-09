/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist. Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

-- ============================================================================
-- Table: bronze.crm_cust_info
-- ============================================================================
DROP TABLE IF EXISTS bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
    cst_id             NVARCHAR(50),
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gender         NVARCHAR(50),
    cst_crate_date     DATE
);

-- ============================================================================
-- Table: bronze.crm_prd_info
-- ============================================================================
DROP TABLE IF EXISTS bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
    prd_id          NVARCHAR(50),
    prd_key         NVARCHAR(50),
    prd_nm          NVARCHAR(50),
    prd_cost        NVARCHAR(50),
    prd_line        NVARCHAR(50),
    prd_start_dt    DATE,
    prd_end_dt      DATE
);

-- ============================================================================
-- Table: bronze.crm_sales_details
-- ============================================================================
DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
    sls_order_num   NVARCHAR(50),
    sls_prd_key     NVARCHAR(50),
    sls_cust_id     NVARCHAR(50),
    sls_order_dt    NVARCHAR(50),
    sls_ship_dt     NVARCHAR(50),
    sls_due_dt      NVARCHAR(50),
    sls_sales       INT,
    sls_qty         INT,
    sls_price       INT
);

-- ============================================================================
-- Table: bronze.erp_cust_az12
-- ============================================================================
DROP TABLE IF EXISTS bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
    cid     NVARCHAR(50),
    bdate   DATE,
    gen     NVARCHAR(50)
);

-- ============================================================================
-- Table: bronze.erp_loc_a101
-- ============================================================================
DROP TABLE IF EXISTS bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101 (
    cid     NVARCHAR(50),
    cntry   NVARCHAR(50)
);

-- ============================================================================
-- Table: bronze.erp_px_cat_g1v2
-- ============================================================================
DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(50),
    cat          NVARCHAR(50),
    subcat       NVARCHAR(50),
    maintenance  NVARCHAR(50)
);
