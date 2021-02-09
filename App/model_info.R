
# -----------------------------------------------------------------
#
# This script contains the descriptions of the various models.
# The module controls the display of the text: various paragraphs 
# are conditionally displayed depending on the type of data generated.
#
# ----------------------------------------------------------------- 

####------####
#### Text ####
####------####

model_info <- "Information about the model to go here. For example, if it is categorical and has two groups, it is an ANOVA.
              If the outcome variable is categorical, it is likely a logistic regression.

              This section can include info on how models relate to one another, and historical reasons for different names.
- The name of the model (e.g., t-test, ANOVA)
- What makes it that type of model (e.g., categorical, 2 categories)
- Why (historically) it has been given the name that it has.
- How it similar to/different from a linear model
- Assumptions??"

linear_regression <- HTML("Linear Regression: to complete")
t_test <- HTML("T-Test: to complete")
one_way_ANOVA <- HTML("One-way ANOVA: to complete")
factorial_ANOVA <- HTML("Factorial ANOVA: to complete")
logistic_regression <- HTML("Logistic Regression: to complete")
other <- HTML("No description has been created for this type of model. Keep an eye out, as this might appear soon! ", 
              "&#x1F440") # this HTML entity creates an emoji hehe






####--------####
#### Module ####
####--------####

model_info_UI <- function(id) {
  
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("model_info"))
  )
}

# Server 
model_info_server <- function(id, predictor_type, n_groups, outcome_type){
  moduleServer(
    id,
    function(input, output, session){
      
      model_info <- reactive({
        
        # Linear regression 
        if(predictor_type() == "Continuous" & outcome_type() == "Continuous"){
          model <- linear_regression
        }
        
        # T-Test
        else if(predictor_type() == "Categorical" & outcome_type() == "Continuous" & n_groups() == 2){
          model <- t_test
        }
        
        # One-way ANOVA
        else if(predictor_type() == "Categorical" & outcome_type() == "Continuous" & n_groups() > 2){
          model <- one_way_ANOVA
        }
        
        # Factorial ANOVA
        # else if(predictor_type() == "Categorical" ){
        #   model <- factorial_ANOVA
        # }
        
        # Logistic regression
        else if(predictor_type() == "Continuous" & outcome_type() == "Categorical"){
          model <- logistic_regression
        }
        
        else({
          model <- other
        })
        
        return(model)
        
      })
      
        
      
      output$model_info <- renderUI(
        model_info()
      )
    }
  )
}









