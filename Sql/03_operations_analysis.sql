-- =====================================================
-- 03 OPERATIONS ANALYSIS
-- Project: Operational Bottleneck & Workflow Efficiency Analytics System
-- Purpose: Analyze wait times, prep times, order types, shift performance, workload pressure, and operational bottlenecks.
-- =====================================================

-- =====================================================
-- 1. AVERAGE WAIT TIME BY SHIFT
-- Business Question: Which shifts have the highest average wait time?
-- =====================================================
SELECT sf.shift_time, ROUND(AVG(op.wait_time),2) AS avg_wait_time FROM operational_metrices op
JOIN staffing_metrices sf
ON op.shift_id = sf.shift_id
GROUP BY sf.shift_time 
ORDER BY avg_wait_time DESC;

-- Finding: Average wait times are consistent across all shifts, ranging from 13.81 to 13.92 minutes. Morning shift recorded the highest average wait time, but the difference between shifts is minimal.

-- =====================================================
-- 2. AVERAGE PREP TIME BY SHIFT
-- Business Question: Which shifts have the highest average preparation time?
-- =====================================================
SELECT sf.shift_time, ROUND(AVG(op.prep_time),2) AS avg_prep_time FROM operational_metrices op
JOIN staffing_metrices sf
ON op.shift_id = sf.shift_id
GROUP BY sf.shift_time 
ORDER BY avg_prep_time DESC;

-- Finding: Average prep times are consistent across all shifts, ranging from 8.83 to 8.93 minutes. Morning shift recorded the highest average prep time, but the difference across shifts is minimal.

-- =====================================================
-- 3. WAIT TIME BY ORDER TYPE
-- Business Question: Do online or in-store orders have longer wait times?
-- =====================================================
SELECT order_type, ROUND(AVG(wait_time),2) AS avg_wait_time FROM operational_metrices 
GROUP BY order_type
ORDER BY avg_wait_time DESC ;

-- Finding : avg wait time in Online orders is high as compared to in-store orders

-- =====================================================
-- 4. PREP TIME BY ORDER TYPE
-- Business Question: Which order type takes longer to prepare?
-- =====================================================
SELECT order_type, ROUND(AVG(prep_time),2) AS avg_prep_time FROM operational_metrices 
GROUP BY order_type
ORDER BY avg_prep_time DESC;

-- Finding : prep time in Online orders is high as compared to in-store orders

-- =====================================================
-- 5. WORKLOAD LEVEL VS WAIT TIME
-- Business Question: Does higher workload increase customer wait time?
-- =====================================================
SELECT sf.workload_level, ROUND(AVG(op.wait_time),2) AS avg_wait_time 
FROM operational_metrices op 
JOIN staffing_metrices sf
ON op.shift_id = sf.shift_id
GROUP BY sf.workload_level
ORDER BY avg_wait_time DESC;

-- Finding: Average wait time is very similar across workload levels, ranging from 13.81 to 13.92 minutes. High workload has the highest average wait time, but the difference is minimal.

-- =====================================================
-- 6. SHIFT ORDER VOLUME
-- Business Question: Which shifts handle the highest number of orders?
-- =====================================================
SELECT sf.shift_time AS shifts, COUNT(op.order_id) AS count_of_orders,
ROUND(AVG(COUNT(op.order_id)) OVER(), 2) AS overall_avg_orders
FROM operational_metrices op 
JOIN staffing_metrices sf
ON sf.shift_id = op.shift_id
GROUP BY sf.shift_time
ORDER BY count_of_orders DESC;

-- Finding: Afternoon shifts handle the highest order volume and are above the overall average order volume.

-- =====================================================
-- 7. BOTTLENECK SHIFTS
-- Business Question: Which shifts show both high order volume and high wait time?
-- =====================================================
SELECT sf.shift_time, COUNT(op.order_id) AS order_volume, ROUND(AVG(op.wait_time) ,2) AS avg_wait_time
FROM operational_metrices op 
JOIN staffing_metrices sf
ON op.shift_id = sf.shift_id
GROUP BY sf.shift_time
ORDER BY order_volume DESC;

-- Finding : Afternoon shift has the highest number of orders but the average wait time of all three shifts is very close and have a negligible time difference.

-- =====================================================
-- 8. MENU CATEGORY VS WAIT TIME
-- Business Question: Which menu categories are linked with longer wait times?
-- =====================================================
SELECT mi.category, ROUND(AVG(op.wait_time),2) AS avg_wait_time FROM menu_items mi
JOIN order_details od
ON mi.menu_item_id = od.item_id
JOIN operational_metrices op
ON op.order_id = od.order_id
GROUP BY mi.category
ORDER BY avg_wait_time DESC;

-- Finding: Average wait time varies only slightly across menu categories, with Italian recording the highest average wait time.

-- =====================================================
-- 9. MENU ITEM VS PREP TIME
-- Business Question: Which menu items take the longest to prepare on average?
-- =====================================================
SELECT mi.item_name, ROUND(AVG(op.prep_time),2) AS avg_prep_time FROM menu_items mi
JOIN order_details od
ON mi.menu_item_id = od.item_id
JOIN operational_metrices op
ON op.order_id = od.order_id
GROUP BY mi.item_name
ORDER BY avg_prep_time DESC;

-- Finding: Average prep time varies only slightly across menu items, with Salmon Roll recording the highest average prep time.

-- =====================================================
-- 10. EXECUTIVE INSIGHTS
-- Purpose: Summarize operational bottlenecks and workflow improvement recommendations.
-- =====================================================

-- Observation 01: Average wait times are consistent across Morning, Afternoon, and Night shifts.
-- Interpretation: Shift timing alone does not appear to be a strong driver of customer wait time.
-- Action: Investigate order type, menu complexity, staffing count, and experience level to identify stronger bottleneck drivers.

-- Observation 02: Average prep times are also consistent across shifts.
-- Interpretation: Preparation time does not vary meaningfully by shift period.
-- Action: Analyze prep time at menu item and order type level rather than relying only on shift-level analysis.

-- Observation 03: Online orders show higher average wait time and prep time than in-store orders.
-- Interpretation: Online orders may create additional workflow pressure due to batching, queue handling, or preparation complexity.
-- Action: Review online order handling processes and consider separate queue management during busy periods.

-- Observation 04: Workload levels show only minimal differences in average wait time.
-- Interpretation: Workload level alone does not strongly explain customer waiting time in this dataset.
-- Action: Combine workload analysis with staff count, experience level, and order type to identify clearer operational patterns.

-- Observation 05: Afternoon shifts handle the highest order volume, but average wait time remains similar to other shifts.
-- Interpretation: Higher order volume does not necessarily translate into higher wait time, suggesting operations may be handling volume consistently across shifts.
-- Action: Continue monitoring Afternoon shift capacity and compare it with staffing levels to prevent future bottlenecks.

-- OPERATIONS ANALYSIS COMPLETED