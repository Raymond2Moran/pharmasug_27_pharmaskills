/* Shared production implementation for the two BDS examples.
   INPUT: normalized findings with SRCSEQ, SRCDTC, AVAL, PARAMCD/PARAM,
   AVISIT/AVISITN and optional ANRLO/ANRHI. QC does not call this macro. */
%macro derive_bds(input=,target=,has_ranges=0);
  %assert_subjects(data=&input);
  proc sort data=&input out=work.findings_sorted; by STUDYID USUBJID; run;
  data work.findings;
    length TRT01A $8 TRT01AN TRTSDT TRTEDT 8 ITTFL SAFFL $1 ADT ADY 8;
    merge work.findings_sorted(in=in_source)
          adam.adsl(keep=STUDYID USUBJID TRT01A TRT01AN TRTSDT TRTEDT ITTFL SAFFL);
    by STUDYID USUBJID;
    if in_source;
    %exact_date(SRCDTC,ADT);
    %relative_day(ADT,TRTSDT,ADY);
    format ADT date9.;
  run;
  %stop_if_errors(bds_dates);
  /* REVIEW B02: Strictly before dosing date; no same-day predose inference.
     Ties: latest date, then greatest source SEQ. */
  proc sort data=work.findings out=work.baseline_candidates;
    where not missing(AVAL) and not missing(ADT) and not missing(TRTSDT)
          and ADT < TRTSDT;
    by STUDYID USUBJID PARAMCD ADT SRCSEQ;
  run;
  data work.baseline;
    set work.baseline_candidates;
    by STUDYID USUBJID PARAMCD;
    if last.PARAMCD;
    BASE=AVAL; BASESEQ=SRCSEQ;
    keep STUDYID USUBJID PARAMCD BASE BASESEQ;
  run;
  /* REVIEW B04: Select latest valid nonmissing result per source visit.
     This is a source-visit example, not a visit-window implementation. */
  proc sort data=work.findings out=work.analysis_candidates;
    where not missing(AVAL) and not missing(ADT) and not missing(AVISITN);
    by STUDYID USUBJID PARAMCD AVISITN ADT SRCSEQ;
  run;
  data work.analysis_selected;
    set work.analysis_candidates;
    by STUDYID USUBJID PARAMCD AVISITN;
    if last.AVISITN;
    length ANL01FL $1; ANL01FL='Y';
    keep STUDYID USUBJID PARAMCD SRCSEQ ANL01FL;
  run;
  proc sort data=work.findings; by STUDYID USUBJID PARAMCD SRCSEQ; run;
  proc sort data=work.baseline; by STUDYID USUBJID PARAMCD; run;
  proc sort data=work.analysis_selected; by STUDYID USUBJID PARAMCD SRCSEQ; run;
  data work.with_baseline;
    merge work.findings(in=in_source) work.baseline;
    by STUDYID USUBJID PARAMCD;
    if in_source;
  run;
  data adam.&target;
    length ABLFL ANL01FL $1 BASE CHG PCHG ASEQ 8;
    %if &has_ranges %then %do; length ANRIND $6; %end;
    merge work.with_baseline(in=in_source) work.analysis_selected;
    by STUDYID USUBJID PARAMCD SRCSEQ;
    if in_source;
    ABLFL=''; if not missing(BASESEQ) and SRCSEQ=BASESEQ then ABLFL='Y';
    CHG=.; PCHG=.;
    /* REVIEW B03: Changes only for dated records on/after first treatment. */
    if not missing(ADT) and not missing(TRTSDT) and ADT >= TRTSDT
       and not missing(AVAL) and not missing(BASE) then do;
      CHG=AVAL-BASE;
      if BASE ne 0 then PCHG=100*CHG/BASE;
    end;
    /* One parameter, one source row per output row in this example. */
    ASEQ=SRCSEQ;
    %if &has_ranges %then %do;
      ANRIND='';
      if nmiss(AVAL,ANRLO,ANRHI)=0 then do;
        if AVAL < ANRLO then ANRIND='LOW';
        else if AVAL > ANRHI then ANRIND='HIGH';
        else ANRIND='NORMAL';
      end;
      label ANRLO='Analysis Normal Range Lower Limit'
            ANRHI='Analysis Normal Range Upper Limit'
            ANRIND='Analysis Reference Range Indicator';
    %end;
    label STUDYID='Study Identifier' USUBJID='Unique Subject Identifier'
      SRCDOM='Source Domain' SRCSEQ='Source Sequence Number'
      SRCDTC='Source Date Text' ASEQ='Analysis Sequence Number'
      PARAMCD='Parameter Code' PARAM='Parameter' AVAL='Analysis Value'
      AVALU='Analysis Value Unit' ADT='Analysis Date' ADY='Analysis Relative Day'
      VISIT='Source Visit' VISITNUM='Source Visit Number'
      AVISIT='Analysis Visit' AVISITN='Analysis Visit Number'
      ABLFL='Baseline Record Flag' BASE='Baseline Value'
      CHG='Change from Baseline' PCHG='Percent Change from Baseline'
      ANL01FL='Analysis Record Flag 01';
    drop BASESEQ;
  run;
  %stop_if_errors(&target);
  %assert_unique(data=adam.&target,keys=%str(STUDYID,USUBJID,ASEQ),id=&target._duplicate);
%mend;
