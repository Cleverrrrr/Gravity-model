libname in "C:\Users\antoi\OneDrive\Bureau\PROJET SAS";

/* Première étape : import des tables BACI. Mise en place du macro programme d'import */

%let path = C:\Users\antoi\OneDrive\Bureau\PROJET SAS\;

%macro import(data);
%do i=1998 %to 2012;
proc import out = in.Y&i 
datafile = "&path.&data.&i..csv"
replace;
getnames = yes;
run;
%end;
%mend;


%import(baci96_)

/* Deuxième étape : agrégation des quantités échangées entre les pays et création de la variable VU (valeur unitaire) 
comme une moyenne de prix pondéré par les quantités. Mise en place du macro programme d'agrégation */

%macro agreg;
%do  i = 1998 %to 2012;

data in.Y&i; set in.Y&i;
VU = v/q;
run;
proc sort data = in.Y&i;
by i j;
run;

proc means data = in.Y&i noprint;
by i j; var q; output out = agreg&i sum = sum_q; run;

data in.Y&i; merge in.Y&i agreg&i;
by i j;
pond = q/sum_q;
drop sum_q;
run;

proc means data = in.Y&i noprint; 
by i j; weight pond;
output out = in.agreg&i sum(q)= sum_q mean(vu) = mean_vu; run;
%end;
%mend;

%agreg

%macro retouche;
%do i = 1998 %to 2012;
data in.agreg&i; set in.agreg&i;
drop _TYPE_ and _FREQ_;
annee = &i;
run;
%end;
%mend;

%retouche


proc import out = in.PIB
datafile = "C:\Users\antoi\OneDrive\Bureau\PROJET SAS\PIB_nominal_USD.xls"
dbms = xls replace;
getnames = yes;
run;

data in.PIB; set in.PIB;
drop _1963 _1964 _1965 _1966 _1967 _1968 _1969 _1970 _1971 _1972 _1973 _1974 _1975 _1976 _1977 _1978 _1979 _1980 _1981
_1982 _1983 _1984 _1985 _1986 _1987 _1988 _1989 _1990 _1991 _1992 _1993 _1994 _1995 _1996 _1997
;
run;


data in.code_pays;
input  country_code & $ i ;
list;
cards;
ABW     533
AFG   4  
ALB   8  
ATA   10  
DZA   12  
ASM   16  
AND   20  
AGO   24  
ATG   28  
AZE   31  
ARG   32  
AUS   36  
AUT   40  
BHS   44  
BHR   48  
BGD   50  
ARM   51  
BRB   52  
BEL     56  
BMU     60  
BTN     64  
BOL     68  
BES     535  
BIH     70  
BWA     72  
BVT     74  
BRA     76  
IOT     86  
BRN     96  
BGR     100  
BFA     854  
BDI     108  
CPV     132  
KHM     116  
CMR     120  
CAN     124  
CYM     136  
CAF     140  
TCD     148  
CHL     152  
CHN     156  
CXR     162  
CCK     166  
COL     170  
COM     174  
COD     180  
COG     178  
COK     184  
CRI     188  
CIV     384  
HRV     191  
CUB     192  
CUW     531  
CYP     196  
CZE     203  
DNK     208  
DJI     262  
DMA     212  
DOM     214  
ECU     218  
EGY     818  
SLV     222  
GNQ     226  
ERI     232  
EST     233  
SWZ     748  
ETH     231  
FLK     238  
FRO     234  
FJI     242  
FIN     246  
FRA     250  
GUF     254  
PYF     258  
ATF     260  
GAB     266  
GMB     270  
GEO     268  
DEU     276  
GHA     288  
GIB     292  
GRC     300  
GRL     304  
GRD     308  
GLP     312  
GUM     316  
GTM     320  
GGY     831  
GIN     324  
GNB     624  
GUY     328  
HTI     332  
HMD     334  
VAT     336  
HND     340  
HKG     344  
HUN     348  
ISL     352  
IND     356  
IDN     360  
IRN     364  
IRQ     368  
IRL     372  
IMN     833  
ISR     376  
ITA     380  
JAM     388  
JPN     392  
JEY     832  
JOR     400  
KAZ     398  
KEN     404  
KIR     296  
PRK     408  
KOR     410  
KWT     414  
KGZ     417  
LAO     418  
LVA     428  
LBN     422  
LSO     426  
LBR     430  
LBY     434  
LIE     438  
LTU     440  
LUX     442  
MAC     446  
MKD     807  
MDG     450  
MWI     454  
MYS     458  
MDV     462  
MLI     466  
MLT     470  
MHL     584  
MTQ     474  
MRT     478  
MUS     480  
MYT     175  
MEX     484  
FSM     583  
MDA     498  
MCO     492  
MNG     496  
MNE     499  
MSR     500  
MAR     504  
MOZ     508  
MMR     104  
NAM     516  
NRU     520  
NPL     524  
NLD     528  
NCL     540  
NZL     554  
NIC     558  
NER     562  
NGA     566  
NIU     570  
NFK     574  
MNP     580  
NOR     578  
OMN     512  
PAK     586  
PLW     585  
PSE     275  
PAN     591  
PNG     598  
PRY     600  
PER     604  
PHL     608  
PCN     612  
POL     616  
PRT     620  
PRI     630  
QAT     634  
REU     638  
ROU     642  
RUS     643  
RWA     646  
BLM     652  
SHN     654  
KNA     659  
LCA     662  
MAF     663  
SPM     666  
VCT     670  
WSM     882  
SMR     674  
STP     678  
SAU     682  
SEN     686  
SRB     688  
SYC     690  
SLE     694  
SGP     702  
SXM     534  
SVK     703  
SVN     705  
SLB     90  
SOM     706  
ZAF     710  
SGS     239  
SSD     728  
ESP     724  
LKA     144  
SDN     729  
SUR     740  
SJM     744  
SWE     752  
CHE     756  
SYR     760  
TWN     158  
TJK     762  
TZA     834  
THA     764  
TLS     626  
TGO     768  
TKL     772  
TON     776  
TTO     780  
TUN     788  
TUR     792  
TKM     795  
TCA     796  
TUV     798  
UGA     800  
UKR     804  
ARE     784  
GBR     826  
UMI     581  
USA     840  
URY     858  
UZB     860  
VUT     548  
VEN     862  
VNM     704  
VGB     92  
VIR     850  
WLF     876  
ESH     732  
YEM     887  
ZMB     894  
ZWE     716  
  ;
run;

%macro tri(tab);
proc sort data = in.&tab;
by country_code;
run;
%mend;

%tri (code_pays)
%tri (pib);

data in.pib2; merge in.pib(in=in1) in.code_pays (in=in2);
by country_code; 
if in1 = 1 and in2 = 1;
run;


data in.pib2; set in.pib2;
j = i ;
drop pib_j;
run;

%macro mise_au_propre;
%do i = 1998 %to 2012;
data in.P&i; set in.pib2;
keep _&i i j;
if _&i = . then delete;
run;

data in.P&i; set in.P&i;
pib_j = _&i;
run;

data in.pi&i; set in.P&i;
drop pib_j j;
rename _&i = pib_i;
run;

data in.pj&i; set in.P&i;
drop _&i i;
run;
%end;
%mend;

%mise_au_propre;

%macro tri2(tab,var);
%do i = 1998 %to 2012;
proc sort data = in.&tab&i; 
by &var;
run;
%end;
%mend;

%tri2 (interm,i);
%tri2 (pj,j);

%macro merge2;
%do i = 1998 %to 2012;
data in.inter&i; merge in.agreg&i (in=in1) in.pi&i (in=in2);
by i;
if in1 = 1 and in2 = 1; 
run;
%end;
%mend;

%merge2;

%macro merge3;
%do i = 1998 %to 2012;
data in.V2interm&i; merge in.interm&i (in=in1) in.dist3(in=in2);
by i j;
if in1 = 1 and in2 = 1;
run;
%end;
%mend;

%merge3;

%macro log(var1, var2);
%do i=1998 %to 2012;
data in.interm&i; set in.interm&i;
&var1=log(&var2);
run;
%end;
%mend;

%log(l_pib_j,pib_j);

%macro supp;
%do i = 1998 %to 2012;
data in.interm&i; set in.interm&i;
drop l_q;
run;
%end;
%mend;
%supp;

%macro exp;
%do i = 1998 %to 2012;
data in.interm&i; set in.interm&i;
x=sum_q*mean_vu;
run;
%end;
%mend;
%exp;

proc import out=in.dist
Datafile="C:\Users\antoi\OneDrive\Bureau\PROJET SAS\dist_cepii.xls"
Dbms=xls replace;
getnames = yes;
run;


%macro tri_general /*()*/;
%do i = 1998 %to 2012;
proc sort data = in.interm&i;
by i j;
run;
%end;
%mend;

%tri_general/*(in.dist3)*/;

data in.code_pays; set in.code_pays;
rename country_code = iso_o;
iso_d = country_code;
j = i; 
run;

data tabi; set in.code_pays;
keep iso_o i;
run;

data tabj; set in.code_pays;
keep iso_d j;
run;

Data interm; merge in.dist tabi;
by iso_o;
run;

data in.dist3; merge interm tabj;
by iso_d;
run;

data in.dist3; set in.dist3;
if nmiss(contig) then delete;
run;

data in.dist3; set in.dist3;
keep i j contig comlang_off comlang_ethno colony comcol dist;
run;

data in.final; set in.V2interm1998 in.V2interm1999 in.V2interm2000 in.V2interm2001 in.V2interm2002 in.V2interm2003 
in.V2interm2004 in.V2interm2005 in.V2interm2006 in.V2interm2007 in.V2interm2008 in.V2interm2009 in.V2interm2010 
in.V2interm2011 in.V2interm2012;
run;

data test; set in.V2interm1998 in.V2interm1999;
run;

data test; set test;
if annee = 1999 then dum1999 = 1 ; else dum1999 = 0;
run;

%macro dum;
%do i = 1999 %to 2012;
data in.final; set in.final;
if annee = &i then dum&i = 1 ; else dum&i = 0;
run;
%end;
%mend;

%dum;

proc reg data = in.final;
model x = l_pib_i l_pib_j contig comlang_off comlang_ethno colony comcol dist dum1999 dum2000 dum2001 dum2002 dum2003
dum2004 dum2005 dum2006 dum2007 dum2008 dum2009 dum2010 dum2011 dum2012;
plot x*l_pib_i;
output out = resid_predict p = prev r = resid; 
run;quit;


proc corr data = in.final; var x; with l_pib_i l_pib_j dist comlang_ethno contig colony comcol; run; quit;

proc hpcountreg data = in.final;
model x = l_pib_i l_pib_j dist contig comlang_ethno colony comcol dist dum1999 dum2000 dum2001 dum2002 dum2003
dum2004 dum2005 dum2006 dum2007 dum2008 dum2009 dum2010 dum2011 dum2012; 
run; quit;


proc gchart data = resid_predict;
vbar resid / levels = 10; 
title "Exchanges density in &i";
run; quit;

proc mcmc data = resid_predict; parms alpha 0; prior alpha ~ normal (0, sd = 1); model general(0);run;quit;
 
proc export data = resid_predict
outfile = "C:\Users\antoi\OneDrive\Bureau\PROJET SAS\tab_resid.xlsx"
dbms = xlsx replace;
run;
 
symbol1 i = join;
proc gplot data = in.final;
plot x*annee;
run;

data in.final; set in.final;
l_x = log(x);
run;


data in.final; set in.final;
l_dist = log(dist);
run;

proc reg data = in.final plots(maxpoints = none);
model l_x = l_pib_i l_pib_j contig comlang_off comlang_ethno colony comcol l_dist dum1999 dum2000 dum2001 dum2002 dum2003
dum2004 dum2005 dum2006 dum2007 dum2008 dum2009 dum2010 dum2011 dum2012;
plot  l_x*l_pib_i;
output out = resid_predict p = prev r = resid; 
run;quit;

%macro create_dum(var, tab);

proc sort data = in.final;
by &var;
run;

proc means data = in.final mean noprint;
var x;
by &var;
output out = &tab mean = moyenne;
run;

data &tab; set &tab;
drop _type_ _freq_ moyenne; 
run;

proc sql noprint;
select &var
into : listevar separated by " "
from &tab;
quit;

%let nb_i = %sysfunc(countw(&listevar , " "));

%macro dum;
%do i = 1 %to &nb_i;
%let pays = %scan(&listevar, &i);
data &tab; set &tab;
if &var = &pays then dum_&var&pays = 1; else dum_&var&pays = 0;
run;
%end;
%mend;

%dum;

%mend;

%create_dum(i, stat);
%create_dum(j, stat1);

proc means data = in.final noprint mean;
var x;
by j;
output out = stat2
mean = moy_x;
run;

proc means data = stat2 noprint max;
var moy_x;
output out = test
max = maxi;
run;

data stat; set stat;
drop dum_i156;
run;

data stat1; set stat1;
drop dum_j392;
run;

%macro sort(var, tab);
proc sort data = &tab;
by &var;
run;
%mend;

%macro merge(var, tab);
data in.final; merge in.final &tab;
by &var;
run;
%mend;

%sort(i, stat);
%sort(i, in.final);
%merge(i, stat);

%sort(j, stat1);
%sort(j, in.final);
%merge(j, stat1);


data temp; set stat;
drop i;
run;
proc transpose data = temp out = challah;
run;

proc sql noprint;
select _NAME_
into : listevar1 separated by " "
from challah;
quit;

data temp1; set stat1;
drop j;
run;
proc transpose data = temp1 out = challah1;
run;

proc sql noprint;
select _NAME_
into : listevar2 separated by " "
from challah1;
quit;

%put &listevar1;
%put &listevar2;


proc reg data = in.final;
model l_x = l_pib_i l_pib_j contig comlang_off comlang_ethno colony comcol l_dist dum1999 dum2000 dum2001 dum2002 dum2003
dum2004 dum2005 dum2006 dum2007 dum2008 dum2009 dum2010 dum2011 dum2012 &listevar1 &listevar2 / covb white;
output out = resid_predict r = resid p = predict;
run;quit;

proc univariate data = resid_predict noprint;
histogram resid / vaxislabel = 'Fréquences';
run;quit; 


proc export data = in.final
outfile = "C:\Users\antoi\OneDrive\Bureau\PROJET SAS\final_1.csv"
dbms = csv replace;
run;

%macro plot(var);
symbol1 i = rl;
proc gplot data = in.final; 
plot l_x*&var;
run;quit;
%mend;

%plot(l_pib_j);

proc gchart data = in.final;
vbar3D  l_x / group = annee;
run; quit;



