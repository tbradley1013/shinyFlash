



valid_flash_cards <- function(.data){
   attempt::stop_if(
     all(c("question", "answer") %in% colnames(.data)), 
     .p = isFALSE,
    msg = "`.data` must contain the columns `question` and `answer`" 
   )
  
  return(.data)
}