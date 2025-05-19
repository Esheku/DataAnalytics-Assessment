SELECT 
    p.owner_id,
        -- Combine first and last names into a single 'name' field
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    -- Count of regular savings plans
    SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END) AS savings_count,
    -- Count of fixed investment plans
    SUM(CASE WHEN p.is_a_fund = 1 THEN 1 ELSE 0 END) AS investment_count,
    -- Total 'amount' formatted to 2 decimal places
    FORMAT(SUM(p.amount), 2) AS total_deposits
FROM 
    plans_plan p
-- Join user details to get first and last names
LEFT JOIN 
    users_customuser u ON p.owner_id = u.id
GROUP BY 
    p.owner_id
-- Only include users who have both a savings and investment plan
HAVING 
    savings_count > 0 AND investment_count > 0
-- Sort by highest total deposits
ORDER BY 
    SUM(p.amount) DESC;

