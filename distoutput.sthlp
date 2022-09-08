{smcl}
{* *! version 1.2.1  07mar2013}{...}
{findalias asfradohelp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{viewerjumpto "Syntax" "distoutput##syntax"}{...}
{viewerjumpto "Description" "distoutput##description"}{...}
{viewerjumpto "Options" "distoutput##options"}{...}
{viewerjumpto "Remarks" "distoutput##remarks"}{...}
{viewerjumpto "Examples" "distoutput##examples"}{...}
{title:Title}

{phang}
{bf:distoutput} {hline 2} Output alternative parametric survival distributions, confidence intervals, and variance-covariance matrices to Excel

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:distoutput}
[{varlist}]
[{it:if}]
{cmd:,}
{cmd: dlist({it:distributions})}
{cmd: fname({it:doctitle})}
{cmd: sname({it:sheetname})}
[{cmd: note(notetext)}]
[{cmdab:mod:ify}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt: {opt dlist(distributions)}} list of distributions to try. All lower case. Typically defined in a macro (see example){p_end}
{synopt: {opt fname(doctitle)}} name of .xls file to use. Does not need to exist, but will modify if it does so {p_end}
{synopt: {opt sname(sheetname)}} name of sheet to use. Does not need to exist {p_end}
{synopt: {opt note(notetext)}} note to be included in cell A3 of {it:sname} {p_end}
{synopt: {opt mod:ify}} if specified, will modify {it:sheetname} (instead of replace) {p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}


{marker description}{...}
{title:Description}

{pstd}
{cmd:distoutput} Outputs parametric survival distributions defined in {dlist} and reports useful data: coefficients, standard errors, 95% confidence intervals, varaince-covaraince matrices. This is handy if multiple distributions are to be included in an economic model implemented in Excel.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:dlist({it:distributions})} list of distributions to try. All lowercase. Note use of  "ggamma" vs "gamma" to denote 3-paramter and 2-parameter gamma distributions, respectively. Typically defined in a macro (see example). Legal names are "weibull" "gompertz" "ggamma" "gamma" "lognormal" "loglogistic" "exponential".

{phang}
{cmd:sname({it:doctitle})} Excel file to write reuslts to

{phang}
{cmd:sname({it:sheetname})} name of sheet to use. Does not need to exist

{phang}
{opt:note({it:notetext})} note to be included in cell A3 of {it:sname}

{phang}
{opt mod:ify} if specified, will modify {it:sheetname} (instead of replace)

{marker examples}{...}
{title:Examples}


{phang}{cmd:. sysuse cancer.dta}{p_end}
{phang}{cmd:. global dlist "ggamma weibull gompertz exponential lognormal loglogistic"}{p_end}
{phang}{cmd:. distoutput age i.drug, dlist($dlist) fname("test.xls") sname("output")}{p_end}

