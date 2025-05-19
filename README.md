# DataAnalytics-Assessment
---

This project analyzes customer and transaction data to support business teams. It covers identifying high-value customers, segmenting by transaction frequency, flagging inactive accounts, and estimating customer lifetime value (CLV). Each task is addressed in its file `Assessment_Q1.sql`, `Assessment_Q2.sql`, `Assessment_Q3.sql`, and `Assessment_Q4.sql`. Each analysis helps improve marketing, finance, and operations decisions. 

## Q1. High-Value Customers with Multiple Products
---

Approach:
To identify customers who hold both savings and investment plans, I joined the plans_plan table with the users_customuser table to get customer details. Then, I used conditional aggregation to count the number of savings plans (is_regular_savings = 1) and investment plans (is_a_fund = 1) per customer. I filtered customers who have at least one of each plan type using the HAVING clause. Finally, I summed all deposits per customer and sorted the results by total deposits to highlight high-value customers.

## Q2. Transaction Frequency Analysis
---

Approach:
I first calculated the number of transactions each customer made every month using the savings_savingsaccount table. Then, I averaged these monthly transaction counts per customer to get their average transaction frequency. Based on the average, I categorized customers into "High", "Medium", or "Low" frequency groups using a CASE statement. Lastly, I aggregated counts and average transactions by these categories to summarize customer behavior for segmentation.

## Q3. Account Inactivity Alert
---

Approach:
To flag inactive accounts, I joined plans_plan with transaction data from savings_savingsaccount by plan ID. For each plan, I determined the most recent transaction date and compared it to the system-wide latest transaction date to compute inactivity days. I filtered accounts that had no transactions for over 365 days (1 year) and included only active savings or investment accounts. The results were ordered by inactivity duration to prioritize the oldest inactive accounts.

## Q4. Customer Lifetime Value (CLV) Estimation
---

Approach:
I started by calculating each customer’s account tenure in months from their signup date to the latest transaction date. Then, I counted their total transactions and computed the average profit per transaction, assuming profit is 0.1% of the transaction value. Using these metrics, I estimated CLV by annualizing transaction frequency (transactions per month multiplied by 12) and multiplying by the average profit. The results were sorted in descendingly order to prioritize customers with the highest estimated CLV.

## Tasks Challenges
---

The first challenge was resisting the temptation to extend the analysis beyond the given instructions. For example, I considered converting amounts from Kobo to Naira, but did not do so since it wasn’t specified. Another difficult decision was how to calculate customer tenure and inactivity periods — whether to use the current date or the latest transaction date in the dataset. I chose to use the dataset’s maximum transaction date because the data was not up to date.
