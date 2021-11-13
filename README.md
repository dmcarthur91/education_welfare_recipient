# education_welfare_recipient

Replication code for McArthur, Daniel (2021) "Why are the highly educated more sympathetic towards welfare recipients?", European Journal of Political Research.  DOI:10.1111/1475-6765.12496

Version 1.0
13 Nov 2021

Daniel McArthur

Please send all questions, comments, and corrections to dan.mcarthur91@gmail.com

Stata code is provided to reproduce all results presented in the main paper and supplementary material.

The paper uses data from the following sources:

BRITISH SOCIAL ATTITUDES SURVEY: 1987 to 2018 https://www.bsa.natcen.ac.uk/

LABOUR FORCE SURVEY: 1984 to 1991 https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/methodologies/labourforcesurveyuserguidance

QUARTERLY LABOUR FORCE SURVEY: 1992 to 2019

All raw data are available from the UK Data Service https://ukdataservice.ac.uk/ on registration.
Unfortunately it is not possible to share either the raw data, or the final dataset used for analysis under the terms of the UK Data Service End User Licence. https://ukdataservice.ac.uk//app/uploads/cd137-enduserlicence.pdf 

All data manipulation and analysis are carried out in Stata, either version 16.1 or 17.0. The following user written commands are required to run code (available from ssc)
  renvars
  estout
  esttab
  coefplot
  Graphs made with the 'plotplain' scheme by Daniel Bischof 
  
There are 3 code files, which must be run in order.

education_welfare_recipient_1of3_LFS
-> This file uses LFS and QLFS data to create birth cohort-region level estimates of degree level education. File names of raw data reflect those used by UK Data Service at date of download and may have subsequently changed. Code assumes that raw files have been extracted and placed in common 'raw' folder. File paths will need to be updated. 

education_welfare_recipient_2of3_BSAS
-> This file uses BSAS 1987-2018 data to create main outcome and explanatory variables. Includes creation of outcome scales. LFS/QLFS data merged in to create final analysis dataset. File names of raw data reflect those used by UK Data Service at date of download and may have subsequently changed. Code assumes that raw files have been extracted and placed in common 'raw' folder. File paths will need to be updated. 

education_welfare_recipient_3of3_ANALYSIS
-> This file runs all analyses and produces output figures and tables. All figures are exported in publication-ready format as .tif files. Most results tables exported as .rtf files. Tables generally not publication ready, and required some manual formatting in MS Word


