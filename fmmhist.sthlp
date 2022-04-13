{smcl}
{* *! version 1.0.0  13apr2021}{...}
{title:fmmhist}

{pstd}
{cmd:fmmhist} Generates a multi-class histogram after estimating a fmm model.

{marker syntax}{...}
{title:Syntax}
{pstd}
{cmd:fmmhist} {cmd:,} {opt bins(integer)} [{opt DENS:ity} {opt TI:tle(string)} {opt XTI:tle(string)} {opt YTI:tle(string)} {opt XLAB(string)} {opt YLAB(string) } ]


{pstd}
{cmd:fmmhist} draws a histogram in different colours indicating class
membership after a {cmd:fmm} estimation command.

{pstd}
Histogram bars are currently drawn with 30% transparency.

{pstd}
The options title, xti, yti, xlab, ylab are standard twoway graph options
to generate graph titles and labels.


{title:Example}

{hline}
{cmd:. sysuse citytemp}

{cmd:. fmm 2: regress heatdd}

{cmd:. fmmhist , bins(20)}

{pstd}Load US city temperatures, fit 2 class model against heating days with 
fmm. 

{pstd}
Displays a histogram showing the two distributions of cold and hot cities.


{hline}

