
#' Read Flash card files
#' 
#' @param path the path to a file. Must have columns `question` and `answer`. 
#' @param question the column name for the questions in the dataset
#' @param answer the column name for the answers in the dataset
#' @param clean logical; whether or not to clean the column names
#' 
#' @details function currently accepts .xlsx, .csv, and .rds
read_flash_cards <- function(path, question = question, answer = answer, clean = TRUE){
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
  
  question <- dplyr::enquo(question)
  answer <- dplyr::enquo(answer)
  
  dat_ext <- tools::file_ext(path)
  if (dat_ext == "xlsx"){
    out <- readxl::read_excel(path)
  } else if (dat_ext == "csv"){
    out <- readr::read_csv(path)
  } else if (dat_ext == "rds"){
    out <- readr::read_rds(path)
  }

  out <- valid_flash_cards(out, question = !!question, 
                           answer = !!answer, clean = clean)
  return(out)
}

#' validate that flash cards have the required columns
#' 
#' @param .data a date frame with columns `question` and `answer`
#' @param question the column name for the questions in the dataset
#' @param answer the column name for the answers in the dataset
#' @param clean logical; whether or not to clean the column names
#' 
#' @details
#' Note: If clean = TRUE (the default) then the columns specified by the 
#' question and answer arguments must be in their cleaned form (lowercase 
#' snakecase)
#' 
#' @details 
#' the column names are case insensitive
valid_flash_cards <- function(.data, question = question, 
                              answer = answer, clean = TRUE){
  
  if (clean) .data <- janitor::clean_names(.data)
  
  question <- dplyr::enquo(question)
  answer <- dplyr::enquo(answer)
  question_name <- dplyr::quo_name(question)
  answer_name <- dplyr::quo_name(answer)
  
  
  attempt::stop_if(
    is_valid_flash_cards(.data, question = !!question, answer = !!answer, clean = clean), 
    .p = isFALSE,
    msg = glue::glue("`.data` must contain the columns `{question_name}` and `{answer_name}`") 
  )
  
  out <- .data %>% 
    dplyr::select(!!question, !!answer) %>% 
    dplyr::mutate_all(as.character)
  
  return(out)
}

is_valid_flash_cards <- function(.data, question = question, 
                                 answer = answer, clean = TRUE){
  if (!inherits(.data, "data.frame")) return(FALSE)
  if (clean) .data <- janitor::clean_names(.data)
  
  question <- dplyr::enquo(question)
  answer <- dplyr::enquo(answer)
  
  question_name <- dplyr::quo_name(question)
  answer_name <- dplyr::quo_name(answer)
  
  if (all(c(question_name, answer_name) %in% colnames(.data))) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
