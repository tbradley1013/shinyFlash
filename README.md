
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shinyFlash <img src="shinyFlash.png" align="right" width="175px" height="203px" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of shinyFlash is to provide easy to use, interactive flash
cards to help you study\! This package contains two primary functions:
`flash_cards` and `flash_addin`. These two functions will allow you to
generate flash cards either in a shiny app or in an interactive RStudio
addin.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("tbradley1013/shinyFlash")
```

## Example

There are two main ways to use the `shinyFlash` pacakge. The first
method is through a shiny application and the second is through an
interactive RStudio Addin. Both implementations have the same effect
although the shiny app has the ability to interactively upload different
datasets in the same session.

``` r
library(shinyFlash)
```

### Shiny app

The shiny app can be launched using the `flash_cards` function:

``` r
flash_cards()
```

If the function is called without specifying the `.data` or `path`
arguments, the app will launch and present the user with a dialog box
that can be used to select one of the two default card decks or upload a
custom dataset. If the user chooses to upload a custom dataset, it must
be either an `.xlsx`, `.rds`, or `.csv` file with the columns `question`
and `answer`.

### RStudio Addin
