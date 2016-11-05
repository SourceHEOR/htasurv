# Survival analysis for Health Technology Assessment



`htasurv` is a Stata module for assessing alternative parametric distributions when extrapolating survival data for use in health economic models. The function `distfind` loops through alternative distributions (specified by the user) and reports statistics and produces plots specified in [NICE DSU TSD 14.0](http://www.nicedsu.org.uk/NICE%20DSU%20TSD%20Survival%20analysis.updated%20March%202013.v2.pdf). The function `distanalysis` writes out results and useful statistics (e.g. variance-covariance matrix) for the analyst. The module can be installed directly from github, using the [github module](https://github.com/haghish/github). Once the github module is installed, installation of htasurv is:

	github install sourceHEOR/htasurv

### Syntax
For `distfind`:

    distfind [varlist], dlist(string) timevar(varname) failure(varname) [GRaphs]

Where `varlist` are the variables in the survival model (often treatment), `timevar` is the variable defining the time-to-event, and `failure` is a binary variable for failure vs censoring (1=failure, 0=censored). If the `graphs` option is used, plots will be saved to `curentdirectory/graphs`.`dlist` is the list of distributions to estimate as lowercase strings (see example below).

For `distanalysis`:

	distanalysis [varlist], sdist(string) doctitle(string) [caption(string)] [fname(string)]

	`distanalysis` will estimate the model with variables given in `varlist` with distribution given in `sdist` (full title; all lowercase). The resulting model will be written to .csv and .rtf files with file names given by `doctitle`. If a folder location is specified by `fname`, all files will be stored there (otherwise, the current directory is used).

### Example use:

	sysuse cancer.dta, clear
	global dlist "gamma weibull gompertz exponential lognormal loglogistic"
	distfind age i.drug, dlist($dlist) timevar(studytime) failure(died)
	distanalysis age i.drug, sdist(gompertz) doctitle(test) tabcaption("Gompertz")

Author
------
  **D Trueman**  
  Source HEOR
  _dtrueman@sourceheor.com_     
  _http://www.sourceheor.com/_  

