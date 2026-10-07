SELECT count(*) FROM db_customer
SELECT count(*) FROM db_subscription
SELECT count(*) FROM db_support
SELECT count(*) FROM df
SELECT * FROM df

-- ============================================================
-- 1. CUSTOMER & CHURN OVERVIEW
-- ============================================================

-- Q01. How many total customers are in the database?
SELECT  COUNT(DISTINCT Customerid) AS Total_Customers FROM df

-- Q02. How many customers have churned?
SELECT COUNT(DISTINCT Customerid) AS Total_Churned_Customers FROM df
WHERE Churn_Flag=1

-- Q03. What is the overall customer churn rate?
SELECT ROUND(COUNT(DISTINCT CASE WHEN Churn_Flag=1 THEN Customerid END)*100.0/COUNT(DISTINCT Customerid),2)
AS Churn_Rate_Pct FROM df

-- Q04. How many customers are currently active?
SELECT COUNT(DISTINCT CASE WHEN Churn_Flag=0 THEN Customerid END) AS Active_Customers FROM df

-- Q05. What is the customer retention rate?
SELECT 100-ROUND(COUNT(DISTINCT CASE WHEN Churn_Flag=1 THEN Customerid END)*100.0/COUNT(DISTINCT Customerid),2)
AS Retention_Rate_Pct FROM df

SELECT ROUND(COUNT(DISTINCT CASE WHEN Churn_Flag=0 THEN Customerid END)*100.0/COUNT(DISTINCT Customerid),2)
AS Retention_Rate_Pct FROM df

-- Q06. How many customers are at high churn risk?
SELECT COUNT(DISTINCT Customerid) AS High_Risk_Customers FROM df
WHERE Churn_Risk='High'

-- Q07. How many customers are in each churn risk band?
SELECT Churn_Risk,COUNT(*) AS Customers_Count FROM df
GROUP BY Churn_Risk
ORDER BY Customers_Count DESC

-- Q08. Which plan type has the highest churn rate?
SELECT Plan_Type,ROUND(COUNT(DISTINCT CASE WHEN Churn_Flag=1 THEN Customerid END)*100.0/
COUNT(DISTINCT Customerid),2) AS Churn_Rate_Pct FROM df
GROUP BY Plan_Type
ORDER BY Churn_Rate_Pct DESC
LIMIT 1

-- Q09. Which contract type has the highest churn rate?
SELECT Contract_Type,
ROUND(COUNT(DISTINCT CASE WHEN Churn_Flag=1 THEN Customerid END)*100.0/COUNT(DISTINCT Customerid),2)
AS Churn_Rate_Pct FROM df
WHERE Contract_Type <> 'Unknown'
GROUP BY Contract_Type
ORDER BY 2 DESC
LIMIT 1

-- Q10. Which subscription channel has the highest churn rate?
SELECT Subscription_Type,
ROUND(COUNT(DISTINCT CASE WHEN Churn_Flag=1 THEN Customerid END)*100.0/COUNT(DISTINCT Customerid),2)
AS Churn_Rate_Pct FROM df
WHERE Subscription_Type <> 'NA'
GROUP BY Subscription_Type
ORDER BY 2 DESC
LIMIT 1

-- ============================================================
-- 2. REVENUE & CUSTOMER VALUE
-- ============================================================
SELECT * FROM df

-- Q11. Which plan generates the highest total monthly revenue?
SELECT Plan_Type,ROUND(SUM(Monthly_Charges)::numeric,2) AS Total_Monthly_Revenue FROM df
WHERE Plan_Type !='Unknown'
GROUP BY Plan_Type
ORDER BY 2 DESC
LIMIT 1

-- Q12. Which plan has the highest average revenue per user?
SELECT Plan_Type, ROUND(SUM(Monthly_Charges)::numeric/COUNT(DISTINCT Customerid),2) AS Average_Revenue_Per_User
FROM df
WHERE Plan_Type<>'Unknown'
GROUP BY Plan_Type
ORDER BY 2 DESC
LIMIT 1

-- Q13. How much monthly revenue is lost from churned customers?
SELECT ROUND(SUM(Monthly_Charges)::numeric,2) AS Monthly_Revenue_Lost FROM df
WHERE Churn_Flag=1

-- Q14. How much revenue is currently at risk from high-risk customers?
SELECT ROUND(SUM(Monthly_Charges)::numeric,2) AS Monthly_Revenue_At_Risk FROM df
WHERE Churn_Risk='High' AND Churn_Flag=0

-- Q15. Which plan has the highest revenue loss from churn?
SELECT Plan_Type, ROUND(SUM(Monthly_Charges)::numeric,2) AS Revenue_Lost_By_Plan_Type
FROM df
WHERE Plan_Type<>'Unknown' AND Churn_Flag=1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q16. Which contract type contributes the most lost revenue?
SELECT Contract_Type, ROUND(SUM(Monthly_Charges)::numeric,2) AS Revenue_Lost_By_Contract_Type
FROM df
WHERE Contract_Type<>'Unknown' AND Churn_Flag=1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q17. Which customers have the highest CLTV among churned customers?
SELECT Customerid,Cltv AS Highest_Cltv FROM df
WHERE Churn_Flag=1
ORDER BY 2 DESC
LIMIT 1

-- Q18. Are high-value customers churning at a higher rate than other customers?
SELECT * FROM df

-- Q19. Which state has the highest churn-related revenue loss?
SELECT State,Round(SUM(Monthly_Charges)::numeric,2) AS Revenue_Loss
FROM df
WHERE State IS NOT NULL AND Churn_Flag=1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q20. Which customer segment has the highest average monthly charge? (Gender/India Wise)
SELECT Gender,ROUND(SUM(Monthly_Charges)::numeric/COUNT(DISTINCT Customerid),2) AS 
Average_Monthly_Charges FROM df
WHERE Gender<>'Unknown' AND Gender IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- ============================================================
-- 3. CUSTOMER SEGMENTATION
-- ============================================================
SELECT * FROM df
-- Q21. Which age group has the highest churn rate?
--First we will create a new column as Age_Group
ALTER TABLE df
ADD COLUMN Age_Group VARCHAR(20)

UPDATE df
SET Age_Group= CASE WHEN Age<=25 THEN '18-25'
                    WHEN Age<=35 THEN '26-35'
					WHEN Age<=45 THEN '36-45'
					WHEN Age<=55 THEN '46-55'
					ELSE '56+'
				END
				
SELECT Age_Group,ROUND(COUNT(DISTINCT CASE WHEN Churn_Flag=1 THEN Customerid END)*100.0
/COUNT(DISTINCT Customerid),2) AS Churn_Rate_Pct FROM df
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q22. Which age group contributes the most churned customers?				
SELECT Age_Group,COUNT(*) AS Total_Churned_Customers FROM df
WHERE Churn_Flag=1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q23. Which gender group has the highest churn rate?
SELECT Gender,ROUND(COUNT(DISTINCT CASE WHEN Churn_Flag=1 THEN Customerid END)*100.0
/COUNT(DISTINCT Customerid),2) AS Churn_Rate_Pct FROM df
WHERE Gender<>'Unknown' AND Gender IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q24. Which country has the highest customer churn rate?
SELECT Country,ROUND(COUNT(DISTINCT CASE WHEN Churn_Flag=1 THEN Customerid END)*100.0
/COUNT(DISTINCT Customerid),2) AS Churn_Rate_Pct FROM df
WHERE Country<>'Unknown' AND Country IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q25. Which state has the highest customer churn rate?
SELECT State,ROUND(COUNT(DISTINCT CASE WHEN Churn_Flag=1 THEN Customerid END)*100.0
/COUNT(DISTINCT Customerid),2) AS Churn_Rate_Pct FROM df
WHERE State IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q26. Which states have both high churn rates and high customer revenue?
SELECT State,
ROUND(SUM(Monthly_Charges)::numeric,2) AS Total_Monthly_Revenue,
ROUND(SUM(Churn_Flag)*100.0/COUNT(*),2) AS Churn_Rate_Pct 
FROM df
WHERE State IS NOT NULL AND State<>'Unknown'
GROUP BY 1
ORDER BY 2 DESC,3 DESC

-- Q27. Which plan and contract combination has the highest churn rate?
SELECT Plan_Type,Contract_Type,
ROUND(SUM(Churn_Flag)*100.0/COUNT(*),2) AS Churn_Rate_Pct 
FROM df
GROUP BY 1,2
ORDER BY 3 DESC

-- Q28. Which subscription channel has the highest number of churned customers?
SELECT Subscription_Type, COUNT(*) AS Total_Churned_Customers 
FROM df
WHERE Churn_Flag=1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q29. Which customer segment has the highest average CLTV? (Gender Wise)
SELECT Gender, ROUND(AVG(Cltv)::numeric,2)
FROM df
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q30. Which customer segment contributes the most revenue at risk? (Gender Wise)
SELECT Gender, ROUND(SUM(Monthly_Charges)::numeric,2) AS Revenue_At_Risk
FROM df
WHERE Churn_Risk='High'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1


-- ============================================================
-- 4. CANCELLATION & CHURN DRIVERS
-- ============================================================
SELECT * FROM df

-- Q31. What are the most common reasons customers cancel their subscriptions?
SELECT Cancellation_Reason, COUNT(*) AS Total_Customers FROM df
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q32. Which cancellation reason accounts for the most churned customers?
SELECT Cancellation_Reason, COUNT(*) AS Total_Customers FROM df
WHERE Churn_Flag=1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q33. Which cancellation reason causes the highest revenue loss?
SELECT Cancellation_Reason, ROUND(SUM(Monthly_Charges)::numeric,2) AS Revenue_Loss FROM df
WHERE Churn_Flag=1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q34. How many customers switched to a competitor?
SELECT COUNT(*) AS Total_Customers FROM df
WHERE Cancellation_Reason ='Switched To Competitor'

-- Q35. How much revenue was lost from customers who switched to competitors?
SELECT ROUND(SUM(Monthly_Charges)::numeric,2) AS Revenue_Loss FROM df
WHERE Cancellation_Reason ='Switched To Competitor' AND Churn_Flag=1

-- Q36. How many customers churned because the service was too expensive?
SELECT COUNT(*) AS Total_Customers FROM df
WHERE Cancellation_Reason ='Too Expensive' AND Churn_Flag=1

-- Q37. Do customers citing price as a reason for churn have higher average monthly charges?
SELECT ROUND(AVG(Monthly_Charges)::numeric,2) AS Average_Monthly_Charges FROM df
WHERE Cancellation_Reason ='Too Expensive' AND Churn_Flag=1

-- Q38. How many customers churned because of poor customer service?
SELECT COUNT(*) AS Total_Customers FROM df
WHERE LOWER(Cancellation_Reason) ='poor customer service' AND Churn_Flag=1

-- Q39. How many customers churned because of service issues?
SELECT COUNT(*) AS Total_Customers FROM df
WHERE LOWER(Cancellation_Reason) ='service issue' AND Churn_Flag=1

-- Q40. Which cancellation reason should the retention team investigate firs
--based on customer volume and revenue loss?
SELECT Cancellation_Reason, COUNT(*) AS Customer_Volume,ROUND(SUM(Monthly_Charges)::numeric,2)
AS Revenue_Loss FROM df
WHERE Churn_Flag=1
GROUP BY 1
ORDER BY 2 DESC, 3 DESC


-- ============================================================
-- 5. CUSTOMER SUPPORT & RETENTION
-- ============================================================

-- Q41. Do customers with complaints have a higher churn rate than customers without complaints?
SELECT CASE WHEN Complaint_Count>0 THEN 'With_Complaints'
            ELSE 'Without_Complaints' END As Complaint_Group,
ROUND(SUM(Churn_Flag)*100.0/COUNT(*),2) AS Churn_Rate_Pct
FROM df
GROUP BY 1
ORDER BY 2 DESC

-- Q42. How does churn rate change as complaint count increases?
SELECT Complaint_Count,
ROUND(SUM(Churn_Flag)*100.0/COUNT(*),2) AS Churn_Rate_Pct 
FROM df
GROUP BY 1
ORDER BY 1 DESC


-- Q43. How many customers have submitted two or more complaints?
SELECT COUNT(*) AS Total_Customers FROM df
WHERE Complaint_Count>=2

-- Q44. Do escalated customers have a higher churn rate than non-escalated customers?
SELECT CASE WHEN Escalations=1 THEN 'Escalated_Customers'
            ELSE 'Non_Escalated_Customers'
	   END AS Escalated_Group,
ROUND(SUM(Churn_Flag)*100.0/COUNT(*),2) AS Churn_Rate_Pct 
FROM df
GROUP BY 1
ORDER BY 2 DESC
			
-- Q45. Which CSAT score range has the highest churn rate?
--First creating a column as CSAT_Score_Range
ALTER TABLE df
ADD COLUMN CSAT_Score_Range VARCHAR(25)
GENERATED ALWAYS AS(
CASE WHEN Csat_Score>75 THEN '76-100'
     WHEN Csat_Score>50 THEN '51-75'
	 WHEN Csat_Score>25 THEN '26-50'
	 ELSE '0-25'
END
)

SELECT CSAT_Score_Range,
ROUND(SUM(Churn_Flag)*100.0/COUNT(*),2) AS Churn_Rate_Pct 
FROM df
GROUP BY 1
ORDER BY 2 DESC

-- Q46. How many high-risk customers have submitted at least one complaint?
SELECT COUNT(*) AS Total_Customers FROM df
WHERE Churn_Risk='High' AND Complaint_Count>=1

-- Q47. How many high-risk customers have experienced support escalation?
SELECT COUNT(*) AS Total_Customers FROM df
WHERE Churn_Risk='High' AND Escalations=1

-- Q48. Which plan has the highest complaint rate?
SELECT Plan_Type,
ROUND(SUM(Complaint_Count)::numeric*100.0/COUNT(*),2) AS Complaint_Rate_Pct 
FROM df
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q49. Which state has the highest average number of complaints per customer?
SELECT State,
ROUND(AVG(Complaint_Count)::numeric,2)*100 AS Average_Complaint_Count
FROM df
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q50. Which customer group has the highest churn rate among customers with complaints?
SELECT Gender,
ROUND(SUM(Churn_Flag)*100.0/COUNT(*),2) AS Churn_Rate_Pct 
FROM df
WHERE Complaint_Date IS NOT NULL AND Gender<>'Unknown'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- ============================================================
-- 6. RETENTION & RISK ANALYSIS
-- ============================================================
SELECT * FROM df

-- Q51. Which active customers have a churn score above 70?
SELECT Customername,Churn_Score FROM df
WHERE Churn_Flag=0 AND Churn_Score>70 AND Customername IS NOT NULL

-- Q52. How much monthly revenue is generated by high-risk active customers?
SELECT ROUND(SUM(Monthly_Charges)::numeric,2) AS Monthly_Revenue 
FROM df
WHERE Churn_Risk='High' AND Churn_Flag=0

-- Q53. Which high-risk customers also have CLTV above 1,500?
SELECT Customername,Cltv FROM df
WHERE Churn_Risk='High' AND Cltv>1500

-- Q54. How many high-risk customers have at least one complaint?
SELECT COUNT(*) AS Total_Customers FROM df
WHERE Churn_Risk='High' AND Complaint_Count>=1

-- Q55. How many high-risk customers have experienced an escalation?
SELECT COUNT(*) AS Total_Customers FROM df
WHERE Churn_Risk='High' AND Escalations=1

-- Q56. Which high-risk segment has the highest revenue exposure? (Country Wise)
SELECT Country, ROUND(SUM(Monthly_Charges)::numeric,2) AS Total_Revenue
FROM df
WHERE Churn_Risk='High' AND Country IS NOT NULL AND Country<>'Unknown'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q57. Which customers have the highest combination of churn score and CLTV?
SELECT Customername,Churn_Score,Cltv,Churn_Score*Cltv AS Risk_Value_Score FROM df
WHERE Churn_Flag=0
ORDER BY 4 DESC
LIMIT 10

-- Q58. How many monthly-contract customers are both high-risk and high-value?
SELECT COUNT(*) AS Total_Customers
FROM df
WHERE Contract_Type='Monthly' AND Churn_Risk='High'AND Cltv>1500

-- Q59. Which states contain the most high-risk customers?
SELECT State, COUNT(*) AS Total_Customers FROM df
WHERE Churn_Risk='High'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Q60. Which plan contains the highest number of high-risk customers?
SELECT Plan_Type, COUNT(*) AS Total_Customers FROM df
WHERE Churn_Risk='High'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- ============================================================
-- 7. TENURE & TIME ANALYSIS
-- ============================================================
SELECT * FROM DF

-- Q61. How many customers churned within their first 365 days?
SELECT COUNT(*) AS Total_Customers FROM df
WHERE "Total_Service_Days"<=365 AND Churn_Flag=1

-- Q62. Which tenure group has the highest churn rate?
--First creating a new column as Tenure Group
ALTER TABLE df
ADD COLUMN Tenure_Group VARCHAR(25)
GENERATED ALWAYS AS(
CASE WHEN "Total_Service_Days"<=365 THEN '0-1 Year'
     WHEN "Total_Service_Days"<=730 THEN '1-2 Years'
	 WHEN "Total_Service_Days"<=1095 THEN '2-3 Years'
	 ELSE '3+ Years'
END
)

SELECT Tenure_Group,
ROUND(SUM(Churn_Flag)*100.0/COUNT(*),2) AS Churn_Rate_Pct 
FROM df
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q63. Which tenure group contributes the most churned customers?
SELECT Tenure_Group,COUNT(*) AS Total_Churned_Customers FROM df
WHERE Churn_Flag=1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q64. Which tenure group has the highest revenue loss from churn?
SELECT Tenure_Group, ROUND(SUM(Monthly_Charges)::numeric,2) AS Revenue_Loss
FROM df
WHERE Churn_Flag=1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q65. How many customers joined in each subscription year?
SELECT EXTRACT (YEAR FROM Subscription_Start_Date) AS Subscription_Year,
COUNT(*) AS Total_Joined_Customers 
FROM df
GROUP BY 1
ORDER BY 1 

-- Q66. Which year recorded the highest number of churned customers?
SELECT * FROM df
SELECT EXTRACT (YEAR FROM Cancellation_Date) AS Churned_Year,
COUNT(*) AS Total_Churned_Customers 
FROM df
WHERE Cancellation_Date IS NOT NULL AND Churn_Flag=1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q67. Which year recorded the lowest number of churned customers?
SELECT EXTRACT (YEAR FROM Cancellation_Date) AS Churned_Year,
COUNT(*) AS Total_Churned_Customers 
FROM df
WHERE Cancellation_Date IS NOT NULL AND Churn_Flag=1
GROUP BY 1
ORDER BY 2 
LIMIT 1

-- Q68. How has the number of churned customers changed year over year?
WITH Yearly_Churned_Customers AS(SELECT EXTRACT (YEAR FROM Cancellation_Date) AS Churned_Year,
COUNT(*) AS Total_Churned_Customers 
FROM df
WHERE Cancellation_Date IS NOT NULL AND Churn_Flag=1
GROUP BY 1)
SELECT Churned_Year,Total_Churned_Customers,
Total_Churned_Customers-
LAG(Total_Churned_Customers) OVER(ORDER BY Churned_Year) AS Change_From_Previous_Year,
ROUND((Total_Churned_Customers-
LAG(Total_Churned_Customers) OVER(ORDER BY Churned_Year))*100.0/
LAG(Total_Churned_Customers) OVER(ORDER BY Churned_Year),2) AS YoY_Change_Pct
FROM Yearly_Churned_Customers
ORDER BY 1

-- Q69. Which month has the highest number of customer cancellations?
SELECT TO_CHAR(Cancellation_Date,'Month') AS Cancellation_Month,
COUNT(*) AS Total_Churned_Customers 
FROM df
WHERE Cancellation_Date IS NOT NULL AND Churn_Flag=1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q70. Which subscription-start cohort has the highest churn rate?
SELECT EXTRACT (YEAR FROM Subscription_Start_Date) AS Subscription_Year,
ROUND(SUM(Churn_Flag)*100.0/COUNT(*),2) AS Churn_Rate_Pct 
FROM df
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1