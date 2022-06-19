


ui = navbarPage("TweetsAnalisys", selected = "HOME", collapsible = TRUE, inverse = TRUE, 
  tabPanel("HOME", 
           HTML("<h1><center>WELCOME TO <b>TweetsAnalisys</b> WEBPAGE</center></h1>"),
           column(width = 12,
                           br(), br(), br(), br(),
                           wellPanel(
                             HTML("<h1><b>TweetsAnalysis</b></h1>"),
                             HTML("<h4><b>TweetsAnalysis</b> is a project which explores 
                             Tweets from Twitter in context of recent events in Ukraine.
                             At <b>24.02.2022</b> Russian Federation began an attack on Ukraine, 
                             this war is currently steel in progress (at 19.06.2022). We wanted 
                             to chceck if since this date there were any changes in popularity of
                             certain key-words releted to war and Ukraine as a country. We analised
                             Tweets posted by most known politicians, newspapers, and celebrities.
                             In our date base are ... Tweets from ... users.
                            </h4>")
                           ))),
  tabPanel("MENU",
    fluidPage(
      tabsetPanel(
        tabPanel("WORD CLOUD",
             titlePanel("Most popular words in tweets"),
             dateRangeInput(inputId = 'dateRange',
                            label = "Time period",
                            min = "2022-01-01",
                            max = "2022-04-30",
                            start = "2022-01-01",
                            end = "2022-04-30"),
             selectInput("variables",
                      label = "Choose user(s)",
                      choices = users),
             mainPanel(textOutput("selected_var"))
             ),
    tabPanel("WAR-THEMED TWEETS"),
    tabPanel("WORD POPULARITY",
            titlePanel("Popularity of key words in tweets in time"),
            selectInput("one_var",
                        label = "Select Word",
                        choices = words),
            plotOutput("one_var_plot"))
  ))
))
