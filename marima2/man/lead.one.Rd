% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mat.polyn.R
\name{lead.one}
\alias{lead.one}
\title{lead.one}
\usage{
lead.one(polyn = NULL, add = 0)
}
\arguments{
\item{polyn}{an input polynomium (an array).}

\item{add}{indicator for adding or removing unity matrix:
+1 = add leading unity matrix,
-1 = remove leading matrix.}
}
\value{
changed array (with leading unity matrix inserted or
removed).
}
\description{
Function to add (or remove) a leading unity matrix to (from)
an  array
(being an array representation of ar- or ma-polynomial).
}
