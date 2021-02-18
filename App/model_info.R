
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

linear_regression <- HTML("Linear Regression: ")
t_test <- HTML("T-Test: A t-test
               Beer test!")
one_way_ANOVA <- HTML("One-way ANOVA: ANOVA stands for Analysis of Variance, and is a test used to analyse the the difference between means of two or more groups. 
                      An ANOVA is used when you have a <b>categorical</b> independent variable, and one quantitative dependent variable. 
                      One-way refers to when you have one indepenedent variable, and two-way when you have two independent variables.
                      ")
factorial_ANOVA <- HTML("Factorial ANOVA: A factorial ANOVA is ____
                        It is used when you look at the effects of more than one factor together
                        It gives us information about their dependence or independence in the same experiment.")

moderation <- ""

logistic_regression <- HTML("Logistic Regression: This is also a type of regression analysis.
With logistic regression
                            It predicts a binary outcomes based on a set of independent variables.
                            A binary outcome is when there are only two possible outcomes - ")

ANCOVA <- ""

MANOVA <- ""

MLM <- ""

Loglinear <- ""

# put in the other models!!
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









