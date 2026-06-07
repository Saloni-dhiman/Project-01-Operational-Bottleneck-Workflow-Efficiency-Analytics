-- =====================================================
-- 04 STAFFING ANALYSIS
-- Project: Operational Bottleneck & Workflow Efficiency Analytics System
-- Purpose: Analyze staffing levels, experience mix, workload distribution,
-- operational efficiency, and workforce impact on customer experience.
-- =====================================================

-- =====================================================
-- 1. STAFF COUNT VS WAIT TIME
-- Business Question: Does increasing staff count reduce customer wait time?
-- =====================================================
SELECT sf.staff_count , ROUND(AVG(op.wait_time),2) AS avg_wait_time
FROM staffing_metrices sf
JOIN operational_metrices op 
ON sf.shift_id = op.shift_id
GROUP BY sf.staff_count
ORDER BY avg_wait_time DESC;

-- Finding : The factor of increasing staff count does not affect average wait time of customers, in every case wait time is close to each other and has a negligible difference

-- =====================================================
-- 2. STAFF COUNT VS PREP TIME
-- Business Question: Does increasing staff count improve preparation efficiency?
-- =====================================================
SELECT sf.staff_count , ROUND(AVG(op.prep_time),2) AS avg_prep_time
FROM staffing_metrices sf
JOIN operational_metrices op 
ON sf.shift_id = op.shift_id
GROUP BY sf.staff_count
ORDER BY avg_prep_time DESC;

-- Finding : The factor of increasing staff count does not affect average prep time, in every case prep time is close to each other and has a negligible difference

-- =====================================================
-- 3. EXPERIENCE LEVEL VS WAIT TIME
-- Business Question: Which experience level delivers the lowest customer wait time?
-- =====================================================
SELECT sf.experience_level , ROUND(AVG(op.wait_time),2) AS avg_wait_time
FROM staffing_metrices sf
JOIN operational_metrices op 
ON sf.shift_id = op.shift_id
GROUP BY sf.experience_level
ORDER BY avg_wait_time DESC;

-- Finding : The customer average wait time for each level is similar, which shows that experience level has no relation with customer wait time

-- =====================================================
-- 4. EXPERIENCE LEVEL VS PREP TIME
-- Business Question: Which experience level delivers the fastest preparation time?
-- =====================================================
SELECT sf.experience_level , ROUND(AVG(op.prep_time),2) AS avg_prep_time
FROM staffing_metrices sf
JOIN operational_metrices op 
ON sf.shift_id = op.shift_id
GROUP BY sf.experience_level
ORDER BY avg_prep_time DESC;

-- Finding : The average prep time for each experience level is similar, which shows that experience level has no relation with prep time

-- =====================================================
-- 5. EXPERIENCE LEVEL VS CUSTOMER SATISFACTION
-- Business Question: Do more experienced teams receive higher customer ratings?
-- =====================================================
SELECT sf.experience_level, ROUND(AVG(cf.ratings) ,1) AS rating 
FROM staffing_metrices sf
JOIN operational_metrices op 
ON sf.shift_id = op.shift_id
JOIN customer_feedback cf
ON op.order_id = cf.order_id
GROUP BY sf.experience_level
ORDER BY rating DESC;

-- Finding : Ratings for all experience levels is 2.9 which clearly shows experience level has no relation with customer satisfaction.

-- =====================================================
-- 6. STAFF COUNT VS ORDER VOLUME
-- Business Question: Are staffing levels aligned with customer demand?
-- =====================================================
SELECT sf.staff_count , COUNT(op.order_id) AS order_volume
FROM staffing_metrices sf
JOIN operational_metrices op 
ON sf.shift_id = op.shift_id
GROUP BY sf.staff_count
ORDER BY order_volume DESC;

-- Finding: Higher staff-count groups handle higher total order volume in this dataset. This suggests staffing levels are broadly aligned with demand, but it does not prove that higher staffing caused higher order volume.

-- =====================================================
-- 7. WORKLOAD LEVEL VS STAFF COUNT
-- Business Question: Are high-workload shifts adequately staffed?
-- =====================================================
SELECT workload_level , AVG(staff_count) AS avg_staff_count
FROM staffing_metrices
GROUP BY workload_level
ORDER BY avg_staff_count DESC ;

-- Finding : Higher workload levels are associated with lower average staff count, suggesting potential understaffing during pressure periods.

-- =====================================================
-- 8. STAFFING EFFICIENCY
-- Business Question: Which staffing setups handle the most orders per employee?
-- =====================================================
SELECT sf.shift_time AS time_of_shift, sf.staff_count AS count_of_staff, sf.experience_level AS exp_level, 
COUNT(op.order_id) AS order_volume,
ROUND((COUNT(op.order_id) / sf.staff_count),0) AS order_per_emp 
FROM staffing_metrices sf
JOIN operational_metrices op
ON sf.shift_id = op.shift_id
GROUP BY sf.shift_time, sf.staff_count, sf.experience_level
ORDER BY order_per_emp DESC;

-- Finding : Setup in afternoon shift with 2 junior level staff are taking most orders with 692 orders per employee and another is night shift where 2 juinor level staff is taking 651 orders per employee.

-- =====================================================
-- 9. OVERLOADED SHIFTS
-- Business Question: Which shifts handle high order volume with limited staffing resources?
-- =====================================================
SELECT sf.shift_time AS time_of_shift, sf.staff_count AS count_of_staff, sf.experience_level AS exp_level, 
COUNT(op.order_id) AS order_volume,
ROUND((COUNT(op.order_id) / sf.staff_count),0) AS order_per_emp 
FROM staffing_metrices sf
JOIN operational_metrices op
ON sf.shift_id = op.shift_id
GROUP BY sf.shift_time, sf.staff_count, sf.experience_level
HAVING order_per_emp > 500
ORDER BY order_per_emp DESC;

-- Finding : Afternoon and Night shifts are with 2 junior level staff with order_per_emp = 692 and 651 are the shifts which has limited staffing resources.

-- =====================================================
-- 10. EXECUTIVE INSIGHTS
-- Purpose: Summarize staffing performance findings and workforce optimization recommendations.
-- =====================================================

-- =====================================================
-- 10. EXECUTIVE INSIGHTS
-- Purpose: Summarize staffing performance findings and workforce optimization recommendations.
-- =====================================================

-- Observation 01: Staff count does not show a meaningful difference in average wait time or prep time.
-- Interpretation: Staffing quantity alone may not be the strongest driver of operational speed in this dataset.
-- Action: Evaluate staffing alongside order type, workload level, and experience mix before changing staffing levels.

-- Observation 02: Customer ratings are similar across experience levels.
-- Interpretation: Experience level alone does not appear to strongly influence customer satisfaction in this dataset.
-- Action: Combine experience analysis with workload and shift-level analysis to better identify service-quality drivers.

-- Observation 03: Higher staff-count groups handle higher total order volume.
-- Interpretation: Staffing levels appear broadly aligned with demand, although this does not prove causation.
-- Action: Continue monitoring order volume against staff allocation to ensure high-demand periods remain adequately covered.

-- Observation 04: High-workload shifts have lower average staff count.
-- Interpretation: This indicates possible staffing imbalance during pressure periods.
-- Action: Review scheduling for high-workload shifts and consider adding support staff during peak pressure periods.

-- Observation 05: Afternoon and Night shifts with 2 junior-heavy staff show the highest orders per employee.
-- Interpretation: These shifts may be operationally overloaded despite appearing efficient on an orders-per-employee basis.
-- Action: Review workload distribution and consider additional staffing or senior support for these shifts.	

-- STAFIING ANALYSIS COMPLETED