
library(shiny)



ui = fluidPage(
  tabsetPanel(
  tabPanel("MENU"),
  tabPanel("WORD CLOUD",
           titlePanel("Most popular words in tweets"),
           dateRangeInput(inputId = 'dateRange',
                          label = "Time period",
                          start = "2022-01-01",
                          end = "2022-04-30")
           ),
  tabPanel("USER POPULARITY"),
  tabPanel("WORD POPULARITY",
          titlePanel("Popularity of key words in tweets in time"),
          selectInput("one_var",
                      label = "Select Word",
                      choices = words),
          plotOutput("one_var_plot")),
  tabPanel("PASS")
  )
)
