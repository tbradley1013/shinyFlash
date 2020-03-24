
#' Read Flash card files
#' 
#' @param path the path to a file. Must have columns `question` and `answer`. 
#' 
#' @details function currently accepts .xlsx, .csv, and .rds
read_flash_cards <- function(path){
  attempt::stop_if(
    file.exists(path),
    .p = isFALSE,
    msg = "file specified does not exist!"
  )
  
  attempt::stop_if(
    tools::file_ext(path) %in% c("xlsx", "rds", "csv"),
    .p = isFALSE,
    msg = "file specified must be a `.xlsx`, `.csv`, or `.rds`"
  )
  
  dat_ext <- tools::file_ext(path)
  
  if (dat_ext == "xlsx"){
    out <- readxl::read_excel(path)
  } else if (dat_ext == "csv"){
    out <- readr::read_csv(path)
  } else if (dat_ext == "rds"){
    out <- readr::read_rds(path)
  }
  
  out <- valid_flash_cards(out)
  return(out)
}

#' validate that flash cards have the required columns
#' 
#' @param .data a date frame with columns `question` and `answer`
#' 
#' @details 
#' the column names are case insensitive
valid_flash_cards <- function(.data){
  .data <- janitor::clean_names(.data)
   attempt::stop_if(
     is_valid_flash_cards(.data), 
     .p = isFALSE,
     msg = "`.data` must contain the columns `question` and `answer`" 
   )
  
  out <- .data %>% 
    dplyr::select(question, answer) %>% 
    dplyr::mutate_all(as.character)
  
  return(out)
}

is_valid_flash_cards <- function(.data){
  if (!inherits(.data, "data.frame")) return(FALSE)
  .data <- janitor::clean_names(.data)
  if (all(c("question", "answer") %in% colnames(.data))) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
