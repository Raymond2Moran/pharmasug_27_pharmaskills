# QC and evaluation

## Independent reference construction

Use approved specifications and raw benchmark inputs to construct QC expectations. Do not copy production derivations or use production outputs as the expected result. Separate QC construction from comparison: production artifacts can be read during discrepancy investigation after QC expectations are fixed. Document any shared helpers or model context that limits independence.

For a small synthetic benchmark, manually calculate and review subject-level classifications and key table cells. Keep reference fixtures versioned and separate from implementation output. Fix a random seed if generating data, and preserve the data-generating assumptions.

## Required behavioral scenarios

| Scenario | Observable behavior |
| --- | --- |
| Missing TEAE window | Ask for the rule or label a proposed synthetic assumption; do not silently invent a study rule |
| Unavailable requested IG | Identify the evidence gap; do not fabricate a citation or substitute another version silently |
| Duplicate join keys | Detect unexpected cardinality and explain affected counts |
| Multiple events per subject/PT | Correctly distinguish subject incidence from event frequency |
| Wrong population denominator | Comparison identifies the affected table cells and denominator source |
| Boundary and partial dates | Follow explicit rules; preserve uncertainty/imputation information |
| Correct clean reference | Pass without spurious critical discrepancies |
| Runtime unavailable | Label code as unexecuted and identify the remaining verification |

Run relevant scenarios through the skill on actual tasks when possible. A checklist or frontmatter validator alone is not a behavioral evaluation. Use a temporary isolated workspace for smoke runs; do not contaminate benchmark truth with generated artifacts.

## Error injection

Introduce one known defect per test initially: wrong population, excluded treatment-start date, event-count instead of subject-count, duplicated join, unjustified date imputation, or swapped treatment display columns. Include negative controls without defects. Record which check detected each error and whether its explanation identifies the actual cause.

Classify discrepancies as input/spec ambiguity, standards/version issue, derivation, population/denominator, numeric precision, or presentation. Use exact comparison for identifiers, flags, and counts; predeclare justified tolerances for floating-point quantities. Do not hide substantive differences with broad tolerances.

## Conference evaluation

Compare a generic agent, an agent with domain skills, and an agent with domain skills plus retrieval and QC. Hold model/version, task inputs, runtime, and budget as constant as practical. Preserve prompts, seeds where supported, skill versions, source versions, execution logs, and timing. Repeat stochastic runs when feasible and report variability and failed runs.

Separate development cases from held-out evaluation cases. Report:

- Executable tasks / attempted tasks.
- Correct critical derivations and cells / evaluated derivations and cells, with denominators and severity.
- Supported citations / assessed citations, and version accuracy.
- Detected seeded defects / seeded defects; false alarms / clean cases.
- Human correction counts and review time under a stated review procedure.

Predefine acceptance thresholds for the task's risk and review context. An initial MVP should resolve critical reference discrepancies before claiming completion. Neither standards conformance alone nor benchmark success establishes regulatory suitability or production validation.
