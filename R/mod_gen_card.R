#' gen_card UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_gen_card_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::uiOutput(ns("card")),
    shiny::br(),
    shiny::fluidRow(
      shiny::actionButton(
        inputId = ns("know_it"),
        label = "I know it!",
        class = "btn-success btn-lg btn-know",
        width = "33%" 
      ),
      shiny::actionButton(
        inputId = ns("show_answer"),
        label = "Show Answer",
        class = "btn-primary btn-lg btn-show",
        width = "33%"
      ),
      shiny::actionButton(
        inputId = ns("next_question"),
        label = "Next Question",
        class = "btn-danger btn-lg btn-next",
        width = "33%"
      ),
      inline = TRUE,
      style = "width:50%;margin: 0 auto;"
    ),
    shiny::div(
      shiny::tags$p(shiny::tags$kbd("a"), ": Toggle Question/Answer"),
      shiny::tags$p(shiny::tags$kbd("d"), ": Next Question"),
      shiny::tags$p(shiny::tags$kbd("w"), ": I Know it!")
    )
  )
}
    
#' gen_card Server Function
#'
#' @noRd 
mod_gen_card_server <- function(input, output, session, rv){
  ns <- session$ns
 
  card_html <- shiny::reactive({
    shiny::req(rv$dat)
    rv$dat %>% 
      dplyr::select(question, answer) %>% 
      dplyr::group_nest(question, .key = "answer") %>% 
      dplyr::mutate(
        question = purrr::map(question, ~{
          shiny::tagList(
            shiny::tags$div(
              class = "question-card",
              id = ns("question-div"),
              shiny::tags$div(
                class = "question",
                shiny::HTML(.x)
              )
            )
          )
        }),
        answer = purrr::map(answer, ~{
          shiny::tagList(
            shiny::tags$div(
              class = "answers-card",
              shiny::tags$div(
                class = "answers",
                shiny::tags$ul(shiny::HTML(paste0("<li>", .x$answer, "</li>")))
              )
            )
          )
        })
      )  
  })
  
  output$card <- shiny::renderUI({
    shiny::req(rv$n)
    selected_card <- card_html()[rv$card_idx[rv$n],]
    if (rv$question_visible){
      return(shiny::tagList(selected_card$question[[1]]))
    } else if (rv$answer_visible) {
      return(shiny::tagList(selected_card$answer[[1]]))
    }
  })
  
  shiny::observeEvent(input$show_answer, {
    if (rv$question_visible){
      rv$answer_visible <- TRUE
      rv$question_visible <- FALSE
      
      shiny::updateActionButton(session, "show_answer", label = "Show Question")
    } else if (rv$answer_visible){
      rv$answer_visible <- FALSE
      rv$question_visible <- TRUE
      
      shiny::updateActionButton(session, "show_answer", label = "Show Answer")
    }
    
  })
  
  shiny::observeEvent(input$next_question, {
    if (rv$answer_visible){
      rv$answer_visible <- FALSE
      rv$question_visible <- TRUE
      shiny::updateActionButton(session, "show_answer", label = "Show Answer")
    }
    
    
    if (length(rv$card_idx) > rv$n){
      rv$n <- rv$n + 1
    } else {
      rv$n <- 1
    }
    
  })
  
  shiny::observeEvent(input$know_it, {
    if (rv$answer_visible){
      rv$answer_visible <- FALSE
      rv$question_visible <- TRUE
    }
    
    rv$card_know <- c(rv$card_know, rv$card_idx[rv$n])
    rv$card_idx <- rv$card_idx[-rv$n]
    shiny::updateActionButton(session, "show_answer", label = "Show Answer")
    
    if (length(rv$card_idx) > rv$n){
      rv$n <- rv$n + 1
    } else {
      if (length(rv$card_idx) > 0){
        rv$n <- 1
      } else {
        shinyalert::shinyalert(title = "Congrats!", text = "You have indicated that you know all of the cards! The deck will now be reset!", type = "success")
        rv$card_idx <- sample(rv$card_know, length(rv$card_know))
        rv$n <- 1
      }
    }
    
  })
}
    
## To be copied in the UI
# mod_gen_card_ui("gen_card_ui_1")
    
## To be copied in the server
# callModule(mod_gen_card_server, "gen_card_ui_1")
 
