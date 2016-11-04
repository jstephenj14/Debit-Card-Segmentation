
/* Andrews Plots for Validation*/
data andrews;
set cluster_summary;
	pi=4*atan(1);
	stepsize=2*pi/100;
	sqrt2=sqrt(2);
	do t=-pi to pi by stepsize;
		f_andrews=recency/sqrt2+mean_txn_amt*sin(1*t)+mean_gap*cos(1*t)+
					months_active*sin(2*t)+vintage*cos(2*t);
		output;
	end;
run;

axis1 label=(a=90 'f(t)');
axis2 label=('t') order=(-3.5 to 3.5 by 1);

proc gplot data=andrews;
	plot f_andrews*t=cluster/frame vaxis=axis1 haxis=axis2 legend=legend1;
	run;

/* Candisc Plots for Validation*/
proc candisc data=adhoc5.dc_rfm_clusters_overall1 out=candisc;
class cluster;
var log_recency log_mean_txn_amt log_mean_gap months_active;
run;

proc sgplot data=candisc;
scatter y=can2 x=can1/group=cluster;
run;

proc sgplot data=candisc;
scatter y=can2 x=can3/group=cluster;
run;

proc sgplot data=candisc;
scatter y=can1 x=can3/group=cluster;
run;