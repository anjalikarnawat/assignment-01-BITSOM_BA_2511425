-- Q1: 
USE retail_db;
SELECT
    c.customer_id,
    c.customer_name,
    SUM(p.unit_price * o.quantity) AS total_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
WHERE c.customer_city = 'Mumbai'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_order_value DESC;


-- Q2: 
SELECT
    p.product_id,
    p.product_name,
    SUM(o.quantity) AS total_qty_sold
FROM products p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_qty_sold DESC
LIMIT 3;


-- Q3: 
SELECT
    sr.sales_rep_id,
    sr.sales_rep_name,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM sales_reps sr
LEFT JOIN orders o ON sr.sales_rep_id = o.sales_rep_id
GROUP BY sr.sales_rep_id, sr.sales_rep_name
ORDER BY unique_customers DESC;


-- Q4: 
SELECT
    o.order_id,
    c.customer_name,
    p.product_name,
    o.quantity,
    p.unit_price,
    (p.unit_price * o.quantity) AS total_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p  ON o.product_id  = p.product_id
WHERE (p.unit_price * o.quantity) > 10000
ORDER BY total_value DESC;


-- Q5: 
SELECT
    p.product_id,
    p.product_name,
    p.category
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;