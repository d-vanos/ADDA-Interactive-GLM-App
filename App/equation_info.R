

# Mathjax tips: 
# Always start and end an equation with $$
# subscript: _{add_here}
# start symbols with \\
# List of common symbols: https://oeis.org/wiki/List_of_LaTeX_mathematical_symbols 

# GLM Version of Equations 

linear_regression_equation <- '$$Y_{i} = \\beta_{0} + \\beta_{1}x_{i} + \\varepsilon$$'

t_test_equation <- '$$Y_{i} = \\beta_{0} + \\beta_{1}x_{i} + \\varepsilon$$'

one_way_anova_equation_3g <- '$$Y_{i} = \\beta_{0} + \\beta_{1}x_{1} + \\beta_{2}x_{2} + \\varepsilon$$'
one_way_anova_equation_4g <- '$$Y_{i} = \\beta_{0} + \\beta_{1}x_{1} + \\beta_{2}x_{2} + \\beta_{3}x_{3} + \\varepsilon$$'
one_way_anova_equation_5g <- '$$Y_{i} = \\beta_{0} + \\beta_{1}x_{1} + \\beta_{2}x_{2} + \\beta_{3}x_{3} + \\beta_{4}x_{4} + \\varepsilon$$'

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
    uiOutput(ns("equation_info"))
  )
}

# Server 
equation_info_server <- function(id, predictor_type, n_groups, outcome_type){
  moduleServer(
    id,
    function(input, output, session){
      
      equation_info <- reactive({
        
        # Linear regression 
        if(predictor_type() == "Continuous" & outcome_type() == "Continuous"){
          equation <- linear_regression_equation
        }
        
        # T-Test
        else if(predictor_type() == "Categorical" & outcome_type() == "Continuous" & n_groups() == 2){
          equation <- t_test_equation
        }
        
        # One-way ANOVA
        else if(predictor_type() == "Categorical" & outcome_type() == "Continuous" & n_groups() > 2){
          if(n_groups() == 3){
            equation <- one_way_anova_equation_3g
          }
          else if (n_groups() == 4){
            equation <- one_way_anova_equation_4g
          }
          else if (n_groups() == 5){
            equation <- one_way_anova_equation_5g
          }
        }
        
        # Factorial ANOVA
        else if(predictor_type() == "Categorical"){
          equation <- factorial_anova_equation
        }
        
        # Logistic regression
        else if(predictor_type() == "Continuous" & outcome_type() == "Categorical"){
          equation <- logistic_regression_equation
        }
        
        else({
          equation <- other
        })
        
        return(equation)
        
      })
      
      
      
      output$equation_info <- renderUI(
        withMathJax(HTML(equation_info()))
      )
    }
  )
}









