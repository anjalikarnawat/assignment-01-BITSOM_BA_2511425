## Database Recommendation

For a healthcare patient management system, I would go with **MySQL**
over MongoDB, and the reasoning comes down to one core concern — data integrity.

In healthcare, there is very little room for error. A patient's medication
history, allergy records, or billing information cannot afford to be partially
written or temporarily inconsistent. This is exactly where **ACID properties**
matter. MySQL ensures that every transaction is either fully completed or fully
rolled back. If a system crash happens while a doctor is updating a prescription,
nothing gets saved halfway. MongoDB, on the other hand, operates on a **BASE**
model — it prioritises availability and accepts that data across nodes might not
be in sync at all times. That kind of trade-off is acceptable for a shopping
cart, not for a patient record.

The **CAP theorem** supports this choice too. You cannot have Consistency,
Availability, and Partition Tolerance all at once. MySQL leans toward
Consistency, which is the right call here. Reading outdated or conflicting
data in a medical system could mean a wrong dosage or a missed allergy warning
— consequences that go beyond a software bug.

There is also the matter of structure. Patient data is naturally relational —
doctors, patients, appointments, prescriptions all connect to each other. MySQL
handles these relationships cleanly through foreign keys and joins, keeping the
data organised and reliable.

That said, if the startup later adds a **fraud detection module**, the answer
gets more nuanced. Fraud detection works differently — it needs to process
high-speed, loosely structured data like access logs and behavioural patterns.
For that specific use case, MongoDB makes more sense. So I would suggest keeping
MySQL for the core system and introducing MongoDB only for the fraud detection
layer. Each tool doing what it is actually good at.