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

program define distplot
version 12.1
syntax [varlist(default=none)] [if], exrange(real) intrange(real) ///
	dlist(string) drugnames(string) [ytitle(string) xtitle(string) ///
	mtitle(string) GRaphs]
tokenize `drugnames'

if "`graphs'"!="" {
	local dir `c(pwd)'
	qui cd "`dir'/graphs"
}

*Store a temporary version of the main dataset
tempfile tempresults
save "`tempresults'"

if "`if'"!=""{
 keep `if'
}
tempfile tempresults2
save "`tempresults2'"

*Some checks
local varpres:word count `varlist'
if `varpres'>1 {
	di in red "Only one variable can be entered in varlist at present"
	exit
}
if !missing("`varlist'") {
	qui tab `varlist' `if'
	local levels = `r(r)'
	if `levels' > 2 {
		di in red "Only 2 levels for varlist supported at present"
		exit
	}
}
else {
	local levels = 1
}
if !missing("`varlist'") {
	qui sum `varlist' `if'
	if `r(max)' > 1 {
		di in red "Treatment variable must be coded 0/1"
		exit
	}
}
if `exrange'<0 {
	local foo "The argument 'exrange' is the time (in your unit of analysis" 
	local foo "`foo' time) over which you would like to see extrapolations,"
	local foo "`foo' and must be > 0"
	di in red "`foo'"
	exit
}

*Fit parametric model(s), save stcurve data using outfile
foreach d in `dlist' {
	
	streg `varlist' `if', dist(`d')
	
	if `levels'==1 {
		stcurve, survival range(0 `exrange') outfile(`d', replace)
		//if "`if'"=="" {
			local myadd "line surv1 _t if dist==1"
		//}
		//else {
		//	local myadd "line surv1 _t `if' & dist==1"
		//}
		
	}
	else if `levels'==2 {
		stcurve, at(`varlist'=0) at(`varlist'=1) survival ///
		range(0 `exrange') outfile(`d', replace)
		//if "`if'"=="" {
			local myadd "line surv1 _t if dist==1 || line surv2 _t if dist==1"
		//}
		//else {
		//	local myadd "line surv1 _t `if' & dist==1 || line surv2 _t `if' & dist==1"
		//}
	}
}

*Create datset containing all extraploations
local y = 1
foreach d in `dlist' {
	if `y'==1 {
		use `d', clear
		gen dist=1
	}
	else if `y' > 1 {
		append using `d'
		replace dist=`y' if missing(dist)
	}
	local y=`y'+1
}
save combined, replace

*Overlay extrapolations on Kaplan-Meier
use `tempresults2', clear
gen real=1 `if'
append using combined
local y = 1
local x = 1

*Set up legend and axis titles
if `levels'==2 {
	local mylegend = `"1 "`1' - Kaplan-Meier" 2 "`2' - Kaplan-Meier" "'
}
else {
	local mylegend = `"1 "`1' - Kaplan-Meier" "' 
}
if "`ytitle'"=="" {
	local ytitle = "Survival"
}
if "`xtitle'"=="" {
	local xtitle = "Time"
}

*Create legend and call to addplot
foreach d in `dlist' {
	if `levels'==2 {
		local x = `x' + 2
		local z = `x' + 1
		local mylegend = `"`mylegend'"' + `" `x' "`1' - `d'" `z' "`2' - `d'" "'
		if `y' > 1 {
			//if "`if'"=="" {
			local myadd "`myadd' || line surv1 _t if dist==`y' || line surv2 _t if dist==`y'"
			//}
			//else {
			//	local myadd "`myadd' || line surv1 _t `if' & dist==`y' || line surv2 _t `if' & dist==`y'"
			//}
		}
	}
	else {
		local x = `x' + 1
		local mylegend = `"`mylegend'"' + `" `x' "`1' - `d'" "'
		if `y' > 1 {
			//if "`if'"=="" {
				local myadd "`myadd' || line surv1 _t if dist==`y' "
			//}
			//else {
			//	local myadd "`myadd' || line surv1 _t `if' & dist==`y' "
			//}
		}
	}
	local y=`y'+1
}

*Create sts graph based on 1/2 variables and whether and if statement
if "`if'"!="" & `levels'== 2 {
	sts graph `if' & real==1, by(`varlist') addplot(`myadd', sort ///
	legend(order(`"`mylegend'"'))) ytitle("`ytitle'") xtitle("`xtitle'") ///
	xla(0 (`intrange') `exrange') title("`mtitle'")
}
else if "`if'"=="" & `levels' == 2 {
	sts graph if real==1, by(`varlist') addplot(`myadd', sort ///
	legend(order(`"`mylegend'"'))) ytitle("`ytitle'") xtitle("`xtitle'") ///
	xla(0 (`intrange') `exrange') title("`mtitle'")
}
else if "`if'"!="" & `levels' == 1 {
	sts graph `if' & real==1, addplot(`myadd', sort ///
	legend(order(`"`mylegend'"'))) ytitle("`ytitle'") xtitle("`xtitle'") ///
	xla(0 (`intrange') `exrange') title("`mtitle'")
}
else if "`if'"=="" & `levels' == 1 {
	sts graph if real==1, addplot(`myadd', sort ///
	legend(order(`"`mylegend'"'))) ytitle("`ytitle'") xtitle("`xtitle'") ///
	xla(0 (`intrange') `exrange') title("`mtitle'")
}

*Restore original dataset
use `tempresults', clear
erase "`tempresults'"
erase "`tempresults2'"
if "`graphs'"!="" {
	qui cd "`dir'"
}
end
