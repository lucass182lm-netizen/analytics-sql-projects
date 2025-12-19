/*
Project: Monthly Data Consolidation
Description: SQL project demonstrating consolidation of CRM, billing and payment data.
Granularity: Consumer Unit + Month

Privacy note:
- All table and column names were anonymized
- Personal, sensitive and identifiable data were removed
- Identifiers are represented as hashed surrogate keys
*/


WITH
uc_fonte_verdade AS (
  SELECT
    consumer_unit,
    account_id,
    contract_id,
    payment_start_date,
    contract,
    reference_consumption_kwh,
    distributor AS distributor_crm,
    product_type,
    status_code,
    state,
    -- removido: cpf/cnpj/rg/nascimento/endereco/credenciais/links
    start_date,
    priced_discount,
    contract_termination_date,
    cancellation_date,
    end_date,
    fidelity_months,
    fidelity_years,
    invoice_aut_validation,
    invoice_type
  FROM dw.crm_consumer_units
  WHERE product_type IN ('GD', 'Desconto garantido')
),

crm_contas AS (
  SELECT
    account_id,
    consumer_unit,
    reference_consumption_kwh,
    distributor_crm,
    contract,
    payment_start_date,
    status_code,
    start_date,
    priced_discount,
    contract_termination_date,
    cancellation_date,
    end_date,
    fidelity_months,
    fidelity_years,
    invoice_aut_validation,
    invoice_type
  FROM uc_fonte_verdade
),

conta_agregados AS (
  SELECT
    account_id,
    COUNT(*) AS total_ucs,
    SUM(reference_consumption_kwh) AS consumo_total
  FROM crm_contas
  WHERE account_id IS NOT NULL
  GROUP BY account_id
),

ucs_validas AS (
  SELECT DISTINCT consumer_unit
  FROM uc_fonte_verdade
),

pagamento_mes AS (
  SELECT
    p.consumer_unit,
    p.status AS payment_status,
    TO_DATE(p.reference_date, 'DD/MM/YYYY') AS ref_date,
    DATE_TRUNC('MONTH', TO_DATE(p.reference_date, 'DD/MM/YYYY')) AS ref_month,
    p.amount AS payment_amount,
    p.paid_at
  FROM dw.payments_last_status p
  INNER JOIN ucs_validas u ON p.consumer_unit = u.consumer_unit
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY p.consumer_unit, DATE_TRUNC('MONTH', TO_DATE(p.reference_date, 'DD/MM/YYYY'))
    ORDER BY
      CASE WHEN p.paid_at IS NOT NULL THEN 0 ELSE 1 END,
      TO_DATE(p.reference_date, 'DD/MM/YYYY') DESC NULLS LAST
  ) = 1
),

fatura_mes AS (
  SELECT
    f.consumer_unit,
    f.status AS invoice_status,
    TO_DATE(f.reference_date, 'DD/MM/YYYY') AS ref_date,
    DATE_TRUNC('MONTH', TO_DATE(f.reference_date, 'DD/MM/YYYY')) AS ref_month,
    f.billed_energy_kwh,
    f.total_amount,
    f.due_date
  FROM dw.invoices_last_status f
  INNER JOIN ucs_validas u ON f.consumer_unit = u.consumer_unit
),

consolidado AS (
  SELECT
    c.consumer_unit,
    c.account_id,
    COALESCE(p.ref_month, f.ref_month) AS ref_month,
    c.reference_consumption_kwh,
    c.distributor_crm,
    c.invoice_type,
    p.payment_status,
    p.payment_amount,
    p.paid_at,
    f.invoice_status,
    f.billed_energy_kwh,
    f.total_amount,
    f.due_date
  FROM crm_contas c
  LEFT JOIN pagamento_mes p ON c.consumer_unit = p.consumer_unit
  LEFT JOIN fatura_mes f ON c.consumer_unit = f.consumer_unit
    AND (p.ref_month IS NULL OR p.ref_month = f.ref_month)
  WHERE p.consumer_unit IS NOT NULL OR f.consumer_unit IS NOT NULL
)

SELECT
  -- chaves anonimizadas
  SHA2(TO_VARCHAR(a.account_id), 256) AS account_sk,
  SHA2(TO_VARCHAR(x.consumer_unit), 256) AS consumer_unit_sk,

  a.total_ucs,
  a.consumo_total,

  x.ref_month,
  x.invoice_type,
  x.reference_consumption_kwh,
  x.distributor_crm,

  COALESCE(x.payment_status, 'no_payment_data') AS payment_status,
  x.payment_amount,
  x.paid_at,

  COALESCE(x.invoice_status, 'no_invoice_data') AS invoice_status,
  x.billed_energy_kwh,
  x.total_amount,
  x.due_date,

  CASE
    WHEN a.consumo_total >= 90000 OR a.total_ucs >= 30 THEN 'Tier 1'
    WHEN a.consumo_total >= 20000 OR a.total_ucs >= 15 THEN 'Tier 2'
    WHEN a.consumo_total >= 12500 OR a.total_ucs >= 10 THEN 'Tier 3'
    WHEN a.consumo_total >= 7000  OR a.total_ucs >= 5  THEN 'Tier 4'
    ELSE 'Tier 5'
  END AS account_tier

FROM consolidado x
LEFT JOIN conta_agregados a ON x.account_id = a.account_id
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY x.consumer_unit, x.ref_month
  ORDER BY x.ref_month DESC NULLS LAST
) = 1
ORDER BY ref_month DESC;
