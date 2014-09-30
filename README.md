Raincheck (version 0.0.1, 12/19/2013)
=====================================

Raincheck is a minimal R package that allows you to put messy code to
reformat and check a function's arguments *outside* that function.
For example:
```R
greatfunction <- function(x1, x2, x3 = NULL) {
    MakeXsCorrect()
    ## great code that does great things
    ## ...
    return(results)
}

MakeXsCorrect <- raincheck({
    x1 <- as.greatobject1(x1)
    x2 <- as.greatobject2(x2)
    x3 <- as.therightthing(x1, x2, x3)
    ## Many more steps to get the xs in the right format
    ## ...
})
```
The assignments `x1 <- as.greatobject(x1)`, etc., operate on the copy
of `x1` in `greatfunction`.

Why do this? `MakeXsCorrect` can contain a lot of confusing
boilerplate code that is peripheral to the main point of the
function. In those cases, this structure can be more readable than
putting the code directly in the function.

Motivation: Literate-style argument checking in R
-------------------------------------------------

A copy of the blog post where I first introduced `raincheck` (which
I'm about to delete)

I’ve played around with [Literate Programming][1] since early in grad
school. Literate Programming was developed by [Don Knuth][2] (who also
developed TeX and was generally a hugely influential computer
scientist) and is grounded in the idea of embedding a computer program
inside its documentation, rather than the other way around. A lot of
people mistakenly believe that the point of this is to have nicely
formatted documentation (there are pretty-printers, etc.) but the big
advantage is that LP tools let you arrange your program in logical
order, and the tools will reassemble it in the correct order for
you. Norman Ramsey’s [noweb][3] program is an example of this.

Anyway, Literate Programming hasn’t caught on and I don’t do it
anymore. (Tools for Reproducible Research, like [Sweave][4] and [Knitr][5],
generally don’t allow you to write the code in arbitrary order, so
they’re close but don’t count.) For one thing, the tools are too
specific to a particular workflow, which makes collaborating
difficult. But another reason is that a lot of the benefits are
available without using dedicated Literate Programming tools. R
packages, for example, let you organize code logically and will get
the order “correct” when it’s time to call them.

But one thing I miss is the construction (using R and Noweb’s syntax):
```R
myfunction <- function(argument) {
    <<extensive error checking of arguments>>
    # Code that does the analysis goes here
    # ...
}

<<extensive error checking of arguments>>=
    # Make sure that the arguments make sense, and reformat
    # them if necessary. 
    # For example:
    argument <- as.data.frame(argument)
@
```
and then call
```R
myfunction(xargument)
```
where (if you’re not familiar with LP syntax), the code between
`<<extensive error checking of arguments>>=` and `@` will be written
into the appropriate part of myfunction before the code is
executed. In my experience, separating this code visually makes it
easier to understand the logic in myfunction and encourages me to
write more error checking, since it won’t pollute the main
function. (I’ve read this in a Knuth interview too, but I can’t find
the source right now.)

But R is flexible, and we can mimic that structure by abusing
environments. So I’ve written some code to do that. Using that code,
we can write
```R
myfunction <- function(argument) {
    ExtensiveChecking()
    # Code that does the analysis goes here
    # ...
}

ExtensiveChecking <- raincheck({
    # Make sure that the arguments make sense, and reformat
    # them if necessary. 
    # For example:
    argument <- as.data.frame(argument)
})
```
and call
```R
myfunction(xargument)
```
where the line `argument <- as.data.frame(argument)` executes inside
`myfunction`. `raincheck` is obviously a cute name to construct these
sort of functions.

The code for raincheck is surprisingly simple:
```R
raincheck <- function(expr) {
    e <- substitute(expr)
    function(env = parent.frame()) {
        eval(e, env)
        invisible(TRUE)
    }
}
```
`raincheck` returns a function that is intended to be called inside
another function. `expr` is a block of unevaluated R code that will be
executed inside that other function. (The line `env = parent.frame()`
means that the R code will be executed in the calling environment by
default, but that can be overridden by supplying another environment
as an argument.)

I’ve made the raincheck function into a minimal R package that’s
available on GitHub, cleverly titled [Raincheck][6]. The package also has a
scold function that can be used to issue warnings and errors that
appear to come from the top function, e.g. if we had written
```R
ExtensiveChecking <- raincheck({
    # Make sure that the arguments make sense, and reformat
    # them if necessary. 
    # For example:
    argument <- as.data.frame(argument)
    scold("error message")
})
myfunction(xargument)
```
we would get
```
Warning message:
In myfunction(xargument) : error message
```
instead of
```
Warning message:
In eval(expr, envir, enclos) : error message
```
which is what would appear if we had used `warning("error message")`.
This makes the messages more informative to end users —
`eval(expr, envir, enclos)` could be anywhere. The scold function uses
information from Hadley’s (2013) book, *[Advanced R Programming][7]*,
especially the chapter on [exceptions and debugging][8].

Obviously this was more of an educational exercise than anything else,
but I will start using the package and see if it’s useful. Let me know
if you have any suggestions.

[1]: http://en.wikipedia.org/wiki/Literate_programming
[2]: http://www-cs-faculty.stanford.edu/~knuth/
[3]: http://www.cs.tufts.edu/~nr/noweb/
[4]: http://en.wikipedia.org/wiki/Sweave
[5]: http://yihui.name/knitr/
[6]: https://github.com/grayclhn/raincheck
[7]: http://adv-r.had.co.nz/
[8]: http://adv-r.had.co.nz/Exceptions-Debugging.html

Dependencies
------------

R, obviously, available from <cran.r-project.org>. Raincheck has been
tested with R version 3; please file a bug report if you run into
problems with older versions.

License
-------

Raincheck is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.

Raincheck is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with Raincheck; if not, see <http://www.gnu.org/licenses/>.

Contact
-------

Raincheck is developed and maintained by Gray Calhoun
<gray@clhn.co>. Please file bug reports in the project's bug tracker:
<https://github.com/grayclhn/raincheck/issues> and email Gray if you
have any other questions or concerns.

Copyright (C) 2013 Gray Calhoun
