---
name: pharma-skills-development
description: Plan, implement, and evaluate this SAS ADaM core-dataset skills project. Prioritize ADSL, then BDS ADLB/ADVS and OCCDS ADAE/ADCM, with specification-driven derivations, traceability, and QC. Use for project development and routing; use dataset skills for study programming.
---

# SAS ADaM Core Dataset Skills Development

Build reusable SAS 9.4 skills for ADaM dataset development. ADSL is the first priority and the subject-level foundation for downstream BDS (ADLB, ADVS) and OCCDS (ADAE, ADCM). “Core” names this project's selected scope, not a mandatory CDISC dataset list.

## Select the deliverable

Inspect repository instructions, study inputs, and milestone evidence. Before changing analysis code, state the statistical purpose, inputs, outputs, and likely failure points. Preserve approved definitions and existing project conventions.

- Planning milestones: read [roadmap](references/roadmap.md).
- Developing derivations or researching standards: read [implementation](references/implementation.md).
- Writing SAS: read [SAS conventions](references/sas-conventions.md).
- QC or evaluation: read [evaluation](references/evaluation.md).
- Initializing study context: adapt [study-context template](assets/study-context.yaml); null means unresolved.

Route study programming to:
- [sas-adam-adsl](../sas-adam-adsl/SKILL.md): DM/EX/DS and study metadata → ADSL.
- [sas-adam-bds](../sas-adam-bds/SKILL.md): LB/VS plus checked ADSL → ADLB/ADVS.
- [sas-adam-occds](../sas-adam-occds/SKILL.md): AE/CM plus checked ADSL → ADAE/ADCM.

The skills form a repository bundle with relative shared references. Each dataset skill can be invoked directly; retain the shared folder when distributing them. Routing does not itself authorize spawning agents.

## Scope and statistical decisions

Use existing SDTM as input. Raw-to-SDTM development, TLF production, ADTTE, tumor response, multi-period treatment algorithms, and submission packaging are outside v1. Standards lookup and specification review support ADaM derivations; QC is part of every dataset skill.

Pin model, IG, OCCDS guide, CT, and study-document versions. Separate CDISC requirements, sponsor conventions, and study choices. Ask about unresolved population, treatment, baseline, visit, partial-date, imputation, and occurrence-classification rules before implementing dependent logic. Continue unaffected work. Do not import universal flag encodings or imputation defaults from examples or another language's package.

Preserve raw inputs and source identifiers; check keys and join cardinality before merging. Track subject/record counts, exclusions, missingness, and derivation provenance. Checked ADSL is a prerequisite, not the sole input to downstream datasets.

## Build and assess

Deliver actual skill instructions, focused references, SAS code, metadata, traceability, and QC examples appropriate to the task. Use [the small worked study](../../../examples/adam-core/README.md) as an explicitly synthetic example, not a general algorithm or a validated benchmark.

Verify structure, metadata, derivations, cross-dataset consistency, and logs separately. Independent expected values must come from the specification and inputs, not production output. PROC COMPARE agreement alone cannot establish correctness.

Report exactly which checks ran. No SAS runtime means unexecuted SAS, not a successful run inferred from another language. Keep milestone evidence current, distinguish planned capabilities from delivered artifacts, and do not commit or publish without task authorization.
