/* Run BEFORE any child dataset. Explicit expected values, no production code. */
%compare_reference(base=qc.expected_adsl,actual=adam.adsl,
  keys=STUDYID USUBJID,
  vars=SUBJID SEX AGE TRT01P TRT01PN TRT01A TRT01AN TRTSDT TRTEDT ITTFL SAFFL EOSSTT EOSDT,
  out=adsl_differences);
/* Check the ADSL attribute contract before downstream programs can use it.
   The independently declared oracle supplies types, lengths and formats. */
proc contents data=adam.adsl
  out=work.adsl_attributes(keep=NAME TYPE LENGTH FORMAT FORMATL LABEL) noprint;
run;
proc contents data=qc.expected_adsl
  out=work.adsl_expected_attributes(keep=NAME TYPE LENGTH FORMAT FORMATL) noprint;
run;
%stop_if_errors(adsl_attributes);
%assert_zero(data=work.adsl_attributes,where=missing(LABEL),id=adsl_labels);
%compare_reference(base=work.adsl_expected_attributes,actual=work.adsl_attributes,
  keys=NAME,vars=TYPE LENGTH FORMAT FORMATL,out=adsl_attribute_differences);
proc sql;
  create table qc.population_counts as
  select count(*) as subjects, sum(ITTFL='Y') as itt, sum(SAFFL='Y') as safety
  from adam.adsl;
quit;
%assert_zero(data=qc.population_counts,where=subjects ne 12 or itt ne 11 or safety ne 10,id=population_counts);
