%compare_reference(base=qc.expected_adlb,actual=adam.adlb,keys=STUDYID USUBJID ASEQ,
  vars=AVAL BASE CHG PCHG ADY ABLFL ANL01FL ANRIND,out=adlb_differences,tolerance=1e-10);
%compare_reference(base=qc.expected_advs,actual=adam.advs,keys=STUDYID USUBJID ASEQ,
  vars=AVAL BASE CHG PCHG ADY ABLFL ANL01FL,out=advs_differences,tolerance=1e-10);
%compare_reference(base=qc.expected_adae,actual=adam.adae,keys=STUDYID USUBJID ASEQ,
  vars=ASTDT AENDT ASTDY AENDY TRTEMFL,out=adae_differences);
%compare_reference(base=qc.expected_adcm,actual=adam.adcm,keys=STUDYID USUBJID ASEQ,
  vars=ASTDT AENDT PRIORFL CONCOMFL,out=adcm_differences);

/* Compare inherited fields to BOTH ADSL and the independent ADSL expectation.
   The second comparison detects a wrong ADSL propagated consistently. */
%macro inheritance(child=,data=,adsl=adam.adsl);
  /* Optional WORK inputs let negative controls exercise this same check. */
  %if %length(&data)=0 %then %let data=adam.&child;
  proc sql;
    create table qc.&child._inheritance as
    select c.USUBJID, c.ASEQ from &data c
      left join &adsl a on c.STUDYID=a.STUDYID and c.USUBJID=a.USUBJID
      left join qc.expected_adsl e on c.STUDYID=e.STUDYID and c.USUBJID=e.USUBJID
    where missing(a.USUBJID) or missing(e.USUBJID)
       or c.TRT01A ne a.TRT01A or c.TRT01A ne e.TRT01A
       or c.TRT01AN ne a.TRT01AN or c.TRT01AN ne e.TRT01AN
       or c.TRTSDT ne a.TRTSDT or c.TRTSDT ne e.TRTSDT
       or c.TRTEDT ne a.TRTEDT or c.TRTEDT ne e.TRTEDT
       or c.ITTFL ne a.ITTFL or c.ITTFL ne e.ITTFL
       or c.SAFFL ne a.SAFFL or c.SAFFL ne e.SAFFL;
  quit;
  %stop_if_errors(inheritance);
  %assert_count(data=qc.&child._inheritance,expected=0);
%mend;
%inheritance(child=adlb);
%inheritance(child=advs);
%inheritance(child=adae);
%inheritance(child=adcm);

%macro bds_structure(child=);
  proc sql;
    create table qc.&child._baseline_count as
    select STUDYID,USUBJID,PARAMCD,sum(ABLFL='Y') as selected
    from adam.&child group by STUDYID,USUBJID,PARAMCD having calculated selected > 1;
  quit;
  %assert_count(data=qc.&child._baseline_count,expected=0);
  %assert_zero(data=adam.&child,where=BASE=0 and not missing(PCHG),id=zero_baseline);
  %assert_zero(data=adam.&child,where=%str(ABLFL not in ('','Y') or ANL01FL not in ('','Y')),id=bds_flag_values);
%mend;
%bds_structure(child=adlb);
%bds_structure(child=advs);

/* Source links: exact retained dates, result/unit and source sequence. */
proc sql;
  create table qc.lb_source as
  select a.* from adam.adlb a left join sdtm.lb s
    on a.STUDYID=s.STUDYID and a.USUBJID=s.USUBJID and a.SRCSEQ=s.LBSEQ
  where missing(s.LBSEQ) or a.ASEQ ne s.LBSEQ or a.SRCDOM ne 'LB'
     or a.SRCDTC ne s.LBDTC or a.AVAL ne s.LBSTRESN or a.AVALU ne s.LBSTRESU
     or a.ANRLO ne s.LBSTNRLO or a.ANRHI ne s.LBSTNRHI
     or a.PARAMCD ne 'ALT' or a.PARAM ne 'Alanine Aminotransferase (U/L)'
     or a.VISIT ne s.VISIT or a.VISITNUM ne s.VISITNUM
     or a.AVISIT ne s.VISIT or a.AVISITN ne s.VISITNUM;
  create table qc.vs_source as
  select a.* from adam.advs a left join sdtm.vs s
    on a.STUDYID=s.STUDYID and a.USUBJID=s.USUBJID and a.SRCSEQ=s.VSSEQ
  where missing(s.VSSEQ) or a.ASEQ ne s.VSSEQ or a.SRCDOM ne 'VS'
     or a.SRCDTC ne s.VSDTC or a.AVAL ne s.VSSTRESN or a.AVALU ne s.VSSTRESU
     or a.PARAMCD ne 'PULSE' or a.PARAM ne 'Pulse Rate (beats/min)'
     or a.VISIT ne s.VISIT or a.VISITNUM ne s.VISITNUM
     or a.AVISIT ne s.VISIT or a.AVISITN ne s.VISITNUM;
  create table qc.ae_source as
  select a.* from adam.adae a left join sdtm.ae s
    on a.STUDYID=s.STUDYID and a.USUBJID=s.USUBJID and a.AESEQ=s.AESEQ
  where missing(s.AESEQ) or a.ASEQ ne s.AESEQ or a.AESTDTC ne s.AESTDTC
     or a.AEENDTC ne s.AEENDTC or a.AETERM ne s.AETERM
     or a.AEDECOD ne s.AEDECOD or a.AEBODSYS ne s.AEBODSYS
     or a.AESEV ne s.AESEV or a.AESER ne s.AESER;
  create table qc.cm_source as
  select a.* from adam.adcm a left join sdtm.cm s
    on a.STUDYID=s.STUDYID and a.USUBJID=s.USUBJID and a.CMSEQ=s.CMSEQ
  where missing(s.CMSEQ) or a.ASEQ ne s.CMSEQ or a.CMSTDTC ne s.CMSTDTC
     or a.CMENDTC ne s.CMENDTC or a.CMTRT ne s.CMTRT or a.CMENRF ne s.CMENRF;
quit;
%stop_if_errors(source_traceability);
%assert_count(data=qc.lb_source,expected=0);
%assert_count(data=qc.vs_source,expected=0);
%assert_count(data=qc.ae_source,expected=0);
%assert_count(data=qc.cm_source,expected=0);

/* Expected unknown classifications are retained, not treated as failures. */
data qc.classification_issues;
  length dataset $4;
  set adam.adae(in=ae keep=STUDYID USUBJID ASEQ CLASSSTAT)
      adam.adcm(in=cm keep=STUDYID USUBJID ASEQ CLASSSTAT);
  if CLASSSTAT='UNRESOLVED DATES';
  if ae then dataset='ADAE'; else if cm then dataset='ADCM';
run;
%assert_count(data=qc.classification_issues,expected=6);
