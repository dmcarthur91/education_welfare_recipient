/******************************************************************************

WHY ARE THE HIGHLY EDUCATED MORE SYMPATHETIC TOWARDS WELFARE RECIPIENTS?

FULL RESULTS SET

Daniel McArthur

version 2.0 

13 Nov 2021

This code file creates all analyses reported in finished paper. To run, the two data cleaning and variable creation codefiles need to be run first.

The following user written packages are required (available from ssc)

coefplot
esttab
estout

Graphs made with the 'plotplain' scheme by Daniel Bischof


******************************************************************************/

version 17.0

clear all

cd "C:\Users\shug3204\Dropbox\Education and negative stereotypes\working"


/////////////////////////////////////////////////////////////////////////////////
* DOCUMENTING VALUE CHANGE - FIGURE 1
/////////////////////////////////////////////////////////////////////////////////

clear


use BSA_8718_2104	

tab beliefs_poverty, gen(beliefs)

rename (beliefs1 beliefs2) (laziness injustice)


foreach v of varlist  unempjobr sochelpr dolefidlr welffeetr ///
	redistrb laziness injustice ///
	damlivesr proudwlfr morewelf  dole {
	
qui summ `v' 
	
egen `v's = std(`v')

summ `v' `v's	
	
}	


collapse ///
	(mean) lazinesss injustices unempjobrs sochelprs dolefidlrs welffeetrs redistrbs  morewelfs  doles  ///
	[pweight=compwt] , by(year)
		
rename ///
		( unempjobrs sochelprs dolefidlrs welffeetrs lazinesss injustices redistrbs morewelfs doles ) ///
		(v1 v2 v3 v4 v5 v6 v7 v8 v9 )
	
reshape long 	///
	v ///
	, i(year) j(var)
	
capture label drop v	
label define v  ///
		1 "Unemployed could find job if wanted" ///
		2 "Many recipients don't deserve help" ///
		3 "Most people on dole fiddling" ///
		4 "Benefits too generous for ppl to stand on own feet" ///
		5 "Poverty caused by laziness" ///
		6 "Poverty caused by injustice" ///
		7 "Govt. should redistribute income" ///
		8 "More welfare even if tax increased (reversed)" ///
		9 "Benefits too high and discourage work"
label values var v  	
	
	
twoway ///
		(scatter v year , connect(l) msym(i) lwidth(medthick) ) ///
		, by(var , note("")  style(compact) ) ///
		ysize(4.5) xsize(7.5) subtitle(, size(small)) ///
		ylabel(-.5 0 .5) xlabel(1990(5)2015) xtitle("") ///
		ytitle("Agreement with question (standardised)", size(medsmall))
graph export "value_change.tif", replace


/////////////////////////////////////////////////////////////////////////////////
* MEASURING VALUES - TABLE 1
/////////////////////////////////////////////////////////////////////////////////

clear

use BSA_8718_2104

* Negative stereotypes about welfare recipients
sem (Negb -> unempjobr sochelpr dolefidlr welffeetr) ///
	, stand 
	
estat gof, 	stat(rms indices ic)
alpha unempjobr sochelpr dolefidlr welffeetr, item

* Right-wing values
sem (LR -> redistrb bigbusnn wealth richlaw indust4), stand

estat gof , stat(rms indices ic)
alpha redistrb bigbusnn wealth richlaw indust4, item

* Authoritarian values

sem (LA -> tradvalsr stifsentr deathappr obeyr censorr), stand

estat gof , stat(rms indices ic)
alpha tradvalsr stifsentr deathappr obeyr censorr, item

/////////////////////////////////////////////////////////////////////////////
* EVIDENCE FOR UNIDIMENSIONALITY - APPENDIX 4
////////////////////////////////////////////////////////////////////////////

* correlations among values

sem ///
	(Negb -> unempjobr sochelpr dolefidlr welffeetr ) ///	
	(LA -> tradvalsr stifsentr deathappr obeyr censorr) ///	
	(LR -> redistrb bigbusnn wealth richlaw indust4) ///
	, stand	
	
* comparing 1 and 2 factor models

sem ///
	(F1 -> unempjobr sochelpr dolefidlr welffeetr ) ///	
	(F2 -> tradvalsr stifsentr deathappr obeyr censorr) ///	
	, stand	
estat gof , stat(rms indices ic)
	
	
sem ///
	(F1 -> unempjobr sochelpr dolefidlr welffeetr ///
	tradvalsr stifsentr deathappr obeyr censorr) ///	
	, stand			
estat gof , stat(rms indices ic)	


/////////////////////////////////////////////////////////////////////////////////
* COHORT AND PERIOD TRENDS IN EDUCATION - FIGURE 2
/////////////////////////////////////////////////////////////////////////////////

* education by survey year
use LFS_edu_year_revised

twoway ///
	(scatter pc_degree year ,connect(l) msym(i) lwidth(thick)) ,  ///
	xlabel(1985(5)2020) xtitle("Year") ytitle("") ylabel(0(10)60) ///
	title("a) Degree level education by year" , ring(0) pos(12)) ///
		name(educ_yr, replace)

* degree attainment by birth cohort and region		
use LFS_edu_chrt_regn_revised
sort chrt  regn2

twoway ///
	(scatter pc_degree chrt if regn2==1 ,connect(l) lcol(black%50) symbol(i) lpattern(solid) ) ///	
	(scatter pc_degree chrt if regn2==2 ,connect(l) mcolor(black) lcol(black%50) symbol(i)  lpattern(solid) ) ///	
	(scatter pc_degree chrt if regn2==3 ,connect(l) mcolor(black) lcol(black%50) symbol(i)  lpattern(solid) ) ///	
	(scatter pc_degree chrt if regn2==4 ,connect(l) mcolor(black) lcol(black%50) symbol(i)  lpattern(solid) ) ///	
	(scatter pc_degree chrt if regn2==5 ,connect(l) mcolor(black) lcol(black%50) symbol(i)  lpattern(solid) ) ///	
	(scatter pc_degree chrt if regn2==6 ,connect(l) mcolor(black) lcol(black%50) symbol(i)  lpattern(solid) ) ///	
	(scatter pc_degree chrt if regn2==7 ,connect(l) mcolor(black) lcol(black%50) symbol(i)  lpattern(solid) ) ///	
	(scatter pc_degree chrt if regn2==8 ,connect(l) mcolor(black) lcol(black%50) symbol(i)  lpattern(solid) ) ///	
	(scatter pc_degree chrt if regn2==9 ,connect(l) mcolor(black) lcol(black%50) symbol(i)  lpattern(solid) ) ///
	, 	 text(51 1981 "London", size(small))  ///
		title("b) Degree attainment by 5 year birth cohort and region" , ring(0) pos(12) ) ///
	xlabel(1925(10)1985)  ylabel(0(10)60) xtitle("5 year birth cohort") ytitle("") ///
	legend(off) ///
	name(deg_coh_regn, replace) 

gr combine 	educ_yr deg_coh_regn, cols(1) xsize(4.5) ysize(5.5) imargin(tiny) ///
	subtitle("% of working age (25-59) population" ,pos(9) orient(vertical))
graph export "agg_edu.tif", replace

//////////////////////////////////////////////////////////////////////////
* DESCRIPTIVES 
//////////////////////////////////////////////////////////////////////////

*** TABLE A1

clear

use bsa8718av_2104

summ ///
	nbfs lrfs lafs ///
	bn.(educ hincqr soccomp econac) ///
	rage bn.(rsex tenure married religsum ethnicity unionm hsize) ///
	pc_degree bn.(chrtpg  year regn2) ///
	, sep(0)
	
	
		
/////////////////////////////////////////////////////////////////////////////////	
* EDUCATION AND ECONOMIC POSITION - FIGURE 3, TABLE A2
/////////////////////////////////////////////////////////////////////////////////

eststo clear

eststo: reg nbfs i.(educ ///
	rsex tenure married religsum ethnicity unionm hsize ///
	chrtpg  year regn2) c.rage##c.rage [pweight=compwt]

eststo: reg nbfs i.(educ hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize ///
	chrtpg year regn2) c.rage##c.rage [pweight=compwt]
	
coefplot ///
		(est1, mcol(gs8) msym(oh) msize(medlarge) ciopts(lcol(gs8)) ) ///
		(est2, mcol(black) msym(X) msize(medlarge) ciopts(lcol(black))) ///
			,  norecycle  keep(*.educ *.hincqr *.soccomp *.econac) ///
			xline(0) xlabel(-.6(.2).8) ///
			legend(pos(6) rows(1) ///
			order(2 "Education only" 4 "Education + all economic position measures")) ///
			xtitle("Coefficient on negative stereotypes about welfare recipients") ///
			headings(1.educ = "{it:Education (ref=degree)}" ///
				1.hincqr = "{it:Income (ref=5th quintile)}" ///
				2.soccomp = "{it:Occupation (ref=salariat)}" ///
				1.econac= "{it:Econ activity (ref=work)}")	
graph export "Negbels_educ_econpos.tif" , replace

esttab est1 est2 using resultstables_210727 ///
	, rtf replace  ///
	se r2  onecell compress label nomti  ///
	drop(_cons) ///
	indicate("Year Fixed Effects = *.year" ///
			"Region Fixed Effects = *.regn2" ///
			"Cohort Fixed Effects = *.chrtpg") /// 	
	order(*.educ *.hincqr *.soccomp *.econac) ///
	coefl(0.educ "Education (ref=degree)" ///
		0.hincqr "Income (ref=5th quintile)" ///
		1.soccomp "Class (ref=salariat)" ///
		0.econac "Econ activity (ref=working)" ///
		1.rsex "Gender (ref=Male)" ///
		0.tenure "Tenure (ref=Owner)" ///
		1.married "Marital status (ref=Married)" ///
		1.religsum "Religion (ref=Anglican)" ///
		1.ethnicity "Ethnicity (ref=White)" ///
		0.unionm "Union membership (ref=non-member)" ///
		1.hsize "Household size (ref=1 person)" ///
		c.rage#c.rage "Age^2") ///
	title("Table A2: Association between education, economic position variables, and negative stereotypes about welfare recipients") ///
	addnotes("Linear regression models. All models include cohort, year and region fixed effects, and are weighted using BSAS survey weight. Data from BSAS 1987-2018.")

	

////////////////////////////////////////////////////////////////////////////////	
* EDUCATION AND VALUES - FIGURE 4, TABLE A3
////////////////////////////////////////////////////////////////////////////////


eststo clear			

eststo: reg nbfs i.(educ hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize ///
		year chrtpg regn2) c.rage##c.rage	 [pweight=compwt]
eststo: reg nbfs lrfs i.(educ hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize ///
		year chrtpg regn2) c.rage##c.rage [pweight=compwt]
eststo: reg nbfs lafs i.(educ hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize ///
		year chrtpg regn2)	c.rage##c.rage [pweight=compwt]
		
esttab , keep(*.educ lrfs lafs)		

coefplot (est1, mcol(gs8) msym(oh) ciopts(lcol(gs8))) ///
			(est2, mcol(black) msym(X) ciopts(lcol(black))) ///
			(est3, mcol(black) msym(sh) ciopts(lcol(black)))	///
			, keep(lrfs lafs *.educ *.hincqr *.soccomp *.econac) msize(large)	///
			order(lrfs lafs) ///
			legend(pos(6) rows(1)  ///
				order(- "Model contains:" 2 "No values" 4 "Right-wing" 6 "Authoritarian" )) ///
			byopts(rows(1)) xlabel(-.6(.1).7) xline(0)	///
			coefl(lrfs = "+1SD Right-wing values" lafs = "+1SD Authoritarian values") ///
			headings(1.educ = "{it:Education (ref=degree)}" ///
				1.hincqr = "{it:Income (ref=5th quintile)}" ///
				2.soccomp = "{it:Occupation (ref=salariat)}" ///
				1.econac= "{it:Econ activity (ref=work)}")	///
			xtitle("Coefficient on negative stereotypes about welfare recipients", size(medsmall)) 
graph export "Negbels_educ_lrla.tif", replace


esttab est1 est2 est3 using resultstables_210727 ///
	, rtf append  ///
	se r2  onecell  compress  label nomti ///
		drop(_cons) ///
	indicate("Demographic controls = *.rsex *.tenure *.married *.religsum *.ethnicity *.unionm *.hsize rage *.rage" ///
			"Year Fixed Effects = *.year" ///
			"Region Fixed Effects = *.regn2" ///
			"Cohort Fixed Effects = *.chrtpg" ) ///  
	order(lafs lrfs *.educ *.hincqr *.soccomp *.econac) ///
	coefl(lafs  "+1SD Authoritarian values" ///
		lrfs "+1SD Right-wing values" ///
		0.educ "Education (ref=degree)" ///
		0.hincqr "Income (ref=5th quintile)" ///
		1.soccomp "Class (ref=salariat)" ///
		0.econac "Econ activity (ref=working)" ) ///
	title("Table A3: Effect of controlling for right-wing and authoritarian values on the association between education and negative stereotypes about welfare recipients") ///
	addnotes("Linear regression models. All models include cohort, year and region fixed effects, and are weighted using BSAS survey weight. Data from BSAS 1987-2018.")

	
	

////////////////////////////////////////////////////////////////////////////////			
* TRENDS IN EDUCATIONAL DIFFERENCES - FIGURES 5,6

///////////////////////////////////////////////////////////////////////////////

reg nbfs i.educ##i.year [pweight=compwt]

margins educ, at(year = (1987 1989 1991 1993/1996 1998/2018)) nose post

marginsplot , xdim(year)  ciopts(lw(none)) ///
	plotopts(msymbol(i)) xlabel(1990(5)2015)  xtitle("") ///
	ytitle("Negative stereotypes about welfare recipients") title("") ///
	legend(pos(6) rows(1)) yline(0, lcol(black))
graph export "Negbels_educ_year.tif", replace

* reported in text - comparisons of marginal means
* 1987
di "1987 Degree vs no quals " _b[1bn._at#4.educ] - _b[1bn._at#0bn.educ]

* 1989
di "1989 Degree vs no quals " _b[2bn._at#4.educ] - _b[2bn._at#0bn.educ]

* 1991
di "1991 Degree vs no quals " _b[3bn._at#4.educ] - _b[3bn._at#0bn.educ]

* 2008
di "2008 Degree vs no quals " _b[18bn._at#4.educ] - _b[18bn._at#0bn.educ]

* 2009
di "2009 Degree vs no quals " _b[19bn._at#4.educ] - _b[19bn._at#0bn.educ]

* 2010
di "2010 Degree vs no quals " _b[20bn._at#4.educ] - _b[20bn._at#0bn.educ]

* 2015
di "2015 Degree vs no quals " _b[25bn._at#4.educ] - _b[25bn._at#0bn.educ]


* CHANGING VARIANCE AMONG HIGHLY EDUCATED
* USING DATA WITH NO MISSINGS REMOVED TO MAXIMISE SAMPLE SIZE

clear

use BSA_8718_2104


egen period = cut(year) , at(1987  1999  2009  2019) icodes

label define period 0 "1987-1998" 1 "1999-2008" 2 "2009-2019"
label values period period 
tab period 

eststo clear

iqreg nbfs i.period  if degree == 1

margins period, post
eststo 

coefplot (est1, msize(vlarge) ciopts(lwidth(thick)) )  ///
	, vert ytitle( "Negative stereotypes about welfare recipients" "Interquartile range among degree educated") ylabel(1(.1)1.6)
graph export "Negbels_degree_IQR.tif", replace



////////////////////////////////////////////////////////////////////////////////
* COHORT-REGION EDUCATION - FIGURE 7, TABLE A4
////////////////////////////////////////////////////////////////////////////////

clear

use bsa8718av_2104

	
eststo clear

* no cohort FEs
eststo: reg nbfs degree##c.pc_degree  i.regn2 c.rage##c.rage ///
	i.(year hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	[pweight=compwt] , vce(cluster chrtregn)	

margins r.degree, at(pc_degree=(5(5)55)) post
marginsplot, recastci(rline) plotopts(msym(i)) ///
	title("a) No cohort adjustment", ring(0) pos(12) size(large))  ///
	xtitle("")	ytitle("") xlabel(0(5)60) ///
	name(degXpc_degree_nocoh, replace) nodraw	

local coh1 = _b[r1vs0.degree@7._at] - _b[r1vs0.degree@1._at]	

* political gen cohorts		
eststo: reg nbfs degree##c.pc_degree i.chrtpg i.regn2 c.rage##c.rage ///
	i.(year hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	[pweight=compwt] , vce(cluster chrtregn)		

margins r.degree, at(pc_degree=(5(5)55))  post
marginsplot, recastci(rline) plotopts(msym(i)) ///
	title("b) Political generation cohorts", ring(0) pos(12) size(large)) ytitle("") ///
	xtitle("")  xlabel(0(5)60)  ylabel(-.6(.1)-.2) ///
	name(degXpc_degree_pgcoh, replace) nodraw		
	
local coh2 = _b[r1vs0.degree@7._at] - _b[r1vs0.degree@1._at]	
	
	
capture: egen tag_chrtregn = tag(chrtregn)

capture: gen y1 = -.6
capture: gen y2 = -.55

* 5 year cohorts	
eststo: reg nbfs degree##c.pc_degree i.chrt i.regn2 c.rage##c.rage ///
	i.(year hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	[pweight=compwt] , vce(cluster chrtregn)
	
margins r.degree, at(pc_degree=(5(5)55))  post
marginsplot, recastci(rline) plotopts(msym(i)) ///
	title("c) 5 year cohorts", ring(0) pos(12)  size(large)) ytitle("") ///
	xtitle("")  xlabel(0(5)60) 	///
	addplot( rspike y1 y2 pc_degree if  tag_chrtregn == 1, lcol(gs8%50) legend(off)  xlabel(0(5)60)) ///
	name(degXpc_degree_5ycoh, replace) nodraw			

local coh3 = _b[r1vs0.degree@7._at] - _b[r1vs0.degree@1._at]	
	
	
gr combine degXpc_degree_nocoh degXpc_degree_pgcoh degXpc_degree_5ycoh  ///
	, cols(1) xsize(3.5) ysize(5.5) imargin(tiny)  ///
	note("Degree vs. no degree difference in" "negative stereotypes about welfare recipients" ///
		, pos(9) orient(vertical)size(large)) ///
	subtitle("% degree educated in" "5 year birth cohort and region", pos(6) size(large))
graph export "Negbels_degXdechrt.tif", replace	

* reported in text	
di "No cohort FEs" `coh1' 	
di "Political generation cohorts" `coh2' 	
di "5 year cohorts" `coh3' 	


esttab est1 est2 est3 using resultstables_210727 ///
	, rtf append  ///
	se r2 compress onecell label  ///
			drop(_cons 0.degree ) ///
	indicate("Demographic controls = *.rsex *.tenure *.married *.religsum *.ethnicity *.unionm *.hsize  rage *.rage" ///
			"Year Fixed Effects = *.year" ///
			"Region Fixed Effects = *.regn2" ///
			"Political generation cohort FEs = *.chrtpg" ///
			"Five year cohort FEs = *.chrt") ///  
	order(1.degree pc_degree 1.degree#pc_degree *.hincqr *.soccomp *.econac) ///
	coefl( ///
		1.degree "Degree (ref=no degree)" ///
		pc_degree "% degree educated" ///
		1.degree#c.pc_degree "Degree X % degree educated" ///
		0.hincqr "Income (ref=5th quintile)" ///
		1.soccomp "Class (ref=salariat)" ///
		0.econac "Econ activity (ref=working)") ///
	mtitle("No cohort effects" "Political generation cohorts" "5-year cohorts") ///
	title("Table A4: Association between education and negative stereotypes about welfare recipients conditional on aggregate levels of education in birth cohort and region") ///
	addnotes("Linear regression models. All models include year and region fixed effects, and are weighted using BSAS survey weight. Models 2 and 3 additionally include cohort fixed effects. Data from BSAS 1987-2018, LFS 1985-1991, and QLFS 1993-2018.")	
	
	
	
***********************************************************

* INDIVIDUAL LEVEL MODELS WITH ALTERNATE COHORT EFFECTS - FIGURES A1-A4

***********************************************************

* NO COHORT EFFECTS

* economic position
eststo clear

eststo: reg nbfs i.(educ ///
	rsex tenure married religsum ethnicity unionm hsize ///
	  year regn2) c.rage##c.rage [pweight=compwt]

eststo: reg nbfs i.(educ hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize ///
	 year regn2) c.rage##c.rage [pweight=compwt]
	
coefplot ///
		(est1, mcol(gs8) msym(oh) msize(medlarge) ciopts(lcol(gs8)) ) ///
		(est2, mcol(black) msym(X) msize(medlarge) ciopts(lcol(black))) ///
			,  norecycle  keep(*.educ *.hincqr *.soccomp *.econac) ///
			xline(0) xlabel(-.6(.2).8) ///
			legend(pos(6) rows(1) ///
			order(2 "Education only" 4 "Education + all economic position measures")) ///
			xtitle("Coefficient on negative stereotypes about welfare recipients") ///
			headings(1.educ = "{it:Education (ref=degree)}" ///
				1.hincqr = "{it:Income (ref=5th quintile)}" ///
				2.soccomp = "{it:Occupation (ref=salariat)}" ///
				1.econac= "{it:Econ activity (ref=work)}")	
graph export "Negbels_educ_econpos_nocoh.tif" , replace

* values
eststo clear			

eststo: reg nbfs i.(educ hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize ///
		year  regn2) c.rage##c.rage	 [pweight=compwt]
eststo: reg nbfs lrfs i.(educ hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize ///
		year  regn2) c.rage##c.rage [pweight=compwt]
eststo: reg nbfs lafs i.(educ hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize ///
		year chrtpg regn2)	c.rage##c.rage [pweight=compwt]
		
coefplot (est1, mcol(gs8) msym(oh) ciopts(lcol(gs8))) ///
			(est2, mcol(black) msym(X) ciopts(lcol(black))) ///
			(est3, mcol(black) msym(sh) ciopts(lcol(black)))	///
			, keep(lrfs lafs *.educ *.hincqr *.soccomp *.econac) msize(large)	///
			order(lrfs lafs) ///
			legend(pos(6) rows(1)  ///
				order(- "Model contains:" 2 "No values" 4 "Right-wing" 6 "Authoritarian" )) ///
			byopts(rows(1)) xlabel(-.6(.1).7) xline(0)	///
			coefl(lrfs = "+1SD Right-wing values" lafs = "+1SD Authoritarian values") ///
			headings(1.educ = "{it:Education (ref=degree)}" ///
				1.hincqr = "{it:Income (ref=5th quintile)}" ///
				2.soccomp = "{it:Occupation (ref=salariat)}" ///
				1.econac= "{it:Econ activity (ref=work)}")	///
			xtitle("Coefficient on negative stereotypes about welfare recipients", size(medsmall)) 
graph export "Negbels_educ_lrla_nocoh.tif", replace


* 5 YEAR COHORTS

* economic position 

eststo clear

eststo: reg nbfs i.(educ ///
	rsex tenure married religsum ethnicity unionm hsize ///
	chrt  year regn2) c.rage##c.rage [pweight=compwt]

eststo: reg nbfs i.(educ hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize ///
	chrt year regn2) c.rage##c.rage [pweight=compwt]
	
coefplot ///
		(est1, mcol(gs8) msym(oh) msize(medlarge) ciopts(lcol(gs8)) ) ///
		(est2, mcol(black) msym(X) msize(medlarge) ciopts(lcol(black))) ///
			,  norecycle  keep(*.educ *.hincqr *.soccomp *.econac) ///
			xline(0) xlabel(-.6(.2).8) ///
			legend(pos(6) rows(1) ///
			order(2 "Education only" 4 "Education + all economic position measures")) ///
			xtitle("Coefficient on negative stereotypes about welfare recipients") ///
			headings(1.educ = "{it:Education (ref=degree)}" ///
				1.hincqr = "{it:Income (ref=5th quintile)}" ///
				2.soccomp = "{it:Occupation (ref=salariat)}" ///
				1.econac= "{it:Econ activity (ref=work)}")	
graph export "Negbels_educ_econpos_5yrcoh.tif" , replace

* values

eststo clear			

eststo: reg nbfs i.(educ hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize ///
		year chrt regn2) c.rage##c.rage	 [pweight=compwt]
eststo: reg nbfs lrfs i.(educ hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize ///
		year chrt regn2) c.rage##c.rage [pweight=compwt]
eststo: reg nbfs lafs i.(educ hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize ///
		year chrt regn2)	c.rage##c.rage [pweight=compwt]
		
esttab , keep(*.educ lrfs lafs)		

coefplot (est1, mcol(gs8) msym(oh) ciopts(lcol(gs8))) ///
			(est2, mcol(black) msym(X) ciopts(lcol(black))) ///
			(est3, mcol(black) msym(sh) ciopts(lcol(black)))	///
			, keep(lrfs lafs *.educ *.hincqr *.soccomp *.econac) msize(large)	///
			order(lrfs lafs) ///
			legend(pos(6) rows(1)  ///
				order(- "Model contains:" 2 "No values" 4 "Right-wing" 6 "Authoritarian" )) ///
			byopts(rows(1)) xlabel(-.6(.1).7) xline(0)	///
			coefl(lrfs = "+1SD Right-wing values" lafs = "+1SD Authoritarian values") ///
			headings(1.educ = "{it:Education (ref=degree)}" ///
				1.hincqr = "{it:Income (ref=5th quintile)}" ///
				2.soccomp = "{it:Occupation (ref=salariat)}" ///
				1.econac= "{it:Econ activity (ref=work)}")	///
			xtitle("Coefficient on negative stereotypes about welfare recipients", size(medsmall)) 
graph export "Negbels_educ_lrla_5yrcoh.tif", replace



***********************************************************

* ANALYSIS OF MISSING VARIABLES - APPENDIX 7 	
	
***********************************************************

	
* TABLE A6 - THOSE IN EDUCATION AGED 25+

clear

use BSA_8718_2104

gen inedu = 0 if econac != .
replace inedu = 1 if econac == 5

tab year inedu if rage >= 25 	 , row nof


* TABLE OF MISSINGS A7

	
foreach v of varlist nbfs lrfs lafs ///
	educ hincqr soccomp econac ///
	rage rsex tenure married religsum ethnicity unionm hsize {
	
gen m_`v' = 0 
replace m_`v' = 1 if `v' == . 	
	
gen m_`v'_dv = 0 if nbfs != .
replace m_`v'_dv = 1 if `v' == . & nbfs != .	
	
}

summ m_nbfs m_lrfs m_lafs m_educ m_hincqr m_soccomp m_econac m_rage m_rsex m_tenure m_married m_religsum m_ethnicity m_unionm m_hsize	, sep(0)
summ m_nbfs_dv m_lrfs_dv m_lafs_dv m_educ_dv m_hincqr_dv m_soccomp_dv m_econac_dv m_rage_dv m_rsex_dv m_tenure_dv m_married_dv m_religsum_dv m_ethnicity_dv m_unionm_dv m_hsize_dv, sep(0)



*  MODELS WITH ONLY AGE AND GENDER CONTROLS FIGURES A6-7


* ECON POS

eststo clear

eststo: reg nbfs i.(educ rsex chrtpg  year regn2) c.rage##c.rage [pweight=compwt]

eststo: reg nbfs i.(educ hincqr soccomp econac ///
	rsex chrtpg year regn2) c.rage##c.rage [pweight=compwt]
	
* figure X	
coefplot ///
		(est1, mcol(gs8) msym(oh) msize(medlarge) ciopts(lcol(gs8)) ) ///
		(est2, mcol(black) msym(X) msize(medlarge) ciopts(lcol(black))) ///
			,  norecycle  keep(*.educ *.hincqr *.soccomp *.econac) ///
			xline(0) xlabel(-.6(.2).8) ///
			legend(pos(6) rows(1) ///
			order(2 "Education only" 4 "Education + all economic position measures")) ///
			xtitle("Coefficient on negative stereotypes about welfare recipients") ///
			headings(1.educ = "{it:Education (ref=degree)}" ///
				1.hincqr = "{it:Income (ref=5th quintile)}" ///
				2.soccomp = "{it:Occupation (ref=salariat)}" ///
				1.econac= "{it:Econ activity (ref=work)}")	
graph export "Negbels_educ_econpos_missing.tif" , replace


* VALUES

eststo clear			

eststo: reg nbfs i.(educ rsex year chrtpg regn2) c.rage##c.rage	 [pweight=compwt]
eststo: reg nbfs lrfs i.(educ rsex 	year chrtpg regn2) c.rage##c.rage [pweight=compwt]
eststo: reg nbfs lafs i.(educ rsex 	year chrtpg regn2)	c.rage##c.rage [pweight=compwt]
		
esttab , keep(*.educ lrfs lafs)		

coefplot (est1, mcol(gs8) msym(oh) ciopts(lcol(gs8))) ///
			(est2, mcol(black) msym(X) ciopts(lcol(black))) ///
			(est3, mcol(black) msym(sh) ciopts(lcol(black)))	///
			, keep(lrfs lafs *.educ *.hincqr *.soccomp *.econac) msize(large)	///
			order(lrfs lafs) ///
			legend(pos(6) rows(1)  ///
				order(- "Model contains:" 2 "No values" 4 "Right-wing" 6 "Authoritarian" )) ///
			byopts(rows(1)) xlabel(-.6(.1).7) xline(0)	///
			coefl(lrfs = "+1SD Right-wing values" lafs = "+1SD Authoritarian values") ///
			headings(1.educ = "{it:Education (ref=degree)}" ///
				1.hincqr = "{it:Income (ref=5th quintile)}" ///
				2.soccomp = "{it:Occupation (ref=salariat)}" ///
				1.econac= "{it:Econ activity (ref=work)}")	///
			xtitle("Coefficient on negative stereotypes about welfare recipients", size(medsmall)) 
graph export "Negbels_educ_lrla_missing.tif", replace


* COHORT REGION EDUCATION

eststo clear

* no cohort FEs
eststo: reg nbfs degree##c.pc_degree  i.regn2 c.rage##c.rage ///
	i.(year rsex ) ///
	[pweight=compwt] , vce(cluster chrtregn)	

margins r.degree, at(pc_degree=(5(5)55)) post
marginsplot, recastci(rline) plotopts(msym(i)) ///
	title("a) No cohort adjustment", ring(0) pos(12) size(large))  ///
	xtitle("")	ytitle("") xlabel(0(5)60) ylabel(-.6(.1)0) ///
	name(degXpc_degree_nocoh, replace) nodraw	

local coh1 = _b[r1vs0.degree@7._at] - _b[r1vs0.degree@1._at]	

* political gen cohorts		
eststo: reg nbfs degree##c.pc_degree i.chrtpg i.regn2 c.rage##c.rage ///
	i.(year rsex ) ///
	[pweight=compwt] , vce(cluster chrtregn)		

margins r.degree, at(pc_degree=(5(5)55))  post
marginsplot, recastci(rline) plotopts(msym(i)) ///
	title("b) Political generation cohorts", ring(0) pos(12) size(large)) ytitle("") ///
	xtitle("")  xlabel(0(5)60)   ylabel(-.6(.1)0) ///
	name(degXpc_degree_pgcoh, replace) nodraw		
	
local coh2 = _b[r1vs0.degree@7._at] - _b[r1vs0.degree@1._at]	
	
* 5 year cohorts	

capture: egen tag_chrtregn = tag(chrtregn)

capture: gen y1 = -.6
capture: gen y2 = -.55


eststo: reg nbfs degree##c.pc_degree i.chrt i.regn2 c.rage##c.rage ///
	i.(year rsex) ///
	[pweight=compwt] , vce(cluster chrtregn)
	
margins r.degree, at(pc_degree=(5(5)55))  post
marginsplot, recastci(rline) plotopts(msym(i)) ///
	title("c) 5 year cohorts", ring(0) pos(12)  size(large)) ytitle("") ///
	xtitle("")  xlabel(0(5)60) 	///
	addplot( rspike y1 y2 pc_degree if  tag_chrtregn == 1, lcol(gs8%50) legend(off)  xlabel(0(5)60) ylabel(-.6(.1)0)) ///	
	name(degXpc_degree_5ycoh, replace) 			

local coh3 = _b[r1vs0.degree@7._at] - _b[r1vs0.degree@1._at]	
	
	
gr combine degXpc_degree_nocoh degXpc_degree_pgcoh degXpc_degree_5ycoh  ///
	, cols(1) xsize(3.5) ysize(5.5) imargin(tiny)  ///
	note("Degree vs. no degree difference in" "negative stereotypes about welfare recipients" ///
		, pos(9) orient(vertical)size(large)) ///
	subtitle("% degree educated in" "5 year birth cohort and region", pos(6) size(large))
graph export "Negbels_degXdechrt_missing.tif", replace	
 



***********************************************************

* CHANGING COEFFICIENT ON EDUCATION - ROBUSTNESS TO DROPPING REGIONS OR DEGREE X REGION INTERACTIONS 	APPENDIX A6
	
***********************************************************
	
clear

use bsa8718av_2104	

* NO LONDON AND SOUTH EAST 	TABLE A5
	

eststo clear

eststo: qui reg nbfs degree##c.pc_degree  i.regn2 c.rage##c.rage ///
	i.(year hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	if regn2 != 5 & regn2 != 6 [pweight=compwt] , vce(cluster chrtregn)	

eststo: qui reg nbfs degree##c.pc_degree i.chrtpg i.regn2 c.rage##c.rage ///
	i.(year hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	if regn2 != 5 & regn2 != 6 [pweight=compwt] , vce(cluster chrtregn)	
	
eststo: qui reg nbfs degree##c.pc_degree i.chrt i.regn2 c.rage##c.rage ///
	i.(year hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	if regn2 != 5 & regn2 != 6 [pweight=compwt] , vce(cluster chrtregn)
	
	
esttab using byregion , rtf replace  ///
 keep(1.degree#c.pc_degree) coefl(1.degree#c.pc_degree  "London and South-East") ///
		se  compress onecell ///
	mtitle("No cohort effects" "Political generation cohorts" "5-year cohorts") ///
	addnotes("Each cell represents one estimate of interaction between degree level education and share degree educated in cohort-region from separate linear regression models. All models include year and region fixed effects, and are weighted using BSAS survey weight. Models 2 and 3 additionally include cohort fixed effects. Data from BSAS 1987-2018, LFS 1985-1991, and QLFS 1993-2018.") ///
	title("Table Ax: Robustness of association between education and negative stereotypes conditional on cohort-region level to dropping selected regions.")

	
* DROPPING ANY SPECIFIC REGION


decode regn2, gen(regnlabel)


levelsof regnlabel, local(rg)
foreach r of local rg {
	
eststo clear

eststo: qui reg nbfs degree##c.pc_degree  i.regn2 c.rage##c.rage ///
	i.(year hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	if regnlabel != "`r'" [pweight=compwt] , vce(cluster chrtregn)	

eststo: qui reg nbfs degree##c.pc_degree i.chrtpg i.regn2 c.rage##c.rage ///
	i.(year hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	if regnlabel != "`r'" [pweight=compwt] , vce(cluster chrtregn)	
	
eststo: qui reg nbfs degree##c.pc_degree i.chrt i.regn2 c.rage##c.rage ///
	i.(year hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	if regnlabel != "`r'" [pweight=compwt] , vce(cluster chrtregn)
		
esttab  using byregion , rtf append  ///
	keep(1.degree#c.pc_degree) coefl(1.degree#c.pc_degree  "`r'") ///
		se  compress onecell ///
	mtitle("No cohort effects" "Political generation cohorts" "5-year cohorts")
	
}		



*** INTERACTION BETWEEN REGION AND DEGREE FIGURE A5

eststo clear

* no cohort FEs
eststo: reg nbfs degree##c.pc_degree i.degree##i.regn2 c.rage##c.rage ///
	i.(year hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	[pweight=compwt] , vce(cluster chrtregn)	

margins r.degree, at(pc_degree=(5(5)55)) post
marginsplot, recastci(rline) plotopts(msym(i)) ///
	title("a) No cohort adjustment", ring(0) pos(12) size(large))  ///
	xtitle("")	ytitle("") xlabel(0(5)60) ylabel(-.6(.1)0) ///
	name(degXpc_degree_nocoh, replace) nodraw	

local coh1 = _b[r1vs0.degree@7._at] - _b[r1vs0.degree@1._at]	

* political gen cohorts		
eststo: reg nbfs degree##c.pc_degree i.degree##i.regn2 i.chrtpg i.regn2 c.rage##c.rage ///
	i.(year hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	[pweight=compwt] , vce(cluster chrtregn)			

margins r.degree, at(pc_degree=(5(5)55))  post
marginsplot, recastci(rline) plotopts(msym(i)) ///
	title("b) Political generation cohorts", ring(0) pos(12) size(large)) ytitle("") ///
	xtitle("")  xlabel(0(5)60)  ylabel(-.6(.1)0) ///
	name(degXpc_degree_pgcoh, replace) nodraw		
	
local coh2 = _b[r1vs0.degree@7._at] - _b[r1vs0.degree@1._at]	


	
* 5 year cohorts	
capture: egen tag_chrtregn = tag(chrtregn)

capture: gen y1 = -.6
capture: gen y2 = -.55

eststo: reg nbfs degree##c.pc_degree i.degree##i.regn2 i.chrt i.regn2 c.rage##c.rage ///
	i.(year hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	[pweight=compwt] , vce(cluster chrtregn)	
	
margins r.degree, at(pc_degree=(5(5)55))  post
marginsplot, recastci(rline) plotopts(msym(i)) ///
	title("c) 5 year cohorts", ring(0) pos(12)  size(large)) ytitle("") ///
	xtitle("")  xlabel(0(5)60) ylabel(-.6(.1)0)	///
	addplot( rspike y1 y2 pc_degree if  tag_chrtregn == 1, lcol(gs8%50) legend(off)  xlabel(0(5)60) ylabel(-.6(.1)0)) ///
	name(degXpc_degree_5ycoh, replace) 			

local coh3 = _b[r1vs0.degree@7._at] - _b[r1vs0.degree@1._at]	
		

gr combine degXpc_degree_nocoh degXpc_degree_pgcoh degXpc_degree_5ycoh  ///
	, cols(1) xsize(3.5) ysize(5.5) imargin(tiny) xcommon ycommon ///
	note("Degree vs. no degree difference in" "negative stereotypes about welfare recipients" ///
		, pos(9) orient(vertical)size(large)) ///
	subtitle("% degree educated in" "5 year birth cohort and region", pos(6) size(large))
graph export "Negbels_degXdechrt_degXregn.tif", replace	
 
	

	

*********************************************************************************
* ROBUSTNESS TO POLITICAL/MACRO EXPLANATIONS APPENDIX 8

*********************************************************************************


* OVER TIME TRENDS BY POLITICAL INTEREST AND POLITICAL PARTY SUPPORT

* POLITICAL INTEREST - FIGURE A8

clear

use bsa8718av_2104

collapse ///
		(mean) nbfs [pweight=compwt], by(degree polint year)
		
drop if polint == . 				
				
twoway ///
	(lowess nbfs year if polint ==1 & degree == 1 , bwidth(.3))	///
	(lowess nbfs year if polint ==1 & degree == 0, bwidth(.3)) ///
	, xtitle("") ytitle("") /// 
	legend(pos(6) rows(1) order(1 "Degree" 2 "No degree")) /// 
	title("Interested in politics") ///
	 name(polint_edu, replace)
	
twoway ///
	(lowess nbfs year if polint ==0 & degree == 1 , bwidth(.3))	///
	(lowess nbfs year if polint ==0 & degree == 0, bwidth(.3)) ///
	, xtitle("") ytitle("") /// 
	legend(pos(6) order(1 "Degree" 2 "No degree")) /// 
	title("Not interested in politics") ///
	 name(nopolint_edu, replace)
	
grc1leg2 	polint_edu nopolint_edu , ycommon note("Negative stereotypes about welfare recipients" , orient(vertical) pos(9))
graph export "Degree_Polint_Year.tif", replace	
	
	
reshape wide nbfs , i(polint year)	 j(degree)
gen dnbfs = 	nbfs1 - nbfs0 
list year polint dnbfs, sepby(polint)
	

* POLITICAL PARTY SUPPORT FIGURE A9

clear

use bsa8718av_2104

collapse ///
		(mean) nbfs [pweight=compwt], by(degree party_ID year)
		
				
twoway ///
	(lowess nbfs year if party_ID ==0 & degree == 1,  )		///
	(lowess nbfs year if party_ID ==0 & degree == 0,  )	///
	, ytitle("") xtitle("")  xlabel(1990(5)2015) 	///
	title("Conservative" , ring(0) pos(12)) ///
	legend(pos(6) rows(1) order(1 "Degree" 2 "No degree")) /// 
	name( con , replace) 
	
twoway ///
	(lowess nbfs year if party_ID ==1 & degree == 1,  )		///
	(lowess nbfs year if party_ID ==1 & degree == 0,  )	///
	, ytitle("") xtitle("")  xlabel(1990(5)2015) 	///
	title("Labour" , ring(0) pos(12)) ///
	legend(pos(6) rows(1) order(1 "Degree" 2 "No degree")) /// 
	name( lab , replace) 
	
twoway ///
	(lowess nbfs year if party_ID ==2 & degree == 1,  )		///
	(lowess nbfs year if party_ID ==2 & degree == 0,  )	///
	, ytitle("") xtitle("")  xlabel(1990(5)2015) 	///
	title("Liberal Democrat" , ring(0) pos(12)) ///
	legend(pos(6) rows(1) order(1 "Degree" 2 "No degree")) /// 
	name( ld , replace) 
	
twoway ///
	(lowess nbfs year if party_ID ==3 & degree == 1,  )		///
	(lowess nbfs year if party_ID ==3 & degree == 0,  )	///
	, ytitle("") xtitle("")  xlabel(1990(5)2015) 	///
	title("Other" , ring(0) pos(12)) ///
	legend(pos(6) rows(1) order(1 "Degree" 2 "No degree")) /// 
	name( other , replace) 
	
twoway ///
	(lowess nbfs year if party_ID ==4 & degree == 1,  )		///
	(lowess nbfs year if party_ID ==4 & degree == 0,  )	///
	, ytitle("") xtitle("")  xlabel(1990(5)2015) 	///
	title("None" , ring(0) pos(12)) ///
	legend(pos(6) rows(1) order(1 "Degree" 2 "No degree")) /// 
	name( none , replace) 	
	
	
grc1leg2  	con lab ld other none , ycommon note("Negative stereotypes about welfare recipients" , orient(vertical) pos(9)) imargin(zero)
graph export "Degree_Party_Year.tif", replace		
	

		
***	INTERACTION BETWEEN DEGREE AND SHARE DEGREE EDUCATED ADJUSTED FOR INTEREST IN POLITICS
* COEFFICIENT ON INTEREST IN POLITICS ALLOWED TO VARY OVER TIME TABLE A8


clear

use bsa8718av_2104

* POLITICAL INTEREST

eststo clear

* no cohort FEs
eststo: qui reg nbfs degree##c.pc_degree i.year##i.polint i.regn2 c.rage##c.rage ///
	i.( hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	[pweight=compwt] , vce(cluster chrtregn)	

* political gen cohorts		
eststo: qui reg nbfs degree##c.pc_degree  i.year##i.polint   i.chrtpg i.regn2 c.rage##c.rage ///
	i.( hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	[pweight=compwt] , vce(cluster chrtregn)	

* 5 year cohorts	
eststo: qui reg nbfs degree##c.pc_degree  i.year##i.polint   i.chrt i.regn2 c.rage##c.rage ///
	i.( hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	[pweight=compwt] , vce(cluster chrtregn)
		
esttab using polint_party , rtf replace  ///
 keep(1.degree#c.pc_degree) coefl(1.degree#c.pc_degree "Adjusted for interest in politics X year") ///
		se  compress onecell ///
	mtitle("No cohort effects" "Political generation cohorts" "5-year cohorts") ///
	addnotes("Each cell represents one estimate of interaction between degree level education and share degree educated in cohort-region from separate linear regression models. Main effects omitted from table. All models include economic position and demographic controls, year and region fixed effects, and are weighted using BSAS survey weight. Models 2 and 3 additionally include cohort fixed effects. Data from BSAS 1987-2018, LFS 1985-1991, and QLFS 1993-2018.") ///
	title("Table Ax: Robustness of association between education and negative stereotypes conditional on cohort-region education to political interest and party ID controls.")
	
	
* PARTY SUPPORT 	
	
eststo clear
	
	
* no cohort FEs
eststo: qui reg nbfs degree##c.pc_degree i.year##i.party_ID  i.regn2 c.rage##c.rage ///
	i.( hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	[pweight=compwt] , vce(cluster chrtregn)	
	
* political gen cohorts		
eststo: qui reg nbfs degree##c.pc_degree i.year##i.party_ID i.chrtpg i.regn2 c.rage##c.rage ///
	i.( hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	[pweight=compwt] , vce(cluster chrtregn)			
	
* 5 year cohorts	
eststo: qui reg nbfs degree##c.pc_degree i.year##i.party_ID i.chrt i.regn2 c.rage##c.rage ///
	i.( hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	[pweight=compwt] , vce(cluster chrtregn)	

esttab using polint_party , rtf append  ///
 keep(1.degree#c.pc_degree) coefl(1.degree#c.pc_degree "Adjusted for party ID X year") ///
		se  compress onecell ///
	mtitle("No cohort effects" "Political generation cohorts" "5-year cohorts")	
	
* POLITICAL INTEREST AND PARTY SUPPORT

eststo clear

eststo: qui reg nbfs degree##c.pc_degree i.year##i.party_ID i.year##i.polint i.regn2 c.rage##c.rage ///
	i.( hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	[pweight=compwt] , vce(cluster chrtregn)	
	
* political gen cohorts		
eststo: qui reg nbfs degree##c.pc_degree i.year##i.party_ID  i.year##i.polint i.chrtpg i.regn2 c.rage##c.rage ///
	i.( hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	[pweight=compwt] , vce(cluster chrtregn)		
	
* 5 year cohorts	
eststo: qui reg nbfs degree##c.pc_degree i.year##i.party_ID i.year##i.polint i.chrt i.regn2 c.rage##c.rage ///
	i.( hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize) ///
	[pweight=compwt] , vce(cluster chrtregn)
	
esttab using polint_party , rtf append  ///
 keep(1.degree#c.pc_degree) coefl(1.degree#c.pc_degree "Adjusted for interest in politics and party ID (both X year)") ///
		se  compress onecell ///
	mtitle("No cohort effects" "Political generation cohorts" "5-year cohorts")	


******************************************************************************
* BELIEFS ABOUT CAUSES OF POVERTY AS ALTERNATE DEPENDENT VARIABLE - APPENDIX 9
********************************************************************************	

* ASSOCIATION WITH NEGATIVE STEREOTYPES FIGURE A10, TABLE A9

eststo clear

eststo: mlogit beliefs_poverty nbfs i.year i.chrtpg i.regn2 [pweight=compwt] , b(1)
margins , at(nbfs=(-2(.5)2))

marginsplot ///
	, bydim(_outcome, ///
		labels("Laziness" "Social injustice" "Been unlucky" "Inevitable")) ///
	plotopts(msymbol(i)) ///
	recastci(rarea) ciopts(lwidth(none) fcol(black%20)) ///	
	byopts(title("")) ///
	xtitle("Negative stereotypes about welfare recipients")	///
	ytitle("Probability of outcome")
graph export beliefs_poverty.tif, replace	

esttab est1  using beliefs_poverty_nbfs,  ///
	rtf replace ///
	eform se compress onecell label ///
	nomtitle drop(_cons) ///
	coefl(nbfs "Negative stereotypes about welfare recipients") ///
	indicate("Year Fixed Effects = *.year" ///
			"Region Fixed Effects = *.regn2" ///
			"Cohort FEs = *.chrtpg") ///
			title("Table Ax: Association between negative stereotypes about welfare recipients and beliefs about causes of poverty") ///
			note("Estimated odds ratios from multinomial logistic regression models with 'social injustice' set to reference category. All models include survey weight. Data from 1989-2010 BSAS")
	
* ASSOCIATION WITH EDUCATION FIGURE A11, TABLE A10
	
eststo clear

eststo: mlogit beliefs_poverty ///
	i.(educ ///
	rsex tenure married religsum ethnicity unionm hsize ///
	chrtpg year regn2) c.rage##c.rage ///
	[pweight=compwt] , b(1)
margins i.educ	,  saving(m1, replace)

eststo: mlogit beliefs_poverty ///
	i.(educ hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize ///
	chrtpg year regn2) c.rage##c.rage ///
	[pweight=compwt] , b(1)
margins i.educ	,  saving(m2, replace)

esttab est1 est2 using beliefs_poverty_educ,  ///
	rtf replace ///
	eform se compress onecell label ///
	nomtitle drop(_cons) ///
	indicate("Economic position controls = *hincqr *.soccomp *.econac" ///
			"Demographic controls = *.rsex *.tenure *.married *.religsum *.ethnicity *.unionm *.hsize  rage *.rage" ///
			"Year Fixed Effects = *.year" ///
			"Region Fixed Effects = *.regn2" ///
			"Cohort FEs = *.chrtpg") ///
			title("Table Ax: Association between education and beliefs about causes of poverty") ///
			note("Estimated odds ratios from multinomial logistic regression models with 'social injustice' set to reference category. All models include survey weight. Data from 1989-2010 BSAS")

clear

use m1

append using m2, gen(m2)
gen model = m2
label define model 0 "Demographics + FEs" 1 "Economic position"
label values model model

gen outcome = _predict
label define outcome 1 "Laziness" 2 "Social injustice" 3 "Been unlucky" 4 "Inevitable"
label values outcome outcome
tab outcome

gen ed = 4-_m1
tab ed _m1

gen pos = ed +.2
replace pos = ed - .2 if model ==1

twoway (scatter pos  _margin if model==0, mcol(black)) ///
		(rcap _ci_lb _ci_ub pos if model==0, horiz lcol(black)) ///
		(scatter pos  _margin if model==1, mcol(gs8)) ///
		(rcap _ci_lb _ci_ub pos if model==1, horiz lcol(gs8)) ///
	,  by(outcome, note("")) ///
	ylabel(4 "Degree" 3 "Further ed < degree" 2 "Upper secondary" 1 "Lower secondary" 0 "No qualification") ///
	xtitle("Predicted probability of outcome") ///
	ytitle("")  xlabel(0(.1).5) ///
	legend(rows(1) order(1 "Demographics + FEs" 3 "Economic position"))	
graph export beliefs_poverty_educ.tif, replace

* ASSOCIATION WITH ATTITUDES FIGURE A12, TABLE A11

clear 

use bsa8718av

eststo clear

eststo: mlogit beliefs_poverty ///
	lrfs ///
	i.( chrtpg year regn2)  ///
	[pweight=compwt] , b(1)	
margins , at(lrfs=(-1.5(.5)1.5)) saving(m3, replace)
	
eststo: mlogit beliefs_poverty ///
	lafs ///
	i.(	chrtpg year regn2) ///
	[pweight=compwt] , b(1)	
margins , at(lafs=(-1.5(.5)1.5)) saving(m4, replace)

esttab est1 est2 using beliefs_poverty_vals,  ///
	rtf replace ///
	eform se compress onecell label ///
	nomtitle drop(_cons) ///
	coefl(lrfs "Right-wing values" lafs "Authoritarian values") ///
	indicate("Year Fixed Effects = *.year" ///
			"Region Fixed Effects = *.regn2" ///
			"Cohort FEs = *.chrtpg") ///
			title("Table Ax: Association between right wing and authoritarian values and beliefs about causes of poverty") ///
			note("Estimated odds ratios from multinomial logistic regression models with 'social injustice' set to reference category. All models include survey weight. Data from 1989-2010 BSAS")
			
clear

use m3

append using m4 , gen(model)

gen outcome = _predict
label define outcome 1 "Laziness" 2 "Social injustice" 3 "Been unlucky" 4 "Inevitable"
label values outcome outcome
tab outcome

	
twoway ///
	(scatter _margin _at1 if model == 0, msym(i) connect(l)) ///
	(rarea _ci_lb _ci_ub _at1 if model ==0 ///
		, lwidth(none) fcol(black%20)) ///
	(scatter _margin _at1 if model == 1, lcol(gs8) msym(i)  connect(l)) ///
	(rarea _ci_lb _ci_ub _at1 if model ==1 ///
		, lwidth(none) fcol(gs8%20)) ///
	, by(outcome, note("")) ///
	legend(rows(1) order(1 "Right-wing" 3 "Authoritarianism")) ///
	ylabel(0(.1).5) xlabel(-1.5(.5)1.5) ///
	xtitle("Values - standardised") ytitle("Predicted probability")
graph export  beliefs_poverty_vals.tif, replace



* EDUCATION AND VALUES FIGURE A13, TABLE A12 

clear 

use bsa8718av

eststo clear

eststo: mlogit beliefs_poverty ///
	i.(educ hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize ///
	chrtpg year regn2) c.rage##c.rage ///
	[pweight=compwt] , b(1)
margins i.educ	,  saving(m5, replace)

eststo: mlogit beliefs_poverty lrfs ///
	i.(educ hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize ///
	chrtpg year regn2) c.rage##c.rage ///
	[pweight=compwt] , b(1)
margins i.educ	,  saving(m6, replace)

eststo: mlogit beliefs_poverty lafs ///
	i.(educ hincqr soccomp econac ///
	rsex tenure married religsum ethnicity unionm hsize ///
	chrtpg year regn2) c.rage##c.rage ///
	[pweight=compwt] , b(1)
margins i.educ	,  saving(m7, replace)

* table Ax

esttab est1 est2 est3 using beliefs_poverty_educ_vals,  ///
	rtf replace ///
	eform se compress onecell label ///
	nomtitle drop(_cons) ///
	coefl(lrfs "Right-wing values" lafs "Authoritarian values") ///
	indicate("Economic position controls = *hincqr *.soccomp *.econac" ///
			"Demographic controls = *.rsex *.tenure *.married *.religsum *.ethnicity *.unionm *.hsize  rage *.rage" ///
			"Year Fixed Effects = *.year" ///
			"Region Fixed Effects = *.regn2" ///
			"Cohort FEs = *.chrtpg") ///
			title("Table Ax: Association between education and beliefs about causes of poverty") ///
			note("Estimated odds ratios from multinomial logistic regression models with 'social injustice' set to reference category. All models include survey weight. Data from 1989-2010 BSAS")

* figure Ay

clear

use m5

append using m6, gen(m6)
gen model = m6

append using m7, gen(m7)
replace model = 2 if m7==1

tab model


gen outcome = _predict
label define outcome 1 "Laziness" 2 "Social injustice" 3 "Been unlucky" 4 "Inevitable"
label values outcome outcome
tab outcome

gen ed = 4-_m1
tab ed _m1

gen pos = ed 
replace pos = ed + .3 if model ==0
replace pos = ed - .3 if model ==2

tab pos

twoway (scatter pos  _margin if model==0, mcol(black) msym(Oh)) ///
		(rcap _ci_lb _ci_ub pos if model==0, horiz lcol(black)) ///
		(scatter pos  _margin if model==1, mcol(gs8) msym(X)) ///
		(rcap _ci_lb _ci_ub pos if model==1, horiz lcol(gs8)) ///
		(scatter pos  _margin if model==2, mcol(red) msym(Th)) ///
		(rcap _ci_lb _ci_ub pos if model==2, horiz lcol(red)) ///
	,  by(outcome, note("")) ///
	ylabel(4 "Degree" 3 "Further ed < degree" 2 "Upper secondary" 1 "Lower secondary" 0 "No qualification") ///
	xtitle("Predicted probability of outcome") ///
	xlabel(.1(.05).5) ///
	ytitle("")  ///
	legend(rows(1) ///
		order(1 "No values" 3 "Right-wing values" 5 "Authoritarian values"))	
graph export beliefs_poverty_educ_vals.tif, replace	