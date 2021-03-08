
# -----------------------------------------------------------------
#
# This module runs a general linear model and prints it. 
#
# ----------------------------------------------------------------- 

R_model_output_UI <- function(id) {
  
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  tagList(
    #textOutput("data"),
    verbatimTextOutput(outputId = ns("model_output_lm")),
    verbatimTextOutput(outputId = ns("model_output_anova"))
  )
}

# Server 
R_model_output_server <- function(id, data,parameters){ 
  moduleServer(
    id,
    function(input, output, session){
      
      # Generate info for equation 
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
        
        model <- glm(as.formula(paste0("y ~", predictor_variables)), data = data())
        return(model)
      })
      
      ####--------####
      #### Output ####
      ####--------####
      
      # Linear model 
      output$model_output_lm <- renderPrint({
        summary(model_summary())
      })
      
      # Other models (t-test/ANOVA) 
      output$model_output_anova <- renderPrint({
        if(parameters$predictor_type() == "Categorical" & parameters$n_groups() == 2){
          t.test(formula = y ~ x, data = data())
        }
        
        else if(parameters$predictor_type() == "Categorical" & parameters$n_groups() >= 3){
          summary(aov(formula = y ~ x, data = data()))
        }
      })
      
    }
  )
}