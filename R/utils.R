

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

valid_flash_cards <- function(.data){
   attempt::stop_if(
     all(c("question", "answer") %in% colnames(.data)), 
     .p = isFALSE,
     msg = "`.data` must contain the columns `question` and `answer`" 
   )
  
  return(.data)
}