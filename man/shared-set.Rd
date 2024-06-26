% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generics.R
\name{shared<-}
\alias{shared<-}
\title{Set shared parameters of a panelPomp object}
\usage{
shared(object) <- value
}
\arguments{
\item{object}{an object that contains shared parameters.}

\item{value}{a named numeric vector containing the desired values of the
shared parameter vector.}
}
\description{
This function is used to set the shared parameters of a panel pomp object.
}
\examples{
prw <- panelRandomWalk()
# set parameters in list form
shared(prw) <- c("sigmaX" = 1, "sigmaY" = 2)
}
\seealso{
\link{panelPomp_methods}
}
\author{
Jesse Wheeler
}
\keyword{internal}
