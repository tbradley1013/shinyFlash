#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  shiny::tagList(
    golem_add_external_resources(),
    shiny::fluidPage(
      shinyjs::hidden(
        shiny::div(
          id = "main-content",
          shiny::div(
            id = "links-div",
            shiny::actionButton(
              inputId = "change_dataset",
              label = "",
              icon = shiny::icon("database"),
              class = "btn-primary btn-sm"
            ),
            shiny::tags$a(
              shiny::icon("github"),
              href = "https://github.com/tbradley1013/shiny-flash-cards"
            )
          ),
          shiny::div(
            shiny::h2("Shiny Flash Cards"),
            shiny::h4("An application designed to make memorization easier!"),
            style = "text-align:center;"
          ),
          shiny::br(),
          mod_gen_card_ui("gen_card_ui_1")
          # shiny::uiOutput("card"),
          # shiny::br(),
          # shiny::fluidRow(
          #   shiny::actionButton(
          #     inputId = "know_it",
          #     label = "I know it!",
          #     class = "btn-success btn-lg",
          #     width = "33%" 
          #   ),
          #   shiny::actionButton(
          #     inputId = "show_answer",
          #     label = "Show Answer",
          #     class = "btn-primary btn-lg",
          #     width = "33%"
          #   ),
          #   shiny::actionButton(
          #     inputId = "next_question",
          #     label = "Next Question",
          #     class = "btn-danger btn-lg",
          #     width = "33%"
          #   ),
          #   inline = TRUE,
          #   style = "width:50%;margin: 0 auto;"
          # ),
          # shiny::div(
          #   shiny::tags$p(shiny::tags$kbd("a"), ": Toggle Question/Answer"),
          #   shiny::tags$p(shiny::tags$kbd("d"), ": Next Question"),
          #   shiny::tags$p(shiny::tags$kbd("w"), ": I Know it!")
          # )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'shinyFlash'
    ),
    shinyjs::useShinyjs(),
    shinyalert::useShinyalert(),
    shiny::tags$link(href='http://fonts.googleapis.com/css?family=Merienda+One', rel='stylesheet', type='text/css'),
    shiny::tags$link(href='http://fonts.googleapis.com/css?family=Lobster+Two', rel='stylesheet', type='text/css'),
    shiny::tags$link(href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap", rel="stylesheet"),
    tags$link(rel="stylesheet", type="text/css", href="www/styles.css"),
    tags$script(src = "www/button-click.js")
  )
}


addin_ui <- function(){
  miniUI::miniPage(
    
  )
}