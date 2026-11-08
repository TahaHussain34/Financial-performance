
-- Q1. Total cost per project
-- LEFT JOIN keeps projects with no spend (shown as 0) instead of dropping them.

SELECT
    p.project_id,
    p.project_name,
    COALESCE(SUM(t.amount), 0) AS total_cost
FROM projects p
LEFT JOIN transactions t
       ON t.project_id = p.project_id
GROUP BY p.project_id, p.project_name
ORDER BY total_cost DESC;


-- -----------------------------------------------------------------------------
-- Q2. Second highest spending project (CTEs)


WITH project_costs AS (          -- step 1: in-scope projects with total spend
    SELECT
        p.project_id,
        p.project_name,
        SUM(t.amount) AS total_cost
    FROM projects p
    JOIN transactions t
      ON t.project_id = p.project_id
    GROUP BY p.project_id, p.project_name
),
ranked_costs AS (                -- step 2: rank by spend, highest = 1
    SELECT
        project_id,
        project_name,
        total_cost,
        DENSE_RANK() OVER (ORDER BY total_cost DESC) AS spend_rank
    FROM project_costs
)
SELECT                           -- step 3: keep rank 2
    project_id,
    project_name,
    total_cost,
    spend_rank
FROM ranked_costs
WHERE spend_rank = 2;


-- -----------------------------------------------------------------------------
-- Q3. Projects exceeding budget
-- Compares total spend with budget; shows the overrun in value and percent.



SELECT
    p.project_id,
    p.project_name,
    p.budget,
    SUM(t.amount)                                       AS total_cost,
    SUM(t.amount) - p.budget                            AS over_budget_amount,
    ROUND(100.0 * (SUM(t.amount) - p.budget) / p.budget, 1) AS over_budget_pct
FROM projects p
JOIN transactions t
  ON t.project_id = p.project_id
GROUP BY p.project_id, p.project_name, p.budget
HAVING SUM(t.amount) > p.budget
ORDER BY over_budget_amount DESC;
