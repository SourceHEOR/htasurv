program define distfind
version 12.1
syntax [varlist(default=none fv)] [if], dlist(string) timevar(varname) failure(varname) [GRaphs] [strata(varlist)]

if "`graphs'"!="" {
	local dir `c(pwd)'
	qui cd "`dir'/graphs"
}

*Loop through distributions, estiamte AIC/BIC and Cox-snell residuals
foreach d in `dlist' {
	qui stset `timevar' `failure'
	if "`strata'"!="" {
		streg `varlist' `if', dist(`d') strata(`strata')
	}
	else {
		streg `varlist' `if', dist(`d')
	}
	estimates store `d'
	predict double cs, csnell
	stset, clear
	qui stset cs `failure'
	qui sts gen km = s `if'
	qui gen double H = -ln(km) `if'
	qui line H cs cs, sort title(`d') leg(off) ///
		ytitle("Cumulative Hazard", size(small) margin(medsmall)) ///
		xtitle(Cox-Snell Residuals, size(small) margin(medsmall)) ///
		saving(`d', replace) name(`d', replace)
	drop cs km H cs
}

*Determine AIC
estimates stats `dlist'
capture window manage close graph _all
gr combine `dlist', saving("cox_snell_residuals", replace)

if "`graphs'"!="" {
	qui cd "`dir'"
	display "Graphs sent to /graphs"
}

qui stset `timevar' `failure'

end
