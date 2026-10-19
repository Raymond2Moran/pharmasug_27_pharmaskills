---
name: sas-adam-occds
description: Develop and QC SAS 9.4 OCCDS ADAE and ADCM from SDTM AE/CM plus checked ADSL, including occurrence records, date uncertainty, TEAE and prior/concomitant medication classifications.
---

# SAS OCCDS: ADAE and ADCM

Read shared [implementation](../pharma-skills-development/references/implementation.md), [SAS conventions](../pharma-skills-development/references/sas-conventions.md), and [QC](../pharma-skills-development/references/evaluation.md). Then read [ADAE](references/adae.md) or [ADCM](references/adcm.md).

## Inputs and workflow

Require checked ADSL, corresponding occurrence domain, approved specification, variable metadata, date/imputation rules and classification windows. Keep actual event/medication records even when a subject has multiple similar records.

1. Inspect subject+source SEQ uniqueness, original terms/coding, dates and ongoing indicators. Detect orphan subjects before joining ADSL.
2. Preserve source records, SEQ and DTC. Merge selected ADSL treatment/population variables by validated subject keys; never multiply occurrence rows.
3. Derive ASTDT/AENDT and relative days only from complete dates or explicitly approved imputation. Retain imputation flags if imputation occurs. Check intervals and distinguish ongoing, partial, missing and invalid.
4. Classify TEAE or medication timing using target-specific rules and treatment periods. Require explicit treatment of uncertainty; blank/unknown must not become N through a missing-date comparison.
5. Apply metadata and traceability. Derive occurrence-selection flags only when requested with explicit grouping/tie rules. Do not deduplicate source records to obtain subject counts.
6. Independently check boundary cases, unresolved dates, untreated subjects and ongoing intervals; reconcile source counts and inherited ADSL variables; inspect SAS logs when run.

Return SAS code, metadata, derivation notes, QC expectations and findings with subject/source keys. A later analysis may count subjects or events, but this skill produces occurrence datasets rather than TLF counts.
