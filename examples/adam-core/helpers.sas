/* Infrastructure only. Study derivation rules belong in the spec/programs. */
%macro stop_if_errors(stage);
  %if &syserr > 4 %then %do;
    %put ERROR: Stage &stage failed; inspect the preserved run log.;
    %abort cancel;
  %end;
%mend;

%macro assert_zero(data=,where=,id=);
  %local failures;
  proc sql noprint;
    select count(*) into :failures trimmed from &data where &where;
  quit;
  %stop_if_errors(&id);
  %if &failures > 0 %then %do;
    %put ERROR: &id found &failures invalid records in &data..;
    proc print data=&data; where &where; run;
    %abort cancel;
  %end;
%mend;

%macro assert_unique(data=,keys=,id=);
  /* GROUP BY accepts comma-separated keys; never remove duplicates. */
  proc sql;
    create table qc.&id as
    select &keys, count(*) as records from &data
    group by &keys having count(*) > 1;
  quit;
  %stop_if_errors(&id);
  %assert_zero(data=qc.&id,where=records > 1,id=&id);
%mend;

%macro assert_count(data=,expected=);
  %local observed;
  proc sql noprint; select count(*) into :observed trimmed from &data; quit;
  %stop_if_errors(count);
  %if &observed ne &expected %then %do;
    %put ERROR: &data expected &expected records but observed &observed..;
    %abort cancel;
  %end;
%mend;

%macro assert_subjects(data=);
  proc sql;
    create table qc.orphan_subjects as
    select s.* from &data as s left join adam.adsl as a
      on s.STUDYID=a.STUDYID and s.USUBJID=a.USUBJID
    where missing(a.USUBJID);
  quit;
  %stop_if_errors(subject_link);
  %assert_count(data=qc.orphan_subjects,expected=0);
%mend;

%macro exact_date(source,target);
  /* Only YYYY-MM-DD is converted. Partial dates remain missing, not imputed.
     Validate complete date text after the ?? informat suppresses SAS notes. */
  &target=.;
  if lengthn(strip(&source))=10 then do;
    &target=input(&source, ?? yymmdd10.);
    if missing(&target) or put(&target,yymmdd10.) ne strip(&source) then do;
      put 'ERROR: Invalid full date ' STUDYID= USUBJID= &source=;
      abort cancel;
    end;
  end;
  else if not missing(&source) then do;
    if not prxmatch('/^\d{4}(-\d{2})?$/',strip(&source)) then do;
      put 'ERROR: Unsupported date representation ' STUDYID= USUBJID= &source=;
      abort cancel;
    end;
    if lengthn(strip(&source))=7 then do;
      if missing(input(cats(&source,'-01'),?? yymmdd10.)) then do;
        put 'ERROR: Invalid partial date ' STUDYID= USUBJID= &source=;
        abort cancel;
      end;
    end;
  end;
%mend;

%macro relative_day(date,reference,target);
  &target=.;
  if not missing(&date) and not missing(&reference) then
    &target=&date-&reference+(&date >= &reference);
%mend;

%macro compare_reference(base=,actual=,keys=,vars=,out=,tolerance=0);
  %local compare_status;
  proc sort data=&base(keep=&keys &vars) out=work._reference; by &keys; run;
  proc sort data=&actual(keep=&keys &vars) out=work._actual; by &keys; run;
  %stop_if_errors(compare_sort);
  /* Expectations check values. Attribute differences are reviewed separately. */
  proc compare base=work._reference compare=work._actual
      method=absolute criterion=&tolerance out=qc.&out outnoequal;
    id &keys;
    var &vars;
  run;
  %let compare_status=&sysinfo;
  %stop_if_errors(compare);
  /* SYSINFO codes 1..32: dataset/variable metadata; checked separately.
     Codes 64 and higher include observations, values, type conflicts AND fatal
     comparison failure (32768). Capture SYSINFO before any following step. */
  %if &compare_status >= 64 %then %do;
    %put ERROR: &out reference comparison failed SYSINFO=&compare_status..;
    %abort cancel;
  %end;
  %put NOTE: &out value comparison completed SYSINFO=&compare_status..;
%mend;
