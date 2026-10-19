/* Bootstrap the synthetic ADaM example in the current Viya WORK directory.
   Requires PROC HTTP, outbound access to raw.githubusercontent.com, and write
   access to WORK. This downloads the main branch; review/pin the source before
   using it in a controlled environment. */
%let project_root=%sysfunc(pathname(work));
%let github_root=https://raw.githubusercontent.com/Raymond2Moran/pharmasug_27_pharmaskills/main/examples/adam-core;

/* Create the directory tree, allowing this setup program to be rerun. */
data _null_;
  length root examples_root example_root newdir $1024;
  root=symget('project_root');
  examples_root=cats(root,'/examples');
  example_root=cats(examples_root,'/adam-core');

  rc=filename('checkdir',examples_root);
  did=dopen('checkdir');
  if did=0 then do;
    newdir=dcreate('examples',root);
    if missing(newdir) then do;
      put 'ERROR: Cannot create examples directory under WORK.';
      abort cancel;
    end;
  end;
  else rc=dclose(did);
  rc=filename('checkdir');

  rc=filename('checkdir',example_root);
  did=dopen('checkdir');
  if did=0 then do;
    newdir=dcreate('adam-core',examples_root);
    if missing(newdir) then do;
      put 'ERROR: Cannot create adam-core directory under WORK.';
      abort cancel;
    end;
  end;
  else rc=dclose(did);
  rc=filename('checkdir');

  example_root=cats(root,'/examples/adam-core');
  rc=filename('checkdir',cats(example_root,'/programs'));
  did=dopen('checkdir');
  if did=0 then do;
    newdir=dcreate('programs',example_root);
    if missing(newdir) then do;
      put 'ERROR: Cannot create programs directory.';
      abort cancel;
    end;
  end;
  else rc=dclose(did);
  rc=filename('checkdir');

  rc=filename('checkdir',cats(example_root,'/qc'));
  did=dopen('checkdir');
  if did=0 then do;
    newdir=dcreate('qc',example_root);
    if missing(newdir) then do;
      put 'ERROR: Cannot create qc directory.';
      abort cancel;
    end;
  end;
  else rc=dclose(did);
  rc=filename('checkdir');
run;

%macro download(path=);
  %local url destination http_status;
  %let url=&github_root/&path;
  %let destination=&project_root/examples/adam-core/&path;

  filename outfile "&destination";
  proc http url="&url" method="GET" out=outfile;
  run;

  %let http_status=&SYS_PROCHTTP_STATUS_CODE;
  %if %length(%superq(http_status))=0 %then %let http_status=000;
  filename outfile clear;

  %if %superq(http_status) ne 200 %then %do;
    %put ERROR: Download failed for &path;
    %put ERROR: HTTP STATUS=&http_status;
    %abort cancel;
  %end;

  %if not %sysfunc(fileexist("&destination")) %then %do;
    %put ERROR: Download returned HTTP 200 but file is missing: &destination;
    %abort cancel;
  %end;

  %put NOTE: Downloaded &path;
%mend;

/* Runtime files required by run_all.sas and its QC includes. */
%download(path=run_all.sas);
%download(path=helpers.sas);
%download(path=source.sas);

%download(path=programs/adsl.sas);
%download(path=programs/bds_common.sas);
%download(path=programs/adlb.sas);
%download(path=programs/advs.sas);
%download(path=programs/adae.sas);
%download(path=programs/adcm.sas);

%download(path=qc/expected.sas);
%download(path=qc/check_adsl.sas);
%download(path=qc/check_children.sas);
%download(path=qc/check_metadata.sas);
%download(path=qc/negative_cases.sas);

/* Confirm the runner exists before starting the full workflow. */
%let runfile=&project_root/examples/adam-core/run_all.sas;
%put NOTE: PROJECT_ROOT=&project_root;
%put NOTE: RUN_ALL_EXISTS=%sysfunc(fileexist("&runfile"));

%if not %sysfunc(fileexist("&runfile")) %then %do;
  %put ERROR: run_all.sas was not downloaded; workflow will not start.;
  %abort cancel;
%end;

%include "&runfile";
