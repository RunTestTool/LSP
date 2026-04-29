# Sample Data Format

## CSV Format

Save as `employees.csv`:

```csv
Name,Hired Date,DOB,Salary at Transition,Current Salary,MPF Mand (ER),MPF Vol (ER)
John Smith,2015-06-01,1985-03-15,18000,22000,95000,5000
Mary Chan,2012-01-15,1980-07-20,20000,24500,125000,10000
David Wong,2010-09-10,1978-11-05,21000,25500,150000,0
Alice Lee,2018-03-01,1992-05-12,15000,18500,0,2000
```

## Excel Format

Use columns in this order (case-sensitive):

| Name | Hired Date | DOB | Salary at Transition | Current Salary | MPF Mand (ER) | MPF Vol (ER) |
|------|-----------|-----|---------------------|-----------------|---------------|--------------|
| John Smith | 2015-06-01 | 1985-03-15 | 18000 | 22000 | 95000 | 5000 |
| Mary Chan | 2012-01-15 | 1980-07-20 | 20000 | 24500 | 125000 | 10000 |
| David Wong | 2010-09-10 | 1978-11-05 | 21000 | 25500 | 150000 | 0 |
| Alice Lee | 2018-03-01 | 1992-05-12 | 15000 | 18500 | | 2000 |

## Field Definitions

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| **Name** | Text | ✅ | Employee identifier (any format acceptable) |
| **Hired Date** | Date (YYYY-MM-DD) | ✅ | Employment start date |
| **DOB** | Date (YYYY-MM-DD) | ✅ | Date of birth (used to calculate years to retirement age 65) |
| **Salary at Transition** | Number | ✅ | Monthly salary as of 30 April 2025 (pre-transition reference) |
| **Current Salary** | Number | ✅ | Monthly salary at valuation date |
| **MPF Mand (ER)** | Number | ❌ | Mandatory ER balance (total accumulated); leave blank to auto-estimate |
| **MPF Vol (ER)** | Number | ❌ | Voluntary ER balance (total accumulated); leave blank for 0 |

## Notes

### Salary at Transition vs Current Salary

- **Salary at Transition**: Monthly salary immediately before 1 May 2025
  - If employee hired after 1 May 2025, use current salary (no pre-transition service)
  - If employee not yet at current salary level on 30 April 2025, use the actual salary at that date

- **Current Salary**: Monthly salary at the valuation date
  - For HKFRS: Used as basis for projection to retirement
  - For SME-FRS: Used directly (no projection)

### MPF Balances

Obtain from MPF trustee statement:

- **MPF Mand (ER)**: Total accumulated mandatory ER contributions + accrued returns as of the valuation date (including both pre- and post-1 May 2025 contributions)
- **MPF Vol (ER)**: Total accumulated voluntary ER contributions + accrued returns as of the valuation date

**If not available, leave blank:**
- Tool will estimate from hire date to valuation date using the historical cap segments (and includes a post-1 May 2025 segment when applicable)
- Estimation less accurate than actual figure
- Always verify with trustee statement before final audit sign-off

### Special Cases

#### Pre-1 May 2025 Hire Dates
- Enter actual hire date
- Tool automatically calculates pre-transition service
- Must have ≥5 years service to be entitled to LSP

#### Post-1 May 2025 Hire Dates
- No pre-transition service
- Result may show $0 (less than 5 years total service)

#### Employees Hired Before 1 Dec 2000 (MPF Inception)
- **Hired Date**: Actual hire date (even if pre-2000)
- **MPF Estimation**: Starts from 1 Dec 2000 only
- Pre-2000 service period: Not reflected in estimated MPF
- **Recommendation**: Obtain actual MPF trustee statement for accurate balance

#### Employees with No Voluntary Contributions
- Leave **MPF Vol (ER)** blank or enter `0`
- Tool treats as `0`

---

## Validation Rules

The tool will skip (or flag errors for) records with:
- Empty or invalid `Hired Date`, `DOB`, `Salary at Transition`, `Current Salary`
- Invalid date format (must be YYYY-MM-DD)
- Salary at Transition or Current Salary ≤ 0
- DOB resulting in age < 18 or > 100 at valuation date
- Hire date after valuation date (future hire)

---

## Example: Multi-Sheet Excel

If using an Excel file with multiple worksheets:
- Only the **first visible sheet** is read
- Ensure all data in one worksheet
- Column headers must be exactly as specified above

---

**Last Updated**: April 2026
