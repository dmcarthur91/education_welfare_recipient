/*
WHY ARE THE HIGHLY EDUCATED MORE SYMPATHETIC TOWARDS WELFARE RECIPIENTS?

DATA CLEANING AND VARIABLE CREATION CODEFILE 2 OF 2
USING BRITISH SOCIAL ATTITUDES DATA 1987-2018
AND LABOUR FORCE SURVEY

Daniel McArthur

version 2.0 

13 Nov 2021


THIS DOFILE CONTAINS ALL COMMANDS NECESSARY TO TAKE RAW DATA AND CREATE ALL VARIABLES USED IN SUBSEQUENT ANALYSIS

The following user written packages are required (available from ssc)

renvars

This file merges BSAS data with LFS data. Codefile to clean LFS data must be run first.

*/


////////////////////////////////////////////////////////////////////////////////
* CREATE SINGLE FILE WITH ALL VARIABLES
////////////////////////////////////////////////////////////////////////////////

clear all

set maxvar 15000


cd "C:\Users\shug3204\Dropbox\Education and negative stereotypes\working"


* RENAME ALL FILES, CONSISTENT FILE NAMES

clear

local raw_dir "C:\Users\shug3204\Dropbox\Education and negative stereotypes\raw"

use "`raw_dir'\UKDA-2567-stata8\stata8\bsa87.dta"
save bsa1987, replace

use "`raw_dir'\UKDA-2723-stata8\stata8\2723.dta"
save bsa1989  , replace

use "`raw_dir'\UKDA-2840-stata6\stata6\bsa90.dta"
save bsa1990  , replace

use "`raw_dir'\UKDA-2952-stata8\stata8\f952.dta"
save bsa1991  , replace

use "`raw_dir'\UKDA-3439-stata8\stata8\bsa93.dta"
save bsa1993  , replace

use "`raw_dir'\UKDA-3572-stata8\stata8\bsa94.dta"
save bsa1994  , replace

use "`raw_dir'\UKDA-3764-stata8\stata8\bsa95.dta"
save bsa1995  , replace

use "`raw_dir'\UKDA-3921-stata8\stata8\g921au.dta"
save bsa1996  , replace

use "`raw_dir'\UKDA-4131-stata8\stata8\bsa98a.dta"
save bsa1998  , replace

use "`raw_dir'\UKDA-4318-stata8\stata8\bsa99a.dta"
save bsa1999  , replace

use "`raw_dir'\UKDA-4486-stata8\stata8\bsa00.dta"
save bsa2000  , replace

use "`raw_dir'\UKDA-4615-stata6\stata6\bsa01.dta"
save bsa2001  , replace

use "`raw_dir'\UKDA-4838-stata6\stata6\bsa02.dta"
save bsa2002  , replace

use "`raw_dir'\UKDA-5235-stata6\stata6\bsa03.dta"
save bsa2003  , replace

use "`raw_dir'\UKDA-5329-stata8\stata8\bsa04.dta"
save bsa2004  , replace

use "`raw_dir'\UKDA-5618-stata8\stata8\bsa05.dta"
save bsa2005  , replace

use "`raw_dir'\UKDA-5823-stata8\stata8\bsa06.dta"
save bsa2006  , replace

use "`raw_dir'\UKDA-6240-stata8\stata8\bsa07.dta"
save bsa2007  , replace

use "`raw_dir'\UKDA-6390-stata8\stata8\bsa08.dta"
save bsa2008  , replace

use "`raw_dir'\UKDA-6695-stata8\stata8\bsa09.dta"
save bsa2009  , replace

use "`raw_dir'\UKDA-6969-stata9\stata9\bsa10.dta"
save bsa2010  , replace

use "`raw_dir'\UKDA-7237-stata11\stata11\bsa11.dta"
save bsa2011  , replace

use "`raw_dir'\UKDA-7476-stata11\stata11\bsa12.dta"
save bsa2012  , replace

use "`raw_dir'\UKDA-7500-stata11\stata11\bsa13ukds.dta"
save bsa2013  , replace

local raw_dir "C:\Users\shug3204\Dropbox\Education and negative stereotypes\raw"
use "`raw_dir'\UKDA-7809-stata11\stata11\bsa14_final.dta"
save bsa2014  , replace

use "`raw_dir'\UKDA-8116-stata11\stata11\bsa15_to_ukds_final.dta"
save bsa2015  , replace

use "`raw_dir'\UKDA-8252-stata11\stata11\bsa16_to_ukda.dta"
save bsa2016  , replace

use "`raw_dir'\8450stata_C074E549F0B37C915D5AA50D4FD85AB2_V1\UKDA-8450-stata\stata\stata11\bsa2017_for_ukda.dta"
save bsa2017  , replace

use "`raw_dir'\8606stata_317C977670ADF64EE4E7E89E09DE1024_V1\UKDA-8606-stata\stata\stata11\bsa2018_final_ukda.dta"
save bsa2018  , replace

///////////////////////////////////////////////////////////////////////////
* APPEND AND DROP ALL BUT NECESSARY VARIABLES
//////////////////////////////////////////////////////////////////////////

* rename all to lower case
* create year specific income variables to preserve specific category labels

clear

foreach x of numlist 1987 1989 1991 1993/1996 1998/2018 { 
    
use bsa`x'		

renvars _all, lower

if `x' < 2010 {
rename hhincome hhincome`x'
label copy hhincome hhincome`x'
label values hhincome`x' hhincome`x'    
}

else if `x' > 2009 {

rename  hhincd hhincd`x'
capture: label copy hhincd hhincd`x'
capture: label copy HHIncD hhincd`x'
label values hhincd`x' hhincd`x'    
	
}

save bsa`x', replace
}


clear

use bsa1987
foreach x of numlist  1989 1991 1993/1996 1998/2018 { 
append using bsa`x', gen(bsa`x') force
}

/*
using force suboption because some variables are of conflicting type
*/

keep ///
	welfhelp unempjob sochelp dolefidl welffeet ///
	redistrb bigbusnn wealth wealth1 richlaw indust4 ///
	censor obey deathapp stifsent tradvals socscale ///
	hedqual hhincd* hhincome* reconact rnseg rghclass rclassgp rsex ///
	raceori2 raceori3 raceorig ethnicgp  ///
	religsum tenure2 childhh kidsu16 ///  
	unionsa union  rage ragee married househld	///	  
	reconacte tenure2e raceori4 househlde ///
	serial sserial wtfactor oldwt gor gor2 gor_id revised_gor2 stregion bsa* ///
	politics polinrst politsc ///
	whyneed damlives proudwlf morewelf falseclm lessbenf  dole  ///
	partyid*
	
save bsa8718_import, replace

/////////////////////////////////////////////////////////////
* VARIABLE CREATION
/////////////////////////////////////////////////////////////

clear 

use bsa8718_import

* CREATE TIME VARIABLES

gen year = .

foreach y of numlist 1989 1991 1993/1996 1998/2018 {
replace year = `y' if bsa`y' == 1 
}	

replace year = 1987 if year==.

tab year

gen t = year-1987

* create tag
egen tagyr = tag(t)

* WEIGHT VARIABLE

gen compwt =.
replace compwt = wtfactor if year < 2005
replace compwt = oldwt if year >= 2005

////////////////////////////////////////////////////////////////////////////////
* CODE ATTITUDINAL VARIABLES
///////////////////////////////////////////////////////////////////////////////

numlabel redistrb bigbusnn wealth wealth1 richlaw indust4 ///
	welfhelp unempjob sochelp dolefidl welffeet ///
		tradvals stifsent deathapp obey censor ///
		damlives proudwlf morewelf falseclm lessbenf  dole ///
			, add mask("#. ")

* negbels 
tab1 welfhelp unempjob sochelp dolefidl welffeet, miss

foreach var of varlist welfhelp unempjob sochelp dolefidl welffeet {
tab year `var', miss
}

* lr  

foreach var of varlist redistrb bigbusnn wealth wealth1 richlaw indust4 {
tab year `var', miss
}

/*
Higher values = more right-wing

1994 version of wealth posed other way around
Ordinary people get their fair share of nations wealth
*/

* la - higher values = more libertarian - reverse

foreach var of varlist tradvals stifsent deathapp obey censor {
tab year `var', miss
}

* remove all missings

foreach var of varlist redistrb bigbusnn wealth wealth1 richlaw indust4 ///
	welfhelp unempjob sochelp dolefidl welffeet ///
		tradvals stifsent deathapp obey censor  {
replace `var' = . if `var' < 1
replace `var' = . if `var' > 5
}

* create reversed versions of all values 

foreach var of varlist redistrb bigbusnn wealth wealth1 richlaw indust4 ///
	welfhelp unempjob sochelp dolefidl welffeet ///
		tradvals stifsent deathapp obey censor {
recode `var' ///
	(1=5 "Strongly agree") (2=4 "Agree") (3=3 "Neither agree nor disagree") (4=2 "Disagree") (5=1 "Strongly disagree") ///
	, gen(`var'r)
}

* investigate wealth question

tab wealth1 year, col nof
tab wealth year if year > 1992 & year < 1997, col nof

/*
differences between two Qs in 1996 are minor
*/

replace wealth = wealth1r if year == 1994
replace wealthr = wealth1 if year == 1994

tab year wealthr , row nof


*** ADDITIONAL MEASURES OF PREFERENCES FOR SPENDING

tab1   dole

* remove missings 

foreach var of varlist damlives proudwlf morewelf falseclm  {
replace `var' = . if `var' < 1
replace `var' = . if `var' > 5
}

replace dole = . if dole < 1
replace dole = . if dole > 2


* reverse
* higher values = more negative

* falseclm 

recode falseclm ///
	(1=4 "Strongly agree") (2=3 "Agree")  (3=2 "Disagree") (4=1 "Strongly disagree") ///
	, gen(falseclmr)

tab falseclm falseclmr


save bsa8718, replace

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
* SCALE CREATION
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

foreach var of varlist welfhelpr unempjobr sochelpr dolefidlr welffeetr ///
tradvalsr stifsentr deathappr obeyr censorr ///
redistrb bigbusnn wealth richlaw indust4 {
tab year `var', nof col miss
}

/// all value vars available in all years

* NEGBELS

* simple average

egen nb_ = rowmean(welfhelpr unempjobr sochelpr dolefidlr welffeetr)
egen nb = std(nb_)
drop nb_

* factor scores
sem (Negb -> welfhelpr unempjobr sochelpr dolefidlr welffeetr) ///
	, stand 
estat gof, 	stat(rms indices ic)
alpha welfhelpr unempjobr sochelpr dolefidlr welffeetr, item

sem (Negb -> unempjobr sochelpr dolefidlr welffeetr) ///
	, stand 
estat gof, 	stat(rms indices ic)
alpha unempjobr sochelpr dolefidlr welffeetr, item

/*
factor has reasonable fit RMSEA around .05, CFI/TFI = c. .99
scale has reliablility around .8

removing welfhelpr associated with minor improvement in all fit statistics
as well as alpha
*/

factor unempjobr sochelpr dolefidlr welffeetr
predict nbf
summ nbf
hist nbf, w(.2)

egen nbfs = std(nbf)

/// symmetrically but pr not normally distributed
/// cor of two scales = .97 so conclusions unlikely to differ


* RIGHT-WING VALUES
tab1 redistrb bigbusnn wealth richlaw indust4

sem (LR -> redistrb bigbusnn wealth richlaw indust4), stand
estat gof , stat(rms indices ic)
alpha redistrb bigbusnn wealth richlaw indust4, item

/*
corrs w/ factor vary from .58 redist -> .79 wealth
rmsea around .09, TLI and CFI around .95
alpha is .82 - not improved by removal of any variable
*/

sem (LR -> bigbusnn wealth richlaw indust4), stand
estat gof , stat(rms indices ic)
alpha  bigbusnn wealth richlaw indust4, item

/*
corrs between .69 - .74
msea still around .09, CFI and TLI still around .95
alpha .80 - no improvement possible
*/

factor redistrb bigbusnn wealth richlaw indust4, factor(1)
predict lrf
summ lrf
egen lrfs = std(lrf)
summ lrfs
hist lrfs, w(.25)
/// clear right-skew w/ many respondents clustering at left-wing end of scale and long tail to right

* AUTHORITARIAN VALUES
sem (LA -> tradvalsr stifsentr deathappr obeyr censorr), stand
estat gof , stat(rms indices ic)
alpha tradvalsr stifsentr deathappr obeyr censorr, item

/*
corrs vary from .41 for censorr -> .75 stifsentr
rmsea around .07, CFI and TLI around .95
alpha = .71 - acceptable rather than good like other two
no improvement possible though removing censorr wouldn't decrease
*/

sem (LA -> tradvalsr stifsentr deathappr obeyr), stand
estat gof , stat(rms indices ic)
alpha tradvalsr stifsentr deathappr obeyr , item

/*
No improvement from removing
*/

factor tradvalsr stifsentr deathappr obeyr censorr, factors(1)
predict laf
egen lafs = std(laf)
summ laf lafs
hist lafs, w(.25)

/*
left skew w/ many very authoritarian Rs
*/

////////////////////////////////////////////////////////////////////
*  RECODE BELIEFS ABOUT CAUSES OF POVERTY
////////////////////////////////////////////////////////////////////	

tab whyneed
tab whyneed, nol 

foreach x of numlist -7 -2 5/9 {
replace whyneed = . if whyneed == `x' 
}

recode whyneed (2=0  "Laziness") (3=1 "Social injustice") ///
	(1=2 "Been unlucky") (4=3 "Inevitable"), gen(beliefs_poverty)

//////////////////////////////////////////////////////////////////////////////
* CODE EDUCATION AND ECONOMIC POSITION
//////////////////////////////////////////////////////////////////////////////

* EDUCATION
tab hedqual year

recode hedqual (1=0 "Degree") (2=1 "Further ed < degree") (3=2 "Upper secondary") ///
	(4 5=3 "Lower secondary") (7=4 "No qualification") (6 8=.), gen(educ)
	
tab year educ,row nof

gen degree = 1 if educ==0
replace degree = 0 if educ>=1 & educ <=4

* INCOME 

/*
income variables use different cutpoints in each year

within year income quintiles - expressing within year relative income
	just dividing up midpoint coded data
*/
 
foreach n of numlist  1987 1989 1991 1993/1996 1998/2009 {
  replace hhincome`n' = . if hhincome`n' < 0 | hhincome`n' > 90
}

foreach n of numlist 2010/2018 {
  replace hhincd`n' = . if hhincd`n' < 0 | hhincd`n' > 90
} 

* QUINTILES OF RELATIVE INCOME
* years w/ arbitrary groups
* do 1996 and 1998 manually

foreach n of numlist 1987 1989 1991 1993/1996 1998/2009 {
egen hhincomeq`n' = cut(hhincome`n') , group(5) icodes
}

foreach n of  numlist 2010/2018 {
recode hhincd`n' (1 2=0) (3 4=1) (5 6=2) (7 8=3) (9 10=4), gen(hhincdq`n')
}

egen hincq = rowmax(hhincomeq1987-hhincdq2018)

tab hincq
tab year hincq, row nof

/*
most quintile sizes are approximately close
bottom quintile has only 16% of Rs - only 9% in 1996 and 1998
for a few years there are simply too few categories  in lowest quintile
but 96 and 98 can be corrected manually
*/

recode hhincome1996 (3 5=0) (7 8=1) (9/11 =2) (12/15=3) (16/20=4) , gen(hhinc96q)

recode hhincome1998 (3 5=0) (7 8=1) (9/11 =2) (12/16=3) (17/21=4) , gen(hhinc98q)

replace hincq = hhinc96q if hhinc96q !=.
replace hincq = hhinc98q if hhinc98q !=.


label define hincq 0 "1st quintile" 1 "2nd quintile" 2 "3rd quintile" ///
	3 "4th quintile" 4 "5th quintile"
label values hincq hincq
tab year hincq	, row nof

* reverse direction of income dummy

gen hincqr = 4-hincq

label define hincqr 4 "1st quintile" 3 "2nd quintile" 2 "3rd quintile" ///
	1 "4th quintile" 0 "5th quintile"
label values hincqr hincqr

tab hincq hincqr



* SOCIAL CLASS

numlabel rnseg rghclass rclassgp , add mask("#. ")

tab1 rnseg rghclass rclassgp

/* recode post 2001 rnseg into rnsegd*/
recode rnseg (1 2 4 5 6 7 8=1) (9=2) (3 15 16 17=3) (11 12=4) (10 13 14 18=5) ///
(else=.), generate(rnsegd)
 label define rnsegd1 1 "salariat (higher and lower)" 2 "clerical (junior non-manual)" 3 ///
 "petty bourgeois" 4 "foremen/technicians" 5 "working class" 9 "don't know" 
 label values rnsegd rnsegd1
 
 /*recode pre 2001 rghclass into rghclassd*/
 recode rghclass (1 2=1) (3 4=2) (5/7=3) (8=4) (9/11=5) (else=.), generate(rghclassd)
 label define rghclassd 1 "Professional/managerial" 2 "Routine" 3 "Small petty bourgeoisie/ farmers" ///
 4 "manual" 5 "other manual" 9 "don't know"
 label values rghclassd rghclassd

 /* create joint variable */
 egen soccomp = rowmax(rnsegd rghclassd)
 replace soccomp = rclassgp if year >= 2016 & rclassgp > 0 & rclassgp < 6
 label define soccomp 1 "Salariat profs/manag" 2 "Clerical routine" 3 ///
 "Self-employed" 4 "Higher manual/routine" 5 "Lower manual/routine"
 label values soccomp soccomp
 
 tab year soccomp, row nof
 
 /*
 compromise for 2016 - using rclassgp as substitute for rnseg which is missing
 potentially causes some inaccuracy in lowest classes
 
 this variable contains discontinuities at 2001 when NSSEC classes introduced,
	and at 2016 when new way of calculating introduced
 */
 
* WORK STATUS
numlabel reconact reconacte, add mask("#. ")

recode reconact (3 4=0 "In work") (2 5/7=1 "Unemployed") (8=2 "Sick or disabled") (9=3 "Retired") ///
	(10=4 "Looking after home")(1=5 "In education") (11 99=.) , generate(econac)

recode reconacte (2 3=0 "In work") (4/6=1 "Unemployed") (7=2 "Sick or disabled") (8=3 "Retired") ///
	(9=4 "Looking after home")(1=5 "In education") (10 99=.) , generate(econace)
	
replace econac = econace if year >2016	
	
tab year econac, row nof	


////////////////////////////////////////////////////////////////////////////////
* DEMOGRAPHIC BACKGROUND
////////////////////////////////////////////////////////////////////////////////

* tenure
recode tenure2 (1=0 "Owner occupier") (2 3=1 "Social rent") (4=2 "Private rent") ///
	(5 9=.), generate(tenure)
	
recode tenure2e (1=0 "Owner occupier") (2 3=1 "Social rent") (4=2 "Private rent") ///
	(9=.), generate(tenure_)	
	
replace tenure = tenure_ if year > 2016	
	
tab year tenure, row nof

/* Marital status */
replace married = . if married > 4
tab year married, row nof
label define married1 1 "Married" 2 "Divorced" 3 "Widowed" 4 "Never married"
label values married married1

/* religion */
tab religsum

mvdecode religsum, mv(-1 8=.)
label define relig 1 "Anglican" 2 "Catholic" 3 "Oth Christian" 4 "Non-Christian" 5 "None"
label values religsum relig
 
* ethnicity
numlabel ethnicgp raceorig raceori2 RACEORI3 raceori4, add mask("#. ")
tab1 ethnicgp raceorig raceori2 raceori3 raceori4

recode raceorig (7/9 = 1) (1=2) (2/6=3) (10=4) (0 97/99=.)
recode raceori2 (1/3=2) (4/8=3) (9 10=1) (11 12=4) (98 99=.)
recode raceori3 (1/3=2) (4/8=3) (9=1) (10 11=4) (-1 98 99=.)
recode raceori4 (3=1) (1=2) (2=3) (4 5=4) (8 9=.)

egen ethnicity = rowmax(ethnicgp raceorig raceori2 raceori3 raceori4)
replace ethnicity = . if ethnicity ==9

label define ethnicity 1 "White" 2 "Black" 3 "Asian" 4 "Other/mixed"
label values ethnicity ethnicity

tab year ethnicity, nof row

* union
gen unionm = .
replace unionm = 0 if union ==3 | unionsa ==3
replace unionm = 1 if union ==1 | union==2 | unionsa==1 | unionsa==2

tab year unionm, row nof

label define unionm 0 "Non-member" 1 "Member"
label values unionm unionm
 
* household size 
* top code at 5
gen hsize = househld if househld < 99
replace hsize = 5 if hsize >5 & hsize !=. 
replace hsize = househlde if year>2016

label define hsize 1 "1" 2 "2" 3 "3" 4 "4" 5 "5+"
label values hsize hsize

tab year hsize, row nof

* gender
label define gender 1 "Male" 2 "Female"
label values rsex gender

* age
* get rid of all Rs > 95

label variable rage "Age"

replace rage = ragee if year >2016

replace rage = . if rage >95

///////////////////////////////////////////////////////////////////////////
* INTEREST IN POLITICS
///////////////////////////////////////////////////////////////////////////

/*
due to changing number of response options, going to reduce
	to binary variable distingushing those 'very' interested in politics/ take a 'great deal' of interest in politics from all others
	
the additional question only used when main question not available	

*/ 
 
tab1 politics  politsc
tab year politics  
tab year politsc  

gen polint = .

replace polint = 1 if politics == 1 | (politics ==. & politsc ==1)
replace polint = 0 if ///
	(politics > 1   & politics < 6) ///
	| (politics ==. & (politsc > 1  & politsc < 6)) 
	
tab year 	polint, row


///////////////////////////////////////////////////////////////////////////////
* POLITICAL PARTY IDENTIFICATION
//////////////////////////////////////////////////////////////////////////////

/// party1 -> 2003
/// partyidn -> 2005 onwards

recode partyid1  (1=0 "Conservative") (2=1 "Labour") (3/5=2 "Liberal Democrat") (6/8=3 "Other party") (10= 4 "None" ) (else = .) , gen(party_ID)

tab party_ID

tab year party_ID , row

///////////////////////////////////////////////////////////////////////////////
* REGION IDENTIFIERS
//////////////////////////////////////////////////////////////////////////////

recode gor (1=1 "North East") (2 3=2 "North West") (4=3 "Yorks & Humberside") (5=4 "East Midlands") (6=5 ///
 "West Midlands") (8=6 "Eastern") (10=7 "London") (9=8 "South East") (7=9 "South West") (11=10 "Wales") (12=11 "Scotland") ,gen(gorr)

recode gor2 (1=1 "North East") (2=2 "North West") (3=3 "Yorks & Humberside") (4=4 "East Midlands") (5=5 ///
 "West Midlands") (7=6 "Eastern") (8 9=7 "London") (10=8 "South East") (6=9 "South West") (11=10 "Wales") (12=11 "Scotland") ,gen(gor2r)

numlabel GOR_ID , add mask("#. ")
tab gor_id

numlabel revised_GOR2 , add mask("#. ")
tab revised_gor2

recode revised_gor2 (1=1 "North East") (2=2 "North West") (3=3 "Yorks & Humberside") ///
	(4=4 "East Midlands") (5=5 "West Midlands") (7=6 "Eastern") (8 9=7 "London") ///
	(10=8 "South East") (6=9 "South West") (11=10 "Wales") (12=11 "Scotland") ///
		,gen(rgor2r)

 
egen regn = rowmax(gorr gor2r gor_id rgor2r)

label define regn 1 "North East" 2 "North West" 3 "Yorks & Humberside" 4 "East Midlands" 5 ///
 "West Midlands" 6 "Eastern" 7 "London" 8 "South East" 9 "South West" 10 "Wales" 11 "Scotland"
label values regn regn

tab year regn , nof row

recode regn (1 2=1 "North") (3=2 "Yorks and Humb") (4=3 "E Midlands") (5=4 "W Midlands") (6 8=5 "East and SE") ///
(7=6 "London") (9=7 "South West") (10=8 "Wales") (11=9 "Scotland"), gen(regn2)
tab regn regn2

recode stregion (2 3=1 "North") (4=2 "Yorks and Humb") (6=3 "E Midlands") (5=4 "W Midlands") (7 9=5 "East and SE") ///
(10=6 "London") (8=7 "South West") (11=8 "Wales") (1=9 "Scotland"),gen(stregion2)
tab stregion stregion2

replace regn2 = stregion2 if(year<2001)

tab year regn2, nof row miss

* generate region by year indicator
egen rgnyr = group(regn2 year) ,label


/////////////////////////////////////////////////////////////////////////
* COHORTS
/////////////////////////////////////////////////////////////////////////

gen yrbrn = year-rage
hist yrbrn, w(1) xlabel(1900(10)2000) percent

* following Grasso et al 2019 - as control
egen chrtpg = cut(yrbrn) , at(1910 1925 1945 1959 1977 1990 2000)

tab chrtpg

* 5 year cohorts
egen chrt = cut(yrbrn) , at(1900(5)2000)

tab year chrt	

egen chrtregn = group(regn2 chrt)

///////////////////////////////////////////////////////////////////////////
* MERGE IN LFS CALCULATIONS OF COHORT AND YEAR LEVELS OF EDUCATION
//////////////////////////////////////////////////////////////////////////

* COHORT
merge m:1 chrt regn2 using ///
	LFS_edu_chrt_regn_revised 
	
tab chrt _merge	, miss
/// all members of 1925-1985 cohort matched

save BSA_8718_2104, replace


	
* DEFINE SET OF NON-MISSING RESPONDENTS

/*
all respondents with non-missing values 

also get rid of all respondents aged 25 or under so we can assume most
	Rs have finished full time education
	and also those currently in education	
*/

graph box rage, over(econac)

hist rage , by(educ, note("")) percent w(1)

tab rage educ if rage <=30, row nof

keep if nbfs  != .  & lafs  != .  & lrfs  != .  & educ  != .  & hincq  != . ///
	 & soccomp  != .  & econac  != .  & rsex  != .  &  tenure  != .  &  married  != . ///
	 & religsum  != .  &  ethnicity  != .  & unionm  != .  & hsize  != .  & rage  != .  &  ///
		year  != .  &  regn2  != .  & chrtpg != . &  compwt != . 

keep nbfs    lafs    lrfs    educ degree   hincqr   ///
	soccomp    econac    rsex     tenure     married  ///
	religsum     ethnicity    unionm    hsize    rage  polint party_ID beliefs_poverty ///
	year     regn2     compwt ///
	chrt chrtpg chrtregn rgnyr ///
	unempjobr sochelpr dolefidlr welffeetr /// 
	redistrb bigbusnn wealth richlaw indust4 ///
	tradvalsr stifsentr deathappr obeyr censorr ///
	pc_degree 

keep if rage >25
drop if econac == 5
drop if chrt == 1990 	

save bsa8718av_2104 , replace
