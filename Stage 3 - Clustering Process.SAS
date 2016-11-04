

/*Scree Plot to identify number of clusters*/

%macro elbow();

%do k=2 %to 12;
proc fastclus data= dc_rfm_capped_stdized_overall maxc=&k. maxiter=15 outstat=cluster_stats&k.;
var log_mean_gap log_mean_txn_amt log_recency months_active log_vintage;
run;

data cluster_stats&k.(keep=OVER_ALL _TYPE_ NO_CLUSTERS);
set cluster_stats&k.(where=(_TYPE_ in ("RSQ","CCC")));
NO_CLUSTERS=&k.;
run;

%if &k=2 %then %do;

proc sql;
create table adhoc5.rsquare_table like cluster_stats&k.;
quit;

%end;

data adhoc5.rsquare_table;
set adhoc5.rsquare_table cluster_stats&k.;
run;

%end;

/*proc sgplot data=rsquare_table;*/
/*series  x=no_clusters y=over_all/datalabel=over_all ;*/
/*xaxis grid values=(2 to 12 by 1); */
/*run;*/

proc transpose data=adhoc5.rsquare_table out= rsquare_table_tt;
by no_clusters;
var over_all;
id _type_;
run;

proc sql;
select * from rsquare_table_tt(drop=_name_ _label_);
quit;

title "Elbow Plot";
proc sgplot data=rsquare_table_tt;
series  x=no_clusters y=RSQ/datalabel=RSQ ;
xaxis grid values=(2 to 12 by 1); 
run;

title "CCC Plot";
proc sgplot data=rsquare_table_tt;
series  x=no_clusters y=CCC/datalabel=CCC ;
xaxis grid values=(2 to 12 by 1); 
run;

%mend;

%elbow()


proc fastclus data= dc_rfm_capped_stdized_overall maxc=7 maxiter=15 out=adhoc5.dc_rfm_clusters_overall1 ;
var log_mean_gap log_mean_txn_amt log_recency months_active log_vintage;
run;

/*adhoc5.dc_rfm_clusters_overall1 contains data with cluster flags*/
