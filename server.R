


server = function(input, output, session){
  
  
  output$selected_var  <- renderText({
    paste("input$dateRange is", 
          paste(as.character(input$dateRange), collapse = " to ")
    )
  })
}