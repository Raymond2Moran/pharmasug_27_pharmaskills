/* Hand-authored reference decisions from SYN001-SPEC-1 and source DATALINES.
   NOT computed by production helpers or from production outputs.
   Dates are parsed directly here; no production date macro is used.
   This is a finite fixture oracle, not a general independent QC derivation. */
data qc.expected_adsl;
  length STUDYID $8 USUBJID $12 SUBJID $3 SEX $1 AGE 8
         TRT01P TRT01A $8 TRT01PN TRT01AN TRTSDT TRTEDT 8
         ITTFL SAFFL $1 EOSSTT $24 EOSDT 8;
  infile datalines dlm='|' dsd truncover;
  input SUBJID :$3. SEX :$1. AGE TRT01P :$8. TRT01PN TRT01A :$8. TRT01AN
        TRTSDT :yymmdd10. TRTEDT :yymmdd10. ITTFL :$1. SAFFL :$1.
        EOSSTT :$24. EOSDT :yymmdd10.;
  STUDYID='SYN001'; USUBJID=cats(STUDYID,'-',SUBJID);
  format TRTSDT TRTEDT EOSDT date9.;
datalines;
001|F|45|Drug|1|Drug|1|2025-01-10|2025-01-20|Y|Y|COMPLETED|2025-01-25
002|M|52|Drug|1|Drug|1|2025-01-10|2025-01-20|Y|Y|COMPLETED|2025-01-25
003|F|38|Placebo|0|Drug|1|2025-01-10|2025-01-20|Y|Y|COMPLETED|2025-01-25
004|M|60|Drug|1|Drug|1|2025-01-10|2025-01-20|Y|Y|DISCONTINUED|2025-01-21
005|F|49|Drug|1|Drug|1|2025-01-10|2025-01-20|Y|Y|COMPLETED|2025-01-25
006|M|55|Placebo|0|Placebo|0|2025-01-10|2025-01-20|Y|Y|COMPLETED|2025-01-25
007|F|41|Placebo|0|||.|.|Y|N|WITHDRAWN|2025-01-09
008|M|63|Drug|1|Drug|1|.|2025-01-20|Y|Y|DISCONTINUED|2025-01-21
009|F|47|Placebo|0|Placebo|0|2025-01-12|2025-01-18|Y|Y|COMPLETED|2025-01-25
010|M|50|Placebo|0|Placebo|0|2025-01-10|2025-01-20|Y|Y|COMPLETED|2025-01-25
011|F|35|||||.|.|N|N|SCREEN FAILURE|2025-01-08
012|M|58|Drug|1|Drug|1|2025-01-10|2025-01-20|Y|Y|COMPLETED|2025-01-25
;
run;

data qc.expected_adlb;
  length STUDYID $8 USUBJID $12 SUBJID $3 ASEQ AVAL BASE CHG PCHG ADY 8
         ABLFL ANL01FL $1 ANRIND $6;
  infile datalines dlm='|' dsd truncover;
  input SUBJID :$3. ASEQ AVAL BASE CHG PCHG ADY ABLFL :$1. ANL01FL :$1. ANRIND :$6.;
  STUDYID='SYN001'; USUBJID=cats(STUDYID,'-',SUBJID); drop SUBJID;
datalines;
001|1|10|12|.|.|-1|||NORMAL
001|2|12|12|.|.|-1|Y|Y|NORMAL
001|3|18|12|6|50|6||Y|HIGH
002|1|20|.|.|.|6||Y|HIGH
003|1|0|0|.|.|-1|Y|Y|LOW
003|2|5|0|5|.|6||Y|NORMAL
004|1|.|.|.|.|-1|||
004|2|20|.|.|.|6||Y|HIGH
005|1|10|10|.|.|-1|Y|Y|NORMAL
005|2|.|10|.|.|6|||
006|1|10|10|.|.|-1|Y|Y|NORMAL
006|2|12|10|2|20|1||Y|NORMAL
008|1|9|.|.|.|.||Y|NORMAL
009|1|5|5|.|.|-1|Y|Y|NORMAL
009|2|10|5|5|100|1||Y|
012|1|7|.|.|.|.|||NORMAL
012|2|9|.|.|.|6||Y|NORMAL
;
run;

data qc.expected_advs;
  length STUDYID $8 USUBJID $12 SUBJID $3 ASEQ AVAL BASE CHG PCHG ADY 8
         ABLFL ANL01FL $1;
  infile datalines dlm='|' dsd truncover;
  input SUBJID :$3. ASEQ AVAL BASE CHG PCHG ADY ABLFL :$1. ANL01FL :$1.;
  STUDYID='SYN001'; USUBJID=cats(STUDYID,'-',SUBJID); drop SUBJID;
datalines;
001|1|60|60|.|.|-1|Y|Y
001|2|72|60|12|20|6||Y
002|1|0|0|.|.|-1|Y|Y
002|2|10|0|10|.|6||Y
003|1|70|71|.|.|-1||
003|2|71|71|.|.|-1|Y|Y
003|3|80|71|9|12.6760563380282|6||Y
007|1|65|.|.|.|.||Y
009|1|60|60|.|.|-1|Y|Y
009|2|.|60|.|.|4||
010|1|85|.|.|.|6||Y
012|1|70|.|.|.|.||
;
run;

data qc.expected_adae;
  length STUDYID $8 USUBJID $12 SUBJID $3 ASEQ ASTDT AENDT ASTDY AENDY 8 TRTEMFL $1;
  infile datalines dlm='|' dsd truncover;
  input SUBJID :$3. ASEQ ASTDT :yymmdd10. AENDT :yymmdd10. ASTDY AENDY TRTEMFL :$1.;
  STUDYID='SYN001'; USUBJID=cats(STUDYID,'-',SUBJID); drop SUBJID;
  format ASTDT AENDT date9.;
datalines;
001|1|2025-01-09|2025-01-12|-1|3|N
001|2|2025-01-10|2025-01-11|1|2|Y
001|3|2025-01-10|2025-01-11|1|2|Y
002|1|2025-02-19|2025-02-20|41|42|Y
002|2|2025-02-20|2025-02-21|42|43|N
003|1|.|2025-01-15|.|6|
007|1|2025-01-11|2025-01-12|.|.|N
008|1|2025-01-15|2025-01-16|.|.|
009|1|2025-01-12|2025-01-13|1|2|Y
012|1|.|2025-01-15|.|6|
;
run;

data qc.expected_adcm;
  length STUDYID $8 USUBJID $12 SUBJID $3 ASEQ ASTDT AENDT 8 PRIORFL CONCOMFL $1;
  infile datalines dlm='|' dsd truncover;
  input SUBJID :$3. ASEQ ASTDT :yymmdd10. AENDT :yymmdd10. PRIORFL :$1. CONCOMFL :$1.;
  STUDYID='SYN001'; USUBJID=cats(STUDYID,'-',SUBJID); drop SUBJID;
  format ASTDT AENDT date9.;
datalines;
001|1|2025-01-01|2025-01-09|Y|N
001|2|2025-01-05|2025-01-10|Y|Y
002|1|2025-01-20|2025-01-22|N|Y
002|2|2025-01-21|2025-01-22|N|N
003|1|2025-01-05|.|Y|Y
004|1|.|2025-01-15||
005|1|2025-01-05|.|Y|
007|1|2025-01-05|2025-01-15||N
008|1|2025-01-05|2025-01-15||
009|1|2025-01-01|2025-01-11|Y|N
012|1|2025-01-10|2025-01-20|N|Y
;
run;
