

debug_UI <- function(id) {
  
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  tagList(
    textOutput(ns("regression_line")),
    textOutput(ns("sample_size")),
    uiOutput(ns("means")),
    textOutput(ns("predictor_type")),
    textOutput(ns("mean")),
    mean_slider_UI(id = ns("mean_0"), label = "Checking dem means")
    
  )
}


# Server 
debug_server <- function(id, parameters){
  moduleServer(
    id,
    function(input, output, session){

      # Print whether regression line is selected
      output$regression_line <- renderText({
        paste0("Regression line selected: ", as.character(parameters$show_regression_line()))
      })
      
      # Sample size
      output$sample_size <- renderText({
        paste0("Sample size: ", as.character(parameters$sample_size()))
      })
      
      # Group means
      output$means <- renderUI({
            paste0("Mean 1: ", 
             as.character(parameters$mean_1()),
             "    Mean 2: ",
             as.character(parameters$mean_2()),
             "    Mean 3: ",
             as.character(parameters$mean_3()),
             "    Mean 4: ",
             as.character(parameters$mean_4()),
             "    Mean 5: ",
             as.character(parameters$mean_5()))
      })
      
      # Predictor type
      output$predictor_type <- renderText({
        paste0("Predictor type: ", as.character(parameters$predictor_type()))
      })
      
      # Means
      mean_0 <- mean_slider_server(id = "mean_0")
      
      output$mean <- renderText({
        paste0("Mean_0 mean: ", mean_0())
      })
    }
  )
}
