# Analytics SQL Projects

This repository contains SQL projects focused on analytical data modeling, business logic centralization and creation of shared analytical foundations for multiple teams.

The projects presented here demonstrate how SQL can be used not only for querying data, but for building scalable, reusable and governance-oriented analytical layers.

---

## Project: Unified Operational Analytics

### Overview
This project provides a **unified operational analytics base** that consolidates CRM, billing and payment data into a single monthly analytical dataset.

It was designed to serve as a **single source of truth** shared across Customer Experience (CX), Customer Success (CS) and Backoffice teams.

### Business Context
Prior to this consolidation, each operational area relied on separate data views and calculations, leading to duplicated logic and inconsistent metrics.

This project established a unified analytical foundation, enabling different teams to work from the same dataset while maintaining consistent definitions and metrics.

### Objective
- Unify multiple operational data sources into a single dataset
- Centralize business rules at the data layer
- Provide a reusable analytical base for multiple teams
- Reduce metric inconsistencies across BI tools

### Data Granularity
- Consumer Unit + Month  
- One record per unit per reference month

### Key Techniques Used
- Layered SQL modeling using CTEs
- Window functions for monthly deduplication
- Temporal alignment using `DATE_TRUNC`
- Business rule implementation with `CASE` logic
- Surrogate keys generated via hashing

### Analytics Consumption
The unified dataset is designed to be consumed by **multiple BI and reporting tools**.

By centralizing logic and definitions at the data layer, this project enables:
- Consistent metrics across dashboards
- Reuse of the same dataset by different teams
- Reduced duplication of logic in BI tools
- Faster development of analytical reports

CX, CS and Backoffice teams operate on a shared analytical foundation, regardless of the visualization layer.

---

## Project: Monthly Churn Analytics

### Overview
This project builds a **monthly churn analytics dataset** based on CRM lifecycle dates, including contract start and cancellation information.

It provides a standardized churn definition used consistently across operational and executive reporting.

### Objective
- Create a reliable monthly churn dataset
- Define churn using contract lifecycle logic
- Enable churn analysis by multiple dimensions
- Support both operational and executive decision-making

### Data Granularity
- Account + Month  
- One record per account per reference month

### Key Techniques Used
- Date spine to ensure complete monthly coverage
- Window functions for account-level deduplication
- Monthly churn rate calculation
- Year-to-date (YTD) churn aggregation
- Dimensional slicing by cancellation attributes

### Executive and BI Consumption
This churn dataset is designed to be consumed by **multiple BI and reporting tools**, serving both operational and executive-level analytics.

It is primarily used to monitor **churn-related OKRs and strategic performance indicators**, supporting management and leadership teams with a consistent and reliable view of customer retention.

By centralizing churn definitions and calculations at the data layer, the project ensures:
- Consistent churn metrics across dashboards
- Alignment between operational teams and leadership
- Reliable inputs for OKR tracking and executive reporting
- Reduced risk of metric discrepancies across BI tools

---

## Privacy and Anonymization
- All table and schema names were anonymized for portfolio purposes
- Personal, sensitive and identifiable data were removed
- Identifiers are represented as hashed surrogate keys
- No real customer or company data is exposed

---

## Technologies and Concepts
- SQL (analytical dialect)
- Common Table Expressions (CTEs)
- Window functions
- Date spine generation
- Analytical data modeling
- Business logic centralization
- BI-oriented data design

---

## 🇧🇷 Resumo em Português

Este repositório reúne projetos SQL voltados à modelagem analítica e à centralização de regras de negócio na camada de dados.

### Base Analítica Operacional Unificada
O projeto **Unified Operational Analytics** cria uma base analítica mensal unificada utilizada por CX, CS e Backoffice como fonte única da verdade.

A solução centraliza regras de negócio, padroniza métricas e permite que múltiplas ferramentas de BI utilizem a mesma base, reduzindo inconsistências e retrabalho.

### Churn Mensal
O projeto **Monthly Churn Analytics** cria uma base mensal de churn com base no ciclo de vida dos contratos no CRM.

Essa base é utilizada tanto para análises operacionais quanto para acompanhamento de **OKRs e indicadores estratégicos**, oferecendo à gerência e à diretoria uma visão consistente sobre retenção de clientes.

Ambos os projetos foram desenhados para suportar múltiplas ferramentas de BI, mantendo governança, consistência e escalabilidade analítica.
