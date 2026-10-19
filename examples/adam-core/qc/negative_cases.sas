/* Run one scenario AFTER run_all.sas in the same session.
   Each scenario deliberately aborts when its intended check detects the defect.
   Only WORK copies are changed. These cases have NOT been executed here. */
%macro negative_case;
  %if not %symexist(scenario) %then %do;
    %put ERROR: Set scenario to duplicate_dm, bad_adsl, propagated_adsl, wrong_baseline, bad_teae, bad_ongoing, or orphan.;
    %abort cancel;
  %end;
  %if &scenario=duplicate_dm %then %do;
    data work.bad; set sdtm.dm sdtm.dm(obs=1); run;
    %assert_unique(data=work.bad,keys=%str(STUDYID,USUBJID),id=negative_dm_duplicate);
  %end;
  %else %if &scenario=bad_adsl %then %do;
    data work.bad;
      set adam.adsl;
      if USUBJID='SYN001-003' then do; TRT01A='Placebo'; TRT01AN=0; end;
    run;
    %compare_reference(base=qc.expected_adsl,actual=work.bad,keys=STUDYID USUBJID,
      vars=TRT01A TRT01AN SAFFL,out=negative_adsl);
  %end;
  %else %if &scenario=propagated_adsl %then %do;
    /* The child agrees with corrupted ADSL; source-based truth must still fail. */
    data work.bad_adsl;
      set adam.adsl;
      if USUBJID='SYN001-003' then do;
        TRT01A='Placebo'; TRT01AN=0; SAFFL='N';
      end;
    run;
    data work.bad_child;
      set adam.adlb;
      if USUBJID='SYN001-003' then do;
        TRT01A='Placebo'; TRT01AN=0; SAFFL='N';
      end;
    run;
    %inheritance(child=adlb,data=work.bad_child,adsl=work.bad_adsl);
  %end;
  %else %if &scenario=wrong_baseline %then %do;
    data work.bad;
      set adam.adlb;
      if USUBJID='SYN001-001' then BASE=10;
    run;
    %compare_reference(base=qc.expected_adlb,actual=work.bad,keys=STUDYID USUBJID ASEQ,
      vars=BASE ABLFL,out=negative_baseline);
  %end;
  %else %if &scenario=bad_teae %then %do;
    data work.bad;
      set adam.adae;
      if USUBJID='SYN001-002' and AESEQ=1 then TRTEMFL='N';
    run;
    %compare_reference(base=qc.expected_adae,actual=work.bad,keys=STUDYID USUBJID ASEQ,
      vars=TRTEMFL,out=negative_teae);
  %end;
  %else %if &scenario=bad_ongoing %then %do;
    data work.bad;
      set adam.adcm;
      if USUBJID='SYN001-005' then CONCOMFL='Y';
    run;
    %compare_reference(base=qc.expected_adcm,actual=work.bad,keys=STUDYID USUBJID ASEQ,
      vars=PRIORFL CONCOMFL,out=negative_ongoing);
  %end;
  %else %if &scenario=orphan %then %do;
    data work.bad; set sdtm.ae; if _n_=1 then USUBJID='SYN001-999'; run;
    %assert_subjects(data=work.bad);
  %end;
  %else %do;
    %put ERROR: Unknown scenario &scenario..;
    %abort cancel;
  %end;
  %put ERROR: Negative scenario &scenario was NOT detected. Investigate the check.;
  %abort cancel;
%mend;
%negative_case;
