
library(shiny)



ui = fluidPage(
  tabsetPanel(
  tabPanel("MENU"),
  tabPanel("WORD MAP"),
  tabPanel("USER POPULARITY"),
  tabPanel("WORD POPULARITY",
          titlePanel("Popularity of key words in tweets"),
          selectInput("one_var",
                      label = "Select Word",
                      choices = words),
          plotOutput("one_var_plot")),
  tabPanel("PASS")
  )
)
