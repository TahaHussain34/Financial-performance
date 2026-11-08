# Data Quality Report

Generated: 2026-11-06 15:26

## 1. Findings

| # | Table | Check | Severity | Rows | Detail | Action |
|---|---|---|---|---|---|---|
| 1 | Transactions | Exact duplicate rows | REJECTED | 9 | Transaction_ID DUP001 repeated; first copy kept | Duplicates rejected, first occurrence kept |
| 2 | Transactions | Missing Project_ID | REJECTED | 1 | NULL01 | Row rejected (cannot be attributed to a project) |
| 3 | Transactions | Project_ID not in Projects (orphan) | REJECTED | 5 | P999 -> INVP0, INVP1, INVP2, INVP3, INVP4 | Row rejected |
| 4 | Transactions | Misspelled Category | CORRECTED | 5 | Travell->Travel, Materiels->Materials, Labr->Labor, Contrct->Contract, Srvces->Services (BAD0, BAD1, BAD2, BAD3, BAD4) | Mapped to standard value. 'Contrct' assumed to be 'Contract' (new category) - confirm with business |
| 5 | Transactions | Negative Amount | WARNING | 1 | NEG01 (P010, -5,000) | Loaded as a credit/reversal - confirm with finance |
| 6 | Transactions | Non-standard Transaction_ID format (expected T####) | WARNING | 11 | TA001, TA002, TA003, TA004, DUP001, BAD0, BAD1, BAD2, BAD3, BAD4, NEG01 | Loaded - look like test/injected records, review at source |

Severity: **REJECTED** = not loaded (see rejected_rows.csv), **CORRECTED** = fixed by rule and loaded, **WARNING** = loaded unchanged, needs review.

## 2. Row reconciliation (source = loaded + rejected)

| Table | Source rows | Rejected | Loaded | In database | Check |
|---|---|---|---|---|---|
| Projects | 50 | 0 | 50 | 50 | OK |
| Transactions | 516 | 15 | 501 | 501 | OK |
| Forecasts | 150 | 0 | 150 | 150 | OK |
