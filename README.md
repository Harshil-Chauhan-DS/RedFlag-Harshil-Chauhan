# RedFlag: Transaction Fraud Detection

## Overview
RedFlag is a data analysis project focused on identifying anomalous and potentially fraudulent behavior within financial transaction datasets. Using advanced SQL querying techniques, this project detects suspicious activities across multiple vectors, providing a robust foundation for automated fraud-flagging systems.

## Tech Stack
* **Language:** SQL
* **RDBMS:** MySQL / SQLite
* **Core Concepts Used:** Window Functions, Common Table Expressions (CTEs), Time-Series Analysis, Complex Aggregations

## Fraud Patterns Detected
The SQL scripts in this repository are engineered to detect several distinct archetypes of suspicious behavior, including:

* **Velocity Spikes:** Accounts exhibiting a sudden, extreme increase in transaction frequency (e.g., peak daily count exceeding 5x the historical average).
* **Geographic Impossibility:** Transactions originating from physically distant cities within an impossibly short timeframe (e.g., under 1 hour).
* **Quick Flips:** Rapid credit-to-debit transfers where ≥70% of deposited funds are withdrawn within a 30-minute window.
* **Odd-Hour Activity:** High volumes of transactions heavily concentrated during non-standard hours (2:00 AM – 4:00 AM).
* **Micro-Transaction Floods & Evasion:** Repeated sub-$10 transactions, high frequencies of strictly round-number amounts, or transactions hitting exact evasion thresholds (e.g., $9,999.00).
* **Dormant Account Activation:** Accounts with over 90 days of inactivity that suddenly execute a high volume of transactions.

## Author
* **Harshil Chauhan - Computer Science & Engineering Student**
