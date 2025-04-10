/*
===============================================================================
DDL Script: Create Gold Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'gold' schema, dropping existing tables 
    if they already exist. Run this script to re-define the DDL structure of 
    'gold' tables.
===============================================================================
*/


-- =============================================================================
-- Dropping tables if it exists
-- =============================================================================
DROP TABLE IF EXISTS gold.sales;
DROP TABLE IF EXISTS gold.products;
DROP TABLE IF EXISTS gold.categories;
DROP TABLE IF EXISTS gold.customers;


-- =============================================================================
-- Table: gold.categories
-- =============================================================================
CREATE TABLE gold.categories (
    category_id     NVARCHAR(50) PRIMARY KEY,
    category        NVARCHAR(50),
    sub_category    NVARCHAR(50),
    maintenance     NVARCHAR(50)
);


-- =============================================================================
-- Table: gold.products
-- =============================================================================
CREATE TABLE gold.products (
    product_id      NVARCHAR(50) PRIMARY KEY,
    category_id     NVARCHAR(50),
    product_key     NVARCHAR(50) NOT NULL UNIQUE,
    product_name    NVARCHAR(50),
    product_line    NVARCHAR(50),
    start_date      DATE,
    cost            INT,
);


-- =============================================================================
-- Table: gold.customers
-- =============================================================================
CREATE TABLE gold.customers (
    customer_id     NVARCHAR(50) PRIMARY KEY,
    customer_key    NVARCHAR(50) UNIQUE NOT NULL,
    first_name      NVARCHAR(50),
    last_name       NVARCHAR(50),
    birthday        DATE,
    marital_status  NVARCHAR(50),
    gender          NVARCHAR(50),
    country         NVARCHAR(50),
    create_date     DATE
);


-- =============================================================================
-- Table: gold.sales
-- =============================================================================
CREATE TABLE gold.sales (
    order_number    NVARCHAR(50),
    customer_id     NVARCHAR(50) NOT NULL,
    product_key     NVARCHAR(50) NOT NULL,
    order_date      DATE,
    ship_date       DATE,
    due_date        DATE,
    quantity        INT,
    unit_price      INT,
    total_sales     INT,
);
