---
name: sas-adam-bds
description: Develop and QC SAS 9.4 BDS ADLB and ADVS datasets from SDTM LB/VS plus checked ADSL. Use for parameter mapping, baseline and change derivations, visit selection, analysis flags and laboratory normal ranges; excludes ADTTE.
---

# SAS BDS: ADLB and ADVS

Read shared [implementation](../pharma-skills-development/references/implementation.md), [SAS conventions](../pharma-skills-development/references/sas-conventions.md), and [QC](../pharma-skills-development/references/evaluation.md). Then read [ADLB](references/adlb.md) or [ADVS](references/advs.md) for the target.

## Required inputs

Checked ADSL plus LB/VS, parameter metadata, approved date/time/visit/baseline/tie rules, missing-data rules and output attributes. ADSL supplies subject context; source findings supply results. Verify ADSL keys and required fields or route to [ADSL](../sas-adam-adsl/SKILL.md).

## Derivation order

1. Inspect source keys, analytes/tests, units, repeated visits/timepoints, dates and missing results. Report orphan subjects.
2. Map tests/units to PARAMCD/PARAM and numeric results to AVAL. Never mix units under one parameter without an approved conversion; do not silently force nonnumeric results to numbers.
3. Derive ADT/ADY and analysis visits from approved rules. Keep source VISIT/VISITNUM and source sequence. Record exclusions explicitly.
4. Select baseline within subject/parameter and, when applicable, period/BASETYPE. Use nonmissing eligible measurements and deterministic tie-breaks. Check at most one chosen baseline per defined group.
5. Carry BASE; derive CHG and PCHG only on eligible records. Handle missing BASE/AVAL and BASE=0 explicitly. Do not round stored values for display.
6. Select analysis records per visit using its own eligibility and tie rules. Baseline and analysis flags need not identify the same row.
7. Apply target-specific lab/vital rules, metadata and provenance. Check counts and inherited ADSL fields.
8. QC baseline identities, changes and visit flags against independent values, including no-baseline/zero-baseline/ties; inspect logs when run.

Return code, parameter/variable metadata, source-to-target notes and QC evidence. Explain unresolved records and classification. Do not silently add LOCF, worst-case selection, grading, unit conversion or derived parameters.
