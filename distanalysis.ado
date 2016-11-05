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

program define distanalysis
version 12.1
syntax [varlist(default=none fv)], sdist(string) doctitle(string) [caption(string)] [fname(string)]

local filepres:word count `fname'
if `filepres'==1{
	local dir `c(pwd)'
	qui cd "`fname'"
	di "Was: " "`dir'" ", now:" "`fname'"
}

*Estimate model (assumes you've used full titles, lowercase )
if "`sdist'"=="weibull" | "`sdist'"=="exponential" | "`sdist'"=="gompertz" {
	streg `varlist', dist(`sdist') nohr
}
else {
	streg `varlist', dist(`sdist')
}
estimates store mymodel

*Write output to files
local csvfile "`doctitle'.csv" //name of csv file
local rtffile "`doctitle'.rtf" //name of rtf file

*Output data
esttab mymodel using "`csvfile'", replace wide plain se title("`doctitle'")
esttab mymodel using "`rtffile'", replace se onecell ///
	title({\b Table 1.} {\i "`caption'"}) mtitles("`sdist'")

*Variance-covariance matrix
estat vce
matrix mymat=e(V)
mat2txt, matrix(mymat) saving("`doctitle'_varcovar.txt") replace ///
	title("Variance-covariance matrix (`sdist')")

if `filepres'==1{
	qui cd "`dir'"
	display "Output sent to " "`fname'"
}

*Tidy up
capture window manage close graph _all
end
