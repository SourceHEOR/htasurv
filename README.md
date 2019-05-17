# Survival analysis for Health Technology Assessment



`htasurv` is a Stata module for assessing alternative parametric distributions when extrapolating survival data for use in health economic models. The function `distfind` loops through alternative distributions (specified by the user) and reports statistics and produces plots specified in [NICE DSU TSD 14.0](http://www.nicedsu.org.uk/NICE%20DSU%20TSD%20Survival%20analysis.updated%20March%202013.v2.pdf). The function `distanalysis` writes out results and useful statistics (e.g. variance-covariance matrix) for the analyst. The module can be installed directly from github, using the [github module](https://github.com/haghish/github). Once the github module is installed, installation of `htasurv` is:

	github install sourceHEOR/htasurv

### Syntax
For `distfind`:

    distfind [varlist], dlist(string) timevar(varname) failure(varname) [GRaphs] [SUPpress]

Where `varlist` are the variables in the survival model (often treatment), `timevar` is the variable defining the time-to-event, and `failure` is a binary variable for failure vs censoring (1=failure, 0=censored). If the `graphs` option is used, plots will be saved to `curentdirectory/graphs`.`dlist` is the list of distributions to estimate as lowercase strings (see example below).  If the `suppress` option is used, the Cox-Snell residuals will not be plotted. The resulting table of diagnostics is returned in `e(diag)`. 

For `distanalysis`:

	distanalysis [varlist], sdist(string) doctitle(string) [caption(string)] [fname(string)]

`distanalysis` will estimate the model with variables given in `varlist` with distribution given in `sdist` (full title; all lowercase). The resulting model will be written to .csv and .rtf files with file names given by `doctitle`. If a folder location is specified by `fname`, all files will be stored there (otherwise, the current directory is used).

### Example use

	sysuse cancer.dta, clear
	global dlist "gamma weibull gompertz exponential lognormal loglogistic"
	distfind age i.drug, dlist($dlist) timevar(studytime) failure(died)
	distanalysis age i.drug, sdist(gompertz) doctitle(test) caption("Gompertz")
	distplot if drug==1, exrange(60) intrange(10) dlist($dlist) drugnames("Placebo Drug2") ytitle("Proportion alive") xtitle("Time (Months)")
	distplot if drug==2, exrange(60) intrange(10) dlist($dlist) drugnames("Placebo Drug2") ytitle("Proportion alive") xtitle("Time (Months)")
	distplot if drug==3, exrange(60) intrange(10) dlist($dlist) drugnames("Placebo Drug2") ytitle("Proportion alive") xtitle("Time (Months)")
	recode drug (1=0) (2=1)
	distplot drug if drug==0 | drug==1, exrange(60) intrange(10) dlist($dlist) drugnames("Placebo Drug2") ytitle("Proportion alive") xtitle("Time (Months)")

	

Author
------
  **D Trueman**  
  Source Health Economics
  
  _dtrueman@source-he.com_     
  _http://www.source-he.com/_  

