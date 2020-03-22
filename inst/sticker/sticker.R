#===============================================================================
# Creating the hex sticker
# 
# Tyler Bradley
# 2020-03-21 
#===============================================================================


library(magick)
library(hexSticker)

plain_index <- magick::image_read("inst/sticker/plain-index.png") %>% 
  magick::image_scale(200) 

lightning <- magick::image_read("inst/sticker/lightning.png") %>% 
  magick::image_scale(200)

flash_index <- magick::image_read("inst/sticker/flash-index.png")


sticker(
  flash_index,
  s_x = 1, 
  s_y = 1.08, 
  s_width = 1.4, 
  s_height = 1.4,
  package = "shinyFlash",
  p_color = "black",
  p_x = 1, 
  p_y = 1.08, 
  h_fill = "#AB0020",
  h_color = "black"
)


magick::image_read("shinyFlash.png")
