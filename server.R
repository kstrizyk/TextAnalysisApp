


server = function(input, output, session){
  
  
  output$wordcloud  <- renderWordcloud2({
    wordcloud_function(tweets, 
                       input$wordcloudUsersChoice, 
                       input$wordcloudDateRange,
                       input$wordcloudMaxwords)})
}