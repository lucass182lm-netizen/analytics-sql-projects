# Analytics SQL Projects

This repository contains SQL projects focused on analytical data modeling, consolidation and business logic implementation.

## Project: Unified Operational Analytics

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


### Business Context
This project was designed as a shared analytical foundation for multiple operational teams, including Customer Experience (CX), Customer Success (CS) and Backoffice operations.

Prior to this consolidation, each team relied on separate data views, leading to duplicated logic, inconsistent metrics and operational inefficiencies.  
The project established a unified, monthly analytical dataset that serves as a single source of truth across teams.

This initiative marked an important milestone by enabling:
- Consistent reporting across operational areas
- Reduced manual data reconciliation
- Improved visibility of billing and payment statuses
- Faster decision-making for customer-facing teams

### Analytics Consumption
The unified dataset produced by this project is designed to be consumed by multiple BI and reporting tools.

By centralizing business logic and definitions at the data layer, the project enables:
- Consistent metrics across dashboards
- Reuse of the same dataset by different teams
- Reduced duplication of logic in BI tools
- Faster development of analytical reports

This approach ensures that CX, CS and Backoffice teams operate on a shared analytical foundation, regardless of the visualization layer.



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

### Contexto de Negócio
Este projeto foi desenvolvido como uma base analítica compartilhada para múltiplas áreas operacionais, incluindo Customer Experience (CX), Customer Success (CS) e Backoffice.

Antes da consolidação, cada área utilizava visões distintas dos dados, o que gerava inconsistências, retrabalho e dificuldades na tomada de decisão.  
A solução criou uma fonte única da verdade, com dados consolidados mensalmente, utilizada de forma transversal pelas equipes.

Este projeto representou um marco ao:
- Padronizar métricas entre áreas
- Reduzir reconciliações manuais de dados
- Melhorar a visibilidade de faturamento e pagamentos
- Apoiar decisões mais rápidas em times orientados ao cliente

### Consumo Analítico (BI)
A base analítica gerada por este projeto foi desenvolvida para ser consumida por múltiplas ferramentas de BI e relatórios.

Ao centralizar regras de negócio e definições na camada de dados, a solução permite:
- Métricas consistentes entre dashboards
- Reutilização da mesma base por diferentes áreas
- Redução de lógica duplicada em ferramentas de BI
- Agilidade no desenvolvimento de análises

Dessa forma, CX, CS e Backoffice utilizam a mesma base analítica, independentemente da ferramenta de visualização.


