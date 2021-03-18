
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
                      <b>History:</b> The ANOVA was developed by statistician Ronald Fisher who you may know for many other contributions to the statistics that we know today.
                      His first application of the ANOVA was to analyse a huge amount of data collected about crops and their variation over the years.")

linear_regression <- HTML("<b> Model Type: </b> Linear Regression <br> 
<b> Description: </b> Linear regression is a linear approach to modelling the relationship between a two or more continuous variables.
When you have one independent/predictor variable, it is a simple linear regression. When you have more than one independent variable, 
it is a multiple linear regression.<br>
<b> History:</b> The initial conceptualisation of linear regression happened in the late 1800s when Sir Francis Galton examined characteristics of the sweet pea plant.
                          He had distributed seeds of the same weight to his friends and obtained the seeds from the next generation of the plants. His two-dimensional 
                          plot of the sizes of daughter peas against the sizes of mother peas was an illustration of the foundations of regression.")


factorial_ANOVA <- HTML("<b>Model Type:</b> Factorial ANOVA <br>
                        <b>Description:</b> A factorial ANOVA is used to determine whether two or more sets of groups (categorical) differ on a variable of interest, and whether there is an interaction 
between the factors in the same experiment. This variable of interest should be continuous, normally distributed, and have a similar spread across your groups. The two-way ANOVA 
is a special case of the Factorial ANOVA. The simplest factorial design contains 2 levels for each of 2 factors: a 2 x 2 design.<br>
                        <b>History:</b> Factorial designs in experiments started being used in the 1800s by the Rothamsted Experimental Station (specifically Lawes and Gilbert).")

moderation <- HTML("<b>Model Type:</b> Moderation <br>
                   <b> Description:</b> Moderation refers to when the relationship between two variables varies depending on a third variable. Moderator variables function as independent variables which 
modify the relationship between X and Y. In other words, the strength and direction of the relationship between X and Y are influenced by the value of your third, moderating variable. Moderation analyses 
look at interaction effects.s")

logistic_regression <- HTML("<b>Model Type:</b> Logistic Regression <br>
                            <b>Decription:</b> This is also a type of regression analysis. It predicts a binary outcome based on a set of independent variables. 
                            A binary outcome is when there are only two possible outcomes - the event happens or it doesn't happen (1 or 0). If your dependent variable is dichotomous, 
or categorical, you could use a logistic regression. Examples of dichotomous output may include yes or no, 1 or 2 (of two groups), pass or fail, etc. The independent variables could be 
continuous, ordinal, or nominal.")

ANCOVA <- HTML("<b>Model Type:</b> ANCOVA <br>
               <b>Description:</b> ANCOVA stands for Analysis of Covariance. It is similar to an ANOVA in that it is used to determine whether there is a difference between 
               three or more categorical predictor variables. However, it also statistically controls for one or more covariates, which allows us to better understand how the factor affects the outcome variable. 
               In this case, the covariate(s) could be thought of as nuisance variables.")

MANOVA <- HTML("<b>Model Type:</b> MANOVA <br>
               <b>Description:</b> MANOVA stands for Multivariate Analysis of Variance. MANOVA is a generalised form of the ANOVA but it has two or more outcome variables and uses 
the covariance between outcome variables in testing the statistical significance of the mean differences. It can be one-way, with one factor and two or more outcome variables. It can also 
be two-way, with two factors and two or more outcome variables.")

MLM <- HTML("<b>Model Type:</b> MLM <br>
            <b>Description:</b> MLM stands for multi-level modeling. MLMs are used in designs where data is organised into different levels. For example, you could have a model 
of restaurant performance where there are measures for individual restaurants as well as measures for cities in which the restaurants are grouped. MLMs can also extend to non-linear models.<br>
            <b>History:</b> MLM has become more popular with improvements in computing software and power.")

loglinear_regression <- HTML("<b>Model Type:</b> Loglinear regression <br>
                  <b>Description:</b> Loglinear regression is usually a Poisson regression used to model count data. It is often applied to multi-way contingency tables.")

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









