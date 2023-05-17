README
================
Alexander Ilich
May 17, 2023

# POSMVReadR

This R package converts binary Applanix POSMV files to plain text. It
provides a convinient R interface to a [python script written by Paul
Kennedy](https://github.com/pktrigg/posmv). As such, it requires [Python
3](https://www.python.org/downloads/) to be installed.

# Package Installation

This package can be installed directly from github using the `remotes`
package using `remotes::install_github("ailich/POSMVReadR")`. To install
the remotes package, use `install.packages("remotes")`.

# Useage

Once the package is installed it can be loaded using
`library(POSMVReadR)`

This package contains a function called `POSMVRead` which has arguments:
`input`: which is a character vector of file names or a directory
containing Applanix POSMV binary files `output`: The name of the file
for the output `append`: A logical whether the output should be appended
to an existing output `tmpdir`: character vector giving the directory
name for temporary files to be stored

For example:

``` r
POSMVRead(input="Data_Directory", output="output/POSMV.csv")
```
