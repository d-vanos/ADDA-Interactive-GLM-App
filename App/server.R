

# Define server
shinyServer(function(input, output, session) {
  
  #### Generate data ####
  data <- generate_data_server(id = "parameters") # data is generated in a separate script called dataset_server.R 
  
  # Import parameters 
  regression <- parameters_server(id = "parameters")

    #### Outputs ####
  # Print dataset 
  output$dataset <- renderDataTable(
    data(), 
    options = list(lengthChange = FALSE,
                   searching = FALSE)
  )

  # Print graph
  graph_server(id = "graph",
               data = data,
               regression = regression)
  # output$graph <- renderPlot({
  #   graph_server(id = "graph", 
  #                data = data,
  #                regression = regression)
  # })
  
  # Print whether regression line is selected
  output$regression_line <- renderText({
    as.character(regression())
  })
})
