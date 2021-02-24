

# Mathjax tips: 
# Always start and end an equation with $$
# subscript: _{add_here}
# start symbols with \\
# List of common symbols: https://oeis.org/wiki/List_of_LaTeX_mathematical_symbols 

# GLM Version of Equations 

linear_regression_equation <- '$$Y_{i} = \\beta_{0} + \\beta_{1}x_{i} + \\varepsilon_{i}$$'

t_test_equation <- '$$Y_{i} = \\beta_{0} + \\beta_{1}x_{i} + \\varepsilon_{i}$$'

one_way_anova_equation_3g <- '$$Y_{i} = \\beta_{0} + \\beta_{1}x_{1} + \\beta_{2}x_{2} + \\varepsilon_{i}$$'
one_way_anova_equation_4g <- '$$Y_{i} = \\beta_{0} + \\beta_{1}x_{1} + \\beta_{2}x_{2} + \\beta_{3}x_{3} + \\varepsilon_{i}$$'
one_way_anova_equation_5g <- '$$Y_{i} = \\beta_{0} + \\beta_{1}x_{1} + \\beta_{2}x_{2} + \\beta_{3}x_{3} + \\beta_{4}x_{4} + \\varepsilon_{i}$$'

factorial_anova_equation <- 'No equation has been added yet for this type of model. Keep an eye out, as this might appear soon! &#x1F440'

logistic_regression_equation <- 'No equation has been added yet for this type of model. Keep an eye out, as this might appear soon! &#x1F440'

# Simplified Version of Equations 




####--------####
#### Module ####
####--------####

equation_info_UI <- function(id) {
  
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("static_equation_info")),
    uiOutput(ns("reactive_equation_info"))
  )
}

# Server 
equation_info_server <- function(id,  parameters){ 
  moduleServer(
    id,
    function(input, output, session){
      
      ####-----------------####
      #### Static Equation ####
      ####-----------------####
      
      static_equation_info <- reactive({
        
        # Linear regression 
        if(parameters$predictor_type() == "Continuous" & parameters$outcome_type() == "Continuous"){
          equation <- linear_regression_equation
        }
        
        # T-Test
        else if(parameters$predictor_type() == "Categorical" & parameters$outcome_type() == "Continuous" & parameters$n_groups() == 2){
          equation <- t_test_equation
        }
        
        # One-way ANOVA
        else if(parameters$predictor_type() == "Categorical" & parameters$outcome_type() == "Continuous" & parameters$n_groups() > 2){
          if(parameters$n_groups() == 3){
            equation <- one_way_anova_equation_3g
          }
          else if (parameters$n_groups() == 4){
            equation <- one_way_anova_equation_4g
          }
          else if (parameters$n_groups() == 5){
            equation <- one_way_anova_equation_5g
          }
        }
        
        # Factorial ANOVA
        else if(parameters$predictor_type() == "Categorical"){
          equation <- factorial_anova_equation
        }
        
        # Logistic regression
        else if(parameters$predictor_type() == "Continuous" & parameters$outcome_type() == "Categorical"){
          equation <- logistic_regression_equation
        }
        
        else({
          equation <- other
        })
        
        return(equation)
        
      })
      
      
      output$static_equation_info <- renderUI(
        withMathJax(HTML(static_equation_info()))
      )
      
      ####-------------------####
      #### Reactive Equation ####
      ####-------------------####
      
      reactive_equation_info <- reactive({
        
        # Linear regression 
        if(parameters$predictor_type() == "Continuous" & parameters$outcome_type() == "Continuous"){
          equation <- paste0("$$Y_{i} = ", parameters$intercept(), "+", parameters$slope(), "x_{i} + \\varepsilon_{i}$$")
        }
        
        # T-Test
        else if(parameters$predictor_type() == "Categorical" & parameters$outcome_type() == "Continuous" & parameters$n_groups() == 2){
          equation <- paste0("$$Y_{i} = ", parameters$mean_0(), "+", (parameters$mean_1() - parameters$mean_0()), "x_{i} + \\varepsilon_{i}$$")
        }
        
        # One-way ANOVA
        else if(parameters$predictor_type() == "Categorical" & parameters$outcome_type() == "Continuous" & parameters$n_groups() > 2){
          if(parameters$n_groups() == 3){
            equation <- paste0("$$Y_{i} = ", parameters$mean_0(), "+", 
                               (parameters$mean_1() - parameters$mean_0()), "x_{1} +",
                               (parameters$mean_2() - parameters$mean_0()),
                               "x_{2} + \\varepsilon_{i}$$")
          }
          else if (parameters$n_groups() == 4){
            equation <- paste0("$$Y_{i} = ", parameters$mean_0(), "+", 
                               (parameters$mean_1() - parameters$mean_0()), "x_{1} +",
                               (parameters$mean_2() - parameters$mean_0()), "x_{2} +",
                               (parameters$mean_3() - parameters$mean_0()),
                               "x_{3} + \\varepsilon_{i}$$")
          }
          else if (parameters$n_groups() == 5){
            equation <- paste0("$$Y_{i} = ", parameters$mean_0(), "+", 
                               (parameters$mean_1() - parameters$mean_0()), "x_{1} +",
                               (parameters$mean_2() - parameters$mean_0()), "x_{2} +",
                               (parameters$mean_3() - parameters$mean_0()), "x_{3} +" ,
                               (parameters$mean_4() - parameters$mean_0()),
                               "x_{4} + \\varepsilon_{i}$$")
          }
        }
        
        # Factorial ANOVA
        else if(parameters$predictor_type() == "Categorical"){
          equation <- factorial_anova_equation
        }
        
        # Logistic regression
        else if(parameters$predictor_type() == "Continuous" & parameters$outcome_type() == "Categorical"){
          equation <- logistic_regression_equation
        }
        
        else({
          equation <- other
        })
        
        return(equation)
        
        
      })
      
      output$reactive_equation_info <- renderUI(
        withMathJax(HTML(reactive_equation_info()))
      )
    }
  )
}









