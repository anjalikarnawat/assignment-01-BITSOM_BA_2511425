# Part 5 — Data Lake Architecture

## Architecture Recommendation

For a fast-growing food delivery startup that collects GPS location logs, customer text reviews, payment transactions, and restaurant menu images, I recommend a **Data Lakehouse** architecture.

A Data Lakehouse combines the best of both a Data Lake (cheap, flexible raw storage) and a Data Warehouse (structured querying and governance). Here are three specific reasons why it fits this startup best:

**1. Handles all four data types in one place.**
The startup's data is fundamentally diverse — GPS logs are high-frequency structured streams, text reviews are unstructured, payment transactions are relational/tabular, and menu images are binary files. A pure Data Warehouse cannot store unstructured or binary data like images and free-form text. A Data Lakehouse stores all formats (JSON, CSV, Parquet, images) in a central object store while still letting analysts run SQL queries on the structured parts — no need for separate silos.

**2. Scales cheaply as the startup grows.**
Food delivery platforms grow rapidly in both users and data volume. A traditional Data Warehouse becomes very expensive to scale because compute and storage are tightly coupled. A Data Lakehouse decouples storage (cheap object storage like S3/GCS) from compute, so the company pays only for what it queries — critical for a cost-sensitive early-stage startup.

**3. Supports both real-time and batch analytics.**
GPS tracking and live order status require near-real-time processing, while weekly business reports need batch analysis. A Data Lakehouse supports both patterns through streaming ingestion (e.g., Apache Kafka → Delta Lake) and batch SQL querying (e.g., via Spark or DuckDB) on the same dataset — avoiding duplicate pipelines that a Warehouse + Lake hybrid would require.

*In summary, the Data Lakehouse is the right choice because it is flexible enough to hold all data types, economical at scale, and versatile enough to power both operational dashboards and deep analytics from a single architecture.*