# OpenOps AWS FX Inefficiency Detector

Detects foreign exchange (FX) inefficiencies in AWS billing using live FX rates and actual INR payment logs.

---

## What It Does

- Pulls **last month’s AWS bill (USD)** via AWS CLI
- Fetches the **live USD→INR FX rate** from exchangerate.host
- Retrieves **actual INR paid** from your internal table
- Calculates **expected INR**, compares it to actual
- Logs the result with a status: `Flagged` or `OK`

---

## File

- `openops-aws-fx-inefficiency-v1.json`  
  → Import this into [OpenOps](https://openops.dev) as a new workflow

---

## Workflow Logic

| Step | Action                                      |
|------|---------------------------------------------|
| 1    | Trigger (daily, at 2AM UTC)                 |
| 2    | Get AWS billing data via CLI (USD)          |
| 3    | Fetch FX rate (USD to INR) via API          |
| 4    | Multiply: USD × FX rate = Expected INR      |
| 5    | Lookup: actual INR paid from table          |
| 6    | Subtract: Actual - Expected                 |
| 7    | Divide: Difference ÷ Expected               |
| 8    | Multiply: Ratio × 100 = FX Loss %           |
| 9    | Save result to `FXInefficiencies` table     |
| 10   | End workflow cleanly                        |

---

## Setup Requirements

- AWS billing enabled + `Cost Explorer` turned on
- Connect your AWS account in OpenOps
- Create two tables in OpenOps:
  - `FxPaymentLog`: must have fields `BillingMonth` (text), `AmountPaidINR` (number)
  - `FXInefficiencies`: will be auto-populated; should have 6 fields:
    - `AWS_USD_Billed`, `FX_Rate_Used`, `ExpectedINR`, `ActualINR`, `FX_Loss_Percent`, `Status`

---

## Live FX Rate Source

This workflow uses [https://exchangerate.host](https://exchangerate.host), a free and no-auth API.

If your network redirects to apilayer or requires a key, change the URL to:

