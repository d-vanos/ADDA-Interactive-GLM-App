

# Define server
shinyServer(function(input, output, session) {
  
  #### Generate data ####
  data <- generate_data_server(id = "parameters") # data is generated in a separate script called dataset_server.R 
  
  # Import parameters 
  parameters <- parameters_server(id = "parameters")

  #### Outputs ####
  # Print dataset 
  output$dataset <- renderDataTable(
    data(),
    options = list(lengthChange = FALSE,
                   searching = FALSE)
  )
  #generate_data_server(id = "data")

  # Print graph
  graph_server(id = "graph",
               data = data,
               regression = parameters$show_regression_line)

  #### Debugging/Checking stuff ####
  # Print whether regression line is selected
  output$regression_line <- renderText({
    paste0("Regression line selected: ", as.character(parameters$show_regression_line()))
  })
  
  output$sample_size <- renderText({
    paste0("Sample size: ", as.character(parameters$sample_size()))
  })
})
