# Analytics SQL Projects

This repository contains SQL projects focused on analytical data modeling, consolidation and business logic implementation.

## Project: Monthly Data Consolidation

### Overview
This project demonstrates the consolidation of CRM, billing and payment data into a single analytical dataset, designed for reporting and business analysis.

### Objective
- Integrate multiple operational data sources using SQL
- Create a monthly consolidated dataset
- Handle data duplication and inconsistent records
- Apply business rules for analytical consumption

### Data Granularity
- Consumer Unit + Month
- One record per consumer unit per reference month

### Key Techniques Used
- Common Table Expressions (CTEs)
- Window functions (`ROW_NUMBER`) for deduplication
- Monthly data alignment using `DATE_TRUNC`
- Business rule application with `CASE` statements
- Surrogate keys generated via hashing

### Output
The final dataset provides:
- Consolidated payment and invoice status
- Energy and financial metrics
- Account-level aggregated metrics
- Account tier classification based on consumption and volume

### Privacy and Anonymization
- All table and column names were anonymized
- Personal and sensitive data were removed
- Identifiers are represented as hashed surrogate keys
- No real customer or company data is exposed

### Technologies
- SQL (analytical dialect)
- Data warehouse-oriented modeling

---

---

## 🇧🇷 Versão em Português (Resumo)

### Visão Geral
Este projeto demonstra a consolidação de dados de CRM, faturamento e pagamentos em um único dataset analítico mensal, utilizando SQL.

### Objetivo
- Unificar múltiplas fontes operacionais
- Tratar registros duplicados por período
- Criar uma base pronta para análise e BI
- Aplicar regras de negócio diretamente em SQL

### Granularidade dos Dados
- Unidade consumidora + mês
- Uma linha por unidade e período de referência

### Boas Práticas Aplicadas
- Uso de CTEs para organização e legibilidade
- Deduplicação com funções de janela (`ROW_NUMBER`)
- Alinhamento temporal por mês de referência
- Preocupação com governança e privacidade dos dados

### Observações de Privacidade
Todos os dados sensíveis foram removidos ou anonimizados.  
Este repositório não contém informações reais de clientes ou empresas.
