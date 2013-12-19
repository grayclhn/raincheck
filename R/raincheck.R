# Copyright (C) 2013 Gray Calhoun
#
# This file is part of the Raincheck R package. Raincheck is free
# software: you can redistribute it and/or modify it under the terms
# of the GNU General Public License as published by the Free Software
# Foundation, either version 2 of the License, or (at your option) any
# later version.
#
# Raincheck is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Raincheck.  If not, see <http://www.gnu.org/licenses/>.

raincheck <- function(expr) {
  e <- substitute(expr)
  function(env = parent.frame()) {
    ##    print(deparse(call.))
    eval(e, env)
    invisible(TRUE)
  }
}

scold <- function(text, action = c("warning", "stop", "message"),...) {
  action <- match.arg(action)
  act <- switch(action, warning = warning, stop = stop, message)
  ## Based on the condition constructor in _Advanced R Programming_ by
  ## Hadley Wickham (2013)
  response <-
    act(structure(class = c("condition", action),
                  list(message = text, call = sys.call(-4)),
                  ...))
  invisible(response)
}
