# 📦 Data Warehousing Project using Medallion Architecture (SQL Server)

## 📑 Overview

This project showcases a **Data Warehousing** pipeline built on **SQL Server**, using CSV datasets extracted from **ERP** and **CRM** systems. It follows the **Medallion Architecture** (Bronze, Silver, Gold) to incrementally transform raw data into valuable business insights.

## 🏗️ Architecture: Medallion Design

- **Bronze Layer (Raw)**  
  Ingests raw CSV data from ERP and CRM systems with minimal transformation.
  
- **Silver Layer (Cleansed)**  
  Applies data cleaning, joins, standardization, and type casting for analytics readiness.
  
- **Gold Layer (Business-Level Models)**  
  Aggregates and curates data for reporting, dashboards, and business intelligence use cases.

## 🧰 Tools & Technologies

- **SQL Server**  
  - Database engine for storing and transforming data across medallion layers  
  - SQL scripts for ETL processing  
- **Microsoft SQL Server Management Studio (SSMS)**  
  - Development and execution of SQL scripts  
- **CSV Files**  
  - Data sources extracted from ERP and CRM systems

## 🔄 ETL Flow

1. **Ingestion:**  
   - Load CSV files into `Bronze` tables using `BULK INSERT`.
2. **Transformation (Bronze ➝ Silver):**  
   - Clean invalid/missing values  
   - Normalize and deduplicate  
   - Apply necessary joins (e.g., customer data from CRM + transaction data from ERP)
3. **Modeling (Silver ➝ Gold):**  
   - Aggregate revenue by region, customer segment, product, etc.  
   - Build star schema (facts and dimensions) for reporting
  
## 📌 Future Improvements
1. **Automate ETL with SQL Server Agent or Azure Data Factory**
2. **Integrate real-time ingestion using Kafka**
3. **Add Slowly Changing Dimensions (SCD) handling**
4. **Connect to visualization tools (Power BI, Looker Studio)**
