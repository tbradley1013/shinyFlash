# Set options here
options(golem.app.prod = FALSE) # TRUE = production mode, FALSE = development mode

# Detach all loaded packages and clean your environment
golem::detach_all_attached()
# rm(list=ls(all.names = TRUE))

# Document and reload your package
golem::document_and_reload()

# Run the application
# flash_cards(.data = shinyFlash::adv_r_deck)
flash_cards(type = "shiny")

flash_local(.data = shinyFlash::adv_r_deck)

flash_addin_envir_custom()


data("adv_r_deck")
flash_addin_envir()
