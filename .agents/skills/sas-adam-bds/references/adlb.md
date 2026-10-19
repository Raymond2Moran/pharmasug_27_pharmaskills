# ADLB

Use LB plus checked ADSL. Confirm the approved list of tests, specimen/method distinctions and standardized units before mapping PARAMCD/PARAM. One parameter can require more than LBTESTCD to identify it.

Preserve LBSEQ and original dates; retain source units and limits needed to understand AVAL. Map standardized numeric results only when the unit agrees with parameter metadata. Nonnumeric results and below-quantification values need explicit handling.

Confirm baseline/visit rules, LBNRIND versus derived range categories, and sex/age/time-specific reference ranges. Normal-range classification is not toxicity grading. Do not import CTCAE or another grading rule without an explicit version and study requirement.

Check lower <= upper; missing limits leave range classification unresolved unless an approved rule says otherwise. Independently verify parameter mapping, baseline identity, BASE/CHG/PCHG and range boundaries.

[Worked ADLB](../../../../examples/adam-core/programs/adlb.sas) uses one synthetic ALT parameter and copied standardized limits. It does not model lab grading or complex range changes.
