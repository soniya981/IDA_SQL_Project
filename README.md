# Understanding IDA Funding: Insights from SQL Analysis
![WorldBank](/images/image1.png)

## Exploring IDA Funding with SQL
When countries don’t have enough resources to fund public services and infrastructure on their own, organizations like IDA step in to help. IDA provides low-interest loans so countries can invest in things like education, health, energy and infrastructure.
In this project, I used SQL to explore IDA financial data and understand where the money goes, how much is being used and where problems might exist.

## The Data
I worked with the most recent IDA Statement of Credits and Grants dataset, which has about 10,400 rows and 30 columns. Each row represents a loan, along with details like the country, project name, amount approved, amount disbursed, amount still owed, service charge rate and region.
After getting familiar with the data, I started asking questions that move from big picture to specific risks.
- **Dataset Link:** (https://financesone.worldbank.org/ida-statement-of-credits-grants-and-guarantees-latest-available-snapshot/DS00001)

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
 ![Question 1](/images/1.png)
 
**Objective:** First, I checked which countries had a lot of money approved but hadn’t used much of it yet. Some countries had utilization rates close to 55–60%, even though billions were approved. That made me think about delays, capacity issues or projects that haven’t fully started.

### 2. Countries that owe the most to IDA
```sql
Select
	Country_Economy,
	sum(Due_to_IDA_US) as Due_Amount 
from banking_data_tbl
Group by Country_Economy
Order by Due_amount DESC;
```
 ![Question 2](/images/2.png)
 
**Objective:** Next, I looked at how much countries still owe. Countries like Bangladesh, Pakistan, Nigeria and Ethiopia stood out and it shows where IDA’s financial exposure is highest.

### 3. Bangladesh as a case study
```sql
Select
	Count(distinct Project_ID) as Total_Projects 
from banking_data_tbl 
where "Country_Economy" =  'Bangladesh';
```
 ![Question 3](/images/3.png)
 
**Objective:** I used Bangladesh as a closer example and found it manages over 300 projects. That’s a lot to coordinate, which helps explain why utilization and repayment patterns can vary.
I also looked at which projects appear most often and which ones received the most funding. A few large projects account for a big share of the total spending.

### 4. Which projects have received the highest disbursed funding?
```sql
Select
	Country_Economy,
	Project_Name,
	Sum(Disbursed_Amount_US) as Total_Fund_Spent
from banking_data_tbl
Group by Country_Economy , Project_Name
order by Total_Fund_Spent Desc; 
```
 ![Question 4](/images/4.png)

**Objective:** Looking globally, only a small number of projects take up a large portion of IDA funding. The PEACE in Ukraine Project stood out the most, along with several large projects in Ethiopia, Nigeria and India.

### 5. Average Service charge rate for all credits over the year
```sql
Select 
	year(Try_Convert(date, Board_Approval_Date)) as Approval_Date,
	AVG(Service_Charge_Rate) as Average_Service_Charge_Rate
from banking_data_tbl
Group by year(Try_Convert(date, Board_Approval_Date))
order by Approval_Date Desc;  
```
 ![Question 5](/images/5.png)

**Objective:** I checked how service charge rates changed over time and noticed they’ve been going down. This suggests IDA is making loans more affordable, especially for countries that are already under financial stress.

### 6. Which sectors get the most funding?
```sql
SELECT
    CASE
        WHEN Project_Name LIKE '%Health%' 
          OR Project_Name LIKE '%Hospital%' THEN 'Health'
        WHEN Project_Name LIKE '%Road%' 
          OR Project_Name LIKE '%Transport%' 
          OR Project_Name LIKE '%Highway%' THEN 'Infrastructure'
        WHEN Project_Name LIKE '%Energy%' 
          OR Project_Name LIKE '%Power%' THEN 'Energy'
        WHEN Project_Name LIKE '%Water%' THEN 'Water & Sanitation'
        ELSE 'Other'
    END AS sector,
    SUM(Disbursed_Amount_US) AS total_disbursed_usd
FROM banking_data_tbl
GROUP BY
    CASE
        WHEN Project_Name LIKE '%Health%' 
          OR Project_Name LIKE '%Hospital%' THEN 'Health'
        WHEN Project_Name LIKE '%Road%' 
          OR Project_Name LIKE '%Transport%' 
          OR Project_Name LIKE '%Highway%' THEN 'Infrastructure'
        WHEN Project_Name LIKE '%Energy%' 
          OR Project_Name LIKE '%Power%' THEN 'Energy'
        WHEN Project_Name LIKE '%Water%' THEN 'Water & Sanitation'
        ELSE 'Other'
    END
ORDER BY total_disbursed_usd DESC; 
```
 ![Question 6](/images/6.png)

**Objective:** Since there was no sector column, I grouped projects based on keywords in their names. Infrastructure and energy projects received the most funding, followed by water, sanitation, and health.

### 7:  Which countries have high debt relative to their approved commitments?
```sql
Select
	Country_Economy,
	sum(Original_Principal_Amount_US) as Approved,
	sum(Due_to_IDA_US) as Due,
	Round(sum(Due_to_IDA_US) / sum(Original_Principal_Amount_US),2) as Ratio
from banking_data_tbl
Group by Country_Economy
order by ratio DESC
```
 ![Question 7](/images/7.png)

**Objective:** This ratio helped highlight countries where a large portion of approved funding is still unpaid. Countries like Ukraine and Lebanon had high ratios, meaning most of their approved funds remain outstanding. This doesn’t automatically mean risk, but it does raise important questions about future repayment and debt pressure.

## Major Findings

- Several countries have high approved funding but low utilization, suggesting delays or implementation challenges
- IDA’s debt exposure is concentrated in a small number of countries
- A few large projects account for a major share of total disbursements
- Service charge rates have decreased over time, making loans more affordable
- Infrastructure and energy dominate sector-level funding
- Countries with high debt-to-commitment ratios may face higher repayment pressure in the future

## Closing Thoughts

This project really showed me how much you can learn once you stop just looking at totals and start asking better questions. Using SQL made it easy to dig deeper and see patterns that aren’t obvious at first glance—like where money is sitting unused, which projects take up most of the funding, and which countries are carrying a lot of debt.
What started as simple queries slowly turned into a bigger story about how funding flows, where things move smoothly, and where they don’t. I also liked how each question led naturally to the next one, making the analysis feel more like problem-solving than just running code.
Overall, this was a fun way to practice SQL while working with meaningful data, and it definitely made me more confident in using data to explain what’s actually going on beneath the surface

