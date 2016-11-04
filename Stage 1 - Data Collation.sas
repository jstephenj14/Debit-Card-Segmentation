proc sql;
   create table ptlf_base as 
   select 
	  monotonic() as tran_no,
	  t1.card_num, 
          t1.acc_no, 
          t1.custid, 
          t1.bin_number, 
          t1.tran_date, 
          t1.mcc_code, 
          t1.co_code, 
          t1.final_amt
      from dcdm.ptlf_data t1
	where "01FEB2015"d<=tran_date<="29FEB2016"d;
quit;

proc sql;
create table ptlf_base as
select t1.*,t2.issue_date,case when tran_date-issue_date>90 then 1 else 0 end as greater_than_90, tran_date-issue_date as tenure
from ptlf_base t1 left join
(
	select distinct card_no,issue_date
	from dcdm.dc_feb16_4
	where card_no ne ' '
)
t2
on t1.card_num=t2.card_no
having issue_date ne .;
quit;

proc sql;
create table ptlf_base  as
select t1.*,input(substr(t2.segment_c,1,1),1.) as segment_c,input(substr(t2.product_c,1,1),1.) as product_c,t2.age_109
from ptlf_base t1 left join maindata.i_grid_109_c t2
on t1.custid=t2.cust_id;
quit;

proc sql;
create table ptlf_txn_rollup as
select 
	custid,
	product_c,
	segment_c,
	put(tran_date,monyy7.) as month,
	count(distinct tran_no) as no_of_txns,
	sum(final_amt) as txn_amt,
	count(distinct case when is_online=1 then tran_no end) as no_of_online_txns,
	sum(case when is_online=1 then final_amt end) as online_txn_amt
from ptlf_base
group by 1,2,3,4;
quit;

proc sql;
create table cust_rollup as
select 
	custid,
	product_c,
	segment_c,
	count(distinct month) as months_active,
	mean(no_of_txns) as mean_no_of_txns,
	mean(txn_amt) as mean_txn_amt,
	mean(no_of_online_txns) as mean_no_of_online_txns,
	mean(online_txn_amt) as mean_online_txn_amt
from ptlf_txn_rollup
group by 1,2,3;
quit;

proc sort data=ptlf_base;
by custid tran_Date;
run;

data delay_data;
set ptlf_base(keep=custid tran_date);
by custid;
delay=tran_date-lag(tran_date);
if first.custid=1 then delay=.;
run;

proc sql;
create table adhoc5.delay_roll_up as
select custid,mean(delay) as mean_gap,"29FEB2016"d-max(tran_date) as recency
from delay_data
group by 1;
quit;

proc sql;
create table adhoc5.DC_RFM_DATA as
select t1.*,t2.*
from cust_rollup t1 left join adhoc5.delay_roll_up t2 
on t1.custid=t2.custid;
quit;

proc sql;
create table vintage_base as
select cust_id,min(start_date) as start_date format=date9.
from adhoc5.start_date_data 
group by 1;
quit;

proc sql;
create table vintage_mapping as
select t1.*,t2.start_date,intck('month',start_date,'28FEB2016'd) as vintage 
from adhoc5.DC_RFM_DATA t1 left join vintage_base t2
on t1.custid=t2.cust_id;
quit;

/*Final data*/
data adhoc5.dc_rfm_trimmed;
set vintage_mapping(where=(product_c=1 or product_c=2 ) keep=custid product_c months_active_new mean_no_of_txns mean_txn_amt mean_gap recency vintage);
run;

