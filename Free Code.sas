libname prasad "/SAS/BIU/WITII04/prasad";

Options compress=yes symbolgen macrogen mlogic;

%Let Start_date="01JUL2015"d;
%Let END_date="31JUL2015"d;

%Let month="31JUL2015"d;/*Trigger month*/
%Let use_month=JUL15;/*Trigger month*/
%Let AD_Month=AUG2015;/*AD latest month*/
%Let ID=101;
%Let I_GRID_C=Adhoc3.I_Grid_101_C;
%LET MDAB_LIST= MDAB_100 MDAB_99 MDAB_98 MDAB_97;

/*Extracting data from UNICA*/
Proc sql;
create table adhoc3.Fixed_BROKEN_Maturity_RM as
select * from _AXURESP.VW_RM_CONTACT_HISTORY
where CAMPAIGNCODE="C000000034" 
/*and (&Start_date.<=Datepart(CONTACTSTARTDATE)<=&END_date.)*/
union all
select * from _AXURESP.VW_RM_CONTACT_HISTORY_BCK
where CAMPAIGNCODE="C000000034" 
;
quit;

Proc freq data=Fixed_BROKEN_Maturity_RM;table CHANNEL SEGMENT NEXT_BEST_PRODUCT/missing norow nocol;run;

/*Extraction of  accounts considering 30 dats of TAT*/
Data Fixed_BROKEN_Maturity_RM;
set adhoc3.Fixed_BROKEN_Maturity_RM;
Acc_no=Put(ACCOUNTNO,Z15.);
Cust_id=Put(CUSTID,Z9.);
Date_var=put(datepart(CONTACTSTARTDATE),monyy5.);
Date1=Datepart(CONTACTSTARTDATE);
Date2=Intnx("Days",DATE1,29);
format Date1 Date2 date9.;
run;

/**********************************************************/
/***************Stop and Mask above data*******************/
/**********************************************************/

%DOITNOW(WORK,Fixed_BROKEN_Maturity_RM,ACC_NO);
%DOITNOW(WORK,Fixed_BROKEN_Maturity_RM,CUST_ID);

data pl_3;
set adhoc3.pl_3;
run;

data hl_3;
set adhoc3.hl_3;
run;

%DOITNOW(WORK,PL_3,CUST_ID);
%DOITNOW(WORK,HL_3,CUST_ID);

proc sort data=Fixed_BROKEN_Maturity_RM;
by cust_id Date1;
run;

proc sort data=Fixed_BROKEN_Maturity_RM nodupkey out=Fixed_BROKEN_Maturity_RM;
by cust_id;
run;

/*Jugad*/

/*Data ADHOC3.FD_BROKEN_&USE_MONTH.;*/
/*set Fixed_BROKEN_Maturity_RM;*/
/*run;*/

/*Map MDAB details*/
Proc sql;
create table FD_BROKEN_&USE_MONTH. as
select A.*,B.*,C.*
from Fixed_BROKEN_Maturity_RM A
left join adhoc3.i_grid_102_c_dc(Keep=Cust_id MDAB_94--MDAB_100 ) B
on A.Cust_id=B.Cust_id
left join adhoc3.i_grid_102_c(keep=Cust_id
									  C_Txn_Amt_97--C_Txn_Amt_99 
									  D_Txn_Amt_97--D_Txn_Amt_99 
									  C_No_of_Txn_97--C_No_of_Txn_100
									  D_No_of_Txn_97--D_No_of_Txn_100) C
on A.Cust_id=C.Cust_id;
quit;

data adhoc3.FD_BROKEN_J;
set Fixed_BROKEN_Maturity_RM;
run;

data adhoc3.FD_BROKEN_J;
set  adhoc3.FD_BROKEN_J;
run;

/*Overall count*/
Proc sql;
select count(distinct cust_id) as Overall_count
from ADHOC3.FD_BROKEN_&USE_MONTH.;

Proc freq data=FD_BROKEN_&USE_MONTH.;
table NEXT_BEST_PRODUCT/missing norow nocol;
run;

/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/**/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/
/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/CONVERSION*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/
/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/**/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/;
Options compress=yes;

%Let use_month=JUL15;
%Let AD_Month=AUG2015;
%Let TD_Date1="01JUL2015"d;
%Let TD_Date2="31AUG2015"d;
%Let ID=101;

%Let MF_DATA=ADHOC3.MF_data_for_Conversion_new;
%Let LI_DATA=ADHOC3.LI_data_for_Conversion;
%LET AD_DATA=ADHOC3.FOR_AD_MAPPING_TILL_AUG2015;
%Let NET_SECURE=ADHOC3.NETSECURE_BRCM_FOR_CAMPAIGN;
%Let Estatement=MARKETIN.ESTATEMENT_DATA_101;
%Let CARD1=CARDS.APPLICATION_PIVOT_201506;
%Let CARD2=CARDS.APPLICATION_PIVOT_201507;

proc sql;
create table LI_CONVERSION_DATA as
select cust_id,LI_Created_variable,sum(WPC) As amount
from &LI_DATA.
/*where &TD_Date1.<=LI_Created_variable<=&TD_Date2.*/
group by 1,2;
quit;
								
/*proc sql;*/
/*create table FD_BROKEN_TEST as*/
/*select A.*,B.amount as LI_Amount,B.LI_Created_variable*/
/*from FD_BROKEN_TEST A*/
/*left join LI_CONVERSION_DATA B */
/*on A.Cust_id=B.Cust_id;*/
/*Quit;*/

/*Conversion mapping for recommended prodcuts with PL,HL,AL*/
Proc sql;
	create table FD_BROKEN_TEST as
		select A.*,

			D.PL_Date as PL_Date,D.PL_Amount,
			E.HL_Date as HL_Date,E.HL_Amount,
/*			F.AL_Date as AL_Date,F.AL_Amount,*/
			case when D.Cust_id ne ' ' then 1 else 0 end as PL_conversion,
			case when E.Cust_id ne ' ' then 1 else 0 end as HL_conversion,
/*			case when F.Cust_id ne ' ' then 1 else 0 end as AL_conversion,*/
			case when G.Cust_id ne ' ' then 1 else 0 end as LI_conversion

		from adhoc3.FD_BROKEN_J A

		left join adhoc3.PL_3 D on A.Cust_id=D.Cust_id and Date1<=PL_DATE<=Date2
		left join adhoc3.HL_3 E on A.Cust_id=E.Cust_id and Date1<=HL_DATE<=Date2
/*		left join ADHOC3.AL_3 F on A.Cust_id=F.Cust_id and Date1<=AL_DATE<=Date2*/

		left join LI_CONVERSION_DATA G on A.Cust_id=G.Cust_id and Date1<=LI_Created_variable<=Date2;
quit;

Proc sql;
select 
	count(distinct Cust_id) as Total_Targeted,
	count(distinct case when PL_conversion=1 then Cust_id end) as PL_conversion,
	count(distinct case when HL_conversion=1 then Cust_id end) as HL_conversion,
/*	count(distinct case when AL_conversion=1 then Cust_id end) as AL_conversion,*/
	count(distinct case when LI_conversion=1 then Cust_id end) as LI_conversion,
	count(distinct case when sum(PL_conversion,HL_conversion,LI_conversion)>0 then Cust_id end) as Total_conversion
from FD_BROKEN_TEST;
quit;

proc sql;
   create table adhoc3.fd_broken_total as 
   select t1.cust_id, 
          t1.acc_no, 
          t1.accountno, 
          t1.custid, 
          t1.contactstartdate, 
          t1.portfoliocode, 
          t1.eventdescription, 
          t1.next_best_product, 
          t1.date_var, 
          t1.date1, 
          t1.date2, 
          t1.pl_amount, 
          t1.hl_amount, 
          t1.pl_conversion, 
          t1.hl_conversion, 
          t1.li_conversion
      from work.FD_BROKEN_TEST t1
	where "01FEB2015"d<=datepart(t1.contactstartdate)<="31JUL2015"d;
quit;

PROC SQL;
   CREATE TABLE ADHOC3.NUMBER_GRID AS 
   SELECT t1.Cust_Id, 
          t1.C_no_Of_Txn_89, 
          t1.C_no_Of_Txn_90, 
          t1.C_no_Of_Txn_91,
          t1.C_no_Of_Txn_92, 
          t1.C_no_Of_Txn_93, 
          t1.C_no_Of_Txn_94, 
          t1.C_no_Of_Txn_95, 
          t1.C_no_Of_Txn_96, 
          t1.C_no_Of_Txn_97, 
          t1.C_no_Of_Txn_98, 
          t1.C_no_Of_Txn_99, 
          t1.C_Txn_Amt_89, 
          t1.C_Txn_Amt_90, 
          t1.C_Txn_Amt_91,  
          t1.C_Txn_Amt_92, 
          t1.C_Txn_Amt_93, 
          t1.C_Txn_Amt_94, 
          t1.C_Txn_Amt_95, 
          t1.C_Txn_Amt_96, 
          t1.C_Txn_Amt_97, 
          t1.C_Txn_Amt_98, 
          t1.C_Txn_Amt_99,
          t1.D_No_Of_Txn_89, 
          t1.D_No_Of_Txn_90, 
          t1.D_No_Of_Txn_91,  
          t1.D_No_Of_Txn_92, 
          t1.D_No_Of_Txn_93, 
          t1.D_No_Of_Txn_94, 
          t1.D_No_Of_Txn_95, 
          t1.D_No_Of_Txn_96, 
          t1.D_No_Of_Txn_97, 
          t1.D_No_Of_Txn_98,  
          t1.D_No_Of_Txn_99,
          t1.D_Txn_Amt_89, 
          t1.D_Txn_Amt_90, 
          t1.D_Txn_Amt_91,  
          t1.D_Txn_Amt_92, 
          t1.D_Txn_Amt_93, 
          t1.D_Txn_Amt_94, 
          t1.D_Txn_Amt_95, 
          t1.D_Txn_Amt_96, 
          t1.D_Txn_Amt_97, 
          t1.D_Txn_Amt_98, 
          t1.D_Txn_Amt_99,  
          t1.MDAB_89, 
          t1.MDAB_90, 
          t1.MDAB_91, 
          t1.MDAB_92, 
          t1.MDAB_93, 
          t1.MDAB_94, 
          t1.MDAB_95, 
          t1.MDAB_96, 
          t1.MDAB_97, 
          t1.MDAB_98,
          t1.MDAB_99
      FROM MAINDATA.I_GRID_102_C t1;
QUIT;

data adhoc3.fd_broken_total;
set adhoc3.fd_broken_total;
run;

%macro run1();
%do i=0 %to 5 %by 1;

	data _null_;
	call symputx('mstart',cat('"',put(intnx('month',"01JUL2015"d,-&i.,'b'),date9.),'"d'));
	call symputx('mend',  cat('"',put(intnx('month',"01JUL2015"d,-&i.,'e'),date9.),'"d'));
	run;
	data _null_;
	call symputx('id',intck('month',"31MAR2007"d,&mstart.)-1);
	call symputx('flag',put(&mstart.,monyy7.));
	run;
%put &mstart. &mend. &id. &flag.;

	data base_&flag.;
	set adhoc3.fd_broken_total;
	where &mstart.<=datepart(contactstartdate)<=&mend.;
	run;

	proc sql;
	create table base_mid_&flag.(rename=(mdab_%eval(&id.-5)-mdab_%eval(&id.)=mdab6-mdab1
								C_Txn_Amt_%eval(&id.-5)-C_Txn_Amt_%eval(&id.)=C_Txn_Amt_6-C_Txn_Amt_1	
								D_Txn_Amt_%eval(&id.-5)-D_Txn_Amt_%eval(&id.)=D_Txn_Amt_6-D_Txn_Amt_1	
								C_No_of_Txn_%eval(&id.-5)-C_No_of_Txn_%eval(&id.)=C_No_of_Txn_6-C_No_of_Txn_1	
								D_No_of_Txn_%eval(&id.-5)-D_No_of_Txn_%eval(&id.)=D_No_of_Txn_6-D_No_of_Txn_1			
								)) as
	select t1.*,t2.*,&mstart. as timestamp format date9.
	from base_&flag. t1 left join adhoc3.number_grid
	(keep=cust_id mdab_%eval(&id.-5)-mdab_%eval(&id.)
	  C_Txn_Amt_%eval(&id.-5)-C_Txn_Amt_%eval(&id.)
	  D_Txn_Amt_%eval(&id.-5)-D_Txn_Amt_%eval(&id.)
	  C_No_of_Txn_%eval(&id.-5)-C_No_of_Txn_%eval(&id.)
	  D_No_of_Txn_%eval(&id.-5)-D_No_of_Txn_%eval(&id.)) t2
	on t1.cust_id=t2.cust_id;
	quit;

	proc sql;
	create table adhoc3.final_&flag. as
	select t1.*,t2.no_of_xh
	from base_mid_&flag. t1 left join prasad.i_xh_new_&id. t2
	on t1.cust_id=t2.cust_id;
	quit;

%end;
%mend;

%run1();

data adhoc3.final_fd_data;
set  adhoc3.final_FEB2015
	 adhoc3.final_MAR2015
	 adhoc3.final_APR2015
	 adhoc3.final_MAY2015
	 adhoc3.final_JUN2015
	 adhoc3.final_JUL2015;
run;

proc sql;
create table life_mapping as
select t1.*,t2.life_stage_f
from FD_BROKEN_TEST t1 left join campteam.lifestage_curr t2
on t1.cust_id=t2.cust_id;
quit;
