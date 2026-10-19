# SAS ADaM roadmap

| Milestone | Deliverable | Completion evidence |
| --- | --- | --- |
| 0: Rules and fixtures | Single-period synthetic study; explicit specifications and independent expected values | Input keys, counts, assumptions and expected decisions documented |
| 1: ADSL first | SAS ADSL skill, program and QC | Subject completeness, demographics, planned/actual treatment, exposure, populations, disposition checked |
| 2: BDS | SAS BDS skill with ADLB and ADVS references/examples | Parameter/unit consistency, baseline ties, missing/zero baseline, visit selection and changes checked |
| 3: OCCDS | SAS OCCDS skill with ADAE and ADCM references/examples | Source events retained, date uncertainty, TEAE and medication boundaries checked |
| 4: Integrated evaluation | Cross-dataset reconciliation and independent comparison | Seeded defects detected; clean controls pass; execution and limitations recorded |
| 5: PharmaSUG delivery | Held-out tasks and reproducible conference materials | Claims supported by recorded trials, reviewer effort and error metrics |

ADSL has priority in implementation and evaluation. BDS/OCCDS need both their own source SDTM and checked ADSL. ADSL defects can propagate consistently to all children; cross-dataset agreement must be supplemented with source-based expectations.

Version 1 uses general SAS 9.4 without sponsor-private macros. Start with an explicitly specified single-period study; do not silently generalize examples to crossover or complex exposure histories. Small examples are teaching artifacts; a full benchmark pipeline is a later deliverable.

Out of scope: raw-to-SDTM generation, TLF generation, efficacy models, ADTTE, oncology response, Define-XML production and full submission validation. Supporting standards retrieval and specification review remain embedded in dataset development.
