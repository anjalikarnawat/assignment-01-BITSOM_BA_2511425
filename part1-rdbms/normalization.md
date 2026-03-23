# Normalization Analysis

## Anomaly Analysis

### Insert Anomaly

**Definition:** An insert anomaly occurs when you cannot add new data to the
database without also providing unrelated data.

**Example from orders_flat.csv:**
It is impossible to add a new product to the system unless a customer
places an order for it. For example, if the company stocks a new product
"Keyboard" (P009, Electronics, ₹1500), there is no way to record it in
the flat file because product information (product_id, product_name,
category, unit_price) only exists as part of an order row.

**Affected columns:** `product_id`, `product_name`, `category`, `unit_price`

**Why it's a problem:** The product catalog is incorrectly tied to sales
history. A product that exists in the warehouse but hasn't been ordered
yet simply cannot be stored.

---

### Update Anomaly

**Definition:** An update anomaly occurs when changing one piece of
information requires updating multiple rows, and missing even one row
creates inconsistency in the data.

**Example from orders_flat.csv:**
Sales rep SR01 (Deepak Joshi) has his office_address repeated across
60+ rows. However, the address is already inconsistent in the dataset —
most rows store "Mumbai HQ, Nariman Point, Mumbai - 400021" but rows
37, 56, 89, 92, 96, 98, 110, 122, 125, 129, 152, 154, 158, 170, 174,
175, 176, 180 store "Mumbai HQ, Nariman Pt, Mumbai - 400021" (truncated
"Pt" instead of "Point").

**Affected column:** `office_address`
**Affected rows (sample):** Row 37 (ORD1180), Row 56 (ORD1173),
Row 89 (ORD1170), Row 98 (ORD1184)

**Why it's a problem:** If the office relocates, all 60+ rows must be
updated manually. As already seen, even a small inconsistency like
"Pt" vs "Point" causes dirty data that can break searches and reports.

---

### Delete Anomaly

**Definition:** A delete anomaly occurs when deleting one piece of data
accidentally destroys other unrelated and important data.

**Example from orders_flat.csv:**
All information about a customer — their name, email, and city — exists
only within order rows. If all orders placed by customer C007
(Arjun Nair, arjun@gmail.com, Bangalore) were deleted from the system
(for example, due to a full refund or account closure), every trace of
Arjun Nair would be permanently lost from the database. There is no
separate customers table to preserve his record.

**Affected columns:** `customer_id`, `customer_name`, `customer_email`,
`customer_city`
**Affected rows:** All rows where customer_id = 'C007'
(ORD1005, ORD1024, ORD1025, ORD1039, ORD1049, ORD1064, ORD1080,
ORD1085, ORD1093, ORD1097, ORD1098, ORD1103, ORD1113, ORD1119,
ORD1127, ORD1128, ORD1129, ORD1145, ORD1148, ORD1150, ORD1151,
ORD1155, ORD1159, ORD1163, ORD1178, ORD1181)

**Why it's a problem:** Customer data and order data are two different
things. A customer can exist without orders. Linking their existence to
orders means losing business-critical contact information the moment
their order history is cleared.

---

## Normalization Justification

While keeping all data in one flat table may seem simpler at first
glance, the orders_flat.csv dataset demonstrates clearly why this
approach creates serious, real-world problems.

The flat file stores customer details — customer_name, customer_email,
and customer_city — in every single order row. Customer C002 (Priya
Sharma) appears in over 15 rows. If her email address changes, every
one of those rows must be updated manually. If even one row is missed,
different parts of the application will show different emails for the
same person, which destroys data reliability. This is not a hypothetical
risk — the dataset already shows this happening with the office_address
column for SR01 (Deepak Joshi), where some rows say "Nariman Point" and
others say "Nariman Pt", a direct consequence of repeated data in
multiple rows.

The flat file also prevents adding a new product like a Keyboard (P009)
until a customer actually orders one. This means the product catalog is
incorrectly dependent on sales history — something no real business
would accept.

Most critically, if all orders for customer C007 (Arjun Nair) were
deleted, all knowledge of that customer — his email, city, and identity
— would be permanently lost. In a real company, this could mean losing
contact with a valuable client simply because their order history was
cleared.

Normalization into 3NF solves all three problems by giving each entity
its own table. Customers, products, and sales reps each have one row of
truth. Updates happen in exactly one place. New products can be added
without needing an order. Customers persist even with no active orders.

The argument that normalization is "over-engineering" confuses short-term
convenience with long-term correctness. A single table works fine for
10 rows in a spreadsheet. At thousands of rows with multiple users
making changes simultaneously, the inconsistencies compound rapidly and
become very expensive to fix. Normalization is not added complexity — it
is the foundation that makes a database trustworthy, maintainable, and
ready to scale.