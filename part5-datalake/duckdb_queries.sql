
-- Q1: 
SELECT
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders
FROM
    read_csv_auto('../datasets/customers.csv') AS c
LEFT JOIN
    read_json_auto('../datasets/orders.json') AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id, c.name
ORDER BY
    total_orders DESC;


-- Q2: 
SELECT
    c.customer_id,
    c.name,
    SUM(o.total_amount) AS total_spent
FROM
    read_csv_auto('../datasets/customers.csv') AS c
JOIN
    read_json_auto('../datasets/orders.json') AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id, c.name
ORDER BY
    total_spent DESC
LIMIT 3;


-- Q3: 
SELECT DISTINCT
    p.product_id,
    p.product_name AS product_name,
    p.category,
    p.unit_price   -- ✅ FIXED
FROM
    read_csv_auto('../datasets/customers.csv') AS c
JOIN
    read_json_auto('../datasets/orders.json') AS o
    ON c.customer_id = o.customer_id
JOIN
    read_parquet('../datasets/products.parquet') AS p
    ON o.order_id = p.order_id
WHERE
    c.city = 'Bangalore'
ORDER BY
    p.product_name;


-- Q4:
SELECT
    c.name       AS customer_name,
    o.order_date,
    p.product_name AS product_name,
    p.quantity
FROM
    read_csv_auto('../datasets/customers.csv') AS c
JOIN
    read_json_auto('../datasets/orders.json') AS o
    ON c.customer_id = o.customer_id
JOIN
    read_parquet('../datasets/products.parquet') AS p
    ON o.order_id = p.order_id
ORDER BY
    o.order_date, c.name;