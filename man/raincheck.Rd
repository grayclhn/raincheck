% Copyright (C) 2013 Gray Calhoun
%
% This file is part of the Raincheck R package. Raincheck is free
% software: you can redistribute it and/or modify it under the terms
% of the GNU General Public License as published by the Free Software
% Foundation, either version 2 of the License, or (at your option) any
% later version.
%
% Raincheck is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see
% <http://www.gnu.org/licenses/>.

\name{raincheck}
\alias{raincheck}
\alias{scold}
\title{Generate external function for argument manipulation}

\description{
The function \code{raincheck} creates a function that will manipulate the
environment where it is called. The \code{scold} function writes error
messages that appear to come from that same environment. Both functions
make it easier to separate code that reformats arguments from the main
code of a function.
}

\usage{
raincheck(expr)
scold(text, action = c("warning", "stop", "message"),...)
}

\arguments{
  \item{expr}{R code that will operate on the environment of the
    function that calls the function returned by \code{raincheck}.}
  \item{text}{An error message to display to the user.}
  \item{action}{The type of error message.}
  \item{...}{Additional arguments to pass to the condition generated in
    \code{scold}.}
}
\details{
Fill in after the package evolves a little.
}
\value{
  \code{raincheck} returns a function that manipulates the environment
  where it is called.  See the examples below.
}

\references{
Wickham, Hadley (2013) \emph{Advanced R
Programming}. Chapman and Hall. \url{http://adv-r.had.co.nz/}}

\author{Gray Calhoun \email{gcalhoun@iastate.edu}}

\note{Some code in the \code{scold} function is based on/borrowed from
  Wickham's (2013) \emph{Advanced R programming}, see
  \url{http://adv-r.had.co.nz/Exceptions-Debugging.html#condition-handling}.
}

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

\keyword{programming}
\keyword{error}
