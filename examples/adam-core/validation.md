# Validation status

Authoring date: 2026-10-19. No SAS executable found in the authoring environment.

| Evidence | Status |
| --- | --- |
| Skill format, relative links and YAML | Checked locally |
| SAS source, specifications and literal oracle review | Static review only |
| DATALINES row counts / widths / independent arithmetic | Checked without executing SAS |
| Python log-screen unit tests | Executed locally; tests screening only |
| SAS compile/run and actual PROC COMPARE output | Pending SAS 9.4 |
| Seven negative SAS scenarios | Authored; execution pending |
| SVG XML and rendered layout | Checked locally |
| Full external CDISC conformance / CT validation | Not performed |
| Independent clinical/statistical reviewer sign-off | Not performed |

Expected clean-run counts (not observed SAS results): DM 12, EX 11, DS 12,
LB 17, VS 12, AE 10, CM 11; ADSL 12, ADLB 17, ADVS 12, ADAE 10, ADCM 11.
Expected populations: ITT 11 and safety 10. Six uncertain occurrence
classifications should remain in the issue listing.

Local review covered all 85 source fixture records and the selected expected
variables on all 62 target records. Independent arithmetic agreed with the
literal oracle; this is a specification/fixture consistency check, not SAS
execution evidence. All four skill validators, 42 local Markdown links and
the three log-screen unit tests passed. ADSL attributes are checked before
downstream use; the propagation negative control alters both treatment and
safety membership consistently in ADSL and ADLB copies.

Before claiming SAS verification, run in a fresh SAS 9.4 session; retain runtime
version, run.log and qc.lst; inspect all diagnostics; verify oracle comparisons,
metadata and source links; then run each negative case on copies and confirm
the intended check catches it. Record command, environment, actual counts and
findings here. Do not replace pending entries with inferred successes.
