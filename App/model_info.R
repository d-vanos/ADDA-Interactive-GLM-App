
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


linear_regression <- HTML("Linear Regression: Linear regression is a linear approach 
                          to modelling the relationship between a scalar response and one (or more) dependent and independent  
                          variables. When you have one independent variable, it is a simple linear regression. When you have more than one 
                          independent variable, it is a multiple linear regression.")

t_test <- HTML("<b>Model Type:</b> T-Test <br>
                <b>Description:</b> A t-test is used to compare the means between two groups. Is is an application of the general linear model 
as you can treat your groups (a binary variable), as a dummy variable and assign the value of 1 for group A, and 0 for group B. <br> 
                <b>History:</b> The history of the student t-test begins at the Irish Guinness brewery, where 
               scientists were recruited to help ensure quality consistency when producing beer in large 
               quantities. The chemist and mathematician William Sealy Gosset was one of those 
               recruited. To make decisions about which ingredients to use, he developed statistical methods 
and the accompanying t-distribution. The Guinness brewery allowed him to publish these findings, 
but only under a pseudonym, Student.")

one_way_ANOVA <- HTML("<b>Model Type:</b> One-way ANOVA <br> 
                       <b>Description:</b> ANOVA stands for Analysis of Variance, and is a test used to analyse the the difference between means of two or more groups. 
                      An ANOVA is used when you have a <b>categorical</b> independent variable, and one quantitative dependent variable. 
                      One-way refers to when you have one independent variable, and two-way when you have two independent variables. <br>
                      ")

linear_regression <- HTML("<b> Model Type: </b> Linear Regression <br> 
<b> Description: </b> Linear regression is a linear approach to modelling the relationship between a two or more continuous variables.
When you have one independent/predictor variable, it is a simple linear regression. When you have more than one independent variable, 
it is a multiple linear regression.")


factorial_ANOVA <- HTML("<b>Model Type:</b> Factorial ANOVA <br>
                        <b>Description:</b> A factorial ANOVA is ____
                        It is used when you look at the effects of more than one factor together
                        It gives us information about their dependence or independence in the same experiment. <br>
                        <b>History:</b> ")

moderation <- HTML("<b>Model Type:</b> Moderation <br>
                   <b> Description:</b>  <br>
                   <b>History:</b> ")

logistic_regression <- HTML("<b>Model Type:</b> Logistic Regression <br>
                            <b>Description:</b> This is also a type of regression analysis. 
It predicts a binary outcomes based on a set of independent variables. 
                            A binary outcome is when there are only two possible outcomes -  <br>
                            <b>History:</b> ")

ANCOVA <- HTML("<b>Model Type:</b> ANCOVA <br>
               <b>Description:</b> ANCOVA stands for   <br>
               <b>History:</b>  ")

MANOVA <- HTML("<b>Model Type:</b> MANOVA <br>
               <b>Description:</b> MANOVA stands for   <br>
               <b>History:</b>  ")

MLM <- HTML("<b>Model Type:</b> MLM <br>
            <b>Description:</b> MLM stands for multi-level modeling.  <br>
            <b>History:</b> ")

Loglinear <- HTML("<b>Model Type:</b> Loglinear <br>
                  <b>Description:</b>   <br>
                  <b>History:</b> ")

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









