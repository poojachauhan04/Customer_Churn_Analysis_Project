# Customer Churn Analysis 📉

An end-to-end data analytics project to find out **who is leaving, when they leave, why they leave, and how much revenue is lost**, using **Python, SQL,** and **Power BI**.

<img width="2470" height="566" alt="churn_banner" src="https://github.com/user-attachments/assets/10e39b97-a774-4375-b75f-e7a4dc30fbf2" />


## 📌 Project Overview

This project looks at a subscription-based service provider that is struggling to keep its customers. The company gets thousands of complaints but does not know why customers leave, or whether handling complaints actually helps. They only react **after** a customer cancels.

The data covers **93,587 customers from India and Nepal**. Subscriptions started between **2018 and 2024**, and cancellations are recorded up to **August 2026**. There have been **no new sign-ups since December 2024**.

**Result at a glance**

| Metric | Value |
|---|---|
| Total Customers | 93,587 |
| Churned Customers | 18,176 |
| Churn Rate | **19.42%** |
| Monthly Revenue Lost | **395.64K** |
| Monthly Revenue Still at High Risk | **486.97K** |

## 🛠️ Tech Stack

- **Data Cleaning & Feature Engineering**: Python (Pandas)
- **Database & Analysis**: SQL (PostgreSQL)
- **Data Visualization**: Power BI
- **Analytical Concepts**: Churn Analysis, Risk Segmentation, Complaint Analysis, Revenue Impact (ARPU, CLTV)

## ❓ Business Problems Solved

- **Who is leaving?** Checked if any plan, country, gender, age group, or risk segment stands out.
- **When do they leave?** Found the right time to step in and save the customer.
- **Why do they leave?** Looked at the real reasons instead of guessing.
- **How much revenue is affected?** Helped decide where to spend the retention budget.

## 🗂️ Dataset Summary

Three source tables were cleaned and merged into one table.

| Source Table | What it contains |
|---|---|
| `db_customer` | Customer details |
| `db_subscription` | Plan and subscription details |
| `db_support` | Complaints and escalations |

**Final table:** `Cleaned_Merged_Data` → **93,587 rows** and **25 columns**

## 🚀 Project Workflow

### Phase 1: Data Cleaning & Feature Engineering (Python)

Used Pandas to clean each table before merging them into one.

- **Customer table**: Dropped mostly empty columns, removed 1,000 duplicates, and standardized gender, country, state, and name formats.
- **Subscription table**: Fixed spelling errors, date formats, the `$` sign, negative values, out-of-range scores, and illogical dates.
- **Support table**: Dropped the empty column, removed duplicates, and standardized escalations (Y/N → Yes/No).
- **All tables**: Handled null values and fixed data types.

### Phase 2: Analysis & KPIs (SQL)

- The data was already cleaned in Python, so **no cleaning was done in SQL**.
- The cleaned table (`Cleaned_Merged_Data`) was exported from Python and imported into **PostgreSQL**.
- SQL queries were written to answer the business questions.
- Each query was checked against the dashboard numbers (for example, churn rate of **19.42%** and **18,176** churned customers).

### Phase 3: Dashboard (Power BI)

An interactive report with **6 pages**, a navigation panel, slicers, and a reset button.

| Page | What it shows |
|---|---|
| **Home** | KPI cards, filters, key review points, and recommendations |
| **Customer Segmentation** | Customers by risk band, plan, age, and gender |
| **Churn Overview** | Cancellation reasons, churn by plan, yearly churn trend |
| **Risk & Complaints** | Churn by risk band and complaint count, escalations |
| **Revenue Impact** | ARPU, CLTV, revenue lost, and revenue at high risk |
| **Time Trends** | Churn and revenue lost by year; revenue at risk by start year |

### 📸 Dashboard Preview

**1. Home**
<img src="images/dashboard_1_home.png" alt="Home page" width="100%" />

**2. Customer Segmentation**
<img src="images/dashboard_2_customer_segmentation.png" alt="Customer Segmentation page" width="100%" />

**3. Churn Overview**
<img src="images/dashboard_3_churn_overview.png" alt="Churn Overview page" width="100%" />

**4. Risk & Complaints**
<img src="images/dashboard_4_risk_and_complaints.png" alt="Risk and Complaints page" width="100%" />

**5. Revenue Impact**
<img src="images/dashboard_5_revenue_impact.png" alt="Revenue Impact page" width="100%" />

**6. Time Trends**
<img src="images/dashboard_6_time_trends.png" alt="Time Trends page" width="100%" />

## 💡 Key Insights

- **Churn rate is 19.42%** (18,176 of 93,587 customers).
- **Revenue lost is 395.6K**, with **487K** still at risk every month.
- **High Risk customers churn at 37.5%** and cause about **287.16K** of the lost revenue.
- **Cancellation reasons are evenly spread.** Service, billing, and content issues together make about 50%.
- **Plan, gender, and age show no real difference** in churn.
- **Complaints don't predict churn.** Churn stays at about 19–20% at every complaint count.
- **Churn is flat** at about 2.6–2.7K customers a year from 2020 to 2024. The 2026 figure is partial.

## ✅ Business Recommendations

➢ **Save High Risk Customers First** → Offer retention deals like discounts, free upgrades, or loyalty perks.

➢ **Fix the Main Problems** → Improve service, billing, and streaming quality with better support.

➢ **Win Back Lost Customers** → Run win-back offers, starting with competitor switchers and customers who left for price or competitor reasons.

➢ **Track Risk Every Month** → Watch the risk score monthly and review how complaints are resolved.

➢ **Restart Customer Acquisition** → There have been no new sign-ups since December 2024, so bring in new customers.

## 👋 Thank you for visiting my repository!
