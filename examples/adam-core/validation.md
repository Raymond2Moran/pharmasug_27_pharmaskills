# Validation status

Authoring date: 2026-10-19. Initial SAS Viya runtime evidence was reviewed from
the generated SAS Output PDF on 2026-10-19. A fresh SAS Viya run, its generated
log and listing, and all seven negative scenarios were subsequently reviewed on
2026-10-19 through the VS Code SAS extension. No SAS executable was available
in the repository authoring environment, so local reproduction still requires
a SAS 9.4/Viya session.

| Evidence | Status |
| --- | --- |
| Skill format, relative links and YAML | Checked locally |
| SAS source, specifications and literal oracle review | Static review only |
| DATALINES row counts / widths / independent arithmetic | Checked without executing SAS |
| Python log-screen unit tests | Executed locally; tests screening only |
| SAS Viya compile/run and actual PROC COMPARE output | Fresh clean SYN001 run passed |
| Generated run.log and qc.lst review | Passed; no flagged diagnostics and completion marker present |
| Seven negative SAS scenarios | Executed; 7/7 intended defects detected |
| SVG XML and rendered layout | Checked locally |
| Full external CDISC conformance / CT validation | Not performed |
| Independent clinical/statistical reviewer sign-off | Not performed; waived for this bounded synthetic example |

Observed clean-run PROC COMPARE results from SAS Viya:

| Dataset | Records compared | Unequal observations |
| --- | ---: | ---: |
| ADSL | 12 | 0 |
| ADLB | 17 | 0 |
| ADVS | 12 | 0 |
| ADAE | 10 | 0 |
| ADCM | 11 | 0 |

Total ADaM records compared: 62. The ADVS comparison reported one value not
exactly equal, with maximum difference 3.0198E-14, which is below the predefined
numeric tolerance of 1E-10. This is treated as a floating-point precision
difference, not a QC failure.

Observed population checks matched the SYN001 specification: 12 total subjects,
ITTFL=Y for 11 subjects, SAFFL=Y for 10 subjects, one ITT-only subject and one
subject in neither population. The planned-versus-actual treatment table retained
the intended Placebo-planned/Drug-actual mismatch scenario. ADSL attribute checks
and critical metadata checks matched expected records; PROC COMPARE attribute
differences caused by labels in production datasets are evaluated separately
from derivation-value comparisons.

The fresh run used output directory `run_41DF699905EE465F_356`. Its generated
`run.log` contained 1,173 records and the diagnostic review returned zero
findings for errors, warnings and the selected suspicious notes. The completion
marker occurred exactly once. The generated `qc.lst` contained 455 records.
In addition to the five dataset value comparisons above, the 15 ADSL attribute
expectations and 22 critical metadata expectations had zero unequal
observations. Generated logs and SAS datasets remained in the ephemeral Viya
WORK area and are not committed to this repository.

Observed negative-control results:

| Scenario | Injected defect detected | Evidence |
| --- | --- | --- |
| `duplicate_dm` | Yes | One duplicate DM key identified |
| `bad_adsl` | Yes | One reference difference; SYSINFO=4128 |
| `propagated_adsl` | Yes | Two ADLB inheritance records identified |
| `wrong_baseline` | Yes | Three comparison-output records; SYSINFO=4128 |
| `bad_teae` | Yes | One reference difference; SYSINFO=4128 |
| `bad_ongoing` | Yes | One reference difference; SYSINFO=4128 |
| `orphan` | Yes | One orphan subject identified |

Each scenario produced its intended error followed by `%ABORT CANCEL`; none
reached the fallback message that the mutation was not detected. Scenarios were
submitted separately because a successful negative control deliberately aborts
the current submission.

Local review covered all 85 source fixture records and the selected expected
variables on all 62 target records. Independent arithmetic agreed with the
literal oracle; this is a specification/fixture consistency check, separate
from the Viya runtime evidence above. All four skill validators, 42 local
Markdown links and the three log-screen unit tests passed. ADSL attributes are
checked before downstream use; the propagation negative control alters both
treatment and safety membership consistently in ADSL and ADLB copies.

The project owner waived independent clinical/statistical reviewer sign-off for
this bounded synthetic teaching example. That waiver is not evidence of an
independent review, and the negative controls do not replace one. Broader
external CDISC/sponsor conformance assessment also remains unperformed. The
recorded evidence supports the clean SYN001 runtime and its authored QC
controls; it does not prove general study, submission or agent performance.
