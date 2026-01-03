
Select *
from banking_data_tbl;

Select count(*)
from banking_data_tbl;

-- Qn1: Which countries have the highest total commitments but low fund utilization?
Select Top 20 
	Country_Economy_Code, 
	Country_Economy, 
	sum(Original_Principal_Amount_US) as total_commitment_usd,
	Round(100 * sum(Disbursed_Amount_US)/sum(Original_Principal_Amount_US),2) as Utilization
from banking_data_tbl
Group by Country_Economy_Code, Country_Economy
Having sum(Original_Principal_Amount_US) >1000000000
Order by Utilization Asc,total_commitment_usd DESC;

-- Qn2: Which Countries owe the most to the IDA?
Select Country_Economy, sum(Due_to_IDA_US) as Due_Amount 
from banking_data_tbl
Group by Country_Economy
Order by Due_amount DESC;

-- Qn3: How many projects Bangladesh has?

Select Count(distinct Project_ID) as Total_Projects 
from banking_data_tbl 
where "Country_Economy" =  'Bangladesh';

--Qn4 : Which projects in Bangladesh have received the most funding?”
Select Project_Name, Count(*) as Total_Projects 
from banking_data_tbl 
where "Country_Economy" =  'Bangladesh'
Group by Project_Name
Order by Total_Projects Desc;

-- Qn5:Which projects have received the highest disbursed funding?
Select Country_Economy , Project_Name, Sum(Disbursed_Amount_US) as Total_Fund_Spent
from banking_data_tbl
Group by Country_Economy , Project_Name
order by Total_Fund_Spent Desc; 


--Qn6:Average Service charge rate for all credits over the year
Select 
year(Try_Convert(date, Board_Approval_Date)) as Approval_Date,
AVG(Service_Charge_Rate) as Average_Service_Charge_Rate
from banking_data_tbl
Group by year(Try_Convert(date, Board_Approval_Date))
order by Approval_Date Desc; 


-- Qn7: Which sectors (e.g., health, infrastructure) see most funding?

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



-- Qn8: Which regions consistently show low utilization or high undisbursed balances?
Select Top 20 
	Region, 
	Round(100 * sum(Disbursed_Amount_US)/sum(Original_Principal_Amount_US),2) as Utilization,
	Round(100 * sum(Undisbursed_Amount_US)/sum(Original_Principal_Amount_US),2) as Undisbursed	
from banking_data_tbl
Group by Region
Order by Utilization Asc, Undisbursed desc;

-- Qn9: Which countries have high debt relative to their approved commitments?
Select Country_Economy,
sum(Original_Principal_Amount_US) as Approved,
sum(Due_to_IDA_US) as Due,
Round(sum(Due_to_IDA_US) / sum(Original_Principal_Amount_US),2) as Ratio
from banking_data_tbl
Group by Country_Economy
order by ratio DESC;
