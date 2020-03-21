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
mod_load_data_server <- function(input, output, session){
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
          inputId = "custom_file",
          label = "Custom File",
          accept = c("xlsx", "csv", "rds")
        ),
        shiny::helpText("File must be a `.csv`, `.xlsx`, or `.rds` file with columns named `question` and `answer`.\nThese columns can contain HTML for custom formatting!")
      )
    } else out <- NULL
    
    return(out)
  })
  
  w <- waiter::Waiter$new()
  
  dat <- shiny::eventReactive(input$load_dataset, {
    dat_choice <- input$dataset_choice
    if (dat_choice == "custom"){
      dat_file <- input$custom_file
      dat_ext <- tools::file_ext(dat_file$datapath)
    } 
    shiny::removeModal()
    w$show
    
    if (dat_choice == "adv_r"){
      dat <- readr::read_rds("data/adv-r-deck.rds")
    } else if (dat_choice == "drbc"){
      dat <- readxl::read_excel("data/drbc-deck-1.xlsx") %>%
        janitor::clean_names() %>%
        dplyr::mutate(answer = as.character(answer))
    } else {
      if (dat_ext == "xlsx"){
        dat <- readxl::read_excel(dat_file$datapath) %>% 
          janitor::clean_names()
      } else if (dat_ext == "csv"){
        dat <- readr::read_csv(dat_file$datapath) %>% 
          janitor::clean_names()
      } else if (dat_ext == "rds"){
        dat <- readr::read_rds(dat_file$datapath) %>% 
          janitor::clean_names()
      } else {
        showModal(dialog)
        return(NULL)
      }
      
      if (!all(c("question", "answer") %in% colnames(dat))){
        showModal(dialog)
        return(NULL)
      }
    }
    
    shinyjs::show("main-content")
    w$hide
    
    return(dat)
  })
}
    
## To be copied in the UI
# mod_load_data_ui("load_data_ui_1")
    
## To be copied in the server
# callModule(mod_load_data_server, "load_data_ui_1")
 
