#' Run the Shiny Application
#' @rdname flash_cards
#' @param .data a data.frame containing columns `question` and `answer`
#' @param path the path to a `.xlsx`, `.csv`, `.rds` file containing a 
#' data.frame with columns `question` and `answer`
#' @param type the type of flash_cards to run. Can be either "shiny" or "addin"
#' @param width the width of the rstudio modal dialog box (in pixels)
#' @param hieght the height of the rstudio modal dialog box (in pixels)
#' @param envir the environment to look for flash card decks when using addin
#' Defaults to .GlobalEnv
#' 
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
flash_cards <- function(
  .data = NULL, path = NULL, type = "local"
) {
  type <- match.arg(type, c("shiny", "local"))
  
  if (type == "shiny"){
    flash_shiny(.data = .data, path = path)
  } else if (type == "local"){
    flash_local(.data = .data, path = path)
  }
}

#' @rdname flash_cards
#' @export
flash_shiny <- function(.data = NULL, path = NULL){
  with_golem_options(
    app = shinyApp(
      ui = app_ui, 
      server = app_server
    ), 
    golem_opts = list(.data = .data, path = path)
  )
}

#' @rdname flash_cards
#' @export
flash_local <- function(.data = NULL, path = NULL, width = 1000, height = 800){
  viewer = shiny::dialogViewer("shinyFlash", width = width, height = height)
  
  app <- shinyApp(
    ui = addin_ui, 
    server = addin_server
  )
  
  app$appOptions$golem_options <- list(.data = .data, path = path)
  
  shiny::runGadget(app = app, viewer = viewer)
}

#' @rdname flash_cards
#' @export
flash_addin_envir <- function(envir = .GlobalEnv){
  user_dat <- get_valid_decks(envir = envir)
  
  flash_local(.data = user_dat)
}

#' @rdname flash_cards
#' @export
flash_addin_file <- function(){
  usr_file <- rstudioapi::selectFile()
  
  flash_local(path = use_file)
}

get_valid_decks <- function(envir = .GlobalEnv){
  all_objs <- ls(envir = envir)
  
  valid_objects <- purrr::map(all_objs, ~{
    obj <- base::get(.x, envir = .GlobalEnv)
    
    if (is_valid_flash_cards(obj)){
      return(obj)
    } else return(NULL)
  }) %>% 
    purrr::set_names(all_objs) %>% 
    purrr::discard(is.null)
  
  attempt::stop_if(length(valid_objects) == 0, msg = "No valid flash card decks in global environment! Valid flash card decks must be data.frames with a `question` and `answer` column!")
  
  if (length(valid_objects) == 1){
    cat(crayon::red("There is only one valid flash card deck, using this deck:", 
                    names(valid_objects)[1]), "\n")
    return(valid_objects[[1]])
  }
  
  user_select_txt <- purrr::map2(names(valid_objects), 1:length(valid_objects), ~{
    glue::glue("{.y}: {.x}")
  }) %>% 
    glue::glue_collapse(sep = "\n")
  
  user_select_txt <- glue::glue(
    "There are {length(valid_objects)} valid flash card decks in your global environment!\n",
    "Please select which dataset you would like to use:\n",
    "{user_select_txt}\n",
    
  )
  
  cat(crayon::red(user_select_txt))
  user_selection <- readline(crayon::red("Enter the number of the deck you would like to use: "))
  
  user_selection <- as.numeric(user_selection)
  if (is.null(user_selection)) stop("Selection must be numeric")
  if (!user_selection %in% seq_along(valid_objects)) stop("Selection must be between 1 and ", length(valid_objects))
  user_dat <- valid_objects[[user_selection]]
  
  return(user_dat)
}
