# Debit Card Segmentation

_Disclaimer: Client sensitive numbers and names have been altered to retain confidentiality._

The repository consists of five main files that detail the entire process, stage by stage. A brief description of the stages as well as accompanying graphs are shown below (the links lead to code deployed for each process):

[**Stage 1 - Data Collation**](https://github.com/jstephenj14/Debit-Card-Segmentation/blob/master/Stage%201%20-%20Data%20Collation.sas)- This primary stage of the process collects data from a variety of sources and consolidates them all to derive a customer level data source containing five attributes. Their derivation are described in this chart: 

<a href="https://drive.google.com/uc?export=view&id=1QX3Hw6eJ6W758j-GX8J6hkaxicvYqsl-"><img src="https://drive.google.com/uc?export=view&id=1QX3Hw6eJ6W758j-GX8J6hkaxicvYqsl-" style="width: 500px; max-width: 100%; height: auto" title="WOE Table" /></a>

[**Stage 2 - Data Cleaning**](https://github.com/jstephenj14/Debit-Card-Segmentation/blob/master/Stage%202%20-%20Data%20Cleaning.sas)- At this stage, the collated data is plotted to identify and treat outliers. Data is also transformed (using log functions) and standardized as well. Standardized values are used to profile clusters (discussed in Stage 5) while transformed values help arrive at stable clustering solutions. For example, the variables mean_txn_amt and mean_gap are treated and transformed like below:

<a href="https://drive.google.com/uc?export=view&id=18eySlnmfZGJosXvmfdKAFX5X3G7sYNsE"><img src="https://drive.google.com/uc?export=view&id=18eySlnmfZGJosXvmfdKAFX5X3G7sYNsE" style="width: 500px; max-width: 100%; height: auto" title="WOE Table" /></a>

[**Stage 3 - Clustering Process**](https://github.com/jstephenj14/Debit-Card-Segmentation/blob/master/Stage%203%20-%20Clustering%20Process.SAS)- After data is cleaned and transformed, the viable number of clusters was identified using a macro that runs PROC FASTCLUS for different number of clusters. Seven clusters were chosen to be optimal going by the scree plot below:

<a href="https://drive.google.com/uc?export=view&id=1Da0dlP7k3iMKiGkyWF106zuOMRHueK6U"><img src="https://drive.google.com/uc?export=view&id=1Da0dlP7k3iMKiGkyWF106zuOMRHueK6U" style="width: 500px; max-width: 100%; height: auto" title="WOE Table" /></a>

[**Stage 4 -  Cluster Validation**](https://github.com/jstephenj14/Debit-Card-Segmentation/blob/master/Stage%204%20-%20Cluster%20Validation.sas) - Clusters created from Stage 4 are further validated using Andrews Plots and Candisc graphs as shown below:
<a href="https://drive.google.com/uc?export=view&id=1PmPO0jLchKK2yj11lpgLXz5GuY-x-vFD"><img src="https://drive.google.com/uc?export=view&id=1PmPO0jLchKK2yj11lpgLXz5GuY-x-vFD" style="width: 500px; max-width: 100%; height: auto" title="WOE Table" /></a>
<a href="https://drive.google.com/uc?export=view&id=1jm7hXLShN3P4vUIBgSOJgfgQobuxbRSi"><img src="https://drive.google.com/uc?export=view&id=1jm7hXLShN3P4vUIBgSOJgfgQobuxbRSi" style="width: 500px; max-width: 100%; height: auto" title="WOE Table" /></a>

[**Stage 5 - Cluster Profiling**](https://github.com/jstephenj14/Debit-Card-Segmentation/blob/master/Stage%205%20-Cluster%20Profiling.sas) -  Post validation, resultant clusters are profiled in a variety of ways. Profile and star plots created based on standardized values for each of the clusters are shown below:
<a href="https://drive.google.com/uc?export=view&id=1-xAyA7y8c6eKQNKygsn6KILfwcUl3ine"><img src="https://drive.google.com/uc?export=view&id=1-xAyA7y8c6eKQNKygsn6KILfwcUl3ine" style="width: 500px; max-width: 100%; height: auto" title="WOE Table" /></a>
<a href="https://drive.google.com/uc?export=view&id=1FT8cpRO81KV8xilmNPtbSfdGHrNYaZ75"><img src="https://drive.google.com/uc?export=view&id=1FT8cpRO81KV8xilmNPtbSfdGHrNYaZ75" style="width: 500px; max-width: 100%; height: auto" title="WOE Table" /></a>
<a href="https://drive.google.com/uc?export=view&id=1LkCtEateETdMW3QAAaSZ4Af1M1WnRECK"><img src="https://drive.google.com/uc?export=view&id=1LkCtEateETdMW3QAAaSZ4Af1M1WnRECK" style="width: 500px; max-width: 100%; height: auto" title="WOE Table" /></a>
<a href="https://drive.google.com/uc?export=view&id=1ISYEX77T1nGbUoywzdKpyyeJ0nbLHXHE"><img src="https://drive.google.com/uc?export=view&id=1ISYEX77T1nGbUoywzdKpyyeJ0nbLHXHE" style="width: 500px; max-width: 100%; height: auto" title="WOE Table" /></a>
<a href="https://drive.google.com/uc?export=view&id=1Keen3F9DhP6Q_9urH9PI2aDX2tyEU04O"><img src="https://drive.google.com/uc?export=view&id=1Keen3F9DhP6Q_9urH9PI2aDX2tyEU04O" style="width: 500px; max-width: 100%; height: auto" title="WOE Table" /></a>
<a href="https://drive.google.com/uc?export=view&id=1qYNugPsFTgAYkCfi15yqzOJlnmA5frkd"><img src="https://drive.google.com/uc?export=view&id=1qYNugPsFTgAYkCfi15yqzOJlnmA5frkd" style="width: 500px; max-width: 100%; height: auto" title="WOE Table" /></a>
<a href="https://drive.google.com/uc?export=view&id=1nj7NEwZFb0Kw56KIRIB92du3zaloIQ4K"><img src="https://drive.google.com/uc?export=view&id=1nj7NEwZFb0Kw56KIRIB92du3zaloIQ4K" style="width: 500px; max-width: 100%; height: auto" title="WOE Table" /></a>
<a href="https://drive.google.com/uc?export=view&id=1AdRVg2xk2bUOMRWLDx-lDSGxzLQbAJvK"><img src="https://drive.google.com/uc?export=view&id=1AdRVg2xk2bUOMRWLDx-lDSGxzLQbAJvK" style="width: 500px; max-width: 100%; height: auto" title="WOE Table" /></a>

A three dimensional plot based on any three of the five variables may also be plotted used PROC G3D like below:
<a href="https://drive.google.com/uc?export=view&id=1SZHJqhmlt5Z9deTmreLW6VbQsMpXVlML"><img src="https://drive.google.com/uc?export=view&id=1SZHJqhmlt5Z9deTmreLW6VbQsMpXVlML" style="width: 500px; max-width: 100%; height: auto" title="WOE Table" /></a>


Subsequent 2 dimensional projections can also be plotted for deeper analysis:
<a href="https://drive.google.com/uc?export=view&id=1nRnHsXdvhGPnX4xM3YSIE_4idne2DZc9"><img src="https://drive.google.com/uc?export=view&id=1nRnHsXdvhGPnX4xM3YSIE_4idne2DZc9" style="width: 500px; max-width: 100%; height: auto" title="WOE Table" /></a>
