#' Run the Shiny Application
#' @rdname flash_cards
#' @param .data a data.frame containing columns `question` and `answer`
#' @param path the path to a `.xlsx`, `.csv`, `.rds` file containing a 
#' data.frame with columns `question` and `answer`
#' @param type the type of flash_cards to run. Can be either "shiny" or "addin"
#' @param width the width of the rstudio modal dialog box (in pixels)
#' @param hieght the height of the rstudio modal dialog box (in pixels)
#' 
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
flash_cards <- function(
  .data = NULL, path = NULL, type = "shiny"
) {
  type <- match.arg(type, c("shiny", "addin"))
  
  if (type == "shiny"){
    flash_shiny(.data = .data, path = path)
  } else if (type == "addin"){
    flash_addin(.data = .data, path = path)
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
flash_addin <- function(.data = NULL, path = NULL, width = 1000, height = 800){
  viewer = shiny::dialogViewer("shinyFlash", width = width, height = height)
  
  app <- shinyApp(
    ui = addin_ui, 
    server = addin_server
  )
  
  app$appOptions$golem_options <- list(.data = .data, path = path)
  
  shiny::runGadget(app = app, viewer = viewer)
}
