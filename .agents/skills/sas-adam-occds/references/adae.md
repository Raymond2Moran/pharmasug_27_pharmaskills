# ADAE

Confirm the TEAE definition: onset window, treatment end extension, preexisting-event worsening and multi-period handling. If worsening data are required but absent, do not approximate worsening from severity alone.

Retain AESEQ, coded terms, severity/seriousness and original DTC. Treat MedDRA coding as supplied, not as a dictionary the skill may invent. Synthetic terms in examples are not licensed dictionary output.

Test onset on treatment start, on the final allowed day, before and after the window; partial/missing onset; untreated subjects; and repeated PT records with distinct AESEQ. Check flags against independent treatment dates as well as against ADSL.

[Worked ADAE](../../../../examples/adam-core/programs/adae.sas) implements an explicitly onset-only synthetic definition and does not infer worsening.
