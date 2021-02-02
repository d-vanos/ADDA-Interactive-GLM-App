
# D. J. van Os 
# 26/01/2021

# Note: Areas for improvement or other notes are specified using 'DEBUG'.

library(shiny)
library(shinydashboard)
library(shinyBS)

# Define UI for application that draws a histogram
shinyUI(
    dashboardPage(skin = "black",
                  dashboardHeader(title = "Exploring the GLM"),
                  dashboardSidebar(
                      sidebarMenu(
                          menuItem("Visualising the GLM", tabName = "graph", icon = icon("chart-area")),
                          menuItem("Learning Exercises", tabName = "exercises", icon = icon("chalkboard-teacher")),
                          menuItem("R Code", tabName = "code", icon = icon("code"))
                      )
                  ),
                  dashboardBody(
                      tabItems(
                      # Application title
                      tabItem(tabName = "graph", h2("Visualising General Linear Models"),
                              
                              fluidRow(
                                  
                                  #### Parameters box ####
                                  box(title = "Parameters", 
                                      
                                      # Predictor Type
                                      radioButtons(inputId = "predictor_type", 
                                                   label = "Predictor Type",
                                                   choices = c("Continuous", "Categorical"),
                                                   inline = TRUE),
                                      
                                      checkboxInput(inputId = "show_regression_line",
                                                    label = "Show Regression Line"),
                                      
                                      sliderInput(inputId = "sample_size",
                                                  label   = "Sample Size per Group",
                                                  value   = 50, 
                                                  min     = 1, 
                                                  max     = 1000),
                                      
                                      bsTooltip(id = "sample_size", title = "If you have selected more than one group, this refers to the sample size per group.", placement = "top"),
                                      
                                      sliderInput(inputId = "within_groups_variance",
                                                  label   = "Variance",
                                                  min     = 0,
                                                  max     = 3, # Consider changing this - fiddle with it 
                                                  value   = 1, 
                                                  step    = 0.01),
                                      
                                      # Selection options if the predictor type is continuous
                                      conditionalPanel(
                                          condition = "input.predictor_type == 'Continuous'",
                                          
                                          sliderInput(inputId = "intercept",
                                                      label = "Intercept",
                                                      min = -10,
                                                      max = +10,
                                                      value = 0),
                                          
                                          sliderInput(inputId = "slope",
                                                      label = "Slope",
                                                      min = -3,
                                                      max = +3,
                                                      value = 0)
                                      ),
                                      
                                      
                                      
                                      # Selection options if the predictor type is categorical
                                      conditionalPanel(
                                          condition = "input.predictor_type == 'Categorical'",
                                          
                                          
                                          
                                          numericInput(inputId = "n_groups",
                                                       label   = "Number of groups",
                                                       value   = 2, 
                                                       min     = 2, 
                                                       max     = 5), # Could be higher but that might make it difficult to select means for each group
                                          
                                          
                                          # DEBUG: DD THIS LATER BECAUSE THIS WILL HAVE TO INTERACT WITH THE MEANS SPECIFIED BELOW
                                          # sliderInput(inputID = "between_groups_variance",
                                          #            label = "Between-groups variance",
                                          #            min = 0, 
                                          #            max = 3, 
                                          #            value = 1, 
                                          #            step = 0.01),
                                          
                                          # Various group sizes - DEBUG: figure out how to make this code more efficient
                                          # 1 group - type of t-test 
                                          # 2+ groups
                                          conditionalPanel(
                                              condition = "input.n_groups == 2 | input.n_groups == 3 | input.n_groups == 4 | input.n_groups == 5",
                                              sliderInput(inputId = "mean_1",
                                                          label   = "Group 1 Mean",
                                                          min     = 0,
                                                          max     = 100, 
                                                          value   = 50, 
                                                          step    = 1),
                                              
                                              sliderInput(inputId = "mean_2",
                                                          label   = "Group 2 Mean",
                                                          min     = 0,
                                                          max     = 100, 
                                                          value   = 50, 
                                                          step    = 1),
                                              
                                          ),
                                          
                                          # 3+ groups
                                          conditionalPanel(
                                              condition = "input.n_groups == 3 | input.n_groups == 4 | input.n_groups == 5",
                                              sliderInput(inputId = "mean_3",
                                                          label   = "Group 3 Mean",
                                                          min     = 0,
                                                          max     = 100,
                                                          value   = 50,
                                                          step    = 1),
                                          ),
                                          
                                          # 4+ groups
                                          conditionalPanel(
                                              condition = "input.n_groups == 4 | input.n_groups == 5",
                                              sliderInput(inputId = "mean_4",
                                                          label   = "Group 4 Mean",
                                                          min     = 0,
                                                          max     = 100,
                                                          value   = 50,
                                                          step    = 1),
                                          ),
                                          
                                          # 5 groups
                                          conditionalPanel(
                                              condition = "input.n_groups == 5",
                                              sliderInput(inputId = "mean_5",
                                                          label   = "Group 5 Mean",
                                                          min     = 0,
                                                          max     = 100,
                                                          value   = 50,
                                                          step    = 1),
                                          )
                                      )
                                  ),
                                  
                                  box(title = "Equation",
                                      HTML("Equation to go here.")), 
                                  
                                  box(title = "Graph",
                                      
                                      plotOutput("graph")
                                      
                                  ),
                                  
                                  box(title = "Dataset",
                                      
                                      dataTableOutput("dataset")
                                      
                                  ),
                                  
                                  box(title = "R Model Output",
                                      
                                      textOutput("data"),
                                      HTML("R Model Output to go here.")
                                  )
                                  
                              )
                      ),
                      tabItem(tabName = "exercises", h2("Learning Exercises")),
                      tabItem(tabName = "code", h2("R Code"))
                      )
                  )
    )
)

