#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  session$onSessionEnded(stopApp)
  .data <- golem::get_golem_options(".data")
  path <- golem::get_golem_options("path")
  
  rv <- shiny::reactiveValues(
    answer_visible = FALSE,
    question_visible = TRUE,
    card_keep = numeric(0),
    card_know = numeric(0),
    dat = NULL
  )
  
  observe({
    req(is.null(rv$dat))
    if (!is.null(.data)){
      rv$dat <- valid_flash_cards(.data)
    } else if (!is.null(path)){
      rv$dat <- read_flash_cards(path)
    } else {
      isolate(shiny::callModule(mod_load_data_server, "load_data_ui_1", rv = rv))
    }
  })
  
  
  
  shiny::observe({
    rv$dat
    req(rv$dat)
    shinyjs::show("main-content")
  })
 
  
  observeEvent(input$change_dataset, {
    shinyjs::hide("main-content")
    rv$dat <- NULL
    isolate(shiny::callModule(mod_load_data_server, "load_data_ui_1", rv = rv))
    # shinyjs::show("main-content")
  })
  
  
  
  
  shiny::observe({
    req(rv$dat)
    rv$n_cards <- length(unique(rv$dat$question))
    rv$card_idx <- sample(1:rv$n_cards, rv$n_cards)
    rv$n <- 1
  })
  
  callModule(mod_gen_card_server, "gen_card_ui_1", rv = rv)
  
  # card_html <- shiny::reactive({
  #   shiny::req(rv$dat)
  #   rv$dat %>% 
  #     dplyr::select(question, answer) %>% 
  #     dplyr::group_nest(question, .key = "answer") %>% 
  #     dplyr::mutate(
  #       question = purrr::map(question, ~{
  #         shiny::tagList(
  #           shiny::tags$div(
  #             class = "question-card",
  #             id = "question-div",
  #             shiny::tags$div(
  #               class = "question",
  #               shiny::HTML(.x)
  #             )
  #           )
  #         )
  #       }),
  #       answer = purrr::map(answer, ~{
  #         shiny::tagList(
  #           shiny::tags$div(
  #             class = "answers-card",
  #             shiny::tags$div(
  #               class = "answers",
  #               shiny::tags$ul(shiny::HTML(paste0("<li>", .x$answer, "</li>")))
  #             )
  #           )
  #         )
  #       })
  #     )  
  # })
  # 
  # output$card <- shiny::renderUI({
  #   shiny::req(rv$n)
  #   selected_card <- card_html()[rv$card_idx[rv$n],]
  #   if (rv$question_visible){
  #     return(shiny::tagList(selected_card$question[[1]]))
  #   } else if (rv$answer_visible) {
  #     return(shiny::tagList(selected_card$answer[[1]]))
  #   }
  # })
  # 
  # shiny::observeEvent(input$show_answer, {
  #   if (rv$question_visible){
  #     rv$answer_visible <- TRUE
  #     rv$question_visible <- FALSE
  #     
  #     shiny::updateActionButton(session, "show_answer", label = "Show Question")
  #   } else if (rv$answer_visible){
  #     rv$answer_visible <- FALSE
  #     rv$question_visible <- TRUE
  #     
  #     shiny::updateActionButton(session, "show_answer", label = "Show Answer")
  #   }
  #   
  # })
  # 
  # shiny::observeEvent(input$next_question, {
  #   if (rv$answer_visible){
  #     rv$answer_visible <- FALSE
  #     rv$question_visible <- TRUE
  #     shiny::updateActionButton(session, "show_answer", label = "Show Answer")
  #   }
  #   
  #   
  #   if (length(rv$card_idx) > rv$n){
  #     rv$n <- rv$n + 1
  #   } else {
  #     rv$n <- 1
  #   }
  #   
  # })
  # 
  # shiny::observeEvent(input$know_it, {
  #   if (rv$answer_visible){
  #     rv$answer_visible <- FALSE
  #     rv$question_visible <- TRUE
  #   }
  #   
  #   rv$card_know <- c(rv$card_know, rv$card_idx[rv$n])
  #   rv$card_idx <- rv$card_idx[-rv$n]
  #   shiny::updateActionButton(session, "show_answer", label = "Show Answer")
  #   
  #   if (length(rv$card_idx) > rv$n){
  #     rv$n <- rv$n + 1
  #   } else {
  #     if (length(rv$card_idx) > 0){
  #       rv$n <- 1
  #     } else {
  #       shinyalert::shinyalert(title = "Congrats!", text = "You have indicated that you know all of the cards! The deck will now be reset!", type = "success")
  #       rv$card_idx <- sample(rv$card_know, length(rv$card_know))
  #       rv$n <- 1
  #     }
  #   }
  #   
  # })
  
}


addin_server <- function(input, output, session){
  session$onSessionEnded(stopApp)
  .data <- golem::get_golem_options(".data")
  path <- golem::get_golem_options("path")
  
  rv <- shiny::reactiveValues(
    answer_visible = FALSE,
    question_visible = TRUE,
    card_keep = numeric(0),
    card_know = numeric(0),
    dat = NULL
  )
  
  observe({
    req(is.null(rv$dat))
    if (!is.null(.data)){
      rv$dat <- valid_flash_cards(.data)
    } else if (!is.null(path)){
      rv$dat <- read_flash_cards(path)
    }
    # rv$dat <- valid_flash_cards(shinyFlash::adv_r_deck)
  })
  
  shiny::observe({
    req(rv$dat)
    rv$n_cards <- length(unique(rv$dat$question))
    rv$card_idx <- sample(1:rv$n_cards, rv$n_cards)
    rv$n <- 1
  })
  
  callModule(mod_gen_card_server, "gen_card_ui_1", rv = rv)
  
}