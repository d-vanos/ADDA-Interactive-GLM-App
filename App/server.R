


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
  
  # Equation info
  equation_info_server(id = "equation_info", parameters = parameters) #predictor_type = parameters$predictor_type, n_groups = parameters$n_groups, outcome_type = parameters$outcome_type)
  
  # Print graph
  graph_server(id = "graph", data = data, regression = parameters$show_regression_line, predictor_type = parameters$predictor_type, n_variables = parameters$n_variables)
  
  # Model info
  model_info_server(id = "model_info", predictor_type = parameters$predictor_type, n_groups = parameters$n_groups, outcome_type = parameters$outcome_type)
  
  # Print dataset 
  display_data_server(id = "dataset", data = data, predictor_type = parameters$predictor_type, n_groups = parameters$n_groups)
  
  
  # Model output
  R_model_output_server(id = "R_model_output", data = data, parameters = parameters)
  

  ####--------------------------####
  #### Debugging/Checking stuff ####
  ####--------------------------####
  
  debug_server(id = "debug", parameters = parameters)
})
