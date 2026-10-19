/* ADSL: SYN001-SPEC-1, rules A01-A06. All DM subjects retained. */
%assert_zero(data=sdtm.dm,where=missing(STUDYID) or missing(USUBJID),id=dm_missing_key);
%assert_unique(data=sdtm.dm,keys=%str(STUDYID,USUBJID),id=dm_duplicate_key);
%assert_unique(data=sdtm.ex,keys=%str(STUDYID,USUBJID,EXSEQ),id=ex_duplicate_key);
%assert_unique(data=sdtm.ds,keys=%str(STUDYID,USUBJID,DSSEQ),id=ds_duplicate_key);
%assert_zero(data=sdtm.ex,where=missing(STUDYID) or missing(USUBJID) or missing(EXSEQ),id=ex_missing_key);
%assert_zero(data=sdtm.ds,where=missing(STUDYID) or missing(USUBJID) or missing(DSSEQ),id=ds_missing_key);
%assert_zero(data=sdtm.dm,where=%str(not missing(ARM) and ARM not in ('Drug','Placebo')),id=planned_treatment);

proc sql;
  create table qc.orphan_ex as
  select e.* from sdtm.ex e left join sdtm.dm d
    on e.STUDYID=d.STUDYID and e.USUBJID=d.USUBJID
  where missing(d.USUBJID);
  create table qc.orphan_ds as
  select s.* from sdtm.ds s left join sdtm.dm d
    on s.STUDYID=d.STUDYID and s.USUBJID=d.USUBJID
  where missing(d.USUBJID);
quit;
%stop_if_errors(source_links);
%assert_count(data=qc.orphan_ex,expected=0);
%assert_count(data=qc.orphan_ds,expected=0);

data work.ex_dates;
  set sdtm.ex;
  length EXSTDT EXENDT 8;
  format EXSTDT EXENDT date9.;
  %exact_date(EXSTDTC,EXSTDT);
  %exact_date(EXENDTC,EXENDT);
run;
%stop_if_errors(ex_dates);
%assert_zero(data=work.ex_dates,where=%str(EXTRT not in ('Drug','Placebo')),id=actual_treatment);
%assert_zero(data=work.ex_dates,where=not missing(EXSTDT) and not missing(EXENDT) and EXENDT < EXSTDT,id=ex_interval);

/* REVIEW A02: EX records document administration including placebo (dose 0).
   If ANY start/end is incomplete, that aggregated boundary is unknown.
   Multiple actual treatments require a different, approved study algorithm. */
proc sql;
  create table work.ex_subject as
  select STUDYID, USUBJID, count(*) as NEX,
         count(distinct EXTRT) as NTRT,
         max(EXTRT) as TRT01A length=8,
         case when sum(missing(EXSTDT))=0 then min(EXSTDT) else . end
           as TRTSDT format=date9.,
         case when sum(missing(EXENDT))=0 then max(EXENDT) else . end
           as TRTEDT format=date9.
  from work.ex_dates group by STUDYID,USUBJID;
quit;
%stop_if_errors(ex_summary);
%assert_zero(data=work.ex_subject,where=NTRT ne 1,id=multiple_treatments);

/* REVIEW A04: Fixture has one final DISPOSITION EVENT per DM subject. */
data work.ds_final;
  set sdtm.ds;
  where DSCAT='DISPOSITION EVENT';
  length EOSSTT $24 EOSDT 8;
  EOSSTT=DSDECOD;
  %exact_date(DSSTDTC,EOSDT);
  format EOSDT date9.;
  keep STUDYID USUBJID EOSSTT EOSDT;
run;
%assert_unique(data=work.ds_final,keys=%str(STUDYID,USUBJID),id=ds_final_duplicate);
proc sort data=sdtm.dm out=work.dm_sorted; by STUDYID USUBJID; run;
proc sort data=work.ex_subject; by STUDYID USUBJID; run;
proc sort data=work.ds_final; by STUDYID USUBJID; run;

data adam.adsl;
  length STUDYID $8 USUBJID $12 SUBJID $3 SEX $1 AGE 8
         TRT01P TRT01A $8 TRT01PN TRT01AN TRTSDT TRTEDT 8
         ITTFL SAFFL $1 EOSSTT $24 EOSDT 8;
  merge work.dm_sorted(in=in_dm) work.ex_subject work.ds_final;
  by STUDYID USUBJID;
  if in_dm;
  /* REVIEW A03: Nonmissing ARM is randomization evidence in this fixture only.
     ITTFL/SAFFL use Y/N; ABLFL/ANL01FL in BDS use Y/blank. */
  TRT01P=ARM;
  ITTFL='N'; if not missing(ARM) then ITTFL='Y';
  SAFFL='N'; if NEX > 0 then SAFFL='Y';
  if TRT01P='Drug' then TRT01PN=1;
  else if TRT01P='Placebo' then TRT01PN=0;
  if TRT01A='Drug' then TRT01AN=1;
  else if TRT01A='Placebo' then TRT01AN=0;
  format TRTSDT TRTEDT EOSDT date9.;
  label STUDYID='Study Identifier' USUBJID='Unique Subject Identifier'
    SUBJID='Subject Identifier' SEX='Sex' AGE='Age'
    TRT01P='Planned Treatment for Period 01' TRT01PN='Planned Treatment Code'
    TRT01A='Actual Treatment for Period 01' TRT01AN='Actual Treatment Code'
    TRTSDT='Date of First Exposure' TRTEDT='Date of Last Exposure'
    ITTFL='Intent-To-Treat Population Flag' SAFFL='Safety Population Flag'
    EOSSTT='End of Study Status' EOSDT='End of Study Date';
  keep STUDYID USUBJID SUBJID SEX AGE TRT01P TRT01PN TRT01A TRT01AN
       TRTSDT TRTEDT ITTFL SAFFL EOSSTT EOSDT;
run;
%stop_if_errors(adsl);
%assert_count(data=adam.adsl,expected=12);
%assert_unique(data=adam.adsl,keys=%str(STUDYID,USUBJID),id=adsl_duplicate);
%assert_zero(data=adam.adsl,where=missing(EOSSTT),id=missing_disposition);
%assert_zero(data=adam.adsl,where=not missing(TRTSDT) and not missing(TRTEDT) and TRTEDT < TRTSDT,id=treatment_interval);
proc freq data=adam.adsl; tables ITTFL*SAFFL TRT01P*TRT01A / missing; run;
