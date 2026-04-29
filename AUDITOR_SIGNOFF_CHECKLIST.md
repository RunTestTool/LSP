# Auditor Sign-off Checklist (核數簽核清單)

Use this checklist to bridge:
- what the tool in `app.py` already computes deterministically, and
- what still requires management/auditor professional judgment.

本清單用於區分：
- 系統已自動完成的計算邏輯，及
- 仍需管理層/核數師專業判斷的事項。

---

## 1) Engagement Details (項目資料)

- Entity (公司名稱):
- Reporting Date (報告日):
- Accounting Framework selected in tool (會計準則): `SME-FRS` / `HKFRS / HKFRS for PE`
- Prepared by (編製):
- Reviewed by (覆核):
- Date (日期):
- Working paper reference (底稿編號):

---

## 2) System-Covered Logic (系統已覆蓋邏輯)

Tick once verified from app output and exported workbook.
請對照畫面與匯出工作底稿核對後勾選。

- [ ] Transition split date is `2025-05-01`.
- [ ] Service years use whole years + remaining days / 365.
- [ ] Pre-transition service is capped at valuation date when valuation is before transition.
- [ ] LSP salary cap (`HK$22,500/month`) and max (`HK$390,000`) are applied.
- [ ] Mandatory MPF offsets pre-transition LSP only.
- [ ] Voluntary MPF offsets pre first, then post with residual only.
- [ ] Government subsidy policy year follows anniversary logic (each 1 May).
- [ ] Subsidy threshold split (`<=500,000` vs `>500,000`) is applied correctly.
- [ ] HKFRS/HKFRS for PE path applies discount factor and retention probability.
- [ ] SME-FRS path uses no discounting (`PV=1`) and no turnover reduction (`prob_stay=1`).

Evidence reference(s):
- `REGULATION_TRACEABILITY.md`
- Excel export: `2.Assumptions`, `4.Calc Detail`, `5.Limitations`

---

## 3) Data Quality & Source Evidence (數據與來源證據)

These items require human verification.
以下項目需人工核對。

- [ ] Employee master data agrees to HR records (name, hire date, DOB).
- [ ] Salary at Transition is correct as at `2025-04-30`.
- [ ] Current Salary is correct at valuation date.
- [ ] MPF balances are trustee-confirmed at valuation date.
- [ ] Any estimated MPF mandatory balances are replaced by trustee figures before final sign-off.
- [ ] Exceptional cases (e.g., pre-2000 hires, unusual contract terms) are reviewed separately.

Primary evidence files (主要證據文件):
- HR/payroll reports
- MPF trustee statements
- Input file used in tool (CSV/XLSX)

---

## 4) Assumptions Requiring Judgment (需專業判斷的假設)

### 4.1 HKFRSs / HKFRS for PE

- [ ] Salary growth rate (`g`) is supportable and documented.
- [ ] Discount rate (`r`) is supportable for reporting date and documented.
- [ ] Turnover rate (`t`) is supportable and documented.
- [ ] Management confirms model simplifications are acceptable for this engagement.
- [ ] Auditor confirms no additional actuarial procedures are required, or required procedures are completed.

### 4.2 SME-FRS

- [ ] Framework election is appropriate for entity.
- [ ] No-discounting treatment is appropriate under engagement policy.
- [ ] Current salary basis (no projection) is accepted for measurement policy.

---

## 5) Disclosure & Governance (披露與治理)

- [ ] Limitations and disclaimers are included in audit file.
- [ ] Basis of assumptions is documented in working papers.
- [ ] Sensitivity/risk commentary is documented where material.
- [ ] Final management representation includes data completeness/accuracy confirmation.

---

## 6) Framework Verdict (準則結論)

Selected framework in tool (工具選擇準則):
- [ ] SME-FRS
- [ ] HKFRSs / HKFRS for PE

Alignment assessment (一致性評估):
- [ ] Full for configured policy scope (符合本工具設定範圍)
- [ ] Partial - additional procedures/disclosures required (部分符合，需補充程序/披露)
- [ ] Exception identified (存在重大例外)

Reasoning / Notes (原因及備註):

---

## 7) Final Conclusion & Sign-off (最終結論及簽核)

Conclusion status:
- [ ] No exceptions identified.
- [ ] Exceptions identified and resolved.
- [ ] Exceptions identified and carried forward to audit adjustments.

Exception log reference (如有):

Preparer sign-off (編製簽核):
- Name:
- Signature/initials:
- Date:

Reviewer sign-off (覆核簽核):
- Name:
- Signature/initials:
- Date:
