
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
                          menuItem("Visualising the GLM", tabName = "graph", icon = icon("chart-area"),
                                   startExpanded = TRUE,
                                   menuSubItem("Free Explore", tabName = "free_explore"),
                                   menuSubItem("Start Tutorial", tabName = "start_tutorial")),
                          menuItem("Learning Exercises", tabName = "exercises", icon = icon("chalkboard-teacher")),
                          menuItem("R Code", tabName = "code", icon = icon("code"),
                                   startExpanded = TRUE,
                                   menuSubItem("Create R Models", tabName = "r_models"),
                                   menuSubItem("Test Your Understanding", tabName = "test_understanding"),
                                   menuSubItem("Useful Code", tabName = "useful_code"))
                      )
                  ),
                  
                  dashboardBody(
                      
                      tabItems(
                          
                          ####---------------------####
                          #### Visualising the GLM ####
                          ####---------------------####
                          
                          tabItem(tabName = "free_explore", h2("Visualising General Linear Models"),
                                  
                                  fluidRow(
                                      column(width = 4,
                                             
                                             box(title = "Parameters", 
                                                 width = NULL,
                                                 parameters_UI(id = "parameters") # Note: this needs to match up to the server
                                             ),
                                             box(title = "Dataset",
                                                 width = NULL,
                                                 dataTableOutput("dataset")
                                             )
                                      ),
                                      
                                      column(width = 8,
                                             
                                             box(title = "Equation",
                                                 width = NULL,
                                                 HTML("Equation to go here.")), 
                                             
                                             box(title = "Model Info",
                                                 width = NULL,
                                                 HTML("Information about the model to go here. For example, if it is categorical and has two groups, it is an ANOVA. 
                                            If the outcome variable is categorical, it is likely a logistic regression.
                                           This section can include info on how models relate to one another, and historical reasons for different names.")),
                                             
                                             box(title = "Graph",
                                                 width = NULL,
                                                 plotOutput("graph")
                                                 
                                             ),
                                             
                                             box(title = "R Model Output",
                                                 width = NULL,
                                                 textOutput("data"),
                                                 HTML("R Model Output to go here.")
                                             )
                                      )
                                      
                                  )
                          ),
                          
                          ####--------------------####
                          #### Learning Exercises ####
                          ####--------------------####
                          
                          tabItem(tabName = "exercises", h2("Learning Exercises"),
                                  fluidRow(
                                      box(title = "Choose a Tutorial")
                                  )),
                          
                          tabItem(tabName = "r_models", h2("R Models")),
                          tabItem(tabName = "test_understanding", h2("Test Your Understanding")),
                          tabItem(tabName = "useful_code", h2("Useful Code"))
                      )
                  )
    )
)

