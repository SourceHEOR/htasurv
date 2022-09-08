{smcl}
{* *! version 1.3.0  08Aug2022}{...}
{findalias asfradohelp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{viewerjumpto "Syntax" "distanalysis##syntax"}{...}
{viewerjumpto "Description" "distanalysis##description"}{...}
{viewerjumpto "Options" "distanalysis##options"}{...}
{viewerjumpto "Remarks" "distanalysis##remarks"}{...}
{viewerjumpto "Examples" "distanalysis##examples"}{...}
{title:Title}

{phang}
{bf:distanalysis} {hline 2} Report results of parametric survival analysis for use in health technology assessment


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:distanalysis}
[{varlist}]
{cmd:,}
{cmd: sdist({it:distribution})}
{cmd: doctitle({it:doctitle})}
[{cmd: caption({it:caption})}]
[{cmd: fname({it:foldername})}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt: {opt sdist(distribution)}} distribution to use. All lowercase.{p_end}
{synopt: {opt doctitle(string)}} name for .csv and .rtf files {it:stset}{p_end}
{synopt: {opt caption(string)}} caption to be used in the created files{p_end}
{synopt: {opt fname(string)}} if specified, will store all output in the directory {it:fname}{p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}


{marker description}{...}
{title:Description}

{pstd}
{cmd:distanalysis} estimates the parametric survival model specified by (optional) {varlist} with distribution {it:sdist} and outputs these models and standard errors to .csv and .rtf files along with the variance-covarinace matrix as .txt.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:sdist({it:distribution})} distribution to use. All lowercase. Legal names are "weibull" "gompertz" "ggamma" "lognormal" "loglogistic" "exponential". The 2-parameter gamma distribution is not supported (this uses mestreg and the likelihoods are not comparable to those from streg).

{phang}
{cmd:doctitle()} variable defining name of output files, e.g. "myoutput".

{phang}
{cmd:caption()} variable defining caption in {it:doctitle}. e.g. "model 1". 

{phang}
{cmd:fname()} if specified, all output will be stored in {it:fname} instead of the current directory.

{marker examples}{...}
{title:Examples}
{phang}{cmd:. sysuse cancer.dta}{p_end}
{phang}{cmd:. global dlist "gamma weibull gompertz exponential lognormal loglogistic"}{p_end}
{phang}{cmd:. distfind age i.drug, dlist($dlist) timevar(studytime) failure(died)}{p_end}
{phang}{cmd:. distanalysis age i.drug, sdist(gompertz) doctitle(test) caption("Gompertz")}{p_end}
