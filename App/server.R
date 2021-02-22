


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
  equation_info_server(id = "equation_info", predictor_type = parameters$predictor_type, n_groups = parameters$n_groups, outcome_type = parameters$outcome_type)
  
  # Model info
  model_info_server(id = "model_info", predictor_type = parameters$predictor_type, n_groups = parameters$n_groups, outcome_type = parameters$outcome_type)
  
  # Print dataset 
  display_data_server(id = "dataset", data = data, predictor_type = parameters$predictor_type, n_groups = parameters$n_groups)

  # Print graph
  graph_server(id = "graph", data = data, regression = parameters$show_regression_line, predictor_type = parameters$predictor_type)
  
  # Model output
  model_summary <- reactive({
    
    if(parameters$predictor_type() == "Continuous"){
      predictor_variables <- "x"

    }

    else if(parameters$predictor_type() == "Categorical" & parameters$n_groups() == 2){
      predictor_variables <- " 1 + group_1"


    }

    else if(parameters$predictor_type() == "Categorical" & parameters$n_groups() == 3){
      predictor_variables <- " 1 + group_1 + group_2"

    }

    else if(parameters$predictor_type() == "Categorical" & parameters$n_groups() == 4){
      predictor_variables <- " 1 + group_1 + group_2 + group_3"

    }

    else if(parameters$predictor_type() == "Categorical" & parameters$n_groups() == 5){
      predictor_variables <- " 1 + group_1 + group_2 + group_3 + group_4"

    }
    
    model <- summary(glm(as.formula(paste0("y ~", predictor_variables)), data = data()), digits = 3)
    return(model)
  })
  
  output$model_output <- renderPrint({
    print(model_summary())
  })
  
  

  ####--------------------------####
  #### Debugging/Checking stuff ####
  ####--------------------------####
  
  debug_server(id = "debug", parameters = parameters)
})
