# Development roadmap

Use milestone evidence rather than dates to choose the next step. Phases can overlap when independent work is useful; the user may explicitly prioritize a different component.

| Phase | Deliverable | Exit evidence |
| --- | --- | --- |
| 0: Scope and benchmark | Synthetic safety study, chosen execution language, documented specifications, manually reviewed expected results | Reproducible fixtures; analysis decisions explicit; expected results independent of generated code |
| 1: Standards Navigator | Version-constrained retrieval and cited answers | Correct source/version/section on representative questions; explicit handling of unavailable or conflicting evidence |
| 2: ADaM and TLF | ADSL/ADAE and demographics/TEAE tables from synthetic DM/EX/AE | Executed code; correct populations, derivations, denominators, cell values, and rendered layout |
| 3: Independent QC | Independent derivations and discrepancy reports | Critical seeded errors detected; false positives measured; clean benchmark also passes |
| 4: SDTM development | Limited raw-source mapping to DM/AE, extending to EX as needed | Source metadata and mapping supplied; keys, mappings, controlled terminology, traceability checked |
| 5: Extension and communication | Additional domains, BDS, efficacy/TTE, reproducible conference materials | Held-out tasks evaluated; claims supported by recorded evidence; tutorial reproducible |

## Component boundaries

- Standards Navigator: answer standards questions with versioned evidence; distinguish requirements, recommendations, and examples.
- Specification Reviewer: identify omissions and conflicts across SAP, specs, shells, and study context; do not resolve analysis choices without an explicit basis.
- SDTM Developer: implement approved source mappings, retaining source-to-target traceability.
- ADaM Developer: implement approved analysis derivations and preserve record-level lineage where appropriate.
- TLF Developer: implement shell and analysis requirements, exposing numeric results separately from rendering.
- Independent QC: independently derive expected datasets/cells and classify discrepancies.

## Initial scope

Use descriptive safety reporting first. Include repeated AE records, no-event subjects, zero-count categories, missing covariates, treatment-date boundaries, and partial dates with explicitly specified handling. Synthetic coded SOC/PT values may be used without suggesting that a licensed medical dictionary was obtained or applied.

Choose one runnable language first. If the user has not selected one, inspect the repository/runtime and explain the proposed choice. Expand to cross-language comparison only when both runtimes and relevant expertise are available. Adding a language is not a substitute for independent specifications and reference results.

Do not expand into broad efficacy inference, submission packaging, or enterprise integrations until requested or the preceding evidence supports that scope.
