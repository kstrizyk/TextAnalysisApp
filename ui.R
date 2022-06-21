ui = navbarPage(
  "TweetsAnalysis",
  selected = "HOME",
  collapsible = TRUE,
  inverse = TRUE,
  tabPanel(
    "HOME",
    HTML(
      "<h1><center>WELCOME TO <b>TweetsAnalysis</b> WEBPAGE</center></h1>"
    ),
    column(width = 12,
           br(), br(), br(), br(),
           wellPanel(
             HTML("<h1><b>TweetsAnalysis</b></h1>"),
             HTML(
               "<h4><b>TweetsAnalysis</b> is a project which explores
                             Tweets from Twitter in context of recent events in Ukraine.
                             At <b>24.02.2022</b> Russian Federation began an attack on Ukraine,
                             this war is currently steel in progress (at 19.06.2022). We wanted
                             to chceck if since this date there were any changes in popularity of
                             certain key-words releted to war and Ukraine as a country. We analised
                             Tweets posted by most known politicians, newspapers, and celebrities.
                             In our date base are ... Tweets from ... users.
                            </h4>"
             )
           ))
  ),
  tabPanel("MENU",
           fluidPage(
             tabsetPanel(
               tabPanel(
                 "WORD CLOUD",
                 titlePanel("Most popular words in tweets"),
                 sidebarLayout(
                   sidebarPanel(
                     dateRangeInput(
                       inputId = 'wordcloudDateRange',
                       label = "Time period",
                       min = "2022-01-01",
                       max = "2022-04-30",
                       start = "2022-01-01",
                       end = "2022-04-30"
                     ),
                     numericInput(
                       "wordcloudMaxwords",
                       label = "Choose number of words to display:",
                       value = 15,
                       min = 5,
                       max = 50
                     ),
                     checkboxGroupInput(
                       "wordcloudUsersChoice",
                       label = "Choose user(s)",
                       selected = users[, userId][1],
                       choiceNames = users[, name],
                       choiceValues = users[, userId]
                     )
                   ),
                   mainPanel(wordcloud2Output("wordcloud"))
                 )
               ),
               tabPanel("WAR-THEMED TWEETS",
                        sidebarLayout(
                          sidebarPanel(
                            checkboxGroupInput(
                              "tweetPopWordChoice",
                              label = "Choose words:",
                              choices = c(words, "all"),
                              selected = words[1]
                            )
                          ),
                          mainPanel(plotOutput("tweetPopularity"))
                        )),
               tabPanel(
                 "WORD POPULARITY",
                 titlePanel("Popularity of key words in tweets daily"),
                 sidebarLayout(sidebarPanel(
                   selectInput("wpWordChoice",
                               label = "Select Word",
                               choices = words)
                 ),
                 mainPanel(plotOutput("wordPopularity")))
               )
             )
           ))
)
