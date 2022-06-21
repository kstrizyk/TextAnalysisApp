ui = navbarPage(
  "TweetsAnalysis",
  selected = "HOME",
  collapsible = TRUE,
  inverse = TRUE,
  tabPanel("HOME",
    fluidPage(
      tabsetPanel(
        tabPanel("PROJECT",
                  HTML("<h1><center>WELCOME TO <b>TweetsAnalysis</b> WEBPAGE</center></h1>"),
                  column(width = 12,
                         br(), br(), 
                           wellPanel(
                             HTML("<h1><b>TweetsAnalysis</b></h1>"),
                             HTML("<h4><b>TweetsAnalysis</b> is a project which explores
                                   Tweets from Twitter in context of recent events in Ukraine.
                                   At <b>24.02.2022</b> Russian Federation began an attack on Ukraine,
                                   this war is currently steel in progress (at 19.06.2022). We wanted
                                   to chceck if since this date there were any changes in popularity of
                                   certain key-words releted to war and Ukraine as a country. We analised
                                   Tweets posted by most known politicians, newspapers, and celebrities.
                                   </h4>")
                             )
                         )
        ),
          tabPanel("FUNCTIONALITIES",
                   HTML("<h1><center> WHAT <b>TweetsAnalysis</b> CAN DO FOR YOU?</center></h1>"),
                   column(width =12, 
                          br(), br(), 
                          wellPanel(
                            HTML("<h1><b>WORDCLOUD</b></h1>"),
                            HTML("<h4> Word cloud shows most popular words 
                                  in tweets by author in a selected period of time.
                                   </h4>"),
                            HTML("<h1><b>WAR-THEMED TWEETS</b></h1>"),
                            HTML("<h4>War-themed tweets functionality bar plots 
                                  show popularity of tweets
                                  with certain key words connected to war.
                                   </h4>"),
                            HTML("<h1><b>WORD POPULARITY</b></h1>"),
                            HTML("<h4> Word popularity plots show number of tweets 
                                  containing selected word over time. This functionality 
                                  enables users to easly see how ceratin war events made
                                  an impact in social media.
                                   </h4>")
                            )
                          )
                        ),
          tabPanel("AUTHORS",
                   HTML("<h1><center>ABOUT US:</center></h1>"),
                   br(),br(),
                   wellPanel(
                   HTML("<h4> We are students at University of Wroclaw, Poland.
                              This project is a part of <b>Programming and Data
                              Analysis in R</b> course at the Institute of Mathematics,
                              coordinated by mgr. Mateusz Staniak. Our team consists of:
                              Anhelina Ustanovich, Karol Striżyk, Aleksandra Strąk, Daniel 
                              Healy.
                                   </h4>")
                    )
                   )
      )
    )
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
                        titlePanel("Popularity of tweets with selected words"),
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

