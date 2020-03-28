#' load_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_load_data_ui <- function(id){
  ns <- NS(id)
  tagList(
    
  )
}
    
#' load_data Server Function
#'
#' @noRd 
mod_load_data_server <- function(input, output, session, rv){
  ns <- session$ns
 
  
  dialog <- shiny::modalDialog(
    shiny::h1("Select Dataset!"),
    shiny::selectInput(
      inputId = ns("dataset_choice"),
      label = "Datasets",
      choices = c(
        "Advanced R" = "adv_r",
        "Delaware River Watershed" = "drbc",
        "Custom" = "custom"
      ),
      selected = "adv_r"
    ),
    shiny::uiOutput(ns("custom_data")),
    footer = shiny::tagList(
      shiny::actionButton(
        inputId = ns("load_dataset"),
        label = "Load Flash Cards!",
        class = "btn-primary"
      )
    )
  )
  
  shiny::observe({
    shiny::showModal(dialog)
  })
  
  output$custom_data <- shiny::renderUI({
    shiny::req(input$dataset_choice)
    
    if (input$dataset_choice == "custom"){
      out <- shiny::tagList(
        shiny::fileInput(
          inputId = ns("custom_file"),
          label = "Custom File",
          accept = c("xlsx", "csv", "rds")
        ),
        shiny::helpText("File must be a `.csv`, `.xlsx`, or `.rds` file with columns named `question` and `answer`.\nThese columns can contain HTML for custom formatting!"),
        shiny::textInput(
          inputId = ns("q_col"),
          label = "Question Column",
          value = "question"
        ),
        shiny::textInput(
          inputId = ns("a_col"),
          label = "Answer Column",
          value = "answer"
        ),
        shiny::checkboxInput(
          inputId = ns("clean_data"),
          label = "Clean Data?",
          value = TRUE
        )
      )
    } else out <- NULL
    
    return(out)
  })
  
  
  observeEvent(input$load_dataset, {
    isolate({
      dat_choice <- input$dataset_choice
      if (dat_choice == "custom"){
        dat_file <- input$custom_file
        question <- dplyr::sym(input$q_col)
        answer <- dplyr::sym(input$a_col)
        clean <- input$clean_data
      } 
      
      if (dat_choice == "adv_r"){
        dat <- valid_flash_cards(
          shinyFlash::adv_r_deck,
          question = question,
          answer = answer,
          clean = TRUE
        )
      } else if (dat_choice == "drbc"){
        dat <- valid_flash_cards(
          shinyFlash::drbc_deck,
          question = question,
          answer = answer,
          clean = TRUE
        )
      } else {
        dat <- read_flash_cards(
          dat_file$datapath,
          question = !!question,
          answer = !!answer,
          clean = clean
        )
      }
      
      cat("Loaded the data!\n")
      
      rv$dat <- dat  
      shiny::removeModal()
      rv$dat_added <- TRUE
       
      
    })
    
  })
}
    
## To be copied in the UI
# mod_load_data_ui("load_data_ui_1")
    
## To be copied in the server
# callModule(mod_load_data_server, "load_data_ui_1")
 
