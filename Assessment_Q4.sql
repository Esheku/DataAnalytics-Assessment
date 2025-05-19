WITH transaction_table AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        
        -- Calculate account tenure in months from signup date to latest transaction date
        TIMESTAMPDIFF(
            MONTH, 
            u.date_joined, 
            (SELECT MAX(transaction_date) FROM savings_savingsaccount)
        ) AS tenure_months,
        
        -- Count total number of transactions per customer
        COUNT(s.id) AS total_transactions,
        
        -- Calculate average profit per transaction assuming profit is 0.1% (0.001) of transaction value
        -- Use NULLIF to avoid division by zero if no transactions exist
        ((SUM(s.confirmed_amount) / NULLIF(COUNT(s.id), 0)) * 0.001) AS avg_profit_per_transaction
    FROM 
        users_customuser u
        LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
    GROUP BY 
        u.id
)
SELECT
    customer_id,
    name,
    tenure_months,
    total_transactions,
    
    -- Estimate Customer Lifetime Value (CLV)
    -- CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
    -- This annualizes transaction frequency and multiplies by average profit per transaction
    ROUND(
        ((total_transactions / tenure_months) * 12 * avg_profit_per_transaction), 
        2
    ) AS estimated_clv
FROM 
    transaction_table
ORDER BY 
    estimated_clv DESC;