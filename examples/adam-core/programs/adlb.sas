/* B01/L01: Only standardized ALT U/L is in this small example's scope. */
%assert_unique(data=sdtm.lb,keys=%str(STUDYID,USUBJID,LBSEQ),id=lb_duplicate);
%assert_zero(data=sdtm.lb,where=missing(STUDYID) or missing(USUBJID) or missing(LBSEQ),id=lb_missing_key);
%assert_zero(data=sdtm.lb,where=%str(LBTESTCD ne 'ALT' or LBSTRESU ne 'U/L'),id=lb_parameter);
%assert_zero(data=sdtm.lb,where=not missing(LBSTNRLO) and not missing(LBSTNRHI) and LBSTNRLO > LBSTNRHI,id=lb_limits);
data work.lb_normalized;
  length STUDYID $8 USUBJID $12 SRCDOM $2 SRCSEQ 8 SRCDTC $10
         PARAMCD $8 PARAM $40 AVAL 8 AVALU $12 ANRLO ANRHI 8
         VISIT AVISIT $12 VISITNUM AVISITN 8;
  set sdtm.lb;
  SRCDOM='LB'; SRCSEQ=LBSEQ; SRCDTC=LBDTC;
  PARAMCD='ALT'; PARAM='Alanine Aminotransferase (U/L)';
  AVAL=LBSTRESN; AVALU=LBSTRESU; ANRLO=LBSTNRLO; ANRHI=LBSTNRHI;
  AVISIT=VISIT; AVISITN=VISITNUM;
  keep STUDYID USUBJID SRCDOM SRCSEQ SRCDTC PARAMCD PARAM AVAL AVALU
       ANRLO ANRHI VISIT VISITNUM AVISIT AVISITN;
run;
%derive_bds(input=work.lb_normalized,target=adlb,has_ranges=1);
%assert_count(data=adam.adlb,expected=17);
