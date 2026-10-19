# SAS ADaM core worked example

This is a small, specification-driven teaching example for ADSL, ADLB, ADVS,
ADAE and ADCM. Read [SYN001-SPEC-1](specification.md) before running or adapting
it. It uses 12 synthetic subjects and minimal SDTM-shaped data; it is not a
submission dataset generator or a fully validated benchmark pipeline.

## Run with SAS 9.4

Start from the repository root in an environment with Base SAS:

```sh
sas -sysin examples/adam-core/run_all.sas
```

In SAS Viya, `setup_viya.sas` can bootstrap the runtime files into WORK from
the GitHub `main` branch and then include `run_all.sas`:

```sas
%include "<path-to-repo>/examples/adam-core/setup_viya.sas";
```

Use a pinned commit or reviewed local checkout when controlled validation
requires reproducibility.

In an existing SAS session, define PROJECT_ROOT to the checkout directory and
include run_all.sas. The default is the current working directory. No external
macro library, package or network connection is required. All fixtures use fixed
DATALINES; the workflow contains no random generation.

The runner creates a fresh directory under output/, writes synthetic source
datasets, then reopens the source library read-only. It runs ADSL and its oracle
first, followed by ADLB/ADVS/ADAE/ADCM and integrated checks. A detected failure
aborts the run and preserves artifacts. No prior run is overwritten.

Each run contains:

- sdtm/: synthetic source datasets.
- adam/: the five derived datasets.
- qc/: expected values, comparison differences, metadata inventory and checks.
- run.log and qc.lst: execution evidence and PROC output.

After execution, review the log and run the optional standard-library Python
diagnostic screen using the actual run-directory path:

```sh
python3 examples/adam-core/scripts/check_sas_log.py <run-directory>/run.log
```

The screen flags errors, warnings and selected suspicious notes. A missing
completion marker is also flagged. A clean screen does not establish analysis
correctness or replace human log review. Avoid source echo when using this
scanner; the example runner disables source and macro echo.

## QC examples and limits

[expected.sas](qc/expected.sas) contains hand-authored values independent of
production outputs and helpers. ADSL is checked for every subject. Selected
critical variables cover every BDS/OCCDS fixture row; the specification lists
coverage limits. PROC COMPARE status is captured immediately, and value failures
are fatal. Metadata is checked separately. Comparisons do not by themselves
establish the correctness of the specification.

For negative controls, after a clean run in the same SAS session:

```sas
%let scenario=duplicate_dm;
%include "&example_root/qc/negative_cases.sas";
```

Run one scenario at a time: duplicate_dm, bad_adsl, propagated_adsl,
wrong_baseline, bad_teae, bad_ongoing, or orphan. The propagation case corrupts
both ADSL and the child consistently, then checks against independent truth.
Each deliberately fails on a WORK copy; inspect the
named check rather than treating any abort as proof of detection. The script
reports a distinct error if the intended check fails to catch the mutation.

## Verification status

Authored: source fixtures, five production programs, shared Base SAS helpers,
runner, independent expected values, metadata/source reconciliation checks and
negative cases. Static review and Python log-screen tests are possible locally.

SAS Viya runtime validation was completed on **2026-10-19** for the SYN001
fixture. PROC COMPARE checks passed for ADSL, ADLB, ADVS, ADAE and ADCM with
zero unequal observations across 62 target records; critical metadata checks
also passed. Review of the generated run.log found no flagged diagnostics and
exactly one completion marker. All seven negative scenarios detected their
intended injected defects. The project owner waived independent reviewer
sign-off for this bounded teaching example; no independent review or broader
CDISC/sponsor conformance is claimed. No derived .sas7bdat files or fabricated
execution logs are included. See [validation status](validation.md).
