# HK MPF-LSP Regulation Traceability

This document maps key statutory/business rules to:
- implementation points in `app.py`, and
- user-facing disclosures in documentation and app output.

It is intended for audit traceability support and internal review.

---

## Scope

- Long Service Payment (LSP) under Employment Ordinance (Cap. 57)
- Abolition of MPF offsetting arrangement effective 1 May 2025
- Government subsidy ladder (25-year scheme)
- Accounting display logic for SME-FRS and HKFRS / HKFRS for PE

---

## Rule-to-Implementation Matrix

| Rule / Requirement | Implementation in `app.py` | User-facing Display / Docs |
|---|---|---|
| Transition date = 2025-05-01 | `TRANS_DATE = pd.Timestamp('2025-05-01')` in main calculation flow | `LANG_DICT` transition labels, `USER_GUIDE.md` formulas and walkthrough |
| Service year method uses whole years + remaining days/365 | `calc_service_years(...)` | Audit step text in app and Excel sheet formulas |
| LSP salary cap = HK$22,500 and total cap = HK$390,000 | `v_pre` and `v_post` formulas with `22500` and `390000` caps | Assumptions sheet, audit detail, `USER_GUIDE.md` |
| Vesting threshold = 5 years | `if calc_service_years(h_dt, REPORT_DATE) < 5.0: ... Not Vested` | Results note and user guide FAQ |
| Mandatory MPF can offset pre-transition LSP only | `offset_mand_pre = min(v_pre, mpf_mand)` and no mandatory applied to post | `res_mpf_pre`, audit step-3 notes, `README.md`, `USER_GUIDE.md` |
| Mandatory MPF includes valuation-date total (pre + post transition accruals) | Input guidance + `mpf_actual` labels + estimate helper | Upload guide text in app and docs (`README.md`, `USER_GUIDE.md`, `SAMPLE_DATA.md`) |
| Voluntary MPF offsets pre first, remainder to post | `vol_to_pre`, `vol_remaining`, `offset_post` logic | Audit step-3 and formula notes in app/Excel/docs |
| Post-transition LSP cannot be offset by mandatory MPF | No mandatory component in `offset_post`; post uses voluntary remaining only | App labels: `res_mpf_post` and audit notes |
| Missing mandatory balance estimation covers hire-to-valuation period with cap segments | `estimate_mpf_mandatory_balance(...)` and dynamic post-transition segment | Audit captions, assumptions formulas, docs notes |
| MPF estimation starts at MPF inception for pre-2000 hires | `_MPF_INCEPTION = pd.Timestamp('2000-12-01')` | Limitation text in Excel sheet and docs |
| Government subsidy uses 25-year two-tier ladder with $500k threshold | `get_subsidy_detail(...)` ladder, threshold test, formula branches | Audit step-4 + assumptions table + user guide subsidy section |
| Year index computation = days since 2025-05-01 // 365 + 1 | `year_idx_display` and `policy_year` logic | Sidebar policy year and audit display |
| HKFRS applies discounting and turnover retention only to employer post burden | `final_pv = (net_pre + employer_post * prob_stay) * pv` | Audit final formula and limitations text |
| SME-FRS uses no discounting and no turnover reduction | `pv = 1.0`, `prob_stay = 1.0`, `effective_g = 0.0` for SME-FRS | App labels and user guide standard comparison table |

---

## Formula Display Checkpoints

- App audit panel and Excel `KEY FORMULAS` section both state:
  - mandatory offset is pre-transition only,
  - voluntary can flow pre then post,
  - final liability under HKFRS applies `prob_stay` to post-transition employer burden only.
- Documentation (`README.md`, `USER_GUIDE.md`, `QUICK_START.md`, `SAMPLE_DATA.md`, `TERMS_OF_SERVICE.md`, `PUBLICATION_READY.md`) is aligned to the same rule wording.

---

## Residual Governance Notes

- This tool is a calculation aid; legal/accounting conclusions should be reviewed by qualified professionals.
- Subsidy rates and interpretation should be reconfirmed at each reporting date against official sources.
- Trustee-confirmed valuation-date MPF balances should replace estimated balances before final sign-off.

---

Last reviewed: 2026-04-29

