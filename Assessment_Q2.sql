-- Monthly transaction count table
WITH user_monthly_txns AS (
    SELECT 
        s.owner_id,
        YEAR(s.transaction_date) AS year,
        MONTH(s.transaction_date) AS month,
        COUNT(*) AS txn_count
    FROM savings_savingsaccount s
	GROUP BY s.owner_id, YEAR(s.transaction_date), MONTH(s.transaction_date)
),
-- Average transaction per customer table
avg_txn_per_customer AS (
    SELECT 
        owner_id,
        -- Average number of transactions per month for each customer
        ROUND(AVG(txn_count), 1) AS avg_txn_per_month
    FROM user_monthly_txns
    GROUP BY owner_id
),
-- Customer category table
categorized_customers AS (
    SELECT 
        owner_id,
        avg_txn_per_month,
        -- Categorize customers based on their average monthly transaction frequency
        CASE 
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM avg_txn_per_customer
)
-- Transaction Frequency Table
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    -- Average of the individual customers' average monthly transactions
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
-- Order for better readability
ORDER BY avg_transactions_per_month DESC;