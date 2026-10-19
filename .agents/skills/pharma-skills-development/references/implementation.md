# Standards and implementation workflow

## Evidence retrieval

Start with the study's pinned versions and the question being answered. Use official sources where available:

- SDTMIG: https://www.cdisc.org/standards/foundational/sdtmig
- ADaM: https://www.cdisc.org/standards/foundational/adam
- CDISC Library API documentation: https://www.cdisc.org/cdisc-library/api-documentation/oas3
- NCI CDISC terminology: https://www.cancer.gov/research/resources/terminology/cdisc

These are entry points, not evidence for every implementation rule. Verify current access, version coverage, and exact source content when used. API metadata does not necessarily contain the narrative guidance needed to resolve an implementation question. Use authorized local guides when online access is unavailable; do not redistribute licensed guide content or assume credentials exist.

For each substantive answer retain: question, standard/model/IG/CT version as relevant, source title and URL or local identifier, section/page or metadata locator, retrieval date, supported interpretation, and unresolved points. Distinguish direct requirements from your inference. If a relevant source cannot be read, state the gap and do not fabricate a definitive answer.

## Implementation contract

Before dependent coding, establish:

1. Inputs: dataset schema and keys, source provenance, approved SAP/spec/shell versions, study context.
2. Decisions: analysis population, planned/actual treatment, reference levels, date/window boundaries, missingness and partial-date handling, record selection, counting unit, and denominators.
3. Outputs: datasets and metadata, code, logs, numeric TLF results, rendered artifacts, and traceability.
4. Checks: expected key uniqueness and join cardinality, filtering/exclusion counts, reference examples, numerical tolerances, and runtime availability.

For an unresolved decision, record the question, affected outputs, source gap, and whether independent work can continue. Never use an unfilled configuration field as a runtime default.

## Safety MVP details

- ADSL: one row per subject; check population flags, treatment variables, exposure dates, and the provenance of demographic variables. Preserve counts before and after exclusions.
- ADAE: retain an event identifier and subject linkage; implement specified TEAE and partial-date rules. Preserve original dates and derivation/imputation flags as specified. Do not treat missing TEAE classification as false without an explicit rule.
- Demographics: document analysis population and denominator per variable/category; specify continuous summaries, missing-value presentation, and precision.
- TEAE: explicitly separate subject incidence from event frequency. Deduplicate at the required overall/SOC/PT level independently. Define denominators, zero cells, sorting, and treatment grouping.
- Joins: check expected cardinality before joining and counts afterward. Investigate unexpected duplication rather than deleting duplicates to make a check pass.

Keep numeric table cells separate from display formatting so QC can compare values before rounding. Validate titles, labels, treatment columns, footnotes, pagination, and clipping in rendered outputs. If rendering is unavailable, report visual verification as pending.

When expanding to inference, document model, estimand, analysis set, reference levels, missing-data strategy, SE/CI method, and multiplicity handling. Preserve sample sizes, exclusions, uncertainty, and model-specific diagnostics. Do not change these to obtain a successful run.
