


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

  # Parameters 
  parameters <- parameters_server(id = "parameters")

  # Generate data 
  data <- generate_data_server(id = "parameters", parameters = parameters) 
  
  ####---------####
  #### Outputs ####
  ####---------####
  
  # Model info
  model_info_server(id = "model_info", predictor_type = parameters$predictor_type, n_groups = parameters$n_groups, outcome_type = parameters$outcome_type)
  
  # Print dataset 
  display_data_server(id = "dataset", data = data)

  # Print graph
  graph_server(id = "graph", data = data, regression = parameters$show_regression_line, predictor_type = parameters$predictor_type)

  ####--------------------------####
  #### Debugging/Checking stuff ####
  ####--------------------------####
  
  debug_server(id = "debug", parameters = parameters)
})
