
proc sort data=adhoc5.dc_rfm_clusters_overall1 ;
by cluster;
run;

/*Means of Unstandardized Variables of each cluser*/
proc means data=adhoc5.dc_rfm_clusters_overall1;
var recency_unstd mean_txn_amt_unstd mean_gap_unstd months_active_unstd vintage_unstd;
by cluster;
run;

/*Means of Standardized Variables of each cluser*/
proc means data=adhoc5.dc_rfm_clusters_overall1;
var recency mean_txn_amt mean_gap months_active vintage;
by cluster;
output out=cluster_summary mean=;
run;

proc transpose data=cluster_summary out=cluster_summary_tt(where=(_name_ not in ("_FREQ_","_TYPE_")));
id cluster;
run;

/*Profile Plot*/
proc sgplot data= cluster_summary_tt;
series x=_name_ y="1"n/curvelabel="Cluster 1";
series x=_name_ y="2"n/curvelabel="Cluster 2";
series x=_name_ y="3"n/curvelabel="Cluster 3";
series x=_name_ y="4"n/curvelabel="Cluster 4";
series x=_name_ y="5"n/curvelabel="Cluster 5";
series x=_name_ y="6"n/curvelabel="Cluster 6";
series x=_name_ y="7"n/curvelabel="Cluster 7";
yaxis label="Standardized Values" grid;
xaxis label="Variables" grid type=discrete;
run;

/*3D Profiling*/
proc g3d data=cluster_summary;
scatter mean_txn_amt*mean_gap=recency/ 
shape="balloon" annotate= label1  size= _FREQ_ ;
run;


/*2D Projections*/
ods graphics on;
%macro _3d(degrees);
title "&degrees.";
proc g3d data=cluster_summary;
scatter mean_txn_amt*mean_gap=recency/ shape="balloon" annotate= label1  size= _FREQ_ tilt=0 rotate=&degrees.;
run;
%mend;

%_3d(0)
%_3d(90)
%_3d(180)
%_3d(270)
%_3d(360)


