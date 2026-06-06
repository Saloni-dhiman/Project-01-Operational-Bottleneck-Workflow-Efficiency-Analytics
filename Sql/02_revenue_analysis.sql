-- =====================================================
-- 02 REVENUE ANALYSIS
-- Project: Operational Bottleneck & Workflow Efficiency Analytics System
-- Purpose: Analyze revenue performance, sales trends, category contribution, menu item performance, and revenue optimization opportunities.
-- =====================================================

-- =====================================================
-- 1. REVENUE BY CATEGORY
-- Business Question: Which menu categories generate the highest revenue?
-- =====================================================
SELECT mi.category ,ROUND(SUM(mi.price),2) AS revenue
FROM menu_items mi
JOIN order_details od
ON mi.menu_item_id = od.item_id
GROUP BY mi.category
ORDER BY revenue DESC;

-- Finding: Highest revenue category : Italian = 49462.7 

-- =====================================================
-- 2. REVENUE BY MENU ITEM
-- Business Question: Which menu items generate the highest revenue?
-- =====================================================
SELECT mi.item_name, mi.price AS item_price, COUNT(od.order_id) AS quantity_sold, ROUND(SUM(mi.price),2) AS revenue
FROM menu_items mi
JOIN order_details od
ON mi.menu_item_id = od.item_id
GROUP BY mi.item_name, mi.price
ORDER BY revenue DESC;

-- Finding: Highest revenue menu item : Korean Beef Bowl = 10554.6, Spaghetti & Meatballs = 8436.5 and Tofu Pad Thai = 8149 are the items which are generating highest revenue

-- =====================================================
-- 3. CATEGORY REVENUE CONTRIBUTION (%)
-- Business Question: What percentage of total revenue comes from each category?
-- =====================================================
SELECT mi.category , ROUND(SUM(mi.price),2) AS revenue, 
ROUND(SUM(mi.price)* 100 / SUM(SUM(mi.price)) OVER() ,2 )AS rev_percentage
FROM menu_items mi
JOIN order_details od
ON mi.menu_item_id = od.item_id
GROUP BY mi.category
ORDER BY rev_percentage DESC;

-- Finding : Italian = 31.07%, Asian = 29.34%, Mexican = 21.85%, American = 17.74% contribution to total revenue.

-- =====================================================
-- 4. BEST-SELLING MENU ITEMS
-- Business Question: Which menu items are ordered most frequently?
-- =====================================================
SELECT mi.item_name , COUNT(od.order_id) AS count_of_order FROM menu_items mi
JOIN order_details od
ON od.item_id = mi.menu_item_id
GROUP BY mi.item_name
ORDER BY count_of_order DESC;

-- Finding : Hamburger, Edamame, Korean beef bowl are the most frequently ordered items

-- =====================================================
-- 5. LOWEST-SELLING MENU ITEMS
-- Business Question: Which menu items are ordered least frequently?
-- =====================================================
SELECT mi.item_name , COUNT(od.order_id) AS count_of_order FROM menu_items mi
JOIN order_details od
ON od.item_id = mi.menu_item_id
GROUP BY mi.item_name
ORDER BY count_of_order ;

-- Finding : Chicken Tacos, Potstickers, Cheese Lasagna are the least ordered menu items

-- =====================================================
-- 6. CATEGORY ORDER VOLUME
-- Business Question: Which categories receive the highest number of orders?
-- =====================================================
SELECT mi.category, COUNT(od.order_id)  AS count_of_orders FROM menu_items mi
JOIN order_details od
ON mi.menu_item_id = od.item_id
GROUP BY mi.category
ORDER BY count_of_orders DESC;

-- Finding : Asian received the highest number of orders and Italian is at the second place 

-- =====================================================
-- 7. AVERAGE PRICE BY CATEGORY
-- Business Question: Which menu categories have the highest average selling price?
-- =====================================================
SELECT mi.category, ROUND(AVG(mi.price),2) AS avg_price FROM menu_items mi
JOIN order_details od
ON mi.menu_item_id = od.item_id
GROUP BY mi.category
ORDER BY avg_price DESC;

-- Finding : Italian = 16.78 and Asian = 13.46 , are having the highest average sold-item prices.

-- =====================================================
-- 8. HIGH REVENUE, LOW VOLUME ITEMS
-- Business Question: Which menu items generate high revenue despite lower sales volume?
-- =====================================================
WITH insight AS (
	SELECT mi.item_name AS item_name , 
		ROUND(SUM(mi.price),2) AS revenue, 
		COUNT(od.order_id) AS sales 
	FROM menu_items mi
	JOIN order_details od
	ON mi.menu_item_id = od.item_id
	GROUP BY mi.item_name
)
SELECT item_name, revenue, sales 
FROM insight
WHERE revenue > 
( SELECT AVG(revenue) FROM insight ) 
AND 
sales <
( SELECT AVG(sales) FROM insight)
ORDER BY revenue DESC;

-- Finding: Chicken Parmesan, Pork Ramen, Mushroom Ravioli, Spaghetti, and Steak Burrito have high revenue but low sales volume.

-- =====================================================
-- 9. HIGH VOLUME, LOW REVENUE ITEMS
-- Business Question: Which menu items are popular but contribute relatively less revenue?
-- =====================================================
WITH data_req AS (
SELECT mi.item_name AS item_name, ROUND(SUM(mi.price),2) AS revenue , COUNT(od.order_id) AS sales
FROM menu_items mi
JOIN order_details od
ON mi.menu_item_id = od.item_id
GROUP BY mi.item_name
)
SELECT item_name, revenue, sales FROM data_req
WHERE revenue < ( SELECT AVG(revenue) FROM data_req )
AND 
sales > ( SELECT AVG(sales) FROM data_req);

-- Finding: French Fries, Chicken Torta, Chips & Salsa, Mac & Cheese, and Edamame are popular items but generate relatively low revenue.

-- =====================================================
-- 10. EXECUTIVE INSIGHTS
-- Purpose: Summarize key revenue findings and business recommendations.
-- =====================================================

-- Observation 01:
-- Italian generated the highest revenue.
-- Interpretation:
-- Higher average item prices helped Italian generate more revenue despite lower order volume than Asian.
-- Action:
-- Maintain Italian pricing strength and promote selected Italian items during peak hours.

-- Observation 02:
-- Korean Beef Bowl and Spaghetti & Meatballs were the highest revenue-generating menu items.
-- Interpretation:
-- These items combine strong demand with higher item prices, making them key revenue drivers.
-- Action:
-- Use combos, upselling, and featured menu placement to further increase their revenue contribution.

-- Observation 03:
-- Chicken Tacos and Potstickers generated the lowest revenue.
-- Interpretation:
-- Chicken Tacos have a near-average price but very low sales volume, while Potstickers have a below-average price but still generate low revenue overall.
-- Action:
-- Investigate Chicken Tacos through customer feedback, taste testing, menu visibility review, or recipe improvement before making pricing changes.

-- Observation 04:
-- American category contributes the lowest share of total revenue at 17.74%.
-- Interpretation:
-- American also has the lowest order volume, suggesting weaker category performance compared with Asian, Italian, and Mexican categories.
-- Action:
-- Review item-level performance within the American category and conduct customer feedback analysis to understand whether low performance is driven by taste, pricing, menu visibility, or customer preference.

-- Observation 05:
-- Chicken Parmesan, Pork Ramen, Mushroom Ravioli, Spaghetti, and Steak Burrito generated high revenue despite lower sales volume.
-- Interpretation:
-- These items likely benefit from above-average prices, making them valuable premium items.
-- Action:
-- Promote these items through targeted marketing, combos, or upselling to improve sales volume without weakening price positioning.

-- Observation 06:
-- French Fries, Chicken Torta, Chips & Salsa, Mac & Cheese, and Edamame had high sales volume but relatively lower revenue.
-- Interpretation:
-- These items are popular but likely priced below the overall average, limiting revenue contribution.
-- Action:
-- Explore pricing review, bundling, or upselling opportunities to increase revenue from high-volume items.

-- REVENUE ANALYSIS COMPLETED