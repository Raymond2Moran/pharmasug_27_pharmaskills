/* C01-C03: prior starts before first dose; concomitant overlaps the inclusive
   treatment interval. No follow-up extension. Ongoing is confirmed at 31JAN2025.
   PRIORFL, CONCOMFL and CLASSSTAT are documented local demonstration variables. */
%assert_unique(data=sdtm.cm,keys=%str(STUDYID,USUBJID,CMSEQ),id=cm_duplicate);
%assert_zero(data=sdtm.cm,where=missing(STUDYID) or missing(USUBJID) or missing(CMSEQ),id=cm_missing_key);
%assert_subjects(data=sdtm.cm);
proc sort data=sdtm.cm out=work.cm_sorted; by STUDYID USUBJID CMSEQ; run;
data adam.adcm;
  length STUDYID $8 USUBJID $12 CMSEQ 8 CMTRT $24
         CMSTDTC CMENDTC $10 CMENRF $8 TRT01A $8
         TRT01AN TRTSDT TRTEDT 8 ITTFL SAFFL $1
         ASEQ ASTDT AENDT ASTDY AENDY 8 PRIORFL CONCOMFL $1 CLASSSTAT $32;
  merge work.cm_sorted(in=in_source)
        adam.adsl(keep=STUDYID USUBJID TRT01A TRT01AN TRTSDT TRTEDT ITTFL SAFFL);
  by STUDYID USUBJID;
  if in_source;
  %exact_date(CMSTDTC,ASTDT);
  %exact_date(CMENDTC,AENDT);
  %relative_day(ASTDT,TRTSDT,ASTDY);
  %relative_day(AENDT,TRTSDT,AENDY);
  ASEQ=CMSEQ; PRIORFL=''; CONCOMFL=''; CLASSSTAT='UNRESOLVED DATES';
  if nmiss(ASTDT,TRTSDT)=0 then do;
    PRIORFL='N'; if ASTDT < TRTSDT then PRIORFL='Y';
  end;
  if SAFFL='N' then do; CONCOMFL='N'; CLASSSTAT='NO EXPOSURE'; end;
  else if nmiss(ASTDT,TRTSDT,TRTEDT)=0 then do;
    if ASTDT > TRTEDT then CONCOMFL='N';
    else if not missing(AENDT) then do;
      CONCOMFL='N'; if AENDT >= TRTSDT then CONCOMFL='Y';
    end;
    else if missing(CMENDTC) and CMENRF='ONGOING' and TRTEDT <= '31JAN2025'd
      then CONCOMFL='Y';
    if not missing(CONCOMFL) then CLASSSTAT='CLASSIFIED';
  end;
  /* No AENDT imputation: ongoing evidence affects classification only. */
  format ASTDT AENDT date9.;
  label STUDYID='Study Identifier' USUBJID='Unique Subject Identifier'
    CMSEQ='Source CM Sequence Number' ASEQ='Analysis Sequence Number'
    CMTRT='Reported Medication' CMSTDTC='Source CM Start Date Text'
    CMENDTC='Source CM End Date Text' CMENRF='Source End Relative to Reference'
    ASTDT='Analysis Start Date' AENDT='Analysis End Date'
    ASTDY='Analysis Start Relative Day' AENDY='Analysis End Relative Day'
    PRIORFL='Prior Medication Flag (Local)' CONCOMFL='Concomitant Medication Flag (Local)'
    CLASSSTAT='Demonstration Classification Status';
run;
%stop_if_errors(adcm);
%assert_count(data=adam.adcm,expected=11);
%assert_unique(data=adam.adcm,keys=%str(STUDYID,USUBJID,ASEQ),id=adcm_duplicate);
%assert_zero(data=adam.adcm,where=not missing(ASTDT) and not missing(AENDT) and AENDT < ASTDT,id=cm_interval);
