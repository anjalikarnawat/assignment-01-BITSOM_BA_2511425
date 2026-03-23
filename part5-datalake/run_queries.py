import duckdb

# Run this file from INSIDE the part5-datalake/ folder:
# cd part5-datalake
# python run_queries.py

CUSTOMERS = '../datasets/customers.csv'
ORDERS    = '../datasets/orders.json'
PRODUCTS  = '../datasets/products.parquet'


print("=" * 55)
print("DEBUG: Products Schema")
print("=" * 55)
duckdb.sql(f"""
    DESCRIBE SELECT * FROM read_parquet('{PRODUCTS}')
""").show()


# Q1 — Total orders per customer
print("=" * 55)
print("Q1: Total Orders per Customer")
print("=" * 55)

duckdb.sql(f"""
    SELECT
        c.customer_id,
        c.name,
        COUNT(o.order_id) AS total_orders
    FROM read_csv_auto('{CUSTOMERS}') AS c
    LEFT JOIN read_json_auto('{ORDERS}') AS o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.name
    ORDER BY total_orders DESC
""").show()


# Q2 — Top 3 customers by total spend
print("=" * 55)
print("Q2: Top 3 Customers by Total Order Value")
print("=" * 55)

duckdb.sql(f"""
    SELECT
        c.customer_id,
        c.name,
        SUM(o.total_amount) AS total_spent
    FROM read_csv_auto('{CUSTOMERS}') AS c
    JOIN read_json_auto('{ORDERS}') AS o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.name
    ORDER BY total_spent DESC
    LIMIT 3
""").show()


# Q3 — Products purchased by Bangalore customers
duckdb.sql(f"""
    SELECT DISTINCT
        p.product_id,
        p.product_name AS product_name,
        p.category,
        p.unit_price   -- ✅ FIXED
    FROM read_csv_auto('{CUSTOMERS}') AS c
    JOIN read_json_auto('{ORDERS}') AS o
        ON c.customer_id = o.customer_id
    JOIN read_parquet('{PRODUCTS}') AS p
        ON o.order_id = p.order_id
    WHERE c.city = 'Bangalore'
    ORDER BY p.product_name
""").show()


# Q4 — Customer + Order Date + Product + Quantity
print("=" * 55)
print("Q4: Customer + Order Date + Product + Quantity")
print("=" * 55)

duckdb.sql(f"""
    SELECT
        c.name AS customer_name,
        o.order_date,
        p.product_name AS product_name,
        p.quantity
    FROM read_csv_auto('{CUSTOMERS}') AS c
    JOIN read_json_auto('{ORDERS}') AS o
        ON c.customer_id = o.customer_id
    JOIN read_parquet('{PRODUCTS}') AS p
        ON o.order_id = p.order_id
    ORDER BY o.order_date, c.name
""").show()