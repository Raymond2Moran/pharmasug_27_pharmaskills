/* E01: Onset-only TEAE within [TRTSDT, TRTEDT + 30], inclusive.
   Pre-treatment worsening is NOT part of this synthetic endpoint definition. */
%assert_unique(data=sdtm.ae,keys=%str(STUDYID,USUBJID,AESEQ),id=ae_duplicate);
%assert_zero(data=sdtm.ae,where=missing(STUDYID) or missing(USUBJID) or missing(AESEQ),id=ae_missing_key);
%assert_subjects(data=sdtm.ae);
proc sort data=sdtm.ae out=work.ae_sorted; by STUDYID USUBJID AESEQ; run;
data adam.adae;
  length STUDYID $8 USUBJID $12 AESEQ 8 AETERM AEDECOD $24
         AEBODSYS $32 AESEV $8 AESER $1 AESTDTC AEENDTC $10
         TRT01A $8 TRT01AN TRTSDT TRTEDT 8 ITTFL SAFFL $1
         ASEQ ASTDT AENDT ASTDY AENDY 8 TRTEMFL $1 CLASSSTAT $32;
  merge work.ae_sorted(in=in_source)
        adam.adsl(keep=STUDYID USUBJID TRT01A TRT01AN TRTSDT TRTEDT ITTFL SAFFL);
  by STUDYID USUBJID;
  if in_source;
  %exact_date(AESTDTC,ASTDT);
  %exact_date(AEENDTC,AENDT);
  %relative_day(ASTDT,TRTSDT,ASTDY);
  %relative_day(AENDT,TRTSDT,AENDY);
  ASEQ=AESEQ; TRTEMFL=''; CLASSSTAT='UNRESOLVED DATES';
  if SAFFL='N' then do; TRTEMFL='N'; CLASSSTAT='NO EXPOSURE'; end;
  else if nmiss(ASTDT,TRTSDT,TRTEDT)=0 then do;
    TRTEMFL='N';
    if ASTDT >= TRTSDT and ASTDT <= TRTEDT+30 then TRTEMFL='Y';
    CLASSSTAT='CLASSIFIED';
  end;
  format ASTDT AENDT date9.;
  label STUDYID='Study Identifier' USUBJID='Unique Subject Identifier'
    AESEQ='Source AE Sequence Number' ASEQ='Analysis Sequence Number'
    AETERM='Reported Adverse Event' AEDECOD='Supplied Preferred Term'
    AEBODSYS='Supplied Body System' AESEV='Severity' AESER='Serious Event'
    AESTDTC='Source AE Start Date Text' AEENDTC='Source AE End Date Text'
    ASTDT='Analysis Start Date' AENDT='Analysis End Date'
    ASTDY='Analysis Start Relative Day' AENDY='Analysis End Relative Day'
    TRTEMFL='Treatment Emergent Analysis Flag'
    CLASSSTAT='Demonstration Classification Status';
run;
%stop_if_errors(adae);
%assert_count(data=adam.adae,expected=10);
%assert_unique(data=adam.adae,keys=%str(STUDYID,USUBJID,ASEQ),id=adae_duplicate);
%assert_zero(data=adam.adae,where=not missing(ASTDT) and not missing(AENDT) and AENDT < ASTDT,id=ae_interval);
