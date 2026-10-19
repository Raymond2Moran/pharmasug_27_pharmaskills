/* B01/V01: Single synthetic pulse parameter, no averaging or conversion. */
%assert_unique(data=sdtm.vs,keys=%str(STUDYID,USUBJID,VSSEQ),id=vs_duplicate);
%assert_zero(data=sdtm.vs,where=missing(STUDYID) or missing(USUBJID) or missing(VSSEQ),id=vs_missing_key);
%assert_zero(data=sdtm.vs,where=%str(VSTESTCD ne 'PULSE' or VSSTRESU ne 'beats/min'),id=vs_parameter);
data work.vs_normalized;
  length STUDYID $8 USUBJID $12 SRCDOM $2 SRCSEQ 8 SRCDTC $10
         PARAMCD $8 PARAM $40 AVAL 8 AVALU $12
         VISIT AVISIT $12 VISITNUM AVISITN 8;
  set sdtm.vs;
  SRCDOM='VS'; SRCSEQ=VSSEQ; SRCDTC=VSDTC;
  PARAMCD='PULSE'; PARAM='Pulse Rate (beats/min)'; AVAL=VSSTRESN; AVALU=VSSTRESU;
  AVISIT=VISIT; AVISITN=VISITNUM;
  keep STUDYID USUBJID SRCDOM SRCSEQ SRCDTC PARAMCD PARAM AVAL AVALU
       VISIT VISITNUM AVISIT AVISITN;
run;
%derive_bds(input=work.vs_normalized,target=advs);
%assert_count(data=adam.advs,expected=12);
