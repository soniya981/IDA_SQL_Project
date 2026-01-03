# Understanding IDA Funding: Insights from SQL Analysis
## Exploring IDA Funding with SQL
When countries don’t have enough resources to fund public services and infrastructure on their own, organizations like IDA step in to help. IDA provides low-interest loans and grants so countries can invest in things like education, health, energy, and infrastructure.
In this project, I used SQL to explore IDA financial data and understand where the money goes, how much is being used, and where problems might exist.
## The Data
I worked with the most recent IDA Statement of Credits and Grants dataset, which has about 10,400 rows and 30 columns. Each row represents a loan or grant, along with details like the country, project name, amount approved, amount disbursed, amount still owed, service charge rate, and region.
After getting familiar with the data, I started asking questions that move from big picture to specific risks.
## Business Problem
### 1. Countries with big commitments but low usage
```sql
Select Top 20 
	Country_Economy_Code, 
	Country_Economy, 
	sum(Original_Principal_Amount_US) as total_commitment_usd,
	Round(100 * sum(Disbursed_Amount_US)/sum(Original_Principal_Amount_US),2) as Utilization
from banking_data_tbl
Group by Country_Economy_Code, Country_Economy
Having sum(Original_Principal_Amount_US) >1000000000
Order by Utilization Asc,total_commitment_usd DESC;
```
**Objective:** First, I checked which countries had a lot of money approved but hadn’t used much of it yet. Some countries had utilization rates close to 55–60%, even though billions were approved. That made me think about delays, capacity issues, or projects that haven’t fully started.
