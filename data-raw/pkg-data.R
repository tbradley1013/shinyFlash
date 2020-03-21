#===============================================================================
# Creating the package datasets
# 
# Tyler Bradley
# 2020-03-21 
#===============================================================================

# Advanced R deck
library(rvest)
library(tidyverse)

base_url <- "https://adv-r.hadley.nz/"

base_html <- read_html(base_url) 

chapters <- base_html %>% 
  html_nodes(".summary li") %>%
  html_attr("data-path") %>% 
  unique()

chapters <- purrr::discard(chapters, is.na)

adv_r_deck <- purrr::map_dfr(chapters, ~{
  # browser()
  chapter_url <- paste0(base_url, .x)
  
  chapter_html <- read_html(chapter_url)
  
  questions <- chapter_html %>% 
    html_nodes(".page-wrapper [id*=quiz] li") %>% 
    # html_nodes("li") %>% 
    as.character() %>% 
    stringr::str_replace_all("^<li>|</li>$", "") %>% 
    stringr::str_replace_all("href=\"", "href=\"https://adv-r.hadley.nz/")
  
  answers <- chapter_html %>% 
    html_nodes(".page-wrapper [id*=answer] li") %>% 
    # html_nodes("li") %>% 
    as.character() %>% 
    stringr::str_replace_all("^<li>|</li>$", "") %>% 
    stringr::str_replace_all("href=\"", "href=\"https://adv-r.hadley.nz/")
  
  if (length(questions) != length(answers)){
    return(NULL)
  }

  if (length(questions) == 0){
    return(NULL)
  }
  
  out <- tibble(
    question = questions,
    answer = answers,
    category = str_replace(.x, "\\.html", "")
  )
  
  return(out)
})

usethis::use_data(adv_r_deck)
# write_rds(adv_r_deck, "data/adv-r-deck.rds", compress = "xz", compression = 9L)


# DRBC Deck
drbc_deck <- readxl::read_excel("data-raw/drbc-deck-1.xlsx")

usethis::use_data(drbc_deck)
