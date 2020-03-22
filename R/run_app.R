#' Run the Shiny Application
#'
#' @param ... A series of options to be used inside the app.
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
flash_cards <- function(
  .data = NULL, path = NULL
) {
  with_golem_options(
    app = shinyApp(
      ui = app_ui, 
      server = app_server
    ), 
    golem_opts = list(.data = .data, path = path)
  )
}


flash_addin <- function(.data = NULL, path = NULL, width = 1000, height = 800){
  viewer = shiny::dialogViewer("shinyFlash", width = width, height = height)
  
  app <- shinyApp(
    ui = addin_ui, 
    server = addin_server
  )
  
  app$appOptions$golem_options <- list(.data = .data, path = path)
  
  shiny::runGadget(app = app, viewer = viewer)
}
