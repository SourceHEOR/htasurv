program define distfind, eclass
version 12.1
syntax [varlist(default=none fv)] [if], dlist(string) timevar(varname) ///
	failure(varname) [GRaphs] [SUPpress] [strata(varlist)] 

if "`graphs'"!="" & "`suppress'"=="" {
	local dir `c(pwd)'
	qui cd "`dir'/graphs"
}

*Loop through distributions, estimate AIC/BIC and Cox-snell residuals
foreach d in `dlist' {
	qui stset `timevar' `failure'
	if "`strata'"!="" {
		cap noisily streg `varlist' `if', dist(`d') strata(`strata') iter(100)
	}
	else {
		cap noisily streg `varlist' `if', dist(`d') iter(100)
	}
	if  e(converged) == 1 {
		local dlist2="`dlist2' `d'"
		estimates store `d'
		if "`suppress'"=="" {
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
	}
}

*Determine AIC
estimates stats `dlist2'
matrix t=r(S)
ereturn matrix diags=t
if "`suppress'"=="" {
	capture window manage close graph _all
	gr combine `dlist2', saving("cox_snell_residuals", replace)

	if "`graphs'"!="" {
		qui cd "`dir'"
		display "Graphs sent to /graphs"
	}
}
qui stset `timevar' `failure'
end
