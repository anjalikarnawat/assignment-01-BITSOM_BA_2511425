## Vector DB Use Case
A traditional keyword-based database search would not suffice for a law firm
searching 500-page contracts using plain English questions. Keyword search works
by matching exact words or phrases — so a query like "termination clauses" would
only return results containing those precise words. Legal contracts, however,
often express the same concept in varied language: "contract dissolution",
"agreement expiry", or "conditions for ending the engagement" all refer to
termination, but a keyword search would miss them entirely.

This is where a vector database becomes essential. The system would first use an
embedding model (such as sentence-transformers) to convert every paragraph or
clause of each contract into a high-dimensional numerical vector that captures
its semantic meaning. These vectors are stored in a vector database such as
Pinecone, Weaviate, or ChromaDB. When a lawyer asks "What are the termination
clauses?", the question is also converted into a vector, and the database
performs a similarity search — retrieving the clauses whose meaning is closest
to the query, regardless of the exact wording used.

This approach offers several advantages for a law firm: it understands intent
rather than just keywords, it handles synonyms and paraphrases naturally, and
it scales efficiently across hundreds of lengthy documents. The result is a far
more accurate and practical search experience, allowing lawyers to find
relevant contract sections quickly without needing to remember specific legal
phrasing — ultimately saving time and reducing the risk of missing critical
clauses.
