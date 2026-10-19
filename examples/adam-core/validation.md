# Validation status

Authoring date: 2026-10-19. Initial SAS Viya runtime evidence was reviewed from
the generated SAS Output PDF on 2026-10-19. No SAS executable was available in
the repository authoring environment, so local reproduction still requires a
SAS 9.4/Viya session.

| Evidence | Status |
| --- | --- |
| Skill format, relative links and YAML | Checked locally |
| SAS source, specifications and literal oracle review | Static review only |
| DATALINES row counts / widths / independent arithmetic | Checked without executing SAS |
| Python log-screen unit tests | Executed locally; tests screening only |
| SAS Viya compile/run and actual PROC COMPARE output | Initial clean SYN001 run observed |
| Seven negative SAS scenarios | Authored; execution pending |
| SVG XML and rendered layout | Checked locally |
| Full external CDISC conformance / CT validation | Not performed |
| Independent clinical/statistical reviewer sign-off | Not performed |

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

Local review covered all 85 source fixture records and the selected expected
variables on all 62 target records. Independent arithmetic agreed with the
literal oracle; this is a specification/fixture consistency check, separate
from the Viya runtime evidence above. All four skill validators, 42 local
Markdown links and the three log-screen unit tests passed. ADSL attributes are
checked before downstream use; the propagation negative control alters both
treatment and safety membership consistently in ADSL and ADLB copies.

Before claiming complete SAS verification, run in a fresh SAS 9.4 or Viya
session; retain runtime version, run.log and qc.lst; inspect all diagnostics;
verify oracle comparisons, metadata and source links; then run each negative
case on copies and confirm the intended check catches it. Record command,
environment, actual counts and findings here. Do not replace pending entries
with inferred successes.

Remaining gaps after the initial Viya clean run: complete run.log review,
negative-case execution, independent reviewer sign-off and broader external
CDISC/sponsor conformance assessment. The evidence validates this bounded
synthetic fixture only; it does not prove general study or agent performance.
