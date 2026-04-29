# Hong Kong LSP Calculator — Step-by-Step User Guide

> **Tool:** Hong Kong Long Service Payment (LSP) Calculator  
> **Version:** Current (supports MPF offsetting abolition effective 1 May 2025)  
> **Language:** Available in English and Traditional Chinese (繁中)

---

## Table of Contents

1. [What This Tool Does](#1-what-this-tool-does)
2. [Before You Start — What You Need](#2-before-you-start--what-you-need)
3. [Step 1 — Launch the Application](#step-1--launch-the-application)
4. [Step 2 — Choose Language](#step-2--choose-language)
5. [Step 3 — Set Calculation Parameters (Sidebar)](#step-3--set-calculation-parameters-sidebar)
6. [Step 4 — Choose Accounting Standard](#step-4--choose-accounting-standard)
7. [Step 5 — Enter Employee Data](#step-5--enter-employee-data)
8. [Step 6 — Run the Calculation](#step-6--run-the-calculation)
9. [Step 7 — Read the Results Summary](#step-7--read-the-results-summary)
10. [Step 8 — Review the Audit Proof](#step-8--review-the-audit-proof)
11. [Step 9 — Download the Excel Working Paper](#step-9--download-the-excel-working-paper)
12. [Understanding the Output Columns](#understanding-the-output-columns)
13. [How the Key Formulas Work](#how-the-key-formulas-work)
14. [Limitations & Important Notes](#limitations--important-notes)
15. [Frequently Asked Questions](#frequently-asked-questions)
16. [Official Reference Links](#official-reference-links)

---

## 1. What This Tool Does

This browser-based calculator computes the **Long Service Payment (LSP)** liability for Hong Kong employers under the **Employment Ordinance (Cap. 57)**. It specifically handles the post-abolition MPF offsetting rules effective **1 May 2025**, the **government subsidy scheme** (25-year ladder), and produces audit-grade working papers.

**Supported accounting treatments:**
| Standard | Discounting | Salary Projection | Turnover Attrition |
|---|---|---|---|
| SME-FRS | ❌ No (PV = 1) | ❌ No (current salary used) | ❌ No (100% retention assumed) |
| HKFRS / HKFRS for PE | ✅ Yes (PV factor) | ✅ Yes (growth rate to age 65) | ✅ Yes (prob. of staying) |

---

## 2. Before You Start — What You Need

### Required Data for Each Employee

| Data Field | Description | Notes |
|---|---|---|
| **Name** | Employee name or staff ID | For identification only |
| **Hired Date** | Employment commencement date | Format: `YYYY-MM-DD` |
| **DOB** | Date of birth | Format: `YYYY-MM-DD` — used to calculate age 65 retirement |
| **Salary at Transition** | Monthly salary as at 30 April 2025 | Used for pre-transition LSP calculation |
| **Current Salary** | Monthly salary at valuation date | Used for post-transition LSP calculation |
| **MPF Mand (ER)** | Total accrued benefit at valuation date for **all employer mandatory contributions** (HKD) | Includes both pre- and post-1 May 2025 mandatory contributions, because the full mandatory balance can offset **pre-transition** LSP; if blank/zero, the tool **estimates** it to valuation date — see Limitation #1 |
| **MPF Vol (ER)** | Cumulative voluntary MPF contributions by employer (HKD) | Optional; leave blank or 0 if none |

> ⚠️ **Data accuracy is critical.** Hire dates, salaries, and MPF balances should be verified against source documents (HR records, MPF trustee statements) before producing final accounts.

### Actuarial Assumptions You Should Decide in Advance

| Parameter | Typical Reference | SME-FRS | HKFRS |
|---|---|---|---|
| **Salary Growth Rate (g)** | Long-term inflation ~2–3% p.a. | Forced to 0% | User-defined |
| **MPF Return Rate (m)** | MPFA DIS Core Fund ~4–5% p.a. | Used for MPF estimation only | Used for MPF estimation only |
| **Discount Rate (r)** | HKMA EFBN 10-year yield (auto-fetched) | Not used | Required |
| **Annual Turnover Rate (t)** | Company-specific; ~5% typical | Not used | Affects retention probability |

---

## Step 1 — Launch the Application

### Option A: Run Locally (Python)

```cmd
pip install -r requirements.txt
streamlit run app.py
```

Then open your browser at: **http://localhost:8501**

### Option B: Run with Docker

```cmd
docker build -t lsp-calculator:1.0 .
docker run -p 8501:8501 lsp-calculator:1.0
```

Then open your browser at: **http://localhost:8501**

### Option C: Run on Synology NAS

1. Copy this project folder to your NAS shared folder (e.g. `/volume1/docker/lsp-calculator`)
2. Open **Container Manager** → **Project** → **Create**
3. Point to the folder containing `docker-compose.synology.yml`
4. Start the project
5. Access from any LAN device: `http://<NAS-IP>:8501`

> 💡 **Cross-check tip:** To compare results with the official LD EasyCal tool, set Salary Growth Rate and Discount Rate both to **0%**.

---

## Step 2 — Choose Language

In the **left sidebar**, at the very top, select your preferred language:

- **EN** — English interface
- **繁中** — Traditional Chinese interface

All labels, audit notes, and downloaded Excel working papers will reflect your chosen language.

---

## Step 3 — Set Calculation Parameters (Sidebar)

All parameters are in the **left sidebar** under "Calculation Parameters":

### 3.1 Valuation Date
- Default: **31 March 2026**
- Set this to your reporting period end date (e.g. `2026-03-31` for FY ending 31 March 2026)
- The sidebar will display the current **Policy Year** of the Government Subsidy Scheme automatically (e.g. "Policy Year: 1 (Post-Abolition)")
- ⚠️ If set before **1 May 2025**, a warning is shown — no government subsidy will apply

### 3.2 Salary Growth Rate (g) — slider 0%–7%
- Only affects HKFRS calculations
- SME-FRS ignores this and forces 0%
- **Recommended reference:** Long-term HK inflation rate (~2–3% p.a.)

### 3.3 MPF Return Rate (m) — slider 0%–7%
- Used **only** when MPF mandatory balance is not provided (triggering the estimation model)
- **Recommended reference:** MPFA DIS Core Accumulation Fund historical return (~4–5% p.a.)
- Default: **2.6%**

### 3.4 Discount Rate (r) — number input 0%–10%
- Only affects HKFRS calculations
- **Auto-fetched** from the HKMA API (10-year EFBN yield) on launch — requires internet access
- If the live rate cannot be fetched, the tool falls back to **3.5%**
- Per HKAS 19, this rate must be reviewed at each reporting date

### 3.5 Annual Turnover Rate (t) — slider 0%–20%
- Only affects HKFRS calculations
- Represents the annual probability that an employee leaves before retirement
- Default: **5%**
- SME-FRS assumes 100% retention (this setting is ignored)

---

## Step 4 — Choose Accounting Standard

On the main page sidebar, select one of:

| Choice | When to Use |
|---|---|
| **SME-FRS** | Most Hong Kong SMEs filing under the HKICPA SME-FRS framework. Simpler: no discounting, no salary projection. |
| **HKFRS / HKFRS for PE** | Listed companies, subsidiaries of listed groups, or entities electing full HKFRS or HKFRS for PE. Requires discounting and salary projection to age 65 (Projected Unit Credit method). |

> If you are unsure which standard applies, consult your auditor.

---

## Step 5 — Enter Employee Data

On the main page, choose a data source:

### Option A: Manual Entry (small teams)

1. Select **Manual** (or **手動輸入** in Chinese)
2. The tool displays a spreadsheet-style table with a sample row ("Staff A")
3. Click any cell to edit; click **+ Add Row** at the bottom to add new employees
4. Fill in all required columns (see [Section 2](#2-before-you-start--what-you-need))

> ✏️ You can leave **MPF Mand (ER)** blank or 0 — the tool will estimate it (see Limitation #1). For final numbers, replace with the MPF trustee-confirmed **total** accrued benefit at valuation date for employer mandatory contributions.

### Option B: Upload File (large teams)

1. Select **Upload** (or **上傳檔案** in Chinese)
2. Prepare an Excel (`.xlsx`) or CSV (`.csv`) file with the following **exact column headers**:

```
Name | Hired Date | DOB | Salary at Transition | Current Salary | MPF Mand (ER) | MPF Vol (ER)
```

3. Click **Upload File** and select your file
4. The tool processes all rows automatically

> 📌 **Column naming is case-sensitive.** Use exactly these headers. `MPF Vol (ER)` is optional and can be omitted or left blank.

#### Sample File Structure

| Name | Hired Date | DOB | Salary at Transition | Current Salary | MPF Mand (ER) | MPF Vol (ER) |
|---|---|---|---|---|---|---|
| Chan Tai Man | 2010-06-01 | 1975-03-15 | 20000 | 25000 | 85000 | 10000 |
| Lee Siu Ming | 2018-01-15 | 1985-07-20 | 18000 | 22000 | | 0 |

---

## Step 6 — Run the Calculation

Click the **"Generate Report"** button (or **"生成審計底稿"** in Chinese).

The tool will:
1. Check each employee for the **5-year vesting requirement** — employees with less than 5 years of total service at the valuation date are excluded (liability = 0)
2. Calculate pre- and post-transition LSP amounts
3. Apply MPF offsetting rules
4. Apply the government subsidy for the applicable policy year
5. Apply PV discounting and turnover probability (HKFRS only)
6. Display results and enable the Excel download

---

## Step 7 — Read the Results Summary

A results table is shown with one row per employee. Key columns:

| Column | Description |
|---|---|
| **Pre-transition LSP (a)** | Gross LSP for service before 1 May 2025 |
| **MPF Offset (pre)** | MPF contributions used to reduce pre-transition LSP |
| **Net Pre-transition (a')** | Employer's pre-transition obligation after MPF offset |
| **Post-transition LSP (b)** | Gross LSP for service from 1 May 2025 to valuation date |
| **MPF Offset (post)** | Voluntary MPF contributions applied to post-transition LSP |
| **Net Post-transition (b')** | Post-transition LSP after voluntary MPF offset |
| **Gov Subsidy (on b')** | Government subsidy for the current policy year |
| **Employer's Post (b'−subsidy)** | What the employer actually owes for the post-transition period |
| **Net Liability** | **Final accounting provision** — the bottom-line figure |
| **MPF Data Basis** | Whether MPF balance is "Actual" or "Estimated" |

> 💡 The **Net Liability** column is what you would book as a provision in your financial statements.

---

## Step 8 — Review the Audit Proof

Click **"🧮 Audit Proof — Step-by-Step Calculations"** to expand the detailed working.

The expander contains **four sections**:

### Section A — Actuarial Assumptions
A summary of all parameters used (standard, valuation date, growth rate, discount rate, salary cap, etc.)

### Section B — Per-Employee Walkthrough
For each employee, the calculation is broken into **four steps**:

| Step | What Is Shown |
|---|---|
| **Step 1** | Service years (pre & post), years to age 65, PV factor, turnover probability |
| **Step 2** | Pre-LSP formula, projected salary (HKFRS), post-LSP formula with caps |
| **Step 3** | MPF offset allocation: all mandatory accrued at valuation date offsets pre-transition only; voluntary offsets pre then post |
| **Step 4** | Policy year, subsidy tier, subsidy amount, employer burden, final liability |

### Section C — Statutory References
Table of all relevant legal provisions (Cap. 57, MPFA Cap. 485, HKAS 19, etc.)

### Section D — Limitations & Disclaimers
Nine key limitations are listed. **Read these before using results in financial statements.**

---

## Step 9 — Download the Excel Working Paper

Click **"📥 Download Excel Working Paper (5 Sheets)"**.

The downloaded file `LSP_Audit_WP_Final.xlsx` contains:

| Sheet | Contents |
|---|---|
| **1.Cover** | Title page with valuation date, standard, policy year, and sign-off fields |
| **2.Assumptions** | All actuarial assumptions, the 25-year government subsidy ladder (current year highlighted), and key formulas |
| **3.Summary** | Results table with totals — ready to attach to audit file |
| **4.Calc Detail** | Step-by-step calculation for every employee (mirrors the on-screen audit proof) |
| **5.Limitations** | All limitations, disclaimers, and statutory references |

> 📝 **For audit files:** Print or attach sheets 1, 2, 3 and 5 to the working paper file. Sheet 4 provides granular backup for reviewer queries.

---

## Understanding the Output Columns

### How MPF Offsetting Works (Post-Abolition Rules)

```
Pre-transition LSP (a)
  └─ Offset by: Mandatory MPF (ER)   ← all mandatory accrued at valuation can offset pre-transition only
  └─ Offset by: Voluntary MPF (ER)   ← voluntary: pre first, then remainder to post
  = Net Pre-transition (a')          ← fully vested, always payable

Post-transition LSP (b)
  └─ Offset by: Remaining Voluntary MPF (ER)
  = Net Post-transition (b')
     └─ Government Subsidy           ← 25-year ladder (see table below)
     = Employer's Post Burden
```

### Government Subsidy Ladder Summary (Key Years)

| Policy Year | Scheme Period | Within ≤$500k: Rate | Within ≤$500k: Employer Cap | Beyond >$500k: Rate |
|---|---|---|---|---|
| 1–3 | 2025–2028 | 50% | $3,000 | 50% |
| 4–6 | 2028–2031 | 40–45% | $25,000 | 40–45% |
| 7–9 | 2031–2034 | 20–30% | $50,000 | 20–30% |
| 10–11 | 2034–2036 | 20% | None | 10–15% |
| 12 | 2036–2037 | 15% | None | 5% |
| 13+ | 2037–2050 | 5–15% | None | **0% (no subsidy)** |

> The **$500,000 threshold** applies to each employee's net post-transition amount (b') individually. Employees above $500k receive the lower "beyond threshold" rate.

### Subsidy Formula (Within ≤$500k, Years 1–9)
```
Subsidy = max(Rate × b',  b' − Employer Cap)
```
This means the employer pays **at most** the employer cap amount (e.g. $3,000 in years 1–3).

### Subsidy Formula (Years 10+, or Beyond $500k)
```
Subsidy = Rate × b'
```

---

## How the Key Formulas Work

### Service Years
```
Service years = Whole completed years + remaining days / 365
```
This matches the official LD EasyCal methodology.

### Pre-Transition LSP (a)
```
a = min(  min(Salary@Transition, $22,500) × (2/3) × pre_years,  $390,000  )
```

### Post-Transition LSP (b)
```
Projected salary = min(  Current Salary × (1 + g)^years_to_age_65,  $22,500  )   [HKFRS]
                 = min(  Current Salary,  $22,500  )                               [SME-FRS]
b = min(  Projected salary × (2/3) × post_years,  $390,000 − a  )
```

### MPF Estimation (When No Actual Balance Provided)
The tool uses a **dynamic segment model from hire date to valuation date**:

| Segment | Salary Cap | Salary Basis | MPF Rate |
|---|---|---|---|
| Dec 2000 – Apr 2012 | $20,000/month | Salary at Transition | 5% |
| May 2012 – May 2014 | $25,000/month | Salary at Transition | 5% |
| Jun 2014 – Apr 2025 | $30,000/month | Salary at Transition | 5% |
| May 2025 – Valuation Date (if applicable) | $30,000/month | Current Salary | 5% |

For each applicable segment:
```
Contribution = min(Salary basis, Cap) × 5% × 12 months × segment years
Grown value  = Contribution × (1 + MPF Return Rate)^years_to_valuation_date
```

> ⚠️ This is an approximation. Always obtain actual MPF trustee statements for final accounts.

### Final Liability

**SME-FRS:**
```
Final Liability = net_pre (a') + employer_post
```

**HKFRS:**
```
PV Factor      = 1 / (1 + r)^years_to_age_65
Prob. of Stay  = (1 − t)^years_to_age_65
Final Liability = (net_pre  +  employer_post × Prob_of_Stay) × PV_Factor
```

> Note: `net_pre` (a') is **not** reduced by the turnover probability because pre-transition LSP is fully vested for employees with 5+ years of service — it is payable upon any termination.

---

## Limitations & Important Notes

| # | Limitation | Impact |
|---|---|---|
| 1 | **MPF Estimated Balances** — If you don't provide the actual MPF mandatory balance, the tool estimates it. The estimate may differ from actual trustee records. | Do **not** use estimated figures for final financial statements. Obtain actual MPF statements. |
| 2 | **Salary Projection (HKFRS)** — Post-transition LSP is projected to age 65 using your specified growth rate. Actual salary at termination will differ. | Choose a growth rate that reflects your best estimate of long-term salary trends. |
| 3 | **Discount Rate** — The HKMA live rate is fetched on page load only. Rates change daily. | Refresh on each reporting date. Manually override if the fetched rate is stale. |
| 4 | **Government Subsidy Rates** — Rates may change if legislation is amended over the 25-year scheme. | Verify the applicable year's rates at each valuation date. |
| 5 | **5-Year Vesting** — Employees with less than 5 years of total service are excluded. | Ensure hire dates are accurate. Employees near the 5-year threshold should be double-checked. |
| 6 | **Retirement Age = 65** — All employees are assumed to retire at age 65. | If employees are likely to leave earlier, increase the Annual Turnover Rate to reflect this. |
| 7 | **LSP Only — Not Severance Pay** — The tool calculates Long Service Payment only, not Severance Payment. | Severance Pay uses the same formula but applies to redundancy cases (Cap. 57 ss.31–33). Calculate separately if needed. |
| 8 | **No Database** — Uploaded data is processed in your browser session only. Refreshing the page clears all data. | Save your Excel working paper before closing the browser. |
| 9 | **Data Privacy** — No employee data is transmitted to any server. All calculations are local. | Safe for internal use; follow your organisation's data governance policy for sensitive HR data. |
| 10 | **Not Professional Advice** — This tool is for reference and audit support purposes only. | Consult a qualified actuary or auditor for final provisions, particularly for HKFRS entities. |

---

## Frequently Asked Questions

**Q: The tool says "Not Vested" for an employee — why?**  
A: The employee has less than 5 years of total service at the valuation date. LSP entitlement requires a minimum of 5 years' service under Cap. 57.

**Q: Why is the MPF Mand (ER) showing "Estimated"?**  
A: You left the MPF Mandatory (ER) column blank or entered 0. The tool estimated employer mandatory contributions from hire date to valuation date, using `Salary at Transition` for pre-transition periods and `Current Salary` for post-transition periods, then compounded each segment to valuation date. Replace this with the trustee-confirmed valuation-date total accrued mandatory benefit before final sign-off.

**Q: The discount rate loaded is different from what I expected.**  
A: The tool fetches the latest available HKMA 10-year EFBN yield on launch. If your internet is unavailable, it falls back to 3.5%. You can manually override the rate in the sidebar.

**Q: Why is the government subsidy $0 even though the valuation date is after 1 May 2025?**  
A: The net post-transition amount (b') for that employee may be $0 (fully offset by voluntary MPF contributions). Check the audit proof — if b' = $0, no subsidy is applicable.

**Q: Should I use SME-FRS or HKFRS?**  
A: Most Hong Kong SMEs file under SME-FRS. If your entity is a listed company, a subsidiary of a listed group, or has adopted full HKFRS / HKFRS for PE, use the HKFRS option. Consult your auditor if unsure.

**Q: How do I verify my results against the LD EasyCal tool?**  
A: Set both **Salary Growth Rate** and **Discount Rate** to **0%**, and set **Turnover Rate** to **0%**. This replicates the LD EasyCal assumptions (current salary, no discounting, full retention).

**Q: My employee was hired before December 2000. Is their pre-MPF service handled correctly?**  
A: Yes for LSP purposes — pre-transition service years are calculated from the actual hire date. However, the **MPF estimation** only starts from 1 December 2000 (MPF inception). If you need accuracy, provide the actual MPF balance from the trustee.

**Q: Can I calculate Severance Pay?**  
A: No. This tool covers LSP only. Severance Pay uses the same formula but applies specifically to redundancy cases. You would need to verify Cap. 57 ss.31–33 and run a separate calculation.

---

## Official Reference Links

| Resource | URL |
|---|---|
| Labour Dept Statutory Entitlement Calculator | https://www.labour.gov.hk/eng/labour/Statutory_Employment_Entitlements_Reference_Calculator.htm |
| Abolition of MPF Offsetting Portal | https://www.op.labour.gov.hk/en/index.html |
| Offsetting Subsidy Scheme Portal | https://www.offsettingsubsidy.gov.hk/en/index.html |
| Subsidy Scheme Calculator (Official) | https://www.offsettingsubsidy.gov.hk/en/calculator.html |
| HKICPA MPF-LSP Accounting Guide | https://www.hkicpa.org.hk/-/media/HKICPA-Website/New-HKICPA/Standards-and-regulation/SSD/gMPFLSP.pdf |
| MPFA Quarterly Reports | https://www.mpfa.org.hk/en/info-centre/research-reports/quarterly-reports/mpf-schemes |
| HKMA EFBN Daily Yields | https://www.hkma.gov.hk/eng/data-publications-and-research/data-and-statistics/daily-monetary-statistics/ |

---

## Quick Checklist Before Filing

- [ ] Valuation date set to the correct reporting period end
- [ ] Accounting standard confirmed with auditor (SME-FRS or HKFRS)
- [ ] Salary Growth Rate and Discount Rate reflect current best estimates (HKFRS)
- [ ] All employee hire dates verified against HR records
- [ ] Salary at Transition verified for all employees (as at 30 April 2025)
- [ ] Actual MPF mandatory balances obtained from trustee (replace any "Estimated" figures)
- [ ] Results cross-checked against prior year provision
- [ ] Excel working paper downloaded and saved to audit file
- [ ] Limitations and disclaimers reviewed
- [ ] Reviewed by a qualified accountant or actuary before booking the provision

---

*This guide is for reference only. All computations are performed locally in your browser. No data is transmitted to any server. For final accounting provisions, consult a qualified professional.*
