server = function(input, output, session){
  
  output$tweetPopularity = renderPlot({
    tweet_popularity_plot(popularity_averages,
                          input$tweetPopWordChoice)
    
  })
  
  output$wordcloud  = renderWordcloud2({
    wordcloud_function(tweets, 
                       input$wordcloudUsersChoice, 
                       input$wordcloudDateRange,
                       input$wordcloudMaxwords)})
  output$wordPopularity = renderPlot({
    word_popularity_plot(input$wpWordChoice,
                         word_popularity_df)
  })
  
}