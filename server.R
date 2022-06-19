


server = function(input, output, session){
  
  
  output$wordcloud  <- renderWordcloud2({
    wordcloud_function(tweets, 
                       input$wordcloudUsersChoice, 
                       input$wordcloudDateRange,
                       input$wordcloudMaxwords)})
  output$wordPopularity = renderPlot({
    word_popularity_plot(input$wpWordChoice,
                         word_popularity_df)
  })
  
}