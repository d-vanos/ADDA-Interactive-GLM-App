


# -----------------------------------------------------------------
#
# This code contains the server, or back-end, of the shiny app. 
# It creates data and displays various outputs including the graph
# and dataset. 
#
# ----------------------------------------------------------------- 




shinyServer(function(input, output, session) {
  

  ####---------------------------####
  #### Generate global variables ####
  ####---------------------------####

  #### Generate data ####
  data <- generate_data_server(id = "parameters") 
  
  # Parameters 
  parameters <- parameters_server(id = "parameters")
  
  # Dataset
  data <- generate_data_server(id = "parameters") 
  
  ####---------####
  #### Outputs ####
  ####---------####
  
  # Print dataset 
  display_data_server(id = "dataset", data = data)

  # Print graph
  graph_server(id = "graph", data = data, regression = parameters$show_regression_line)

  ####--------------------------####
  #### Debugging/Checking stuff ####
  ####--------------------------####
  
  # Print whether regression line is selected
  output$regression_line <- renderText({
    paste0("Regression line selected: ", as.character(parameters$show_regression_line()))
  })
  
  output$sample_size <- renderText({
    paste0("Sample size: ", as.character(parameters$sample_size()))
  })
})
