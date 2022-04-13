cap program drop fmmhist
version 17.0
program define fmmhist
	syntax  , [bins(integer -1) DENSity TItle(passthru) XLAB(passthru) YLAB(passthru) XTItle(passthru) YTItle(passthru) ]
	if (substr("`e(cmdline)'",1,4)!="fmm ") {
		di as error "No previous fmm model found"
		error 999
	}
	// Find the dependent variable, check it is the same across equations
	local depvars "`e(depvar)'"
	local depvarcount : word count `depvars'
	local firstdepvar : word 1 of `depvars'
	forv i=2(1)`depvarcount' {
		local newdepvar : word `i' of `depvars'
		if "`newdepvar'" != "`firstdepvar'" {
			di as error "Multiple dependent variables found"
			error 999
		}
	}
	local outcomevar `firstdepvar'
	confirm numeric variable `outcomevar'
	
	preserve	
	tempvar densityvar prob allfreq binnedOutcome freq
	predict `densityvar', marginal density
	label variable `densityvar' "Fitted density"	
	predict `prob'*, classposteriorpr
	qui ds `prob'*
	local classcount : word count `r(varlist)'
	
	if (`bins'==-1) {
		qui summ `outcomevar'
		local minBin=floor(`r(min)')
		local maxBin=ceil(`r(max)')
		local binStep=1	
		egen `binnedOutcome'=cut(`outcomevar'), at(`minBin'(`binStep')`maxBin')  label
		local label: variable label `outcomevar'
		label variable `binnedOutcome' "`label'"
	}
	else {
		qui summ `outcomevar'
		local minBin=`r(min)'
		local maxBin=`r(max)'
		local range=`maxBin'-`minBin'
		local binStep=`range'/`bins'
		egen `binnedOutcome'=cut(`outcomevar'), at(`minBin'(`binStep')`maxBin')  label
		local label: variable label `outcomevar'
		label variable `binnedOutcome' "`label'"		
	}
	
	collapse (count) `allfreq'=`outcomevar' (mean) `densityvar' (mean) `prob'*  , by(`binnedOutcome')	
	label variable `densityvar' "Fitted density"	
	local i=1
	local graphstatement ""
	local graphopts ""
	foreach v of varlist `prob'* {
		gen `freq'`i'=`v'*`allfreq'
		label variable `freq'`i' "Count in class `i'"
		if `i'>1 {
			local graphstatement "`graphstatement' || "	
		}
		local graphstatement "`graphstatement' bar  `freq'`i' `binnedOutcome' , bcol(%30) "	
				
		local i=`i'+1
	}
	
	if "`density'"!="" {
		local graphstatement "`graphstatement' || line `densityvar' `binnedOutcome' , yaxis(2)  "			
		local graphopts "`graphopts'  yti("", axis(2)) ylab(,axis(2) nolabels) "
	}
	
	* di "`graphstatement'"
	* di "`graphopts'"
	
	local graphopts "`graphopts' `title' `xlab' `ylab' `xtitle' `ytitle' "
			
	twoway ///		
		`graphstatement'  ///		
		, yti("Count", axis(1))	`graphopts'
restore
end