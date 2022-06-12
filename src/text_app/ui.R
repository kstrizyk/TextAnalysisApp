library(shiny)


ui = fluidPage(
  titlePanel("Text Analisys App"),
  
  sidebarLayout(position = "right",
                sidebarPanel("COMMENTS"),
                mainPanel("MENU"))
)