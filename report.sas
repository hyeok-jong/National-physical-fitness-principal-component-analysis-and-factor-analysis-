proc import out =  d17
datafile = 'D:\UOS_2021_2\multi\report\2017.xlsx'
dbms = excel 
replace;
getnames = yes;
run;

proc import out =  d15
datafile = 'D:\UOS_2021_2\multi\report\2015.xlsx'
dbms = excel 
replace;
getnames = yes;
run;

proc import out =  d13
datafile = 'D:\UOS_2021_2\multi\report\2013.xlsx'
dbms = excel 
replace;
getnames = yes;
run;


proc import out =  d09
datafile = 'D:\UOS_2021_2\multi\report\2009.xlsx'
dbms = excel 
replace;
getnames = yes;
run;

proc import out =  d07
datafile = 'D:\UOS_2021_2\multi\report\2007.xlsx'
dbms = excel 
replace;
getnames = yes;
run;

proc means data =d17 maxdec = 2;
run;



data dd07;
set d07;
rename _COL0=age _COL1=sex _COL2=height _COL3=weight _COL4=bmi _COL5=run50 _COL6=jump _COL7=push _COL8=situp _COL9=iwan _COL10=su _COL11=bodyfat;
run;

data dd09;
set d09;
rename _COL0=age _COL1=sex _COL2=height _COL3=weight _COL4=bmi _COL5=situp _COL6=ak _COL7=jump _COL8=run20 _COL9=run50 _COL10=gul _COL11=iwan _COL12=su;
run;

data dd13;
set d13;
rename _COL0=age _COL2=height _COL3=weight _COL4=bmi _COL5=situp _COL6=ak _COL8=jump _COL9=run20 _COL10=run50  _COL11=bodyfat;
drop _COL7;
run;



data dd15;
set d15;
rename _COL0=age _COL1=sex _COL2=height _COL3=weight _COL4=bmi _COL5=situp _COL6=ak _COL8=jump _COL9=run20 _COL10=run50  _COL11=bodyfat _COL12=iwan _COL13=su;
drop _COL7;
run;

data dd17;
set d17;
rename _COL0=age _COL1=sex _COL2=height _COL3=weight _COL4=bmi _COL5=situp _COL6=ak _COL8=jump _COL9=run20 _COL10=gul  _COL11=run10 _COL12=bodyfat;
drop _COL7;
run;

/*연령대 추가한다*/
data all;
set dd07 dd09 dd13 dd15 dd17;
if 0<age<10 then ag = 0;
else if 9<age<20 then ag = 1;
else if 19<age<30 then ag = 2;
else if 29<age<40 then ag = 3;
else if 39<age<50 then ag = 4;
else if 49<age<60 then ag = 5;
else if 59<age<70 then ag = 6;
drop push gul;
run;

/*말도 안되는 121살 있어서 제외 하려고 그냥 연령그룸으로 추가 안해버림
추가로 70 한명인데 이거 노인 제외한 성인 이라서 그럼*/




/*dataset 속성 보기*/
proc contents data = all; run;




/*전체변수 평균 계산*/
proc means data = all maxdec = 2;
run;

/*age 결측 보기 위해 정렬*/
proc sort data = all out = sort_age;
by age;
run;


/*연령대별 표본 수 보기*/
proc sort data = all out = sort_ag;
by ag;
run;
proc means data = sort_ag mean maxdec = 1;
by ag;
run;


/* 성별 표본 수 보기*/
proc sort data = all out = sort_sex;
by sex;
run;
proc means data = sort_sex mean maxdec = 1;
by sex;
run;


/**/








/* 주성분 분석 */



proc princomp data = all;
var height weight bmi;
run;

proc princomp data = all covariance;
var height weight bmi;
run;


data aa;
set all;
if height = . then delete;
if weight = . then delete;
if bmi = . then delete;
if iwan = . then delete;
if su = . then delete;
if bodyfat = . then delete;
run;

proc princomp data = aa;
var height weight bmi iwan su bodyfat;
run;

proc princomp data = aa covariance;
var height weight bmi iwan su bodyfat;
run;


data aaa;
set all;
if height = . then delete;
if weight = . then delete;
if bmi = . then delete;
if iwan = . then delete;
if su = . then delete;
if bodyfat = . then delete;
if jump = . then delete;
if situp = . then delete;
run;

proc princomp data = aaa;
var height weight bmi iwan su bodyfat jump situp; 
run;

proc princomp data = aaa covariance;
var height weight bmi iwan su bodyfat jump situp; 
run;








data male;
set all;
if height = . then delete;
if weight = . then delete;
if bmi = . then delete;
if iwan = . then delete;
if su = . then delete;
if bodyfat = . then delete;
if jump = . then delete;
if situp = . then delete;
if sex=1;
run;


data female;
set all;
if height = . then delete;
if weight = . then delete;
if bmi = . then delete;
if iwan = . then delete;
if su = . then delete;
if bodyfat = . then delete;
if jump = . then delete;
if situp = . then delete;
if sex=2;
run;






proc princomp data = female covariance;
var height weight bmi iwan su bodyfat jump situp; 
run;
proc princomp data = female ;
var height weight bmi iwan su bodyfat jump situp; 
run;


proc princomp data = male covariance;
var height weight bmi iwan su bodyfat jump situp; 
run;
proc princomp data = male ;
var height weight bmi iwan su bodyfat jump situp; 
run;













data aaa;
set all;
if height = . then delete;
if weight = . then delete;
if bmi = . then delete;
if iwan = . then delete;
if su = . then delete;
if bodyfat = . then delete;
if jump = . then delete;
if situp = . then delete;
run;

proc factor data = aaa method = prin scree nfactors = 3 reorder;
var height weight bmi iwan su bodyfat jump situp; 
run;

proc factor data = aaa method = prin scree nfactors = 3 rotate = varimax reorder;
var height weight bmi iwan su bodyfat jump situp; 
run;

proc factor data = aaa method = ml scree nfactors = 2 heywood reorder;
var height weight bmi iwan su bodyfat jump situp; 
run;

proc factor data = aaa method = ml scree nfactors = 2 heywood reorder rotate = varimax;
var height weight bmi iwan su bodyfat jump situp; 
run;






proc factor data = female method = prin scree nfactors = 4 reorder;
var height weight bmi iwan su bodyfat jump situp; 
run;

proc factor data = female method = prin scree nfactors = 4 rotate = varimax reorder;
var height weight bmi iwan su bodyfat jump situp; 
run;

proc factor data = female method = ml scree nfactors = 2 heywood reorder;
var height weight bmi iwan su bodyfat jump situp; 
run;

proc factor data = female method = ml scree nfactors = 2 heywood reorder rotate = varimax;
var height weight bmi iwan su bodyfat jump situp; 
run;






proc factor data = male method = prin scree nfactors = 4 reorder;
var height weight bmi iwan su bodyfat jump situp; 
run;


proc factor data = male method = prin scree nfactors = 4 rotate = varimax reorder;
var height weight bmi iwan su bodyfat jump situp; 
run;

proc factor data = male method = ml scree nfactors = 2 heywood reorder;
var height weight bmi iwan su bodyfat jump situp; 
run;

proc factor data = male method = ml scree nfactors = 2 heywood reorder rotate = varimax;
var height weight bmi iwan su bodyfat jump situp; 
run;













data male;
set all;
if height = . then delete;
if weight = . then delete;
if bmi = . then delete;
if iwan = . then delete;
if su = . then delete;
if bodyfat = . then delete;
if jump = . then delete;
if situp = . then delete;
if sex=1;
run;


data female;
set all;
if height = . then delete;
if weight = . then delete;
if bmi = . then delete;
if iwan = . then delete;
if su = . then delete;
if bodyfat = . then delete;
if jump = . then delete;
if situp = . then delete;
if sex=2;
run;




/**/
