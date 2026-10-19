---
name: pharma-skills-development
description: Plan, implement, and evaluate reusable pharma/CRO statistical programming agent skills for CDISC standards retrieval, SDTM/ADaM development, TLF generation, and independent QC. Use for developing this skills project or its component skills, rather than unrelated clinical advice or general statistical analyses.
---

# Pharma Skills Development

Develop a versioned, reviewable skills workflow for pharma/CRO statistical programming. The initial demonstration is synthetic SDTM DM/EX/AE → ADSL/ADAE → demographics and TEAE tables → independent QC. This is a development workflow, not a claim that generated programs or this skill are validated for production use.

## Start from the requested outcome

Inspect repository instructions, existing artifacts, and current milestone evidence. Preserve the project's structure and the user's chosen language and scope. Before editing analysis code, briefly state the statistical objective, inputs, outputs, and likely failure points.

- For roadmap or milestone work, read [references/roadmap.md](references/roadmap.md).
- For standards retrieval, derivation, code, or TLF work, read [references/implementation.md](references/implementation.md).
- For QC, benchmark design, or release assessment, read [references/evaluation.md](references/evaluation.md).
- When initializing a study, adapt [assets/study-context.yaml](assets/study-context.yaml); unresolved fields are intentional and must not become implicit analysis defaults.

Select the smallest complete deliverable that advances the requested milestone. A request to plan does not authorize implementing the entire roadmap. A request to implement calls for actual files and relevant execution, not just advice. Do not create placeholder component skills and report them as implemented.

## Preserve statistical intent

Treat the approved protocol/SAP, derivation specifications, and shells as the sources of study-specific analysis decisions. Separate those decisions from CDISC requirements and sponsor conventions. If sources conflict, surface the conflict rather than silently choosing a rule.

Flag unresolved populations, pairing, clustering, estimands, censoring, baseline, visit windows, partial dates, missingness, treatment assignment, and factor reference levels before implementing dependent logic. Continue independent work while seeking necessary clarification. For a demonstration, explicit synthetic assumptions may be proposed and labeled as such; never present them as approved study rules.

Pin standard model, IG, CT, and source-document versions. Do not equate the newest release with the study's applicable version. Cite verifiable authoritative evidence for standards claims; never invent sections or imply access to an unavailable guide.

Never overwrite raw data. Preserve subject/record counts, exclusions, join cardinality checks, derivation traceability, and uncertainty/diagnostics when inference is involved. Set and record a seed for synthetic data or resampling. Do not silently add dependencies or substitute a language when execution is unavailable.

## Build reusable skills

For each component, define its trigger, required inputs, concrete outputs, execution procedure, unresolved-input behavior, and validation evidence. Keep shared rules in this skill; put domain-specific detail in the component. Reuse existing project helpers and templates where they fit. If a skill-creation utility is available, use its format and validation guidance; otherwise use a SKILL.md with name/description frontmatter and focused linked resources.

Separate structured metadata lookup from narrative guide retrieval. Separate code generation from execution, and execution from correctness. For QC, share the approved specification but do not derive expected results from production implementation or outputs. A second prompt or a different language alone does not establish independence.

## Finish with evidence

Run the smallest relevant validation and examine the resulting artifacts. For generated code, distinguish syntax review, actual execution, numeric agreement, standards checks, and visual output review. Never claim checks that were not run.

Report what changed, the milestone advanced, validation performed, remaining statistical decisions, and limitations. Record durable milestone evidence in existing project tracking when available; otherwise add a concise project status file only when needed for multi-session work. Do not mark a milestone complete merely because instructions or code exist. Do not self-modify this skill unless the task includes improving it.
