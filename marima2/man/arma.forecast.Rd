% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/arma.forecasting.R
\name{arma.forecast}
\alias{arma.forecast}
\title{arma.forecast}
\usage{
arma.forecast(
  series = NULL,
  marima = NULL,
  nstart = NULL,
  nstep = 1,
  dif.poly = NULL,
  check = TRUE
)
}
\arguments{
\item{series}{matrix holding the kvar-variate timeseries.
The series is assumed to have the same format
as the timeseries analysed by marima BEFORE differencing (if
differencing was used via define.dif)
(the length, though, does not need to be the same but can be shorter
or longer). Results
from estimating the model (for the differenced data, if used) are assumed
to be saved in the input-object 'marima' (see 'usage') by marima.

The series is assumed to have the total length=(nstart+nstep) (but it
may be longer. In any case the forecasting is starting from nstart
continuing to nstart+nstep. Future values already present or initialised,
for example, as NAs are overwritten with the forecasted values.)

An example of a series prepared for forcasting is in the marima library:
'data(austr)': (see below, the example).

If future (independent) x-values for the forecasting are to be used
these values must be supplied in 'series' at the proper places before
calling 'arma.forecast(...)' (that is except the x-value(s)
corresponding to the last prediction).}

\item{marima}{the object holding the marima results to be used for
the forecasting, that is an output object created by marima.

If the ar- and/or the ma-model do not include a leading unity matrix
this is automatically taken care of in the function (in that case the
dimensions of the model arrays used will be, respectively,
(kvar, kvar, p+1) and (kvar, kvar, q+1)) after inserting the leading
unity matrix (if the object 'marima' was produced by marima, this
will automatically be OK.}

\item{nstart}{starting point for forecasting (1st forecast values
will be for time point t = nstart+1).}

\item{nstep}{length of forecast (forecasts will be for time points
nstart+1,...,nstart+nstep).}

\item{dif.poly}{(most often) output from the function define.dif holding
the ar-representation of the differencing polynomial
(define.dif$dif.poly).
If a differenced timeseries was analysed by marima
the forecast-variance/covariance matrices are calculated for the
aggregated (original) timeseries if 'dif.poly' is specified. If not,
the forecast-variance/covariance matrices are calculated for the
differenced time series. If forecasting is wanted for the original
(not differenced) time series the 'dif.poly' created by define.dif
must be specified.}

\item{check}{If check=TRUE (default) various checks and
printouts are carried out.}
}
\value{
forecasts = forecasted values following the nstart first values
of the input series (at time points 'nstart+1,...,nstart+nstep').
The forecasted values will be (over-) written in the input series at
the proper future positions (if relevant).

residuals = corresponding residuals for input series followed by
nstep future residuals (all=0).

prediction.variances = (kvar, kvar, nstep) array containing
prediction covariance matrices corresponding to the nstep forecasts.

nstart = starting point for prediction (1st prediction at point
nstart+1).

nstep = length of forecast
}
\description{
Forecasting of (multivariate) time series of
using marima type model.
}
\examples{

library(marima)
data(austr)
series<-austr
Model5 <- define.model(kvar=7, ar=1, ma=1, rem.var=1, reg.var=6:7)
Marima5 <- marima(ts(series[1:90, ]), Model5$ar.pattern, Model5$ma.pattern, 
penalty=1)

nstart  <- 90
nstep   <- 10
cat("Calling arma.forecast.\n")
cat("In the example the input series is dim(length,kvar).\n")
cat("and of type ts() (timeseries) for illustration. \n")
Forecasts <- arma.forecast(series=ts(series), marima=Marima5, 
               nstart=nstart, nstep=nstep )
Year<-series[91:100,1]
One.step <- Forecasts$forecasts[, (nstart+1)]
One.step
Predict  <- Forecasts$forecasts[ 2, 91:100]
Predict
stdv<-sqrt(Forecasts$pred.var[2, 2, ])
upper.lim=Predict+stdv*1.645
lower.lim=Predict-stdv*1.645
Out<-rbind(Year, Predict, upper.lim, lower.lim)
print(Out)
# plot results:
plot(series[1:100, 1], Forecasts$forecasts[2, ], type='l', xlab='Year', 
ylab='Rate of armed suicides', main='Prediction of suicides by firearms', 
ylim=c(0.0, 4.1))
lines(series[1:90, 1], series[1:90, 2], type='p')
grid(lty=2, lwd=1, col='black')
Years<-2005:2014
lines(Years, Predict, type='l')
lines(Years, upper.lim, type='l')
lines(Years, lower.lim, type='l')
lines(c(2004.5, 2004.5), c(0.0, 2.0), lty = 2)

}
