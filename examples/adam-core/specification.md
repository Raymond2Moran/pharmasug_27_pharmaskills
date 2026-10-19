# SYN001-SPEC-1: worked ADaM study

Version 1, 2026-10-19. This is an explicit synthetic-study specification, not an
approved clinical SAP or a normative CDISC rulebook. Purpose: demonstrate SAS
ADaM derivations and QC; no hypothesis testing, modeling or estimand inference.

## Reference context and limits

Reference targets are ADaM model 2.1, ADaMIG 1.3 and OCCDS IG 1.1, as grouped in
the [CDISC release-package description](https://www.cdisc.org/kb/articles/making-sense-various-adam-documents).
Those versions guide the structures, not the study-specific decisions below.
Full licensed guides and CT releases are not bundled or claimed as validated.
Inputs are minimal SDTM-shaped fixtures, not complete SDTM submission domains;
no SDTMIG conformance is asserted. No external CT release or medical dictionary
is applied: the small value sets and terms below are local synthetic choices.

Study: SYN001, 12 subjects, one treatment period, planned Drug/Placebo arms.
Identifiers use STUDYID + USUBJID; source domains also use their sequence number.
All source rows are retained in their target, except EX is aggregated and DS is
selected for ADSL. Clinical realism is intentionally secondary to edge cases.

## ADSL rules

| ID | Decision |
| --- | --- |
| A01 | Include every DM subject, including screen failure and randomized untreated subjects. Preserve SUBJID, AGE and SEX. DM key must be unique and nonmissing. |
| A02 | Each EX row documents an actual administration interval, including placebo dose 0. Actual treatment is its EXTRT. Multiple distinct EXTRT values per subject stop this single-period example. Earliest complete start and latest complete end define treatment boundaries only if **all** respective dates are complete; otherwise that boundary is unknown. |
| A03 | Nonmissing DM.ARM is explicit fixture randomization evidence: ITTFL=Y, otherwise N. Any documented EX row gives SAFFL=Y, otherwise N. Treatment code Drug=1, Placebo=0; untreated actual treatment/code are missing. No exposure is inferred from ARM. |
| A04 | Select DSCAT=DISPOSITION EVENT; require exactly one final record per subject in this fixture. EOSSTT=DSDECOD; EOSDT=DSSTDTC when complete. |
| A05 | Strict YYYY-MM-DD parsing. Year/year-month strings remain unconverted. No date imputation, so no imputation flags are generated. Invalid complete dates fail. |
| A06 | Relative day is date-reference+1 on/after reference, date-reference before reference; no day zero. Missing date/reference gives missing relative day. |

Expected ADSL: 12 rows, ITT=11, safety=10. Subject 003 is planned Placebo but
actually Drug. Subject 006 is exposed to placebo at dose 0. Subject 007 is
randomized/untreated; 011 is screen failure/untreated. Subject 008 is exposed
but has an unresolved first-treatment date. No subject is silently excluded.

## BDS rules (ADLB and ADVS)

| ID | Decision |
| --- | --- |
| B01 | ADLB: ALT in U/L → PARAMCD=ALT, PARAM=Alanine Aminotransferase (U/L). ADVS: PULSE in beats/min → PARAMCD=PULSE, PARAM=Pulse Rate (beats/min). Other test/unit combinations fail. Copy STRESN to AVAL and STRESU to local AVALU; no conversion or averaging. |
| B02 | Baseline is the latest nonmissing AVAL with complete ADT strictly before TRTSDT per subject/parameter. Same-date ties choose greatest source SEQ. No baseline for unknown TRTSDT. ABLFL=Y only for the selected record; otherwise blank. Carry selected AVAL as BASE to all records in that parameter. |
| B03 | CHG=AVAL-BASE only when ADT is complete and on/after known TRTSDT, and both values exist. PCHG=100*CHG/BASE only when BASE is nonzero. Otherwise CHG/PCHG remain missing; even baseline records have missing CHG/PCHG in this example. No rounding is stored. |
| B04 | Copy source VISIT/VISITNUM to AVISIT/AVISITN; no visit windowing. Select latest complete ADT with nonmissing AVAL per subject/parameter/visit, breaking ties by greatest SEQ. ANL01FL=Y for that row, blank otherwise. Selection is independent of safety membership; users must still apply analysis populations. |
| L01 | Copy standardized lower/upper lab limits to ANRLO/ANRHI. With AVAL and both limits present, LOW below lower, HIGH above upper, NORMAL at/between bounds. Missing any value leaves ANRIND blank. Reject lower>upper. No toxicity grading. |
| V01 | No BMI, position/timepoint pooling or repeated-reading averages. The synthetic pulse value 0 is an artificial arithmetic test, not a plausible clinical reading. |

Retain SRCDOM, SRCSEQ, original SRCDTC and source visits; ASEQ=source sequence
because each example contains exactly one parameter and one output per input.
This sequence rule must not be generalized to derived/expanded BDS records.
Expected ADLB/ADVS row counts: 17/12. Lab subject 001 selects baseline SEQ=2
(12), so the follow-up 18 gives CHG=6, PCHG=50. Vital subject 003 selects SEQ=2
(71), so 80 gives CHG=9 and PCHG≈12.6760563380282. Missing/zero baselines,
missing results and partial dates are also explicitly covered in the oracle.

## OCCDS rules (ADAE and ADCM)

Preserve every AE/CM source record, SEQ and date string. ASEQ=source SEQ. Carry
actual treatment, dates and population flags from ADSL unchanged. Parse complete
dates and derive relative days per A05/A06; no imputation. Reject complete end
dates before complete starts. No subject-level deduplication is performed.

| ID | Decision |
| --- | --- |
| E01 | Onset-only TEAE: TRTEMFL=Y when ASTDT falls in [TRTSDT, TRTEDT+30], inclusive; N when fully assessable but outside. Untreated subjects get N. Exposed subjects missing onset or either treatment boundary remain blank. Worsening of preexisting events is expressly excluded from this synthetic endpoint. |
| E02 | Preserve supplied AE terms, synthetic category, severity and seriousness. No dictionary recoding or severity-to-worsening inference. |
| C01 | PRIORFL=Y if complete medication start precedes complete TRTSDT; N if start is on/after. Missing required dates give blank, including untreated subjects. |
| C02 | CONCOMFL=Y when [ASTDT,AENDT] overlaps [TRTSDT,TRTEDT], inclusive. N for known nonoverlap or no exposure. Unknown required boundaries give blank. No post-treatment extension. A complete start after TRTEDT establishes N even if the medication end is unknown. |
| C03 | CMENRF=ONGOING with **empty** CMENDTC means independently confirmed ongoing on 31JAN2025 in this fixture. If start and treatment boundaries are known and treatment ends by that date, classify overlap without assigning AENDT. A merely missing/partial end without that evidence remains unknown. |

PRIORFL and CONCOMFL can both be Y. PRIORFL, CONCOMFL, CLASSSTAT and AVALU are
documented local demonstration variables, not claims of universally required
standard variable names. CLASSSTAT distinguishes CLASSIFIED, NO EXPOSURE and
UNRESOLVED DATES; six unresolved occurrence rows are expected (ADAE 003/1,
008/1, 012/1; ADCM 004/1, 005/1, 008/1).

Expected ADAE/ADCM row counts: 10/11. For subject 002, 19FEB2025 is the final
TEAE day (20JAN+30); 20FEB is outside. Repeated subject 001 AE rows with
SEQ 2 and 3 are both retained. Medication ending on first dose or beginning
on last dose overlaps inclusively. Unknown classification is not converted to N.

## Metadata, lineage and QC contract

All target lengths/types/labels/formats are explicitly declared in production
programs. Dates are numeric SAS dates formatted DATE9.; day/count/result variables
are numeric length 8. Keys use STUDYID $8 and USUBJID $12. Population/selection
flags are $1 with their **variable-specific** sets above. Metadata inventory and
22 critical attribute expectations are retained by the QC program. This is not
a full CDISC metadata validation suite.

| Target group | Provenance / rule | QC |
| --- | --- | --- |
| ADSL subject/demographics/planned treatment | DM by subject, A01/A03 | All 12 hand-authored expected subjects |
| ADSL actual treatment/dates/populations | EX aggregation and DM, A02/A03/A05 | Full ADSL values; independent expected counts |
| ADSL disposition | DS by subject after category selection, A04 | Full ADSL expected status/date |
| BDS results/parameters/visits | LB/VS by subject+SEQ, B01/B04 | Source links and mapping checks |
| BDS baseline/change/flags | Within subject+parameter; B02/B03/B04 | Hand-authored values for all fixture records |
| ADLB range | LB limits, L01 | Retained limits and hand-authored categories |
| OCCDS dates/classifications | AE/CM + ADSL, A05/A06/E01/C01-C03 | All fixture dates/flags; preserved source fields |
| Inherited ADSL context | ADSL by subject | Compare with both ADSL and independent ADSL truth |

Selected BDS numeric values use absolute tolerance 1e-10 to accommodate the
literal repeating-decimal oracle. Keys/counts/flags/dates otherwise compare
exactly. QC does not reuse production derivation helpers. It is a fixture oracle,
not a second general derivation engine. Some fields (e.g. ADCM relative days and
individual source-to-ADT conversions for BDS) have static review but no dedicated
independent per-record oracle; full coverage remains a future extension.
