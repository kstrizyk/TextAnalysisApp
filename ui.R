ui = navbarPage(
  "TweetsAnalysis",
  selected = "Home",
  collapsible = TRUE,
  inverse = TRUE,
  tabPanel("Home",
           fluidPage(
             tabsetPanel(
               tabPanel("Project",
                        HTML("<h1><center>Welcome to <b>TweetsAnalysisApp</b></center></h1>"),
                        column(width = 12,
                               br(), br(), 
                               wellPanel(
                                 HTML("<h1><b>TweetsAnalysis</b></h1>"),
                                 HTML("<h4><b>TweetsAnalysis</b> is a project which explores
                                   Tweets from Twitter in context of recent events in Ukraine.
                                   At <b>24.02.2022</b>, Russian Federation began an attack on Ukraine,
                                   this war is currently still in progress (at 19.06.2022). We wanted
                                   to chceck if since this date there were any changes in popularity of
                                   certain key-words related to war and Ukraine as a country. We analysed
                                   Tweets posted by known politicians and newspapers.
                                   </h4>")
                               )
                        )
               ),
               tabPanel("Functionalities",
                        HTML("<h2><center> What <b>TweetsAnalysis</b> can do for you?</center></h2>"),
                        column(width =12, 
                               br(), br(), 
                               wellPanel(
                                 HTML("<h2><b>Wordcloud</b></h2>"),
                                 HTML("<h4> Wordcloud shows most popular words 
                                  in Tweets by selected authors in a selected period of time.
                                   </h4>"),
                                 HTML("<h2><b>Reaction barplot</b></h2>"),
                                 HTML("<h4>This barplot shows the average reactions to Tweets
                                      containing selected words. Reaction is the sum of retweets, 
                                      quotes, likes and replies.
                                   </h4>"),
                                 HTML("<h2><b>Occurence timeseries</b></h2>"),
                                 HTML("<h4> The plot shows number of Tweets 
                                  containing selected word over time. This functionality 
                                  enables users to easily see how ceratin war events made
                                  an impact in social media.
                                   </h4>")
                               )
                        )
               ),
               tabPanel("Authors",
                        HTML("<h2><center>About us:</center></h2>"),
                        br(),br(),
                        wellPanel(
                          HTML("<h4> We are students at University of Wroclaw, Poland.
                              This project is a part of <b>Programming and Data
                              Analysis in R</b> course at the Institute of Mathematics,
                              coordinated by mgr Mateusz Staniak. Our team consists of:
                              Anhelina Ustanovich, Karol Striżyk, Aleksandra Strąk, Daniel 
                              Healy.
                                   </h4>")
                        )
               )
             )
           )
  ),
  tabPanel("Plots",
           fluidPage(
             tabsetPanel(
               tabPanel(
                 "Wordcloud",
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
                     selectInput(
                       "wordcloudUsersChoice",
                       label = "Choose user(s)",
                       choices = choices,
                       selected = users[, userId][1],
                       multiple = TRUE
                       # choiceNames = users[, name],
                       # choiceValues = users[, userId]
                     )
                   ),
                   mainPanel(wordcloud2Output("wordcloud"))
                 )
               ),
               tabPanel("Reaction barplot",
                        titlePanel("Reactions to tweets"),
                        sidebarLayout(
                          sidebarPanel(
                            selectInput(
                              "tweetPopWordChoice",
                              label = "Choose words:",
                              choices = c(words, "all words"),
                              selected = words[1],
                              multiple = TRUE
                            )
                          ),
                          mainPanel(plotOutput("tweetPopularity"))
                        )),
               tabPanel(
                 "Occurence timeseries",
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
