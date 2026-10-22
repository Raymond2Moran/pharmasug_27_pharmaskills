# SAS ADaM Core Dataset Skills

This PharmaSUG 2027 project provides a set of agent skills for **developing and
checking ADaM datasets in SAS, guided by approved study specifications**. It
follows an ADSL-first workflow and currently covers five datasets: ADSL,
ADLB, ADVS, ADAE and ADCM. “Core” describes the scope of this project.

The skills are intended for statistical programmers in CROs and pharmaceutical
companies. They use existing SDTM datasets and approved study documents to
guide SAS programming, metadata preparation, derivation documentation and QC.

## Aim and scope

| Priority | Structure / datasets | Initial capabilities |
| --- | --- | --- |
| First | ADSL | Subject completeness, demographics, planned/actual treatment, exposure dates, populations and disposition |
| Next | BDS: ADLB, ADVS | Parameter mapping, analysis dates/visits, baseline selection, BASE/CHG/PCHG, analysis flags and laboratory normal ranges |
| Next | OCCDS: ADAE, ADCM | Occurrence records, source dates, date uncertainty, treatment-emergent AE and prior/concomitant medication classifications |

ADSL is developed and checked first, then supplies subject-level treatment and
population information to the downstream datasets. ADLB and ADVS also require
LB and VS; ADAE and ADCM require AE and CM.

The skills target Base SAS 9.4 and do not depend on external sponsor macro
libraries. Shared guidance covers standards references, specification review,
SAS conventions and QC.

The current scope excludes raw-to-SDTM development, TLF production, ADTTE,
tumor response, complex multi-period treatment algorithms and full submission
packaging.

## Skills and usage

| Skill | Role |
| --- | --- |
| [pharma-skills-development](.agents/skills/pharma-skills-development/SKILL.md) | Project roadmap, shared conventions, standards evidence and routing |
| [sas-adam-adsl](.agents/skills/sas-adam-adsl/SKILL.md) | Develop and independently check subject-level ADSL |
| [sas-adam-bds](.agents/skills/sas-adam-bds/SKILL.md) | Develop ADLB/ADVS using checked ADSL and source findings |
| [sas-adam-occds](.agents/skills/sas-adam-occds/SKILL.md) | Develop ADAE/ADCM using checked ADSL and source occurrences |

Each dataset skill can be invoked directly. Keep the skill bundle together
because the dataset skills use shared references in
`pharma-skills-development`.

Use the [study-context template](.agents/skills/pharma-skills-development/assets/study-context.yaml)
to record study-specific rules, document versions and unresolved decisions.

```text
Use $sas-adam-adsl to develop ADSL from the supplied DM, EX and DS,
following this study's approved specification. Identify missing decisions
and provide SAS code, traceability, and independent QC expectations.
```

```text
Use $sas-adam-bds to develop ADLB and ADVS from LB, VS and checked ADSL.
Use the supplied parameter, baseline and visit rules; preserve source links.
```

```text
Use $sas-adam-occds to develop ADAE and ADCM from AE, CM and checked ADSL.
Apply the specified TEAE and medication interval rules and expose uncertainty.
```

## Workflow

<p align="center">
  <img
    src="assets/pharma-skills-workflow.svg"
    alt="SAS ADaM workflow"
    width="700"
  />
</p>

The workflow starts with source-data checks and specification review. ADSL is
then developed and checked before its subject-level variables are used in
ADLB, ADVS, ADAE and ADCM.

QC addresses dataset structure, metadata, derivations, cross-dataset consistency
and SAS logs. Source-based expectations supplement checks against ADSL so that
an error carried consistently into downstream datasets can still be detected.
Discrepancies lead to review of the relevant rules and code, followed by
rerunning the affected checks.

The workflow diagram was created following the
[svg-diagram skill](https://github.com/bybit-exchange/svg-diagram).

## Worked SAS example


The [worked example](examples/adam-core/README.md) demonstrates the workflow
with 12 synthetic subjects and SDTM-shaped DM, EX, DS, LB, VS, AE and CM data.
It includes:

- SAS programs for all five ADaM datasets and shared helper code.
- A runner that executes programs and checks in dependency order.
- An explicit [synthetic study specification](examples/adam-core/specification.md).
- Hand-authored expected values, metadata checks and source reconciliation.
- Seven negative scenarios that test whether QC detects deliberately introduced defects.
- A Python utility for screening SAS logs.

The expected values are authored separately from the production outputs.
The example illustrates the specified synthetic study rules; adapting it to
another study requires review of that study's inputs and approved decisions.

From the repository root, in an environment with SAS installed:

```sh
sas -sysin examples/adam-core/run_all.sas
```

### Existing skills and our contribution

Public-source review date: **2026-10-19**. The nearest related work is
[R Consortium Pharma Skills](https://github.com/RConsortium/pharma-skills):

| Related skill | Existing capability | Relationship to this project |
| --- | --- | --- |
| [admiral family](https://github.com/RConsortium/pharma-skills/blob/main/admiral/SKILL.md), including ADSL, BDS and ADAE | R ADaM derivations through `{admiral}`, shared conventions and dataset-specific guidance | Demonstrates that ADaM category routing and derivation skills already exist; our execution examples target SAS |
| [statistical-reviewer](https://github.com/RConsortium/pharma-skills/blob/main/statistical-reviewer/SKILL.md) | Reviews results and traces TLF/ADaM/SDTM against study documents | Related QC work; our scope is dataset construction with a small independent fixture oracle |
| [sdtm-oak](https://github.com/RConsortium/pharma-skills/blob/main/sdtm-oak/SKILL.md) | R raw-to-SDTM mapping using `{sdtm.oak}` | Upstream work; our first release starts with existing SDTM |

This project's contribution is a SAS-focused implementation of an ADSL-first
skill workflow across ADSL, ADLB, ADVS, ADAE and ADCM. It connects approved
specifications with reviewable SAS code, derivation traceability,
cross-dataset checks and independently authored QC expectations. The worked
example also demonstrates log screening and detection of selected defects.

The project draws on established patterns such as focused dataset guidance,
explicit inputs and traceable QC. Study rules are defined explicitly rather
than inherited from another package's defaults. The examples require no
third-party skills or R packages.

While reviewing existing agent skills and bundles, we did not identify a SAS skill bundle with the same
combination of scope and deliverables. This observation is limited to the sources reviewed and does not 
establish novelty or priority.

## Current status and verification

The repository includes four skills, shared references, a study-context
template, SAS programs for all five datasets, QC programs, negative scenarios
and a workflow diagram.

Local checks covered skill structure, YAML, relative links, source and
specification consistency, fixture counts, reference arithmetic, Python
log-screen tests and SVG rendering.

The [validation record](examples/adam-core/validation.md) documents a SAS Viya
run of the synthetic SYN001 example completed on **2026-10-19**:

- All five datasets passed the specified PROC COMPARE checks, with zero
  unequal observations across 62 target records.
- One ADVS floating-point difference was within the predefined numeric tolerance.
- ADSL population, attribute and critical metadata checks matched expectations.
- The generated log had no flagged diagnostics and contained exactly one
  completion marker.
- All seven negative scenarios detected their intended injected defects.

These results support the documented SYN001 example and its QC controls.
They do not establish performance across other studies or agent runs.
Independent clinical/statistical reviewer sign-off was waived for this
teaching example, and broader CDISC/sponsor conformance assessment has not
been performed. Generated SAS datasets and execution logs are not included
in the repository.
