/*
Project: Monthly Churn Analytics
Description: Creates a monthly churn dataset using a date spine and CRM lifecycle dates.
Granularity: Account + Month (+ churn dimensions)

Privacy note:
- Table/schema names were anonymized for portfolio purposes
- No customer-identifiable data is included
*/

CREATE OR REPLACE VIEW prd_dw.analytics.churn_monthly AS
WITH date_spine AS (
  SELECT DATEADD(
           MONTH,
           SEQ4(),
           DATE_TRUNC('MONTH', TO_DATE('2024-10-01'))
         ) AS month_start
  FROM TABLE(GENERATOR(ROWCOUNT => 1200))
),

months AS (
  SELECT month_start
  FROM date_spine
  WHERE month_start <= DATE_TRUNC('MONTH', CURRENT_DATE + INTERVAL '1 month')
),

crm AS (
  SELECT
      uc.account AS account_id,

      DATE_TRUNC('MONTH', TO_DATE(opt.close_date) - INTERVAL '3 hour') AS start_month,
      DATE_TRUNC('MONTH', TO_DATE(ct.rescision_contract_date) - INTERVAL '3 hour') AS churn_month,

      uc.responsible_for_cancellation,
      uc.cancellation_type,
      uc.previous_announcement,
      uc.penalty,
      uc.reason_for_cancellation,
      uc.reference_consumption_kwh,
      uc.distributor,
      uc.subreason_for_cancellation

  FROM prd_dw.crm_refined.consumer_units uc
  LEFT JOIN prd_dw.crm_refined.opportunities opt
         ON uc.opportunity_id = opt.opportunity_id
  LEFT JOIN prd_dw.crm_refined.contracts ct
         ON uc.contract_id = ct.contract_id
  LEFT JOIN prd_dw.crm_refined.accounts ac
         ON uc.account_id = ac.account_id

  WHERE ac.relation_type = 'Client'

  QUALIFY ROW_NUMBER() OVER (
            PARTITION BY uc.account
            ORDER BY opt.close_date ASC NULLS LAST, ct.start_date DESC NULLS LAST
          ) = 1
),

base AS (
  SELECT
    m.month_start,
    c.account_id,
    c.responsible_for_cancellation,
    c.cancellation_type,
    c.previous_announcement,
    c.penalty,
    c.reason_for_cancellation,
    c.reference_consumption_kwh,
    c.distributor,
    c.subreason_for_cancellation,

    COUNT(CASE
      WHEN c.start_month < m.month_start
       AND (c.churn_month IS NULL OR c.churn_month >= m.month_start)
      THEN c.account_id END
    ) AS active_accounts_start_month,

    COUNT(CASE
      WHEN c.churn_month = m.month_start
       AND (c.subreason_for_cancellation NOT ILIKE '%new contract%'
            OR c.subreason_for_cancellation IS NULL)
      THEN c.account_id END
    ) AS cancellations

  FROM months m
  CROSS JOIN crm c
  GROUP BY
    m.month_start,
    c.account_id,
    c.responsible_for_cancellation,
    c.cancellation_type,
    c.previous_announcement,
    c.penalty,
    c.reason_for_cancellation,
    c.reference_consumption_kwh,
    c.distributor,
    c.subreason_for_cancellation
),

final AS (
  SELECT
    month_start,
    account_id,
    responsible_for_cancellation,
    cancellation_type,
    previous_announcement,
    penalty,
    reason_for_cancellation,
    reference_consumption_kwh,
    distributor,
    subreason_for_cancellation,

    active_accounts_start_month,

    LAG(active_accounts_start_month, 1) OVER (
      PARTITION BY account_id,
                   responsible_for_cancellation,
                   cancellation_type,
                   previous_announcement,
                   penalty,
                   reason_for_cancellation,
                   reference_consumption_kwh,
                   distributor,
                   subreason_for_cancellation
      ORDER BY month_start
    ) AS active_accounts_prev_month,

    cancellations,

    LAG(cancellations, 1) OVER (
      PARTITION BY account_id,
                   responsible_for_cancellation,
                   cancellation_type,
                   previous_announcement,
                   penalty,
                   reason_for_cancellation,
                   reference_consumption_kwh,
                   distributor,
                   subreason_for_cancellation
      ORDER BY month_start
    ) AS cancellations_prev_month,

    ROUND(cancellations / NULLIF(active_accounts_start_month, 0), 4) AS churn_rate,

    SUM(cancellations) OVER (
      PARTITION BY account_id,
                   responsible_for_cancellation,
                   cancellation_type,
                   previous_announcement,
                   penalty,
                   reason_for_cancellation,
                   reference_consumption_kwh,
                   distributor,
                   subreason_for_cancellation,
                   YEAR(month_start)
      ORDER BY month_start
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cancellations_ytd,

    ROUND(
      SUM(cancellations) OVER (
        PARTITION BY account_id,
                     responsible_for_cancellation,
                     cancellation_type,
                     previous_announcement,
                     penalty,
                     reason_for_cancellation,
                     reference_consumption_kwh,
                     distributor,
                     subreason_for_cancellation,
                     YEAR(month_start)
        ORDER BY month_start
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
      ) / NULLIF(active_accounts_start_month, 0),
      4
    ) AS churn_rate_ytd

  FROM base
)

SELECT *
FROM final;
