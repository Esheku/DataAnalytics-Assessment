SELECT 
    p.id AS plan_id,                          
    p.owner_id,   
    -- Identify the type of plan: 'investment' if it's a fund, 'savings' if it's a savings account
    CASE
        WHEN p.is_a_fund = 1 THEN 'investment'
        WHEN p.is_regular_savings = 1 THEN 'savings'
    END AS type,
    -- Get the most recent transaction date for the plan
    MAX(DATE(s.transaction_date)) AS last_transaction_date,
    -- Calculate days of inactivity by comparing the plan's last transaction to the latest transaction date in the entire system
    DATEDIFF(
        (SELECT MAX(transaction_date) FROM savings_savingsaccount), 
        MAX(s.transaction_date)
    ) AS inactivity_days
FROM plans_plan p
-- Join the savings transactions to the plans by plan ID
LEFT JOIN savings_savingsaccount s ON p.id = s.plan_id
-- Filter to include only active savings or investment accounts
WHERE p.is_a_fund = 1 OR p.is_regular_savings = 1
-- Group by each plan to compute aggregated values per plan
GROUP BY p.id, p.owner_id, type 
-- Keep only those plans with inactivity greater than 365 days
HAVING inactivity_days > 365
-- Show most inactive plans first
ORDER BY inactivity_days DESC;