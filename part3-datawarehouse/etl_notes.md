## ETL Decisions

### Decision 1 — Fixing Different Date Formats
Problem: The dates in the CSV were not in one consistent format. Some rows
used DD/MM/YYYY (e.g. 29/08/2023), some used DD-MM-YYYY (e.g. 12-12-2023),
and others used YYYY-MM-DD (e.g. 2023-02-05). This was a problem because
MySQL expects dates in one standard format, and mixed formats can cause
insert failures or wrong sorting.

Resolution: I manually converted all dates to the YYYY-MM-DD format before
writing the INSERT statements. I also stored the date as an integer key in
YYYYMMDD format (e.g. 20230115) in the dim_date table because it makes
joining with the fact table simpler and faster.

---

### Decision 2 — Fixing Category Name Inconsistencies
Problem: The category column was not consistent across rows. The same
category was written in different ways — for example "electronics" in some
rows and "Electronics" in others. Similarly, grocery items were sometimes
labelled "Grocery" and sometimes "Groceries". If I loaded this as-is,
GROUP BY queries would treat them as separate categories and give wrong
totals.

Resolution: I picked one standard version for each category and used it
everywhere in the dim_product inserts. I went with Title Case throughout
(Electronics, Grocery, Clothing). So "electronics" became "Electronics"
and "Groceries" became "Grocery" across all rows.

---

### Decision 3 — Filling in Missing City Values
Problem: Some rows in the raw data had a blank store_city — for example
TXN5033 had "Mumbai Central" as the store name but no city value. Loading
NULL cities into the dim_store table would cause issues when grouping or
filtering by city in queries.

Resolution: Since every store name always belongs to the same city
(Mumbai Central is always in Mumbai, Chennai Anna is always in Chennai,
etc.), I just filled in the correct city manually during the dim_store
INSERT. There were only 5 stores so it was easy to do without any guessing.