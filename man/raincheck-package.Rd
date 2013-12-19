\name{raincheck-package}
\alias{raincheck-package}
\docType{package}
\title{Minimal deferred argument manipulation for R functions.}

\description{
This package lets you write code to check and manage a function's
arguments, but put that code outside the function for readability.
}
\author{Gray Calhoun \email{gcalhoun@iastate.edu}}
\keyword{ package }

\examples{
f1 <- function(x) {
  FormatArguments_f1() # Yikes; *only* side effects
  ## Important, logical stuff goes here
  x[10,10]
} 

FormatArguments_f1 <- raincheck({
  if (!is.matrix(x)) {
    scold("'x' really should have been a matrix.")
    x <- as.matrix(x)
  }
  if (any(x == 30)) {
    scold("Cool, I love the number thirty.\n", "message")
  }
  if (nrow(x) < 10 || ncol(x) < 10) {
    scold("'x' must have at least 10 rows and 10 columns.", "stop")
  }
})

f1(matrix(30, 11, 11))
f1(matrix(31, 11, 11))

\dontrun{f1(30)}
}
