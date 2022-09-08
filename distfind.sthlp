{smcl}
{* *! version 1.3.0  08Aug2022}{...}
{findalias asfradohelp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{viewerjumpto "Syntax" "distfind##syntax"}{...}
{viewerjumpto "Description" "distfind##description"}{...}
{viewerjumpto "Options" "distfind##options"}{...}
{viewerjumpto "Remarks" "distfind##remarks"}{...}
{viewerjumpto "Examples" "distfind##examples"}{...}
{title:Title}

{phang}
{bf:distfind} {hline 2} Fit alternative parametric survival distributions and report statistics relevant for health technology assessment


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:distfind}
[{varlist}]
[if]
{cmd:,}
{cmd: dlist({it:distributions})}
{cmd: timevar({varname})}
{cmd: failure({varname})}
[{cmdab:gr:aphs}]
[{cmdab:sup:press}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt: {opt dlist(distributions)}} list of distributions to try. All lower case. Typically defined in a macro (see example){p_end}
{synopt: {opt timevar(varname)}} variable defining time-to-event. Used in the same way as {it:stset}{p_end}
{synopt: {opt failure(varname)}} variable specifying the failure event. Assumes 1=failure, 0=censoring{p_end}
{synopt: {opt gr:aphs}} if specified, will store Cox-Snell resiudal plots in currdirectory/graphs{p_end}
{synopt: {opt sup:press}} if specified, will suppress production of the Cox-Snell residual plots{p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}


{marker description}{...}
{title:Description}

{pstd}
{cmd:distfind} fits alternative parametric survival distributions defined in {dlist} and reports standard summary statistics such as the Akaike Information Criterion, and produces plots of the Cox-Snell residuals.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:dlist({it:distributions})} list of distributions to try. All lowercase. Typically defined in a macro (see example). Legal names are "weibull" "gompertz" "ggamma" "lognormal" "loglogistic" "exponential". The two-parameter gamma distribtuion is not supported.

{phang}
{cmd:timevar({it:timevar})} variable defining time-to-event. Used in the same way as {it:stset}

{phang}
{cmd:failure({it:failvar})} variable specifying the failure event. Assumes 1=failure, 0=censoring.

{phang}
{opt gr:aphs} will store graphs in currentdirectory/graphs, if avaiable. This is designed for simialr folder structures to those used in the projectTemplate package in R.

{marker examples}{...}
{title:Examples}


{phang}{cmd:. sysuse cancer.dta}{p_end}
{phang}{cmd:. global dlist "ggamma weibull gompertz exponential lognormal loglogistic"}{p_end}
{phang}{cmd:. distfind age i.drug, dlist($dlist) timevar(studytime) failure(died)}{p_end}
{phang}{cmd:. distanalysis age i.drug, sdist(gompertz) doctitle(test) tabcaption("Gompertz")}{p_end}
