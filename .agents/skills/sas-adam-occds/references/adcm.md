# ADCM

Confirm prior/concomitant definitions, any follow-up extension, ongoing evidence, partial-date handling and whether both classifications may apply. Concomitant is an interval-overlap decision, not merely a comparison of start dates.

Retain CMSEQ, medication/coding fields and original dates. Determine the observation boundary and distinguish explicit ongoing evidence from an unknown end date. Do not equate all missing ends with ongoing use.

Test medication wholly before treatment, beginning before and overlapping, starting/ending on treatment boundaries, beginning afterward, ongoing use, partial start/end dates and untreated subjects.

[Worked ADCM](../../../../examples/adam-core/programs/adcm.sas) uses local demonstration variables PRIORFL/CONCOMFL with Y/N/blank semantics defined in the example spec; these are not asserted as universally mandated CDISC names.
