CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	declare @start_date datetime, @end_date datetime
	set @start_date = GETDATE();
    -- Truncate silver.crm_cust_info before inserting new data
    PRINT '>>> Truncating silver.crm_cust_info... <<<'
    TRUNCATE TABLE silver.crm_cust_info;

    -- Clean and load bronze.crm_cust_info
    PRINT '>>> Cleaning and loading bronze.crm_cust_info... <<<'
    ;WITH clean_cust_info AS (
        SELECT 
            cst_id, 
            cst_key, 
            TRIM(cst_firstname) AS cst_firstname,
            TRIM(cst_lastname) AS cst_lastname,
            CASE cst_marital_status
                WHEN 'M' THEN 'Married'
                WHEN 'S' THEN 'Single'
                ELSE cst_marital_status
            END AS cst_marital_status,
            CASE cst_gender
                WHEN 'M' THEN 'Male'
                WHEN 'F' THEN 'Female'
                ELSE cst_gender
            END AS cst_gender,
            cst_crate_date,
            ROW_NUMBER() OVER(PARTITION BY cst_key ORDER BY cst_crate_date DESC) AS duplicates
        FROM bronze.crm_cust_info
    )
    INSERT INTO silver.crm_cust_info (
        cst_id, 
        cst_key,
        cst_firstname, 
        cst_lastname, 
        cst_marital_status, 
        cst_gender, 
        cst_crate_date
    ) 
    SELECT 
        cst_id, 
        cst_key, 
        cst_firstname, 
        cst_lastname, 
        cst_marital_status, 
        cst_gender, 
        cst_crate_date
    FROM clean_cust_info
    WHERE duplicates = 1;
    PRINT '>>> Data successfully loaded into silver.crm_cust_info. <<<'

    -- Truncate silver.crm_prd_info
    PRINT '>>> Truncating silver.crm_prd_info... <<<'
    TRUNCATE TABLE silver.crm_prd_info;

    -- Clean and load bronze.crm_prd_info
    PRINT '>>> Cleaning and loading bronze.crm_prd_info... <<<'
    ;WITH clean_crm_prd_info AS (
        SELECT
            prd_id,
            SUBSTRING(prd_key, 1, 5) AS cat_id,
            SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
            prd_nm,
            ISNULL(prd_cost, 0) AS prd_cost,
            CASE prd_line
                WHEN 'R' THEN 'Road'
                WHEN 'M' THEN 'Mountain'
                WHEN 'S' THEN 'Other Sales'
                WHEN 'T' THEN 'Touring'
                ELSE 'N/A'
            END AS prd_line,
            prd_start_dt,
            LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) AS prd_end_dt
        FROM bronze.crm_prd_info
    )
    INSERT INTO silver.crm_prd_info(
        prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )
    SELECT
        prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    FROM clean_crm_prd_info;
    PRINT '>>> Data successfully loaded into silver.crm_prd_info. <<<'

    -- Truncate silver.crm_sales_details
    PRINT '>>> Truncating silver.crm_sales_details... <<<'
    TRUNCATE TABLE silver.crm_sales_details;

    -- Clean and load bronze.crm_sales_details
    PRINT '>>> Cleaning and loading bronze.crm_sales_details... <<<'
    ;WITH clean_crm_sales_details AS (
        SELECT
            sls_order_num,
            sls_prd_key,
            sls_cust_id,
            CASE 
                WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
            END AS sls_order_dt,
            CASE 
                WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
            END AS sls_ship_dt,
            CASE 
                WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
            END AS sls_due_dt,
            CASE 
                WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_qty * ABS(sls_price) 
                    THEN sls_qty * sls_price
                ELSE sls_sales 
            END AS sls_sales,
            sls_qty,
            CASE 
                WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / sls_qty
                ELSE sls_price 
            END AS sls_price
        FROM bronze.crm_sales_details
    )
    INSERT INTO silver.crm_sales_details(
        sls_order_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_qty,
        sls_price
    )
    SELECT 
        sls_order_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_qty,
        sls_price
    FROM clean_crm_sales_details;
    PRINT '>>> Data successfully loaded into silver.crm_sales_details. <<<'

    -- Truncate silver.erp_cust_az12
    PRINT '>>> Truncating silver.erp_cust_az12... <<<'
    TRUNCATE TABLE silver.erp_cust_az12;

    -- Clean and load bronze.erp_cust_az12
    PRINT '>>> Cleaning and loading bronze.erp_cust_az12... <<<'
    ;WITH clean_erp_cust_az12 AS (
        SELECT 
            SUBSTRING(cid, 4, LEN(cid)) AS cid,
            CASE 
                WHEN bdate > GETDATE() THEN NULL 
                ELSE bdate 
            END AS bdate,
            CASE
                WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
                WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
                ELSE 'N/A' 
            END AS gen
        FROM bronze.erp_cust_az12
    )
    INSERT INTO silver.erp_cust_az12(
        cid,
        bdate,
        gen
    )
    SELECT
        cid,
        bdate,
        gen
    FROM clean_erp_cust_az12;
    PRINT '>>> Data successfully loaded into silver.erp_cust_az12. <<<'

    -- Truncate silver.erp_loc_a101
    PRINT '>>> Truncating silver.erp_loc_a101... <<<'
    TRUNCATE TABLE silver.erp_loc_a101;

    -- Clean and load bronze.erp_loc_a101
    PRINT '>>> Cleaning and loading bronze.erp_loc_a101... <<<'
    ;WITH clean_erp_loc_a101 AS (
        SELECT 
            REPLACE(cid, '-', '') AS cid,
            CASE 
                WHEN cntry IN('DE', 'Germany') THEN 'Germany'
                WHEN cntry IN ('USA', 'United States', 'US') THEN 'United States'
                WHEN cntry IS NULL OR cntry = '' THEN 'N/A' 
                ELSE TRIM(cntry) 
            END AS cntry
        FROM bronze.erp_loc_a101
    )
    INSERT INTO silver.erp_loc_a101(
        cid,
        cntry
    )
    SELECT 
        cid,
        cntry
    FROM clean_erp_loc_a101;
    PRINT '>>> Data successfully loaded into silver.erp_loc_a101. <<<'

    -- Truncate silver.erp_px_cat_g1v2
    PRINT '>>> Truncating silver.erp_px_cat_g1v2... <<<'
    TRUNCATE TABLE silver.erp_px_cat_g1v2;

    -- Clean and load bronze.erp_px_cat_g1v2
    PRINT '>>> Cleaning and loading bronze.erp_px_cat_g1v2... <<<'
    ;WITH clean_erp_px_cat_g1v2 AS (
        SELECT 
            REPLACE(id, '_', '-') AS id,
            cat,
            subcat,
            maintenance
        FROM bronze.erp_px_cat_g1v2
    )
    INSERT INTO silver.erp_px_cat_g1v2(
        id,
        cat,
        subcat,
        maintenance
    )
    SELECT 
        id,
        cat,
        subcat,
        maintenance
    FROM clean_erp_px_cat_g1v2;
    PRINT '>>> Data successfully loaded into silver.erp_px_cat_g1v2. <<<'
	set @end_date = GETDATE();
	PRINT '========================================================='
	PRINT 'Load Duration: '+ CAST(DATEDIFF(SECOND, @start_date, @end_date)AS NVARCHAR)+ ' second(s)'
	PRINT '========================================================='
END

