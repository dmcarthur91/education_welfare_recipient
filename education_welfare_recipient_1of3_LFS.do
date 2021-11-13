/*
WHY ARE THE HIGHLY EDUCATED MORE SYMPATHETIC TOWARDS WELFARE RECIPIENTS?

DATA CLEANING AND VARIABLE CREATION CODEFILE 1 OF 2

EDUCATION BY BIRTH-COHORT AND REGION

LABOUR FORCE SURVEY 1984-1991, QUARTERLY LABOUR FORCE SURVEY 1992-2019

Daniel McArthur

version 2.0 

13 Nov 2021

The following user written packages are required (available from ssc)

renvars

USING DATA FROM LABOUR FORCE SURVEY 1984-1991
AND QUARTERLY LFS 1992-2019 -> USING JULY TO SEPTEMBER WAVE ONLY

METHODOLOGY
Aggregate all waves of LFS
And drop Respondents in 5th wave in quarterly version to avoid double counting

Create measure of degree attainment

Lower levels of qualification more difficult to reconcile

qualifications change in 1996
fewer 'other' in 2011 due to question change

restrict to consistent 25-59 population in all years

*/

* setup

version 16.1
set more off

clear all

* top directory 

local topdir "C:\Users\shug3204\Dropbox\Education and negative stereotypes"

cd "`topdir'/working"

local _import 1
local _append 1
local _clean 1
local _collapse 1 


* IMPORT RAW AND SAVE ONLY NEEDED VARS

*********************************************************************************
* IMPORT RAW
*********************************************************************************

if `_import' == 1 {

local rawdir "C:\Users\shug3204\Dropbox\Education and negative stereotypes\raw\LFS"

local fn  `"   "`rawdir'\2143stata6_f9b9a90325f8b81eae5da1a6e1b5d2df\UKDA-2143-stata6\stata6\lfs1984.dta"    "`rawdir'\2265stata6_0f001822e238d4c388c680789c785e8f\UKDA-2265-stata6\stata6\lfs1985.dta"    "`rawdir'\2360stata6_a666d64b460a0d65a09b537b27537212\UKDA-2360-stata6\stata6\lfs1986.dta"		"`rawdir'\2720stata6_bc28b244b2a48af73e189593ab3c90ce\UKDA-2720-stata6\stata6\lfs1987.dta"		"`rawdir'\2721stata6_235687b9c300105b89a11b5f8b6c1678\UKDA-2721-stata6\stata6\lfs1988.dta"		"`rawdir'\2722stata6_64ab87351d907fa00ef2a3547fe79bb4\UKDA-2722-stata6\stata6\lfs1989.dta"		"`rawdir'\2839stata6_6976e2d481cd02d90ed8628b481a9a25\UKDA-2839-stata6\stata6\lfs1990.dta"		"`rawdir'\2875stata6_9e90ca0e93e1ab99a8b760fc79bdee5a\UKDA-2875-stata6\stata6\lfs1991.dta"		"`rawdir'\5888stata8_cb5009fa6c9406cbaad58228f2215da4\UKDA-5888-stata8\stata8\qlfsjs92.dta"		"`rawdir'\5885stata8_1e0752dd37292b56f6420b99127d8100\UKDA-5885-stata8\stata8\qlfsjs93.dta"		"`rawdir'\5881stata8_e09ca157371e1527f21add1682218ce4\UKDA-5881-stata8\stata8\qlfsjs94.dta"		"`rawdir'\5877stata8_4fc6edbde76ba669c2f8ef3580ced6fd\UKDA-5877-stata8\stata8\qlfsjs95.dta"		"`rawdir'\5873stata8_56af0fe4179ed233f64c661b2d6f69f1\UKDA-5873-stata8\stata8\qlfsjs96.dta"		"`rawdir'\5870stata8_8fee3318339184133207de825e0f6320\UKDA-5870-stata8\stata8\qlfsjs97.dta"		"`rawdir'\5867stata8_9e0148fde569ee62d22e8b4a824f0906\UKDA-5867-stata8\stata8\qlfsjs98.dta"		"`rawdir'\5864stata8_00fd34e2c14d369171f027266fedb1e5\UKDA-5864-stata8\stata8\qlfsjs99.dta"		"`rawdir'\5858stata8_ca31728ba9f7e6a93f2777af28fbc488\UKDA-5858-stata8\stata8\qlfsjs00.dta"		"`rawdir'\5855stata11_93752c093091923187ad7f95c6c4f83f\UKDA-5855-stata11\stata11\lfsp_js01_end_user.dta"	"`rawdir'\5847stata11_262c5c46886f1a15f48db96c703f6c59\UKDA-5847-stata11\stata11\lfsp_js02_end_user.dta"		"`rawdir'\5845stata11_4107df8147f633974e139e2745909a60\UKDA-5845-stata11\stata11\lfsp_js03_end_user.dta"	"`rawdir'\5843stata11_96a29ce3857554402318725f03ac5b3b\UKDA-5843-stata11\stata11\lfsp_js04_end_user.dta"	"`rawdir'\5428stata11_bc5e663f96d0c716da240ebce0956a5f\UKDA-5428-stata11\stata11\lfsp_js05_end_user.dta"	"`rawdir'\5547stata11_89fd5302549cb412cebb49eafd97a298\UKDA-5547-stata11\stata11\lfsp_js06_end_user.dta"	"`rawdir'\5763stata11_fe7203e6602ee97d8cec8d485df18a8e\UKDA-5763-stata11\stata11\lfsp_js07_end_user.dta"	"`rawdir'\6074stata11_b6887c470cb15509aa20af493c8ffac9\UKDA-6074-stata11\stata11\lfsp_js08_end_user.dta"	"`rawdir'\6334stata11_c90adf5537616db3d1945e9a8affee31\UKDA-6334-stata11\stata11\lfsp_js09_end_user.dta"	"`rawdir'\6632stata11_d62d0ca1d8751a6e3bc69126e949dd9d\UKDA-6632-stata11\stata11\lfsp_js10_end_user.dta"	"`rawdir'\6906stata_93F8DADCE33FA55AEDEEAB2ABFDFFB94_V1\UKDA-6906-stata\stata\stata11\lfsp_js11_end_user_pwt18.dta"	"`rawdir'\7174stata_212BB6E8BB6663A2D7BC1F951844D603_V1\UKDA-7174-stata\stata\stata11\lfsp_js12_end_user.dta"	"`rawdir'\7452stata_77E0AA2CCFBB0AAD299F990C87229B49_V1\UKDA-7452-stata\stata\stata11\lfsp_js13_end_user.dta"	"`rawdir'\7570stata_AC25D1D54FED76192EC8F31A63407157_V1\UKDA-7570-stata\stata\stata11\lfsp_js14_end_user.dta"	"`rawdir'\7842stata_32B34264120E80151739371CBC264BF4_V1\UKDA-7842-stata\stata\stata11\lfsp_js15_eul.dta"	"`rawdir'\8104stata_EDF031DFD7652E17C1CD9A8D2BD52C4D_V1\UKDA-8104-stata\stata\stata11\lfsp_js16_eul.dta"	"`rawdir'\8292stata_CBB29630EA070EDFB448CE0E7B217B1C_V1\UKDA-8292-stata\stata\stata11\lfsp_js17_eul.dta"	"`rawdir'\8407stata_F9947AF9165720B2EC0049FB15D86D33_V1\UKDA-8407-stata\stata\stata11\lfsp_js18_eul.dta"    "`rawdir'\8588stata_AE3CB283CB8EF2DA962AD716E127D2CD_V1\UKDA-8588-stata\stata\stata11\lfsp_js19_eul.dta"         "'


local y 1984

foreach f of local fn {
clear	
use "`f'"

save LFS_`y'_revised, replace	

renvars _all , lower

if `y' < 1985 {

keep quala fage sex urescomf pwt03
rename  quala quala_`y'
label copy quala quala_`y'
label values quala_`y' quala_`y'	
}

else if `y' < 1992 {
keep age qualsm1  sex ereg  region pwt03 weight1
rename qualsm1 qualsm1_`y'
label copy qualsm1 qualsm1_`y'
label values qualsm1_`y' qualsm1_`y'
}
else if `y' < 1996 {	
keep age hiquap qual0 sex thiswv wavfnd govtor pwt07
rename hiquap hiquap_`y'
label copy hiquap hiquap_`y'
label values hiquap_`y' hiquap_`y'
rename qual0 qual0_`y'
label copy qual0 qual0_`y'
label values qual0_`y' qual0_`y'	
}
else if `y' < 2001 {	
keep age hiquald hiqual sex thiswv wavfnd govtor pwt07	
}
else if `y' < 2004 {	
keep age hiquald hiqual sex thiswv wavfnd govtor pwt14	
}
else if `y' == 2004 {	
keep age hiqual4d hiqual4 sex thiswv wavfnd govtor	pwt14
}
else if `y' < 2008 {	
keep age hiqual5d hiqual5 sex thiswv wavfnd govtor	pwt14
}
else if `y' < 2011 {	
keep age hiqual8d hiqual8 sex thiswv wavfnd govtor	pwt14
}
else if `y' < 2015 {	
keep age hiqul11d hiqual11 sex thiswv wavfnd govtor	pwt18
}
else  {	
keep age hiqul15d hiqual15 sex thiswv wavfnd gor9d govtof2	pwt18
}

save LFS_`y'_revised , replace

local ++y

sleep 1000

}

}

*********************************************************************************
* APPEND TOGETHER
*********************************************************************************

if `_append' == 1 {

clear

use LFS_1984_revised

gen year = 1984

foreach y of numlist  1985/2019 {
append using	LFS_`y'_revised , gen(app`y')
replace year = `y' if app`y' ==1
}

drop app*

save LFS_8419_revised, replace


}

*********************************************************************************
* HARMONISE VARIABLES FOR CALCULATIONS
*********************************************************************************

if `_clean' == 1 {
	
clear

use 	LFS_8419_revised

numlabel, add mask("#. ")


/*

DEGREE ONLY

code all other qualifications as not degree 
including missing values/ dk / other
so we can use whole population of cohort as denominator

this is more robust to changing size of 'other' qualifications

1996 -> 2018 = Degree or equivalent

pre 1996 -> higher degree, first degree, other degree

*/

* 1996-2019
recode hiqul15d (1=1) (.=.) (else=0) , gen(degree15)
tab degree15

recode hiqul11d (1=1)  (.=.)  (else=0) , gen(degree11)
tab degree11

recode hiqual8d (1=1)  (.=.)  (else=0) , gen(degree8)
tab degree8

recode hiqual5d (1=1)  (.=.)  (else=0) , gen(degree5)
tab degree5

recode hiqual4d (1=1)  (.=.)  (else=0) , gen(degree4)
tab degree4

recode hiquald (1=1)  (.=.)  (else=0) , gen(degree96)
tab degree96


* 1995
recode hiquap_1995 (1/3 =1)   (.=.)  (else=0) , gen(degree95)
tab degree95

* 1994 
recode hiquap_1994 (1/3 =1)   (.=.)  (else=0) , gen(degree94)
tab degree94

* 1993
recode hiquap_1993 (1/3 =1)  (.=.)   (else=0) , gen(degree93)
tab degree93

* 1992
recode hiquap_1992 (1/3 =1)  (.=.)   (else=0) , gen(degree92)
tab degree92

* 1991
recode qualsm1_1991  (1/3 =1)   (.=.)  (else=0) , gen(degree91)
tab degree91

* 1990
recode qualsm1_1990  (1/3 =1)   (.=.)  (else=0) , gen(degree90)
tab degree90

* 1989
recode qualsm1_1989  (1/3 =1)  (.=.)   (else=0) , gen(degree89)
tab degree89

* 1988
recode qualsm1_1988  (1/3 =1)   (.=.)  (else=0) , gen(degree88)
tab degree88

* 1987
recode qualsm1_1987  (1/3 =1)   (.=.)  (else=0) , gen(degree87)
tab degree87

* 1986
recode qualsm1_1986  (1/3 =1)   (.=.)  (else=0) , gen(degree86)
tab degree86

* 1985

recode qualsm1_1985  (1/3 =1)   (.=.)  (else=0) , gen(degree85)
tab degree85

* 1984

recode quala_1984  (1/3 =1)   (.=.)  (else=0) , gen(degree84)
tab degree84



* COMBINE ALL EDUCATIONAL LEVELS
gen degree =.

foreach n of numlist 4 5 8 11 15 84/96 {
replace	degree = degree`n' if degree`n' != .
}


tab degree

tab year degree, row nof

tab year degree if age >= 25, row nof
tab year degree if age >= 25


/*
Over time trends generally very stable
With exception of slight discontinuity between 1991 and 1992
*/




* REGION

/*
1985 -1991 region - RECODING ON BASIS OF ORIGINAL CODEBOOK

coding for compatibility with regn2 in  BSAS - this means combining NE and NW and SE and East
for other purposes more granular codings possible

*/

/*
1 Tyne & Wear
2 Rest of Northern
3 South Yorkshire
4 West Yorkshire
5 Rest of Yorks & Humberside region

6 East Midlands region
7 East Anglia region
8 Inner London + Outer London
9 Rest of South East region
10 South West region

11 West Midlands met
12 Rest of West Midlands region
13 Greater Manchester
14 Merseyside
15 Rest of Northwest region

16 Wales
17 Scotland
18 Northern Ireland
*/

recode urescomf (1 2 13/15=1) (3/5 =2) (6 =3) (11 12 =4) (7 9 =5) ///
	(8 =6) (10 =7) (16 =8) (17 =9) (18 =10), gen(regn2_84)

recode region (1/3 20/22=1) (4/6 =2) (7/8 =3) (17/19 =4) (9 10 13 14 =5) ///
	(11 12 =6) (15 16 =7) (23 24 =8) (25/27 =9) (28 =10) /// 
	, gen(regn2_91)

recode govtor (1/5=1) (6/8=2) (9 =3) (10 11 =4) (12 15 =5) ///
	(13 14 =6) (16 =7) (17 =8) (18 19 =9) (20 =10) /// 
	, gen(regn2_14)	
	
recode govtof2 (1 2=1) (4=2) (5 =3) (6 =4) (7 9=5) ///
	(8 =6) (10 =7) (11 =8) (12 =9) (13 =10) /// 
	, gen(regn2_18)
	
gen regn2 = .

replace regn2 = regn2_84 if year == 1984	
replace regn2 = regn2_91 if year <= 1991 & year >=1985	
replace regn2 = regn2_14 if year >= 1992 & year <= 2014	
replace regn2 = regn2_18 if year >= 2015	

label define regn2 1 "North" 2 "Yorkshire and Humberside" 3 "East Midlands" 4 "West Midlands" ///
	5 "East and South East" 6 "London" 7 "South West" 8 "Wales" 9 "Scotland" 10 "Northern Ireland"

label values regn2 regn2

tab regn2

tab regn2 year	, col nof

drop if regn2 == 10
	
	
* CREATE BIRTH COHORTS

replace age = fage if year == 1984

gen yrbrn = year - age
egen chrt = cut(yrbrn), at(1900(5)2000)
tab chrt


* CREATE WORKING AGE INDICATOR

gen wa_common = 0
replace wa_common = 1 if age >= 16 & age <= 59 

tab year degree if wa_common==1 & age >= 25 , row


* WEIGHTS 

egen pwt = rowmean(pwt03 pwt07 pwt14 pwt18)

tab year , summ( pwt)


* DROP UNEEDED Rs and VARS

drop if degree == .

drop if age < 25

drop if wa_common == 0

drop if yrbrn < 1925 | yrbrn >= 1990

drop if thiswv ==5

tab chrt degree , miss row 

keep age sex year degree regn2 yrbrn chrt pwt wa_common

gen person = 1

save LFS_8618_revised_av, replace

}

*********************************************************************************
* CALCULATE AVERAGE EDUCATIONAL ATTAINMENT
*********************************************************************************

if `_collapse' == 1 {

clear

use LFS_8618_revised_av

* COHORT

collapse ///
	(sum) degree person ///
	[pweight=pwt] , by(chrt)
	
gen pc_degree = (degree/person)*100	

scatter pc_degree chrt , connect(l) 

save LFS_edu_chrt_revised, replace
	

* COHORT REGION

clear

use LFS_8618_revised_av

collapse ///
	(sum) degree person ///
	[pweight=pwt] , by(chrt regn2)
	
gen pc_degree = (degree/person)*100	

sort regn2 chrt  
scatter pc_degree chrt , connect(l) by(regn2, note("") style(compact))

save LFS_edu_chrt_regn_revised, replace


* YEAR 

clear

use LFS_8618_revised_av

collapse ///
	(sum) degree person ///
	[pweight=pwt] , by(year)
	
gen pc_degree = (degree/person)*100	

scatter pc_degree year , connect(l) 

save LFS_edu_year_revised, replace

}