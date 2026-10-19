# ADaM QC and evaluation

Assess structure/keys, metadata, derivation values and execution/logs separately. Add cross-dataset reconciliation after ADSL-specific checks.

## Independent expectations

Construct truth from specifications and sources before viewing generated outputs. The example uses manually authored expectations for all 12 ADSL subjects and selected variables on every BDS/OCCDS fixture record; this is partial variable coverage, not a complete independent implementation.

For real studies, keep production implementation out of QC logic construction. Inspect production during discrepancy investigation after expectations are fixed. Document shared helpers and ADSL dependencies.

## Behavioral scenarios

| Case | Required behavior |
| --- | --- |
| Duplicate/missing DM key | Stop before ambiguous merging; retain offending keys |
| Untreated or planned/actual treatment mismatch | Preserve eligible subjects and use specified treatment/population evidence |
| Missing/partial/invalid dates | Preserve source text; no unauthorized imputation; expose uncertainty |
| Missing baseline/result | No invented baseline or change |
| Baseline/visit tie | Documented deterministic tie-break, not input order |
| BASE = 0 | Percent change undefined; no division by zero |
| Similar events with distinct SEQ | Preserve separate source records |
| TEAE boundary or pre-treatment worsening | Apply approved window/worsening rules; unknown is not automatically false |
| Medication before/across/after treatment | Explicit interval and ongoing rules |
| Orphan child or changed inherited flag | Detect unmatched keys and inconsistent ADSL inheritance |
| Corrupted ADSL propagated to children | Source-based expectations still detect the error |
| No SAS runtime | Label SAS unexecuted and checks pending |

Inject defects only on copies: duplicate DM key, altered population/treatment, wrong baseline, zero-baseline division, removed missing-date guard, wrong TEAE endpoint, or wrong ongoing classification. Include clean controls and record the responsible check.

## Reports and acceptance

Each finding includes ID, dataset/key/variable, expected/actual, rule/source, severity, affected subjects and follow-up. Separate expected fixture uncertainties from programming defects. Report checked and unchecked variables.

Compare keys/dates/flags/counts exactly; predeclare tolerances for other numerics. Attribute checks are independent. Agreement cannot excuse wrong selection.

For conference evaluation, compare a generic agent, dataset skills, and skills plus retrieval/QC on held-out tasks with comparable inputs/model/runtime/budget. Record execution rate, critical derivation correctness, metadata/key errors, defect detection/false alarms, citation support and review effort. Preserve failures and run variability.

Authoring completion requires skills, examples, reference values and static checks. “SAS verified” additionally requires actual SAS execution, inspected logs, passing comparisons and independent review. Conformance or one successful example does not establish universal production validation.
