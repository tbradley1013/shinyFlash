
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shinyFlash <img src="shinyFlash.png" align="right" width="175px" height="203px" />

<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
<!-- badges: end -->

The goal of shinyFlash is to provide easy to use, interactive flash
cards to help you study\! This package contains one primary function:
`flash_cards`. This function will allow you to generate flash cards
either in a shiny app or in an interactive RStudio addin.

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

### RStudio Modal

The default mode for the flash cards (i.e. `type = "local"`) will result
in the flash cards appearing as a modal in your RStudio window. If `type
= "local"` then the user must specify a data frame using the `.data`
argument or the path to a valid file with the `path` argument. Whichever
is specified, the user must specify the names of the columns that make
up the questions and answers. By default, it will look for columns named
`question` and `answer`, but the user can change the column it looks for
using the arguments `question` and `answer`.

``` r
flash_cards(shinyFlash::adv_r_deck)
```

![](man/readme/flash-cards-default.gif)

### Shiny app

The shiny app can be launched using the `flash_cards` function:

``` r
flash_cards(type = "shiny")
```

If the function is called without specifying the `.data` or `path`
arguments, the app will launch and present the user with a dialog box
that can be used to select one of the two default card decks or upload a
custom dataset. If the user chooses to upload a custom dataset, it must
be either an `.xlsx`, `.rds`, or `.csv` file and the user must specify
the column names that contain the question and answer, respectively.

Users can also specify a dataset to the `flash_cards` dataset using
either the `.data` or `path` arguments. Just like when specifying a
dataset using the shiny application, the specified dataset must have the
columns `question` and `answer`. If specifying a path, it must be either
a `.xlsx`, `.csv`, or `.rds` file.

![](man/readme/flash-cards-shiny.gif)

### Flash Deck Data

Valid flash card decks must have a question and answer column. By
default, the functions in this package will look for the columns named
`question` and `answer`. However, the user can specify different column
names using the `question` and `answer` function arguments. The only
requirement for these columns is that they must be characters.

Questions can be repeated multiple times in a dataset with different
answers. If this occurs, the function will group together those
questions and list them as bullets on the back side of a single flash
card.

The qustion and answer columns can also contain HTML tags which will
then be interpretted as HTML within the program.

### RStudio Addin

This package also comes with three RStudio Addins. Both of these
functions call versions of the local flash cards, but differ in the way
the user specifies the dataset to be used.

The first addin, `shinyFlash`, will look through the Global Environment
for all objects that are valid flash card decks (i.e. data.frames with
columns named `question` and `answer`. If there is only one valid flash
card deck then the addin will launch using this dataset. If there are
multiple valid flash card decks, then the user will be asked to specify
which dataset they would like to use in the console.

The second addin, `shinyFlash (custom column names)`, will look through
the Global Environment for valid flash card decks similar to the first
addin. However this addin, as suggested by the name, will allow for
users to specify the question and answer column names as something other
than the `question` and `answer`.

The third addin, `shinyFlash (file)`, will result in a file system
dialog to appear and allow the user to select the file that they wish to
uplaod to the function, as if through the `path` argument.

![](man/readme/flash-cards-addin.gif)

## Contributing

If you have any suggestions or comments, I would love to hear them\!
Please consider [creating an
issue](https://github.com/tbradley1013/shinyFlash/issues) or creating a
pull request if you would like to contribute\!

If you would like to submit a new dataset to be added to the default
options available in the application, please open an
[issue](https://github.com/tbradley1013/shinyFlash/issues) with the
title: `NEW DATASET: <your dataset name>`

### Code of Conduct

Please note that the connectapi project is released with a [Contributor
Code of
Conduct](https://github.com/tbradley1013/shinyFlash/blob/master/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.
