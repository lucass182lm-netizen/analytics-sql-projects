/*
Project: Billing Onboarding Monitoring
Description: Monitors billing onboarding progress by joining CRM units, contracts, accounts and latest invoice status.
Granularity: Consumer Unit (anonymized) + latest billing status

Privacy note:
- Identifiable data (names, documents, addresses, credentials) was removed
- Surrogate keys are derived via hashing
*/

WITH base_units AS (
  SELECT
    -- anonymized keys
    SHA2(TO_VARCHAR(consumer_units.consumer_unit), 256) AS consumer_unit_sk,
    SHA2(TO_VARCHAR(consumer_units.account_id), 256) AS account_sk,
    SHA2(TO_VARCHAR(consumer_units.contract_id), 256) AS contract_sk,

    -- operational fields (non-identifying)
    consumer_units.distributor,
    consumer_units.reference_consumption_kwh,
    DATE_TRUNC('MONTH', DATE(consumer_units.payment_start_date)) AS onboarding_month

  FROM prd_dw.crm_refined.consumer_units AS consumer_units
  WHERE 1=1
    -- Optional filters for operational monitoring:
    -- AND consumer_units.distributor = '<DISTRIBUTOR>'
    -- AND DATE(consumer_units.payment_start_date) = '<ONBOARDING_DATE>'
),

latest_invoice AS (
  SELECT
    SHA2(TO_VARCHAR(inv.unidade_consumidora), 256) AS consumer_unit_sk,
    inv.status AS invoice_status,
    inv.data_emissao_serena AS invoice_issued_at,
    inv.data_vencimento AS invoice_due_at,
    inv.desconto AS discount
  FROM prd_dw.billing.invoices_last_status AS inv
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY inv.unidade_consumidora
    ORDER BY inv.data_emissao_serena DESC NULLS LAST
  ) = 1
),

contracts AS (
  SELECT
    SHA2(TO_VARCHAR(contract_id), 256) AS contract_sk,
    benefit,
    contract_term
  FROM prd_dw.crm_refined.contracts
),

final AS (
  SELECT
    base_units.consumer_unit_sk,
    base_units.account_sk,
    base_units.distributor,
    base_units.reference_consumption_kwh,
    base_units.onboarding_month,
    contracts.benefit,
    contracts.contract_term,
    latest_invoice.invoice_status,
    latest_invoice.invoice_issued_at,
    latest_invoice.invoice_due_at,
    latest_invoice.discount,

    CASE
      WHEN latest_invoice.invoice_status IS NULL THEN 'not_billing_started'
      WHEN latest_invoice.invoice_issued_at IS NOT NULL THEN 'billing_issued'
      ELSE 'billing_in_progress'
    END AS onboarding_billing_stage

  FROM base_units
  LEFT JOIN contracts
    ON base_units.contract_sk = contracts.contract_sk
  LEFT JOIN latest_invoice
    ON base_units.consumer_unit_sk = latest_invoice.consumer_unit_sk
)

SELECT *
FROM final
ORDER BY onboarding_month DESC;
