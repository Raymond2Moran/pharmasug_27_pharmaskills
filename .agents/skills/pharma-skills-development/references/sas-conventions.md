# Shared SAS 9.4 conventions

Use Base SAS DATA steps, PROC SORT/SQL/FREQ/CONTENTS/COMPARE as appropriate. Do not assume licensed add-on products, Viya services or private macros. Inspect provided macro interfaces before reuse.

## Code and data safety

- Declare output character lengths before SET/MERGE, and apply labels/formats explicitly. Never shorten values silently; check metadata separately from data comparisons.
- Use configured relative paths and never write to input libraries. Sort copies with OUT=; do not use NODUPKEY to hide unexpected duplicates.
- Check complete keys, uniqueness and join cardinality before merging. Check unmatched subjects and before/after counts. DATA step many-to-many MERGE and SQL joins are not interchangeable.
- Avoid implicit conversions and source name collisions. Select only needed ADSL columns during child merges and preserve source SEQ.
- Missing numerics sort below ordinary numbers in SAS. Use NOT MISSING guards in comparisons and divisions; never classify unknown dates as before treatment accidentally.
- Parse documented date forms only. Preserve partial DTC strings. Impute only under an approved rule and retain its imputation flag. Suppression of invalid-data notes must be paired with explicit invalid-date checks.
- Use /* REVIEW: rule ID, source and decision */ at study-specific branches; annotations do not approve a rule.
- Record source/final counts and exclusions. Record a seed for random fixtures; fixed DATALINES need no seed.

## Execution and evidence

Use an explicit dependency order and a fresh output folder. Preserve SAS version, logs, comparisons and metadata. Check errors after stages and fail rather than continuing with missing/stale datasets.

Review ERROR, WARNING and diagnostic NOTEs: uninitialized variables, invalid values, conversions, missing-value generation, truncation and repeated BY values. A clean log does not prove correctness. Static review cannot certify SAS syntax or numeric behavior.

Use PROC COMPARE with explicit ID keys, selected variables, justified absolute tolerance, difference datasets and captured SYSINFO. Counts, flags and identifiers require exact agreement. Check metadata independently.

## QC independence

Freeze expectations from spec and sources before reading production outputs. Prefer manually enumerated expectations for the small fixture. Shared production helpers or a shared wrong ADSL can make pipelines agree incorrectly. Document shared dependencies.

The [example runner](../../../../examples/adam-core/run_all.sas) is a bounded teaching workflow, not a universal study runner. Keep the repository bundle together.
