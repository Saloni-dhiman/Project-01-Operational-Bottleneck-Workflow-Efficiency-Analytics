-- =====================================================
-- 05 CUSTOMER SATISFACTION ANALYSIS
-- Project: Operational Bottleneck & Workflow Efficiency Analytics System
-- Purpose: Analyze customer ratings, complaint patterns, wait-time impact,
-- service quality issues, and customer experience drivers.
-- =====================================================

-- =====================================================
-- 1. OVERALL CUSTOMER RATING DISTRIBUTION
-- Business Question: What is the distribution of customer ratings?
-- =====================================================
WITH rating_table AS (
SELECT ratings, COUNT(*) AS total_ratings ,
SUM(COUNT(*)) OVER() AS grand_total FROM customer_feedback
GROUP BY ratings
)
SELECT ratings, total_ratings, 
ROUND(total_ratings * 100 / grand_total ,2) AS percent_in_total
FROM rating_table
ORDER BY percent_in_total DESC;

-- Finding: Rating 4 has the highest share at 34.48%, while rating 5 contributes only 2.41%. This suggests most positive feedback is concentrated at rating 4 rather than the highest satisfaction level.

-- =====================================================
-- 2. AVERAGE RATING BY SHIFT
-- Business Question: Which shifts receive the highest and lowest average customer ratings?
-- =====================================================
SELECT sf.shift_time, ROUND(AVG(cf.ratings), 2) AS avg_rating
FROM staffing_metrices sf
JOIN operational_metrices op 
ON sf.shift_id = op.shift_id
JOIN customer_feedback cf
ON op.order_id = cf.order_id
GROUP BY sf.shift_time
ORDER BY avg_rating DESC;

-- Finding: Average customer rating is 2.9 across all shifts.

-- =====================================================
-- 3. AVERAGE RATING BY ORDER TYPE
-- Business Question: Do online or in-store orders receive better customer ratings?
-- =====================================================
SELECT op.order_type , ROUND(AVG(cf.ratings),2) AS avr_rating 
FROM customer_feedback cf
JOIN operational_metrices op 
ON op.order_id = cf.order_id
GROUP BY op.order_type;

-- Finding : This dataset provided 3.02 ratings for Online orders and 2.74 ratings for In-store orders which donot show a large difference but still online orders are above Instore orders

-- =====================================================
-- 4. WAIT TIME VS CUSTOMER RATING
-- Business Question: Does longer wait time reduce customer ratings?
-- =====================================================
SELECT cf.ratings , ROUND(AVG(op.wait_time),2) AS avg_wait_time FROM customer_feedback cf
JOIN operational_metrices op 
ON op.order_id = cf.order_id
GROUP BY cf.ratings 
ORDER BY avg_wait_time DESC;

-- Finding: Lower ratings are associated with higher average wait time, suggesting wait time is a meaningful customer satisfaction driver.

-- =====================================================
-- 5. PREP TIME VS CUSTOMER RATING
-- Business Question: Does longer preparation time affect customer ratings?
-- =====================================================
SELECT cf.ratings , ROUND(AVG(op.prep_time),2) AS avg_prep_time FROM customer_feedback cf
JOIN operational_metrices op 
ON op.order_id = cf.order_id
GROUP BY cf.ratings 
ORDER BY avg_prep_time DESC;

-- Finding: Lower ratings are associated with higher average prep time, suggesting preparation delays may negatively affect customer ratings.

-- =====================================================
-- 6. COMPLAINT TYPE DISTRIBUTION
-- Business Question: What are the most common customer complaint types?
-- =====================================================
WITH complaints AS (
SELECT
complaint_type,
COUNT(*) AS total_complaints,
SUM(COUNT(*)) OVER() AS grand_total
FROM customer_feedback
GROUP BY complaint_type
)
SELECT
complaint_type,
total_complaints,
ROUND(total_complaints * 100 / grand_total, 2) AS complaint_percentage
FROM complaints
WHERE complaint_type IS NOT NULL
AND complaint_type <> ''
ORDER BY total_complaints DESC;

-- Finding : 36.89% customers gave no feedback however, 32.17% customers were unsatisfied with food and 30.94% customers complained about slow service.

-- =====================================================
-- 7. COMPLAINTS BY SHIFT
-- Business Question: Which shifts generate the highest number of complaints?
-- =====================================================
SELECT sf.shift_time, 
COUNT(DISTINCT cf.order_id) AS complaint_orders
FROM staffing_metrices sf
JOIN operational_metrices op 
ON sf.shift_id = op.shift_id
JOIN customer_feedback cf
ON op.order_id = cf.order_id
WHERE cf.complaint_type IS NOT NULL
AND cf.complaint_type <> ''
GROUP BY sf.shift_time
ORDER BY complaint_orders DESC;

-- Finding : Afternoon shifts faces highest number of complaints while night shift generated lowest number of complaints 

-- =====================================================
-- 8. COMPLAINTS BY WORKLOAD LEVEL
-- Business Question: Do higher workload levels generate more complaints?
-- =====================================================
SELECT sf.workload_level, 
COUNT(DISTINCT cf.order_id) AS complaint_orders
FROM staffing_metrices sf
JOIN operational_metrices op 
ON sf.shift_id = op.shift_id
JOIN customer_feedback cf
ON op.order_id = cf.order_id
WHERE cf.complaint_type IS NOT NULL
AND cf.complaint_type <> ''
GROUP BY sf.workload_level
ORDER BY complaint_orders DESC;

-- Finding : When workload is low complaints are high but when workload is high then comaplaints are low which shows worload level has no association with complaints

-- =====================================================
-- 9. LOW RATING ROOT CAUSE ANALYSIS
-- Business Question: What operational factors are linked with low customer ratings?
-- =====================================================
SELECT cf.ratings, 
ROUND(AVG(op.wait_time),2) AS avg_wait_time, 
ROUND(AVG(op.prep_time),2) AS avg_prep_time, 
op.order_type
FROM operational_metrices op 
JOIN customer_feedback cf
ON op.order_id = cf.order_id
GROUP BY cf.ratings, op.order_type
ORDER BY cf.ratings DESC;

-- Finding : Online orders show higher average wait time and prep time than in-store orders across all rating levels. Lower ratings are generally associated with longer wait and prep times, especially for online orders.

-- =====================================================
-- 10. EXECUTIVE INSIGHTS
-- Purpose: Summarize customer satisfaction findings and service improvement recommendations.
-- =====================================================

-- Observation 01: Rating 4 represents the largest share of customer feedback, while rating 5 contributes only a small percentage.
-- Interpretation: Customers are generally satisfied but relatively few report the highest level of satisfaction.
-- Action: Focus on improving the customer experience to convert satisfied customers into highly satisfied customers.

-- Observation 02: Average customer ratings remain consistent across Morning, Afternoon, and Night shifts.
-- Interpretation: Shift timing does not appear to be a major driver of customer satisfaction.
-- Action: Focus improvement efforts on operational and product-related factors rather than shift-specific changes.

-- Observation 03: Online orders receive slightly higher ratings than in-store orders.
-- Interpretation: Order channel may have a minor influence on customer satisfaction, but the difference is not substantial.
-- Action: Continue monitoring both channels and investigate customer expectations for each order type.

-- Observation 04: Lower ratings are associated with longer wait times and preparation times.
-- Interpretation: Service speed is an important customer satisfaction driver.
-- Action: Reduce delays by monitoring high-wait orders and improving operational efficiency during busy periods.

-- Observation 05: food taste complaints occur more frequently than slow-service complaints.
-- Interpretation: Product quality issues appear to have a greater impact on customer dissatisfaction than operational delays.
-- Action: Review food preparation consistency, recipe execution, ingredient quality, and quality-control processes.

-- Observation 06: Afternoon shifts generate the highest number of complaints.
-- Interpretation: This may be related to higher order volume during Afternoon shifts rather than poorer service quality.
-- Action: Calculate complaint rates relative to order volume before implementing shift-specific interventions.

-- Observation 07: Online orders consistently show higher wait times and preparation times across all rating levels.
-- Interpretation: Online order processing may introduce additional operational complexity and customer delays.
-- Action: Review online order workflows, queue management, and staffing allocation during peak online demand periods.

-- CUSTOMER SATISFACTION ANALYSIS COMPLETED
