## Storage Systems

For Goal 1 (readmission prediction), MySQL is used as the primary OLTP database to store structured patient records — diagnoses, treatments, discharge summaries, and visit history. MySQL's relational structure is ideal here because the ML model needs clean, queryable tabular data with well-defined relationships (patients → visits → treatments).

For Goal 2 (natural language querying by doctors), two systems work together: MySQL handles structured lookups like patient names and dates, while a Vector Database (such as Pinecone or pgvector) stores sentence embeddings of clinical notes. When a doctor asks "Has this patient had a cardiac event before?", the NLP layer converts the question into a vector, searches the Vector DB for semantically similar records, and returns results in plain English.

For Goal 3 (monthly management reports), a Data Warehouse (such as Amazon Redshift or Google BigQuery) is used. This is an OLAP system optimized for aggregating large volumes of historical data — perfect for computing total bed occupancy per month or department-wise costs across quarters.

For Goal 4 (real-time ICU vitals), Redis (an in-memory key-value store) handles the incoming stream from monitoring devices. Redis can ingest thousands of data points per second with very low latency, making it ideal for real-time alert dashboards. Data is later archived to cold storage or MySQL for long-term analysis.

## OLTP vs OLAP Boundary

The transactional system (OLTP) is MySQL — it handles all day-to-day read/write operations: registering patients, recording vitals, logging treatments, and updating discharge statuses. These are frequent, small, row-level operations that require data consistency and ACID compliance.

The analytical system (OLAP) begins at the Data Warehouse. A nightly ETL (Extract, Transform, Load) pipeline pulls aggregated data from MySQL and loads it into the warehouse. This is the boundary: once data crosses into the warehouse, it is read-only, denormalized, and optimized for bulk aggregation queries. Management reports (Goal 3) never query MySQL directly — they always query the warehouse. This separation ensures that heavy analytical queries do not slow down live hospital operations.

## Trade-offs

The most significant trade-off in this design is the latency introduced by the ETL pipeline between MySQL and the Data Warehouse. Because data is batch-loaded (e.g., nightly), management reports are always slightly out of date. A report run on the 15th of the month reflects data only up to the previous night. This means real-time decision-making based on reports is not possible.

To mitigate this, two approaches can be combined. First, a streaming ETL tool like Apache Kafka or AWS DMS can reduce the pipeline frequency from nightly to near-real-time (every few minutes). Second, for truly time-sensitive metrics (such as current ICU bed count), a separate live dashboard fed directly from Redis can be provided alongside the monthly warehouse reports. This hybrid approach balances the performance benefits of OLAP separation while ensuring critical real-time data is always accessible.