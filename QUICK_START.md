# Quick Start Guide — LSP Calculator

**For the impatient**: Get the app running in 60 seconds!

---

## ⚡ 60-Second Setup

### Option 1: Local (Recommended for Testing)
```bash
cd c:\Users\Kevin\Documents\LSP
pip install -r requirements.txt
streamlit run app.py
```
✅ Opens automatically at `http://localhost:8501`

### Option 2: Docker
```bash
docker build -t lsp-calc .
docker run -p 8501:8501 lsp-calc
```
✅ Access at `http://localhost:8501`

### Option 3: Streamlit Cloud (Easiest for Sharing)
1. Push to GitHub
2. Visit https://streamlit.io/cloud
3. Click "New app" → select this repo
4. ✅ Live in <1 minute!

---

## 📊 Basic Workflow

### Step 1: Set Parameters (Left Sidebar)
- **Accounting Standard**: SME-FRS or HKFRS
- **Valuation Date**: Your reporting date
- **Salary Growth**: 0-7% (SME-FRS forces 0%)
- **MPF Return**: 0-7% (typical: 4-5%)
- **Discount Rate**: Auto-fetches from HKMA
- **Turnover Rate**: 0-20% (HKFRS only)

### Step 2: Input Employee Data
**Option A: Manual** (for 1-2 employees)
- Use editable table
- Add rows as needed

**Option B: Upload** (for many employees)
- Download template from README.md
- Fill in employee data
- Upload CSV or XLSX

**Required columns**:
```
Name | Hired Date | DOB | Salary at Transition | Current Salary | MPF Mand (ER) | MPF Vol (ER)
```

### Step 3: Calculate
- Click **"生成審計底稿" / "Generate Report"**
- Results appear instantly

### Step 4: Review & Export
- 📊 View summary table
- 🧮 Expand audit details (step-by-step breakdown)
- 📥 Download Excel working paper (5 sheets)

---

## 🎯 Example Calculation (2 Minutes)

### Sample Employee
```
Name: John Smith
Hired: 2015-06-01
DOB: 1985-03-15
Salary @ Transition (30 Apr 2025): $18,000/month
Current Salary (31 Mar 2026): $22,000/month
MPF Mandatory: $95,000
MPF Voluntary: $5,000
```

### Expected Results
- **Pre-transition LSP**: ~$92,000
- **Post-transition LSP**: ~$11,000
- **MPF Offset**: ~$75,000
- **Net Post**: ~$28,000
- **Gov Subsidy**: ~$14,000
- **Final Liability**: ~$37,000 (approximate)

---

## 📋 Data Format Cheat Sheet

| Field | Format | Example | Notes |
|-------|--------|---------|-------|
| Name | Text | John Smith | Any format OK |
| Hired Date | YYYY-MM-DD | 2015-06-01 | Start of employment |
| DOB | YYYY-MM-DD | 1985-03-15 | Calc age to 65 |
| Salary @ Transition | Number | 18000 | Monthly, $30 Apr 2025 |
| Current Salary | Number | 22000 | Monthly, at valuation date |
| MPF Mand (ER) | Number | 95000 | Total employer mandatory accrued benefit at valuation date; leave blank to estimate |
| MPF Vol (ER) | Number | 5000 | Optional; blank = 0 |

### ✅ Valid Example Row
```
John Smith,2015-06-01,1985-03-15,18000,22000,95000,5000
```

### ⚠️ Common Mistakes
```
❌ Wrong date: 2015/6/1 (use YYYY-MM-DD)
❌ Wrong date: 01-06-2015 (use YYYY-MM-DD)
❌ Salary text: "HK$18,000" (use number only: 18000)
❌ Names: "Staff A - Senior Manager" (simple names work better)
```

---

## 📱 UI Guide

### Left Sidebar
- **Language**: EN / 繁中 (switches entire UI)
- **Parameters**: Sliders & inputs for calculations
- **Policy Year**: Auto-calculated policy year post-abolition

### Main Area
- **Source Label**: Manual entry or file upload
- **Results Table**: Summary of all employees
- **Audit Expander**: Detailed step-by-step calculations
- **Download Button**: Excel workbook export

---

## ✅ Pre-Use Checklist

- [ ] Python 3.9+ installed? (`python --version`)
- [ ] Dependencies installed? (`pip list | grep streamlit`)
- [ ] Internet connection? (for HKMA yield fetch)
- [ ] Employee data ready? (actual salaries & hire dates)
- [ ] MPF statements available? (for verification)

---

## 🆘 Troubleshooting

| Problem | Solution |
|---------|----------|
| "Port 8501 already in use" | `streamlit run app.py --server.port=8502` |
| "Module not found: streamlit" | `pip install -r requirements.txt` |
| "HKMA API timeout" | Check internet; will use 3.5% fallback |
| "No data after upload" | Check file format (XLSX/CSV); column names exact |
| "Calculation error for employee X" | Check dates valid & salary > 0 |
| App won't start | Try: `pip install --upgrade streamlit` |

---

## 📖 Full Docs

- **Setup & Installation**: See `DEPLOYMENT.md`
- **Usage & Formulas**: See `README.md`
- **Input Data Formats**: See `SAMPLE_DATA.md`
- **Legal & Disclaimers**: See `TERMS_OF_SERVICE.md`
- **Code Quality**: See `CODE_IMPROVEMENTS.md`
- **Pre-Launch**: See `PUBLICATION_CHECKLIST.md`

---

## 🎯 Common Use Cases

### Use Case 1: Single Employee Check
1. Manual entry → 1 employee
2. Set SME-FRS or HKFRS
3. Click calculate
4. Copy/paste result

### Use Case 2: Annual Audit
1. Upload all employees (CSV)
2. Set valuation date
3. Generate report
4. Download Excel working paper
5. Use for audit sign-off

### Use Case 3: Accounting Provision
1. Upload all employees
2. Set HKFRS standard
3. Set 3% salary growth + 5% MPF return
4. Get aggregate liability
5. Book accounting provision

### Use Case 4: HR Planning
1. Upload current staff
2. Set SME-FRS (current obligation)
3. Filter by service years
4. Plan retention/severance budget

---

## 🚀 Deploy to Production

### Easiest: Streamlit Cloud
```bash
git push origin main
# Go to streamlit.io/cloud → New app → done!
```

### Standard: Docker
```bash
docker build -t lsp-calc .
docker run -d -p 8501:8501 lsp-calc
```

### Advanced: AWS/Azure/GCP
See `DEPLOYMENT.md` for step-by-step guides

---

## 📞 Need Help?

1. **How do I...?** → Check `README.md` FAQ
2. **What's the data format?** → See `SAMPLE_DATA.md`
3. **Is this legal advice?** → See `TERMS_OF_SERVICE.md` disclaimer
4. **How do I deploy?** → Read `DEPLOYMENT.md`
5. **What can be improved?** → See `CODE_IMPROVEMENTS.md`

---

## 🎓 Learning Resources

- [Hong Kong Labour Dept Calculator](https://www.labour.gov.hk/eng/labour/Statutory_Employment_Entitlements_Reference_Calculator.htm) — Compare your results
- [HKICPA MPF-LSP Guidance](https://www.hkicpa.org.hk) — Accounting standards
- [Subsidy Scheme Portal](https://www.offsettingsubsidy.gov.hk) — Official government info
- [MPFA Reports](https://www.mpfa.org.hk) — MPF return data
- [HKMA Yields](https://www.hkma.gov.hk) — Live discount rates

---

**Last Updated**: 27 April 2026  
**Status**: Ready to Use ✅

**Start calculating in seconds!** 🚀
