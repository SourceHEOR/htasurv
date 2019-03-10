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
mata: mata clear 
mata:
void nozero(Q) {
 		M = st_matrix(Q)
		non_zero = select(select(M, rowsum(abs(M))),colsum(abs(M))) 
		st_matrix("VarCovar", non_zero)
}
end

program define distoutput
syntax [varlist(default=none fv)] [if], dlist(string) fname(string)	///
	sname(string) [note(string) MODify]


if "`modify'" == "" {
	putexcel set "`fname'", sheet("`sname'") replace
}
else {
	putexcel set "`fname'", sheet("`sname'") modify
}
/*
*Set up spreadsheet
if "`startrow'" == "" {
	local myrow = `startrow'
}
else { 
*/
	local myrow = 6
//}

local trow=`myrow'-1
putexcel A1="`c(current_date)'"
putexcel A2="`c(current_time)'"
putexcel A3="`note'"
putexcel C`trow'="Coef." D`trow'="Std. Err" E`trow'="ll" ///
	F`trow'="ul" G`trow'="Variance-covariance"

foreach dist in `dlist' {
	
	*Run regression and store output
	streg `varlist' `if', d(`dist')
	matrix A = e(V)
	local nvars = rowsof(A) //Includes ommitted variables
	matrix B = r(table)'
	local rownms: rown B    //Row names
	
	*Get variance-covriance matrix without zeros
	mata: nozero("A")

	if !missing("`j'") {
		local myrow = `myrow' + `j'
	}
	putexcel A`myrow' = ("`dist'")
	local j = 0
	
	forvalues i = 1/`nvars' {	
		if !missing(B[`i', 2]) {
			local rowname: word `i' of `rownms'
			local mynewrow = `myrow' + `j'
			local mycoef = B[`i', 1]
			local myse   = B[`i', 2]
			local myll   = B[`i', 5]
			local myul   = B[`i', 6]
			
			putexcel B`mynewrow' = "`rowname'"
			putexcel C`mynewrow' = `mycoef'
			putexcel D`mynewrow' = `myse'
			putexcel E`mynewrow' = `myll'
			putexcel F`mynewrow' = `myul'
			local j = `j' + 1	
		}		
	}
	putexcel G`myrow' = matrix(VarCovar)
}
putexcel close
end