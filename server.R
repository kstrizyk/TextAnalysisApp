


server = function(input, output, session){
  
  
  output$wordcloud  <- renderPlot({
    wordcloud_function(tweets, 
                       input$wordcloudUsersChoice, 
                       input$wordcloudDateRange,
                       10)})
}