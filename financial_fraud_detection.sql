-- Use Database
USE july;

-- financial fraud sample data
CREATE  TABLE fin_fraud SELECT * FROM financial_fraud LIMIT 25000;

-- Total Transactions
SELECT COUNT(*) AS total_transactions FROM fin_fraud;

-- Total Fraud Transactions
SELECT COUNT(*) AS total_fraud
FROM fin_fraud
WHERE is_fraud = 1;

-- Fraud Percentage
SELECT 
ROUND(SUM(is_fraud=1)/COUNT(*)*100,2) AS fraud_percentage
FROM fin_fraud;

-- Total Transaction Amount
SELECT 
ROUND(SUM(amount),2) AS total_amount
FROM fin_fraud;

-- Average Transaction Amount
SELECT 
ROUND(AVG(amount),2) avg_transaction
FROM fin_fraud;

-- Fraud by Transaction Type
SELECT 
	transaction_type,
    COUNT(*) total_transactions,
    SUM(is_fraud=1) fraud_cases,
    ROUND(SUM(is_fraud=1)/COUNT(*)*100,2) fraud_rate
FROM fin_fraud
GROUP BY transaction_type
ORDER BY fraud_rate DESC;

-- Fraud by Merchant Category
SELECT 
	merchant_category,
	COUNT(*) total_transactions,
	SUM(is_fraud=1) fraud_cases
FROM fin_fraud
GROUP BY merchant_category
ORDER BY fraud_cases DESC;

-- Fraud by Payment Channel
SELECT 
	payment_channel,
	COUNT(*) total_transactions,
	SUM(is_fraud=1) fraud_transactions
FROM fin_fraud
GROUP BY payment_channel
ORDER BY fraud_transactions DESC;

-- Fraud by Location
SELECT 
	location,
	COUNT(*) total_transactions,
	SUM(is_fraud=1) fraud_cases
FROM fin_fraud
GROUP BY location
ORDER BY fraud_cases DESC;

-- Fraud by Device Used
SELECT 
	device_used,
	COUNT(*) total_transactions,
	SUM(is_fraud=1) fraud_cases
FROM fin_fraud
GROUP BY device_used
ORDER BY fraud_cases DESC;

-- High Risk Transactions
SELECT 
	CASE
    WHEN velocity_score >= 14 THEN 'High risk'
    WHEN velocity_score BETWEEN 7 AND 14 THEN 'Medium risk'
    ELSE 'Low risk'
    END Risk_level,
    COUNT(*) Total_tnx
FROM fin_fraud
GROUP BY Risk_level;

-- Top 10 Highest Fraud Amounts
SELECT 
	sender_account,
	amount,
	fraud_type
FROM fin_fraud
WHERE is_fraud = 1
ORDER BY amount DESC
LIMIT 10;

-- Fraud Trend by Date
SELECT 
	DATE(timestamp) transaction_date,
	COUNT(*) total_transactions,
	SUM(is_fraud=1) fraud_cases
FROM fin_fraud
GROUP BY DATE(timestamp)
ORDER BY transaction_date;

-- Fraud by Hour (Suspicious Time Detection)
SELECT 
	HOUR(timestamp) transaction_hour,
	COUNT(*) total_transactions,
	SUM(is_fraud=1) fraud_cases
FROM fin_fraud
GROUP BY transaction_hour
ORDER BY fraud_cases DESC;

-- Top Fraud Sender Accounts
SELECT 
	sender_account,
	COUNT(*) fraud_count
	FROM fin_fraud
WHERE is_fraud = 1
GROUP BY sender_account
ORDER BY fraud_count DESC
LIMIT 10;

-- Velocity Fraud Detection
SELECT 
	sender_account,
	COUNT(*) transaction_count
FROM fin_fraud
GROUP BY sender_account
HAVING COUNT(*) > 1
ORDER BY transaction_count DESC;

-- Same Device Multiple Accounts (Device Fraud)
SELECT 
	device_hash,
	COUNT(DISTINCT sender_account) accounts_used
FROM fin_fraud
GROUP BY device_hash
HAVING accounts_used > 1;

-- Same IP Address Fraud Detection
SELECT 
	ip_address,
	COUNT(*) transactions,
	SUM(is_fraud=1) fraud_cases
FROM fin_fraud
GROUP BY ip_address
ORDER BY fraud_cases DESC;

-- Suspicious Geo Location Transactions
SELECT *
FROM fin_fraud
WHERE geo_anomaly_score >= 0.7;

-- High Amount + High Risk Transactions
SELECT *
FROM fin_fraud
WHERE amount >= 1500
AND spending_deviation_score >= 2
AND is_fraud = 1;

-- Fraud Type Distribution
SELECT 
	fraud_type,
	COUNT(*) total_cases
FROM fin_fraud
WHERE is_fraud = 1
GROUP BY fraud_type
ORDER BY total_cases DESC;

-- Fraud vs Non Fraud Comparison
SELECT 
	is_fraud,
	COUNT(*) total_transactions,
	ROUND(AVG(amount),2) avg_amount
FROM fin_fraud
GROUP BY is_fraud;

-- Merchant Category High Risk Score
SELECT 
	merchant_category,
	ROUND(AVG(spending_deviation_score),2) avg_risk
FROM fin_fraud
GROUP BY merchant_category
ORDER BY avg_risk DESC;

-- Fraud Detection Rate
SELECT 
	ROUND(SUM(is_fraud=1)/COUNT(*)*100,2) fraud_rate
FROM fin_fraud;

-- Total Fraud Loss Amount
SELECT 
	ROUND(SUM(amount),2) total_fraud_loss
FROM fin_fraud
WHERE is_fraud = 1;

-- Last 15 Minutes Fraud
SELECT 
	COUNT(*) fraud_last_15_mins
FROM fin_fraud
WHERE timestamp >= (SELECT MAX(timestamp) FROM fin_fraud) - INTERVAL 15 MINUTE
AND is_fraud = 1;

-- Last 15 Minutes Non-Fraud
SELECT *
FROM fin_fraud
WHERE timestamp >= (SELECT MAX(timestamp) FROM fin_fraud) - INTERVAL 15 MINUTE
AND is_fraud = 0;

