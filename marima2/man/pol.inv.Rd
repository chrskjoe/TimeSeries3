% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mat.polyn.R
\name{pol.inv}
\alias{pol.inv}
\title{pol.inv}
\usage{
pol.inv(phi, L)
}
\arguments{
\item{phi}{polynomium (an array) to invert}

\item{L}{order of inverse polynomium}
}
\value{
left inverse of phi of order L (L+1 terms including leading
unity matrix)
}
\description{
Calculation of left inverse of matrix polynomial. The
leading term
is expected to be the (k by k) identity matrix. This is checked
and the proper leading unity term is taken into account when the
inverse is calculated.

phi = matrix polynomial coefficients = I, phi1, phi2, ..., phi(p).

dim(phi) = c(k, k, p+1) where k = dimension of coefficient
matrices (k by k), and L  = order of polynomial (length = 1+L ,
including the leading unity matrix).
}
\examples{
set.seed(4711)
p2<-check.one(array(rnorm(32),dim=c(4,4,2)))
pi2<-pol.inv(p2,L=12)
short.form(pi2)

}
