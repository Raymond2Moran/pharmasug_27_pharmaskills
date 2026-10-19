---
name: sas-adam-adsl
description: Develop and QC ADSL in SAS 9.4 from SDTM DM/EX/DS and approved study specifications, covering subject completeness, demographics, treatment, exposure, population flags and disposition. Use for subject-level ADaM programming or review.
---

# SAS ADSL

ADSL is the first priority and the subject-level foundation for this skill family. Develop a specified study dataset, not a generic fixed list of variables.

Read the shared [implementation contract](../pharma-skills-development/references/implementation.md), [SAS conventions](../pharma-skills-development/references/sas-conventions.md), and [QC guidance](../pharma-skills-development/references/evaluation.md). Keep this bundle together when installing. The [worked specification](../../../examples/adam-core/specification.md) and [ADSL program](../../../examples/adam-core/programs/adsl.sas) illustrate synthetic choices only.

## Inputs and decisions

Inspect DM/EX/DS, subject keys, variable metadata, randomization/treatment evidence, protocol/SAP and derivation spec. Additional domains are needed only when the requested variables require them. Confirm subject inclusion, planned/actual treatment sources, exposure aggregation, population definitions and disposition selection. Missing evidence is a question, not a default.

## Procedure

1. Inventory source variables, types, lengths, counts, missing keys and duplicates. Require unique DM subject keys and unique relevant source-record keys; report exceptions before any join.
2. Create a variable derivation map: target, source/keys, rule ID, attributes and QC check. Define character lengths before merges. Preserve demographics as specified; do not recode factors or treatment silently.
3. Aggregate EX to the specified subject/treatment period: first/last valid exposure and actual treatment. Detect multiple regimens, partial dates and conflicting evidence. Do not choose arbitrary first/last treatment for an unsupported design.
4. Derive population flags from their specified evidence. Untreated randomized subjects may remain in ADSL. Define each flag's allowed values separately.
5. Select DS records using category and decision rules before aggregating; do not assume every DS record is an end-of-study disposition.
6. Merge subject-level derivations into the approved subject universe. Check cardinality before and counts after. Document exclusions and unresolved dates.
7. Apply final metadata and inspect one-row-per-subject, treatment/date/population relationships and source provenance.
8. QC against independent expectations; inspect logs if run. Only then provide ADSL as checked input to downstream skills.

## Output and handoff

Deliver SAS code, variable metadata, derivation notes, QC code/expected values and findings. Include counts for source/included/excluded subjects, reasons and open questions. Report actual datasets/logs only if executed.

ADSL is not “checked” solely because children agree with it. Reconcile actual treatment and populations independently with source evidence. Downstream skills must not silently rebuild or override ADSL flags.
