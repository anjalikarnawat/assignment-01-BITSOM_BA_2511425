USE retail_dw;

-- Q1: 
SELECT
    d.year,
    d.month,
    d.month_name,
    p.category,
    SUM(f.total_amount) AS total_revenue
FROM fact_sales f
JOIN dim_date    d ON f.date_key    = d.date_key
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY d.year, d.month, d.month_name, p.category
ORDER BY d.year, d.month, p.category;

-- Q2: 
SELECT
    s.store_name,
    s.store_city,
    SUM(f.total_amount) AS total_revenue
FROM fact_sales f
JOIN dim_store s ON f.store_key = s.store_key
GROUP BY s.store_key, s.store_name, s.store_city
ORDER BY total_revenue DESC
LIMIT 2;

-- Q3: 
SELECT
    year,
    month,
    month_name,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY year, month) AS prev_month_revenue,
    ROUND(
        total_revenue - LAG(total_revenue) OVER (ORDER BY year, month),
    2) AS mom_change
FROM (
    SELECT
        d.year,
        d.month,
        d.month_name,
        SUM(f.total_amount) AS total_revenue
    FROM fact_sales f
    JOIN dim_date d ON f.date_key = d.date_key
    GROUP BY d.year, d.month, d.month_name
) AS monthly_totals
ORDER BY year, month;