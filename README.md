# Restaurant Operations Dashboard – Power BI

## Project Overview
This Power BI project analyses restaurant operations using sales, menu, staffing, operational metrics, and customer feedback data. The dashboard focuses on identifying operational bottlenecks, revenue patterns, staffing efficiency, and customer satisfaction trends.

## Business Questions
- Which shift receives the highest order volume?
- Which menu items generate the most revenue?
- How do wait time and prep time vary by staff count?
- What is the satisfaction rate based on customer complaints?
- Which areas show possible operational bottlenecks?

## Tools Used
- Power BI
- MySQL
- DAX
- Power Query
- Data Modelling

## Data Model
The model uses a central Orders table to avoid many-to-many relationships and create clean one-to-many relationships between order details, operational metrics, and customer feedback.

## Key Measures
- Total Revenue
- Total Orders
- Items Sold
- Average Wait Time
- Average Prep Time
- Satisfaction Rate
- Top and Bottom Revenue Items

## Dashboard Preview
![Dashboard Preview](All_months_data.png)

## Key Insights
- Afternoon shift recorded the highest order volume.
- Average wait time was higher than average prep time, suggesting delays beyond food preparation.
- Korean Beef Bowl was the highest revenue-generating item.
- Staffing levels influenced wait and prep time patterns.

## What I Learned
This project helped me practise Power BI data modelling, DAX measures, Power Query data type corrections, KPI design, slicers, and business insight generation.
