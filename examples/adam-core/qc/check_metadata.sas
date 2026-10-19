/* Attribute evidence is separate from value comparisons. Full inventory is
   retained; the hand-specified critical subset below is machine-compared. */
proc contents data=adam._all_ out=qc.metadata noprint; run;
%stop_if_errors(metadata_inventory);
%assert_zero(data=qc.metadata,where=missing(label),id=unlabeled_variable);
data qc.expected_metadata;
  length MEMNAME $32 NAME $32 TYPE LENGTH 8 FORMAT $49 FORMATL 8 LABEL $256;
  infile datalines dlm='|' dsd truncover;
  input MEMNAME :$32. NAME :$32. TYPE LENGTH FORMAT :$49. FORMATL LABEL :$256.;
datalines;
ADSL|STUDYID|2|8||0|Study Identifier
ADSL|USUBJID|2|12||0|Unique Subject Identifier
ADSL|TRT01A|2|8||0|Actual Treatment for Period 01
ADSL|TRTSDT|1|8|DATE|9|Date of First Exposure
ADSL|ITTFL|2|1||0|Intent-To-Treat Population Flag
ADSL|SAFFL|2|1||0|Safety Population Flag
ADLB|PARAMCD|2|8||0|Parameter Code
ADLB|PARAM|2|40||0|Parameter
ADLB|AVALU|2|12||0|Analysis Value Unit
ADLB|ADT|1|8|DATE|9|Analysis Date
ADLB|BASE|1|8||0|Baseline Value
ADLB|ANRIND|2|6||0|Analysis Reference Range Indicator
ADVS|PARAMCD|2|8||0|Parameter Code
ADVS|AVALU|2|12||0|Analysis Value Unit
ADVS|ABLFL|2|1||0|Baseline Record Flag
ADVS|PCHG|1|8||0|Percent Change from Baseline
ADAE|ASTDT|1|8|DATE|9|Analysis Start Date
ADAE|TRTEMFL|2|1||0|Treatment Emergent Analysis Flag
ADAE|CLASSSTAT|2|32||0|Demonstration Classification Status
ADCM|AENDT|1|8|DATE|9|Analysis End Date
ADCM|PRIORFL|2|1||0|Prior Medication Flag (Local)
ADCM|CONCOMFL|2|1||0|Concomitant Medication Flag (Local)
;
run;
proc sql;
  create table work.actual_metadata as
  select m.MEMNAME, upcase(m.NAME) as NAME length=32,
         m.TYPE,m.LENGTH,m.FORMAT,m.FORMATL,m.LABEL
  from qc.metadata m inner join qc.expected_metadata e
    on m.MEMNAME=e.MEMNAME and upcase(m.NAME)=e.NAME;
quit;
%compare_reference(base=qc.expected_metadata,actual=work.actual_metadata,
  keys=MEMNAME NAME,vars=TYPE LENGTH FORMAT FORMATL LABEL,out=metadata_differences);
