/*
Copyright (C) 2016  Source Market Access Ltd

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

program define distfind2
version 12.1
syntax [varlist(default=none fv)], dlist(string) timevar(varname) ///
	failure(varname) [GRaphs] [fname(string) sname(string) wght(string)]

if "`graphs'"!="" {
	local dir `c(pwd)'
	qui cd "`dir'/graphs"
}
*Loop through distributions, estimate AIC/BIC and Cox-snell residuals
foreach d in `dlist' {
	if "`mywght'" !="" {
		qui stset `timevar' [iw=`mywght'], fail(`failure')
	}
	else {
		qui stset `timevar', fail(`failure')
	}
	qui streg `varlist', dist(`d')
	qui estat ic
	qui matrix define `d' = J(1,6,0)
	qui matrix `d' = r(S)
	qui matrix rownames `d' = `d'
	estimates store `d'
	predict double cs, csnell
	stset, clear
	qui stset cs `failure'
	qui sts gen km = s
	qui gen double H = -ln(km)
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

if "`fname'"!="" {
	putexcel set `fname', sheet(`sname', replace) modify
	local y=1
	foreach d in `dlist'{
		local y = `y'+1
		if `y' == 2 {
			matrix list `d'
			putexcel A1 = matrix(`d'), names
		}	
		else {
			putexcel A`y' = matrix(`d'), rownames
		}
	}
}
if "`graphs'"!="" {
	qui cd "`dir'"
	display "Graphs sent to /graphs"
}
qui stset `timevar' `failure'
end
