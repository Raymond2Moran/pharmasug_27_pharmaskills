# ADaM implementation contract

## Evidence and authority

Start from the study's pinned versions. Authoritative entry points:
- [CDISC ADaM](https://www.cdisc.org/standards/foundational/adam)
- [OCCDS v1.1](https://www.cdisc.org/standards/foundational/adam/adam-structure-occurrence-data-implementation-guide-v1-1)
- [CDISC Library](https://www.cdisc.org/cdisc-library/api-documentation/oas3)
- [NCI CDISC terminology](https://www.cancer.gov/research/resources/terminology/cdisc)

Read the actual relevant source before attributing a rule. Record document/version, section or metadata locator, URL/local identifier and retrieval date. Metadata APIs do not replace narrative guidance. If the requested guide is unavailable, name the gap; do not invent a citation or substitute a different version silently. Do not redistribute licensed guides.

Approved protocol/SAP/specifications govern study decisions; identify conflicts for resolution rather than silently choosing precedence. Model/guide rules, CT, sponsor conventions and synthetic choices must be labeled separately.

## Inputs and outputs

Inputs: target datasets; SDTM datasets and keys; approved derivation spec/SAP/protocol; variable/parameter metadata; treatment/population definitions; date, visit, baseline and occurrence rules; SAS runtime and sponsor conventions if applicable.

Outputs: readable .sas code, dataset attributes, source-to-target derivation notes, checks and discrepancy report. Actual derived datasets and logs require execution. Distinguish missing specification, missing source data and missing runtime.

For each target variable retain source domain/variable, join keys, transformation or rule ID, metadata, and the QC expectation. Preserve source sequence numbers and DTC strings where relevant. Complex derived records require explicit lineage, not a fabricated one-to-one source sequence.

## Decisions to resolve before dependent coding

- ADSL: subject inclusion, randomization evidence, planned/actual treatment, exposure aggregation, population definitions and disposition record selection.
- BDS: parameter/unit mapping, analysis date/time, baseline eligibility and ties, visit windows and ties, analysis flags, missing values and zero BASE handling.
- OCCDS: date completion/imputation and flags, TEAE window and worsening rules, medication prior/concomitant definitions, open-ended intervals and treatment periods.
- All: flag-specific allowed values, output types/lengths/labels/formats, exclusions, source links and numerical tolerances.

Do not silently translate uncertain classification into “N”. Do not assume all flags use Y/N or Y/blank. Ask for a variable-specific rule with its basis.

## Shared sequence

Inspect sources → confirm rules and metadata → check source keys → build ADSL → independently check ADSL → build requested BDS/OCCDS from source plus ADSL → compare against independent expectations → reconcile shared variables and counts → report evidence.

For existing ADSL, inspect its checks and provenance rather than unnecessarily rebuilding it. If required ADSL fields are invalid or unsupported, block affected downstream derivations and explain why. Keep unresolved records visible in an issue listing.
