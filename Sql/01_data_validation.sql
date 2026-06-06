-- =====================================================
-- 01 DATA VALIDATION
-- Project: Operational Bottleneck & Workflow Efficiency Analytics System
-- Purpose: Check row counts, missing values, duplicates, invalid values, and broken relationships
-- =====================================================

-- STEP - 01
-- Finding : Row count check 
SELECT "customer_feedback",COUNT(*) FROM customer_feedback
UNION ALL
SELECT "menu_items",COUNT(*) FROM menu_items
UNION ALL
SELECT "operational_metrices",COUNT(*) FROM operational_metrices
UNION ALL
SELECT "order_details",COUNT(*) FROM order_details
UNION ALL
SELECT "staffing_metrices",COUNT(*) FROM staffing_metrices;

-- Checking which order id exists in operational_metrices and not in orders details
SELECT op.order_id AS null_id
FROM operational_metrices op
JOIN order_details od
ON op.order_id = od.order_id
WHERE op.order_id NOT IN (od.order_id);

-- I find a null value 
SELECT * FROM operational_metrices 
WHERE order_id IS NULL;

-- DELETING the null column 
DELETE FROM operational_metrices WHERE order_id IS NULL;

-- checking again for nulls 
SELECT * FROM operational_metrices 
WHERE order_id IS NULL;

-- checking row counts again
SELECT "customer_feedback",COUNT(*) FROM customer_feedback
UNION ALL
SELECT "menu_items",COUNT(*) FROM menu_items
UNION ALL
SELECT "operational_metrices",COUNT(*) FROM operational_metrices
UNION ALL
SELECT "order_details",COUNT(*) FROM order_details
UNION ALL
SELECT "staffing_metrices",COUNT(*) FROM staffing_metrices;

-- Now checking nulls in other tables as well
SELECT * FROM customer_feedback
WHERE order_id IS NULL;  

SELECT * FROM menu_items 
WHERE menu_item_id IS NULL; 

SELECT * FROM order_details  
WHERE order_id IS NULL;  

SELECT * FROM staffing_metrices 
WHERE shift_id IS NULL; 

-- No nulls founds in any table 

-- STEP - 02
-- Finding  : Duplicates

SELECT order_details_id , COUNT(*) FROM order_details
GROUP BY order_details_id
HAVING COUNT(*) > 1;  

SELECT menu_item_id , COUNT(*) FROM menu_items
GROUP BY menu_item_id
HAVING COUNT(*) > 1;  

SELECT shift_id , COUNT(*) FROM staffing_metrices
GROUP BY shift_id
HAVING COUNT(*) > 1; 

-- No duplicates found in any table 

-- STEP : 03 
-- Finding : invalid ratings check in customers_feedback table
SELECT ratings FROM customer_feedback
WHERE ratings NOT BETWEEN 1 AND 5;   

-- No invalid rating

-- STEP : 04 
-- Finding : negative wait_time and prep_time
SELECT wait_time , prep_time FROM operational_metrices
WHERE wait_time < 0 AND prep_time < 0;  

-- No negative values found for wait_time and prep_time

-- STEP : 05
-- Finding : Broken relationships

SELECT COUNT(od.item_id) AS broken_relationship FROM order_details od
LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
WHERE mi.menu_item_id IS NULL;
-- All order_details.item_id values successfully match menu_items.menu_item_id.

SELECT COUNT(od.order_id) FROM order_details od
LEFT JOIN customer_feedback cf
ON od.order_id = cf.order_id
WHERE cf.order_id IS NULL;
-- All order_details.order_id values successfully match customer_feedback.order_id.

SELECT COUNT(od.order_id) FROM order_details od
LEFT JOIN operational_metrices op
ON od.order_id = op.order_id
WHERE op.order_id IS NULL;
-- All order_details.order_id values successfully match operational_metrices.order_id.

SELECT COUNT(op.shift_id) FROM operational_metrices op
LEFT JOIN staffing_metrices sm
ON op.shift_id = sm.shift_id
WHERE sm.shift_id IS NULL;
-- All operational_metrices.shift_id values successfully match staffing_metrices.shift_id.


-- Relationship Check Finding:
-- No broken relationships found.
-- All foreign key relationships are valid:
-- order_details.item_id → menu_items.menu_item_id
-- operational_metrices.order_id → order_details.order_id
-- customer_feedback.order_id → order_details.order_id
-- operational_metrices.shift_id → staffing_metrices.shift_id

-- STEP : 06
-- Finding : Invalid value checks

SELECT * FROM customer_feedback
WHERE ratings NOT BETWEEN 1 AND 5;

SELECT * FROM menu_items 
WHERE price = 0;

SELECT * FROM operational_metrices
WHERE prep_time = 0 OR wait_time = 0;

SELECT DISTINCT shift_id
FROM operational_metrices
WHERE shift_id NOT IN (
    SELECT DISTINCT shift_id FROM operational_metrices
);

SELECT DISTINCT workload_level
FROM staffing_metrices
WHERE workload_level NOT IN (
    SELECT DISTINCT workload_level FROM staffing_metrices
);

SELECT DISTINCT experience_level
FROM staffing_metrices
WHERE experience_level NOT IN (
    SELECT DISTINCT experience_level FROM staffing_metrices
);

SELECT DISTINCT shift_time
FROM staffing_metrices
WHERE shift_time NOT IN (
    SELECT DISTINCT shift_time FROM staffing_metrices
);

-- Finding: No invalid shift, workload, or experience labels found.

-- DATA VALIDATION COMPLETE













