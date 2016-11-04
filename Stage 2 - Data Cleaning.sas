
/*Extracting Percentiles for Outlier Treatment*/
proc univariate data= adhoc5.dc_rfm_trimmed;
var mean_txn_amt ;
histogram mean_txn_amt;
output out= p_mean_txn_amt_overall pctlpts= 1 5 90 95 99 pctlpre=P ;
run;

proc univariate data= adhoc5.dc_rfm_trimmed;
var mean_gap;
histogram mean_gap;
output out= p_mean_gap_overall pctlpts= 1 5 90 95 99 pctlpre=P ;
run;

proc univariate data= adhoc5.dc_rfm_trimmed;
var months_Active;
output out= p_months_Active pctlpts= 1 5 90 95 99 pctlpre=P; 
histogram months_Active;
run;

data percentile_2_mid;
set  p_mean_txn_amt_overall(in=a) p_mean_gap_overall(in=b) p_months_Active (in=c) end=eof;
if a=1 then variable="mean_txn_amt";
if b=1 then variable="mean_gap";
if c=1 then variable="months_Active";
run;


/*Creates code for later use in capping or filtering outliers*/
data percentiles_2;
length phrase capping phrase1_99 capping1_99 $10000.;
set percentile_2_mid end=eof;
retain phrase capping phrase1_99 capping1_99;
by variable notsorted;
if first.variable=1 then 
do;

phrase=catx("","(",p5,"<=",variable,"<=",p95," ) ");
capping=catx("","if", variable,">=",p95,"then",variable,"=",p95,";else if",variable,"<=",p5,"then", variable,"=",p5,";");

phrase1_99=catx("","(",p1,"<=",variable,"<=",p99," ) ");
capping1_99=catx("","if", variable,">=",p99,"then",variable,"=",p99,";else if",variable,"<=",p1,"then", variable,"=",p1,";");

end;

else 
do;

phrase=catx("","(",p5,"<=",variable,"<=",p95," ) ");
capping=catx("",capping,"if",variable,">=",p95,"then", variable,"=",p95,
";else if", variable,"<=",p5,"then", variable,"=",p5,";");

phrase1_99=catx("","(",p1,"<=",variable,"<=",p99," ) ");
capping1_99=catx("",capping,"if",variable,">=",p99,"then", variable,"=",p99,
";else if", variable,"<=",p1,"then", variable,"=",p1,";");

end;
if last.variable=1 then 
do;
call symput(catx("_","filter",variable),phrase);
call symput(catx("_","cap",variable),capping);

call symput(catx("_","filter1_99",variable),phrase1_99);
call symput(catx("_","cap1_99",variable),capping1_99);
end;
run;



/*Log transforms for normalization*/

data dc_rfm_capped_logged_overall;
set adhoc5.dc_rfm_trimmed;

log_mean_no_of_txns=log(mean_no_of_txns);
log_mean_txn_amt=log(mean_txn_amt);
log_vintage=log(vintage);
log_mean_gap=log(mean_gap);
log_recency=log(recency);

mean_txn_amt_unstd=mean_txn_amt;
mean_gap_unstd=mean_gap;
recency_unstd=recency;
product_1_unstd=product_1;
months_active_unstd=months_active;
vintage_unstd=vintage;
run;

proc univariate data= dc_rfm_capped_logged_overall(where=((&filter1_99_mean_txn_amt.) AND (&filter1_99_mean_gap.) and log_mean_gap>=-0.925 ));
var mean_gap log_mean_gap log_mean_txn_amt log_recency log_vintage;
qqplot mean_gap log_mean_gap log_mean_txn_amt log_recency log_vintage/ normal;
hist mean_gap  log_mean_gap log_mean_txn_amt log_recency log_vintage;
run;

/*Filtering out outliers and standardization*/
proc standard data= dc_rfm_capped_logged_overall(where=((&filter1_99_mean_txn_amt.) AND (&filter1_99_mean_gap.) and log_mean_gap>=-0.925)) mean=0 std=1 out=dc_rfm_capped_stdized_overall ;
var 
mean_no_of_txns 
mean_txn_amt 
mean_gap 
recency 
vintage
log_mean_no_of_txns 
log_mean_txn_amt 
log_mean_gap 
log_recency
log_vintage
months_active
product_1
; 
run; 