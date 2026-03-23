
-- STAR SCHEMA FOR RETAIL SALES DATA WAREHOUSE
CREATE DATABASE IF NOT EXISTS retail_dw;
USE retail_dw;

-- DIMENSION TABLE 1: dim_date
CREATE TABLE IF NOT EXISTS dim_date (
    date_key        INT PRIMARY KEY,          -- e.g. 20230101 (compact integer key)
    full_date       DATE NOT NULL,
    day             INT NOT NULL,
    month           INT NOT NULL,
    month_name      VARCHAR(20) NOT NULL,
    quarter         INT NOT NULL,
    year            INT NOT NULL
);

-- DIMENSION TABLE 2: dim_store
CREATE TABLE IF NOT EXISTS dim_store (
    store_key       INT AUTO_INCREMENT PRIMARY KEY,
    store_name      VARCHAR(100) NOT NULL,
    store_city      VARCHAR(100) NOT NULL
);

-- DIMENSION TABLE 3: dim_product
CREATE TABLE IF NOT EXISTS dim_product (
    product_key     INT AUTO_INCREMENT PRIMARY KEY,
    product_name    VARCHAR(100) NOT NULL,
    category        VARCHAR(50) NOT NULL,     -- will always be Title Case
    unit_price      DECIMAL(10,2) NOT NULL
);

-- FACT TABLE: fact_sales
CREATE TABLE IF NOT EXISTS fact_sales (
    sale_id         INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id  VARCHAR(20) NOT NULL,
    date_key        INT NOT NULL,
    store_key       INT NOT NULL,
    product_key     INT NOT NULL,
    units_sold      INT NOT NULL,
    unit_price      DECIMAL(10,2) NOT NULL,
    total_amount    DECIMAL(12,2) NOT NULL,   -- derived: units_sold * unit_price

    -- Foreign key constraints (links to dimension tables)
    FOREIGN KEY (date_key)    REFERENCES dim_date(date_key),
    FOREIGN KEY (store_key)   REFERENCES dim_store(store_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key)
);

USE retail_dw;
-- INSERT DATA INTO dim_date
INSERT INTO dim_date VALUES
(20230115, '2023-01-15', 15,  1, 'January',   1, 2023),
(20230202, '2023-02-02', 2,   2, 'February',  1, 2023),
(20230205, '2023-02-05', 5,   2, 'February',  1, 2023),
(20230220, '2023-02-20', 20,  2, 'February',  1, 2023),
(20230331, '2023-03-31', 31,  3, 'March',     1, 2023),
(20230401, '2023-04-01', 1,   4, 'April',     2, 2023),
(20230501, '2023-05-01', 1,   5, 'May',       2, 2023),
(20230604, '2023-06-04', 4,   6, 'June',      2, 2023),
(20230809, '2023-08-09', 9,   8, 'August',    3, 2023),
(20231026, '2023-10-26', 26, 10, 'October',   4, 2023),
(20231208, '2023-12-08', 8,  12, 'December',  4, 2023),
(20231212, '2023-12-12', 12, 12, 'December',  4, 2023);

-- INSERT DATA INTO dim_store
INSERT INTO dim_store (store_key, store_name, store_city) VALUES
(1, 'Chennai Anna',    'Chennai'),
(2, 'Bangalore MG',   'Bangalore'),
(3, 'Mumbai Central', 'Mumbai'),
(4, 'Delhi South',    'Delhi'),
(5, 'Pune FC Road',   'Pune');

-- INSERT DATA INTO dim_product
INSERT INTO dim_product (product_key, product_name, category, unit_price) VALUES
(1,  'Speaker',     'Electronics', 49262.78),
(2,  'Tablet',      'Electronics', 23226.12),
(3,  'Phone',       'Electronics', 48703.39),
(4,  'Smartwatch',  'Electronics', 58851.01),
(5,  'Laptop',      'Electronics', 42343.15),
(6,  'Headphones',  'Electronics', 39854.96),
(7,  'Atta 10kg',   'Grocery',     52464.00),
(8,  'Biscuits',    'Grocery',     27469.99),
(9,  'Jeans',       'Clothing',    2317.47),
(10, 'Jacket',      'Clothing',    30187.24),
(11, 'Saree',       'Clothing',    35451.81),
(12, 'T-Shirt',     'Clothing',    29770.19);

-- INSERT DATA INTO fact_sales (at least 10 rows)
INSERT INTO fact_sales (transaction_id, date_key, store_key, product_key, units_sold, unit_price, total_amount) VALUES
('TXN5000', 20230809,  1,  1,  3,  49262.78,  147788.34),  -- Chennai, Speaker,    Aug
('TXN5001', 20231212,  1,  2, 11,  23226.12,  255487.32),  -- Chennai, Tablet,     Dec
('TXN5002', 20230205,  1,  3, 20,  48703.39,  974067.80),  -- Chennai, Phone,      Feb
('TXN5003', 20230220,  4,  2, 14,  23226.12,  325165.68),  -- Delhi,   Tablet,     Feb
('TXN5004', 20230115,  1,  4, 10,  58851.01,  588510.10),  -- Chennai, Smartwatch, Jan
('TXN5005', 20230809,  2,  7, 12,  52464.00,  629568.00),  -- Bangalore, Atta,     Aug
('TXN5006', 20230331,  5,  4,  6,  58851.01,  353106.06),  -- Pune,    Smartwatch, Mar
('TXN5007', 20231026,  5,  9, 16,  2317.47,    37079.52),  -- Pune,    Jeans,      Oct
('TXN5008', 20231208,  2,  8,  9,  27469.99,  247229.91),  -- Bangalore, Biscuits, Dec
('TXN5009', 20230809,  2,  4,  3,  58851.01,  176553.03),  -- Bangalore, Smartwatch, Aug
('TXN5010', 20230604,  1, 10, 15,  30187.24,  452808.60),  -- Chennai, Jacket,     Jun
('TXN5011', 20231026,  3,  9, 13,  2317.47,    30127.11);  -- Mumbai,  Jeans,      Oct