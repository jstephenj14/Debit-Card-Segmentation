_My name is John Stephen and I've created these pages to document my project work both at my workplace and otherwise. I am open to updating or improving any of the codes or processes I discuss here so feel free to reach out to me. Happy reading!_

_Disclaimer: Client sensitive numbers and names have been altered to retain confidentiality._

This repository consists of the SAS code that I developed and deployed to perform customer segmentation for one of my clients. The segmentation is done on debit card transaction data.

The repository consists of five main files that detail the entire process, stage by stage. A brief description of the stages as well as accompanying graphs are shown below (the links lead to code deployed for each process):

[**Stage 1 - Data Collation**](https://github.com/jstephenj14/Debit-Card-Segmentation/blob/master/Stage%201%20-%20Data%20Collation.sas)- This primary stage of the process collects data from a variety of sources and consolidates them all to derive a customer level data source containing five attributes. Their derivation are described in this chart: 

![](https://s14.postimg.org/yoa7k5k69/Data_Collation.png)

[**Stage 2 - Data Cleaning**](https://github.com/jstephenj14/Debit-Card-Segmentation/blob/master/Stage%202%20-%20Data%20Cleaning.sas)- At this stage, the collated data is plotted to identify and treat outliers. Data is also transformed (using log functions) and standardized as well. Standardized values are used to profile clusters (discussed in Stage 5) while transformed values help arrive at stable clustering solutions. For example, the variables mean_txn_amt and mean_gap are treated and transformed like below:

![](https://s13.postimg.org/uloyyp0t3/Data_Cleaning.png)

[**Stage 3 - Clustering Process**](https://github.com/jstephenj14/Debit-Card-Segmentation/blob/master/Stage%203%20-%20Clustering%20Process.SAS)- After data is cleaned and transformed, the viable number of clusters was identified using a macro that runs PROC FASTCLUS for different number of clusters. Seven clusters were chosen to be optimal going by the scree plot below:
![](https://s16.postimg.org/4mh0ker0l/Clustering_Process.png)

[**Stage 4 -  Cluster Validation**](https://github.com/jstephenj14/Debit-Card-Segmentation/blob/master/Stage%204%20-%20Cluster%20Validation.sas) - Clusters created from Stage 4 are further validated using Andrews Plots and Candisc graphs as shown below:
![](https://s21.postimg.org/4qrnb9htj/Clustering_Validation.png)
![](https://s21.postimg.org/d4schoinb/Clustering_Validation_Andrews.png) 

[**Stage 5 - Cluster Profiling**](https://github.com/jstephenj14/Debit-Card-Segmentation/blob/master/Stage%205%20-Cluster%20Profiling.sas) -  Post validation, resultant clusters are profiled in a variety of ways. Profile and star plots created based on standardized values for each of the clusters are shown below:
![](https://s11.postimg.org/osa2xz837/Profiling_All.png)
![](https://s11.postimg.org/e9a38t5f7/Profiling_1.png)
![](https://s11.postimg.org/89mc55kmr/Profiling_2.png)
![](https://s11.postimg.org/l2ag52w8j/Profiling_3.png)
![](https://s11.postimg.org/lt36auylv/Profiling_4.png)
![](https://s11.postimg.org/gvplpqwmr/Profiling_5.png)
![](https://s11.postimg.org/jr2owm0mr/Profiling_6.png)
![](https://s11.postimg.org/fvzau1hgz/Profiling_7.png)

A three dimensional plot based on any three of the five variables may also be plotted used PROC G3D like below:
![](https://s11.postimg.org/wat86lzg3/3_D_Profile.png)

Subsequent 2 dimensional projections can also be plotted for deeper analysis:
![](https://s11.postimg.org/bmpze4otv/2_D_Projection_1.png)
