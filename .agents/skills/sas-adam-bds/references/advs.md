# ADVS

Use VS plus checked ADSL. Confirm parameter mapping including units, position, location and timepoint where these affect analysis. Do not average repeated readings or derive BMI unless specified.

Preserve VSSEQ, source visits and original date strings. Confirm predose assessment identification when dates lack time; same-day cannot establish predose timing by itself.

Derive analysis visits, baseline and selected records using documented rules. Check missing results, baseline ties, unscheduled measurements and BASE=0. Independent QC must verify which source record was selected, not only its value.

[Worked ADVS](../../../../examples/adam-core/programs/advs.sas) uses one synthetic pulse parameter; it carries source visits rather than applying visit windows.
