# remotes::install_github("tbradley1013/shinyFlash")
library(shinyFlash)
library(shiny)

shinyApp(
  ui = shinyFlash:::app_ui(),
  server = shinyFlash:::app_server
)