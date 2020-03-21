#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  session$onSessionEnded(stopApp)
  # List the first level callModules here
  .data <- golem::get_golem_options(".data")
  path <- golem::get_golem_options("path")
  
  if (!is.null(data)){
    dat <- valid_flash_cards(.data)
  } else if (!is.null(path)){
    dat <- read_flash_cards(path)
  } else {
    
  }
  
 
  
  observeEvent(input$change_dataset, {
    shinyjs::hide("main-content")
    showModal(dialog)
  })
  
  
  rv <- reactiveValues(
    answer_visible = FALSE,
    question_visible = TRUE,
    card_keep = numeric(0),
    card_know = numeric(0)
  )
  
  observe({
    rv$n_cards <- length(unique(dat()$question))
    rv$card_idx <- sample(1:rv$n_cards, rv$n_cards)
    rv$n <- 1
  })
  
  card_html <- reactive({
    dat() %>% 
      select(question, answer) %>% 
      group_nest(question, .key = "answer") %>% 
      mutate(
        question = purrr::map(question, ~{
          tagList(
            tags$div(
              class = "question-card",
              id = "question-div",
              tags$div(
                class = "question",
                HTML(.x)
              )
            )
          )
        }),
        answer = purrr::map(answer, ~{
          tagList(
            tags$div(
              class = "answers-card",
              tags$div(
                class = "answers",
                tags$ul(HTML(paste0("<li>", .x$answer, "</li>")))
              )
            )
          )
        })
      )  
  })
  
  output$card <- renderUI({
    req(rv$n)
    selected_card <- card_html()[rv$card_idx[rv$n],]
    if (rv$question_visible){
      return(tagList(selected_card$question[[1]]))
    } else if (rv$answer_visible) {
      return(tagList(selected_card$answer[[1]]))
    }
  })
  
  observeEvent(input$show_answer, {
    if (rv$question_visible){
      rv$answer_visible <- TRUE
      rv$question_visible <- FALSE
      
      updateActionButton(session, "show_answer", label = "Show Question")
    } else if (rv$answer_visible){
      rv$answer_visible <- FALSE
      rv$question_visible <- TRUE
      
      updateActionButton(session, "show_answer", label = "Show Answer")
    }
    
  })
  
  observeEvent(input$next_question, {
    if (rv$answer_visible){
      rv$answer_visible <- FALSE
      rv$question_visible <- TRUE
      updateActionButton(session, "show_answer", label = "Show Answer")
    }
    
    
    if (length(rv$card_idx) > rv$n){
      rv$n <- rv$n + 1
    } else {
      rv$n <- 1
    }
    
  })
  
  observeEvent(input$know_it, {
    if (rv$answer_visible){
      rv$answer_visible <- FALSE
      rv$question_visible <- TRUE
    }
    
    rv$card_know <- c(rv$card_know, rv$card_idx[rv$n])
    rv$card_idx <- rv$card_idx[-rv$n]
    updateActionButton(session, "show_answer", label = "Show Answer")
    
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
