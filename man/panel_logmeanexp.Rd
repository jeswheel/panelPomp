% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/panel_logmeanexp.R
\name{panel_logmeanexp}
\alias{panel_logmeanexp}
\title{Log-mean-exp for panels}
\usage{
panel_logmeanexp(x, MARGIN, se = FALSE)
}
\arguments{
\item{x}{Matrix with the same number of replicated estimates for each panel
unit loglikelihood.}

\item{MARGIN}{The dimension of the matrix that corresponds to a panel unit
and over which averaging occurs (1 indicates rows, 2 indicates columns).}

\item{se}{logical; whether to give standard errors.}
}
\value{
A \code{numeric} value with the average panel log likelihood or, when
\code{se = TRUE}, a \code{numeric} vector adding the corresponding standard error.
}
\description{
This function computes the \code{\link[pomp]{logmeanexp}} for each column
or row of a numeric matrix and sums the result. Because the loglikelihood
of a \code{panelPomp} object is the sum of the loglikelihoods of its units,
this function can be used to summarize replicated estimates of the
\code{panelPomp} model likelihood. If \code{se = TRUE}, the jackknife SE estimates
from \code{\link[pomp]{logmeanexp}} are squared, summed and the squared root is taken.
}
\examples{
ulls <- matrix(c(1,1,10,10),nr=2)
panel_logmeanexp(ulls,MARGIN=2,se=TRUE)
}
\seealso{
panel_loglik
}
\author{
Carles \Breto
}
