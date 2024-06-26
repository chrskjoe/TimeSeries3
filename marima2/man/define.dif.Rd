% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/defining.programs.R
\name{define.dif}
\alias{define.dif}
\title{define.dif}
\usage{
define.dif(series = series, difference = NULL)
}
\arguments{
\item{series}{= kvar-variate timeseries (kvar by n matrix).}

\item{difference}{= 2 by L matrix defining L differencing operations.}
}
\value{
y.dif = the differenced timeseries (the complete part)

y.lost = the first observations lost because of differencing

dif.poly = differencing polynomial
array = c(kvar, kvar, ...) holding the autoregressive representation
of the specified differencing

averages = the averages of the original series as they
were subtracted before differencing

dif.series = the differenced series (y.lost followed by y.dif)
}
\description{
Function to generate and apply a differencing matrix polynomial
(autoregressive form) defined by a pattern.

To be used before calling marima in order to difference the
timeseries before the marima analysis. The averages of the variables
in the time series are subtracted from the input series before
differencing.
}
\examples{

# Generate Y=series with 4 variables for illustration:
set.seed(4711)
Y<-matrix(round(100*rnorm(40)+10), nrow=4)

# Example 1: use of difference parameter: If
difference=c(2, 1, 2, 1, 3, 12)
difference
# the variable 2 is differenced
# twice, and variable 3 is differenced once with lag=12.

# Example 2:
poly <- define.dif(series=Y, difference=c(2, 1, 3, 1, 3, 1))
poly
# Generates a (4-variate) polynomial differencing array (with a leading
# unity matrix corresponding to lag=0, and (in the example) differencing
# of variable 2 for lag 1 and variable 3 for lag 1 but twice. Afterwards
# the series Y is differenced accordingly. Results in poly$series and
# poly$dif.poly .

# Example 3: Generation and application of multivariate differencing
# polynomial. Re-use the 4-variate time series and use the
# differencing polynomial (ar-form):
# var=1, dif=1, var=2, dif=6, and var=3 and 4, no differencing.
dif.y <-define.dif(Y, c(1, 1,  2, 6,  3, 0,  4, 0))
# Now dif.y contains the differenced series and the differencing
# polynomial. Print the generated polynomial in short form:
short.form(dif.y$dif.poly)
# Specifying no differencing (3, 0 and 4, 0) may be omitted:
dif.y <-define.dif(Y, c(1, 1,  2, 6))
dif.y

# Example 4:
y<-matrix(round(rnorm(1200)*100+50), nrow=6)
library(marima)
difference<-c(3, 2, 4, 0, 5, 0, 6, 7)
matrix(difference, nrow=2)
Y<-define.dif(y, difference=difference)
round(rowMeans(Y$dif.series), 2)
round(Y$averages, 2)

}
