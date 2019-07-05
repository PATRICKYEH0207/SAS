data dn_1;
infile 'fliepath' dlm='09'x firstobs=2 dsd;
length SUBJID $16 Cohort $11;
input dbGaP_SubjID SUBJID $ Kidney ESRD Age Agedx DurT1D Sex Bsite_1 Bsite_2 LIPID BMI HBA1C Cohort $;
run; 
data dn_2;
infile 'fliepath' dlm=' ' dsd;
length FamilyID $16 SUBJID $16 ;
input FamilyID $ SUBJID $ FatherID MotherID Sex Kidney;
run; 
proc sort data=dn_1; 
by SUBJID; 
run;
proc sort data =dn_2; 
by SUBJID; 
run;
data dn_3;
merge dn_1 dn_2;
by SUBJID;
run;
/*已設定的case、control*/
data dn_4;
set dn_3;
if FatherID=. then delete;
run;
data dn_4;
set dn_4;
if ESRD=-9 then ESRD=.;
if BMI=-9 then BMI=.;
if HBA1C=-9 then HBA1C=.;
run;
data dn_4;
set dn_4;
if BMI=. then BMI_new=.;
if 0<BMI<18.5 then BMI_new=1;
if 18.5<=BMI<24 then BMI_new=2;
if 24<=BMI then BMI_new=3;
run;
data dn_4;
set dn_4;
if HBA1C=. then HBA1C_new=.;
if 0<HBA1C<7 then HBA1C_new=1;
if 7<=HBA1C then HBA1C_new=2;
run;
data dn_4;
set dn_4;
if bsite_1=1 then bsite=1;
if bsite_2=1 then bsite=2;
if bsite_1=0 and bsite_2=0 then bsite=3;
run;
data dn_4;
length outcome $ 10;
set dn_4;
if Kidney=2 or ESRD=2 then outcome='case';
else outcome='control';
run;
proc ttest data=dn_4;
class outcome;
var Age Agedx DurT1D ;
run;
proc means data=dn_4 median max min; 
var Age Agedx DurT1D;
run;
proc freq data=dn_4;
table outcome*sex/chisq;
run;
proc freq data=dn_4;
table outcome*BMI_new/chisq;
run;
proc freq data=dn_4;
table outcome*HBA1C_new/chisq;
run;
proc freq data=dn_4;
table outcome*cohort/chisq;
run;
proc freq data=dn_4;
table outcome*bsite/chisq;
run;
/*自記設定，BMI>=24*/
data dn_5;
set dn_3;
if FatherID=. then delete;
if ESRD=-9 then ESRD=.;
if BMI=-9 then BMI=.;
if HBA1C=-9 then HBA1C=.;
run;
data dn_5;
set dn_5;
if BMI<24 then delete;
run;
data dn_5;
set dn_5;
if HBA1C=. then HBA1C_new=.;
if 0<HBA1C<7 then HBA1C_new=1;
if 7<=HBA1C then HBA1C_new=2;
run;
data dn_5;
set dn_5;
if bsite_1=1 then bsite=1;
if bsite_2=1 then bsite=2;
if bsite_1=0 and bsite_2=0 then bsite=3;
run;
data dn_5;
length outcome $ 10;
set dn_5;
if ESRD=2 then outcome='case';
else if ESRD=1 and LIPID=0 then outcome='control';
else delete;
run;
proc sort data=dn_5;
by outcome;
run;
proc ttest data=dn_5;
class outcome;
var Age Agedx DurT1D ;
run;
proc means data=dn_5 median max min; 
var Age Agedx DurT1D;
run;
proc freq data=dn_5;
table outcome*sex/chisq;
run;
proc freq data=dn_5;
table outcome*HBA1C_new/chisq;
run;
proc freq data=dn_5;
table outcome*cohort/chisq;
run;
proc freq data=dn_5;
table outcome*bsite/chisq;
run;
/*自記設定，BMI<24*/
data dn_6;
set dn_3;
if FatherID=. then delete;
if ESRD=-9 then ESRD=.;
if BMI=-9 then BMI=.;
if HBA1C=-9 then HBA1C=.;
run;
data dn_6;
set dn_6;
if BMI>=24 then delete;
if BMI=. then delete;
run;
data dn_6;
set dn_6;
if HBA1C=. then HBA1C_new=.;
if 0<HBA1C<7 then HBA1C_new=1;
if 7<=HBA1C then HBA1C_new=2;
run;
data dn_6;
set dn_6;
if bsite_1=1 then bsite=1;
if bsite_2=1 then bsite=2;
if bsite_1=0 and bsite_2=0 then bsite=3;
run;
data dn_6;
length outcome $ 10;
set dn_6;
if ESRD=2 then outcome='case';
else if ESRD=1 and LIPID=0 then outcome='control';
else delete;
run;
proc ttest data=dn_6;
class outcome;
var Age Agedx DurT1D ;
run;
proc means data=dn_6 median max min; 
var Age Agedx DurT1D;
run;
proc freq data=dn_6;
table outcome*sex/chisq;
run;
proc freq data=dn_6;
table outcome*HBA1C_new/chisq;
run;
proc freq data=dn_6;
table outcome*cohort/chisq;
run;
proc freq data=dn_6;
table outcome*bsite/chisq;
run;
/*檢定常態*/
proc univariate data=dn_4 normal;
var Age;
qqplot Age;
run;
data dn_4;
set dn_4;
age_log=log(age);
run;
proc univariate data=dn_4 normal;
var Age_log;
qqplot Age_log;
run;
data dn_4;
set dn_4;
Age_sqrt=sqrt(age);
run;
proc univariate data=dn_4 normal;
var Age_sqrt;
qqplot Age_sqrt;
run;
data dn_4;
set dn_4;
Age_1=(age)**-1;
run;
proc univariate data=dn_4 normal;
var Age_1;
qqplot Age_1;
run;
proc univariate data=dn_5 normal;
var Age;
qqplot Age;
run;
data dn_5;
set dn_5;
age_log=log(age);
run;
proc univariate data=dn_5 normal;
var Age_log;
qqplot Age_log;
run;
data dn_5;
set dn_5;
Age_sqrt=sqrt(age);
run;
proc univariate data=dn_5 normal;
var Age_sqrt;
qqplot Age_sqrt;
run;
data dn_5;
set dn_5;
Age_1=(age)**-1;
run;
proc univariate data=dn_5 normal;
var Age_1;
qqplot Age_1;
run;
proc univariate data=dn_6 normal;
var Age;
qqplot Age;
run;
data dn_6;
set dn_6;
age_log=log(age);
run;
proc univariate data=dn_6 normal;
var Age_log;
qqplot Age_log;
run;
data dn_6;
set dn_6;
Age_sqrt=sqrt(age);
run;
proc univariate data=dn_6 normal;
var Age_sqrt;
qqplot Age_sqrt;
run;
data dn_6;
set dn_6;
Age_1=(age)**-1;
run;
proc univariate data=dn_6 normal;
var Age_1;
qqplot Age_1;
run;
/*Wilcoxon*/
proc npar1way wilcoxon correct=no data=dn_4;
class outcome;
var Age;
run;
proc npar1way wilcoxon correct=no data=dn_4;
class outcome;
var Agedx;
run;
proc npar1way wilcoxon correct=no data=dn_4;
class outcome;
var durt1d;
run;
proc npar1way wilcoxon correct=no data=dn_5;
class outcome;
var Age;
run;
proc npar1way wilcoxon correct=no data=dn_5;
class outcome;
var Agedx;
run;
proc npar1way wilcoxon correct=no data=dn_5;
class outcome;
var durt1d;
run;
proc npar1way wilcoxon correct=no data=dn_6;
class outcome;
var Age;
run;
proc npar1way wilcoxon correct=no data=dn_6;
class outcome;
var Agedx;
run;
proc npar1way wilcoxon correct=no data=dn_6;
class outcome;
var durt1d;
run;
