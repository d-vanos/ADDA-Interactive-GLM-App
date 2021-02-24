
# -----------------------------------------------------------------
#
# This script contains the user interface, or front-end, of the 
# app. This includes the overall structure, CSS and other 
# formatting, and various buttons and toggles.
#
#
# Note: Areas for improvement or other notes are specified using
# 'DEBUG'.
#
# ----------------------------------------------------------------- 



shinyUI(
  tagList(
  dashboardPage(skin = "black",
                
                # Overall structure and headings 
                dashboardHeader(title = "Exploring the GLM"),
                dashboardSidebar(
                  sidebarMenu(
                    menuItem("Visualising the GLM", tabName = "graph", icon = icon("chart-area")),
                    
                    #------------------------------------------#
                    # !!!! WARNING: CURRENTLY NOT VISIBLE !!!! #
                    #------------------------------------------#
                             # startExpanded = TRUE,
                             # menuSubItem("Free Explore", tabName = "free_explore")),
                             # menuSubItem("Start Tutorial", tabName = "start_tutorial")),
                    # menuItem("Learning Exercises", tabName = "exercises", icon = icon("chalkboard-teacher")),
                    # menuItem("R Code", tabName = "code", icon = icon("code"),
                    #          startExpanded = TRUE,
                    #          menuSubItem("Create R Models", tabName = "r_models"),
                    #          menuSubItem("Test Your Understanding", tabName = "test_understanding"),
                    #          menuSubItem("Useful Code", tabName = "useful_code")),
                    
                    #------------------------------------------#
                    
                    menuItem("Further Resources", tabName = "resources", icon = icon("book-open"))
                  )
                ),
                
                dashboardBody(
                  
                  # CSS styling for colours 
                  tags$head(tags$style(HTML("
                  .skin-black .left-side, .skin-black .main-sidebar, .skin-black .wrapper {
                                            background-color: #012a58;
                                            }
                                            .skin-black .sidebar-menu>li>.treeview-menu {
                                            margin: 0 1px;
                                            background: #012a58;
                                            }"))),
                  tabItems(
                    
                    ####--------------------------####
                    #### Tab: Visualising the GLM ####
                    ####--------------------------####
                    
                    tabItem(tabName = "graph", h2("Visualising General Linear Models"),
                            
                            fluidRow(
                              column(width = 3,
                                     
                                     # box(title = "Checking stuff",
                                     #     width = NULL,
                                     #     debug_UI(id = "debug")
                                     #     ),
                                     
                                     box(title = "Parameters",
                                         width = NULL,
                                         parameters_UI(id = "parameters") # Note: this needs to match up to the server
                                     )
                              ),
                              column(width = 9,
                                     
                                     box(title = "Equation",
                                         width = NULL,
                                         equation_info_UI(id = "equation_info")
                                     ),
                                     
                                     box(title = "Graph",
                                         width = NULL,
                                         graph_UI(id = "graph")
                                     ),
                                     
                                     fluidRow(
                                       column(width = 6,
                                              box(title = "R Model Output",
                                                  width = NULL,
                                                  textOutput("data"),
                                                  verbatimTextOutput("model_output_lm"),
                                                  verbatimTextOutput("model_output_anova")
                                                  
                                              )
                                       ),
                                       
                                       column(width = 6,
                                              box(title = "Model Info",
                                                  width = NULL,
                                                  model_info_UI(id = "model_info"))
                                       
                                       )
                                     ),
                                     
                                     box(title = "Dataset",
                                         width = NULL,
                                         display_data_UI(id = "dataset")
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
                  tabItem(tabName = "useful_code", h2("Useful Code")),
                  
                  ####-------------------####
                  #### Further Resources ####
                  ####-------------------####
                  
                  tabItem(tabName = "resources", h2("Further Resources"),
                          fluidRow(
                            column(width = 12, includeMarkdown("resources.md"))
                          )
                          )
                )
                )
  ),
  
  # Footer 
  tags$footer("Created for Advanced Design and Data Analysis at the University of Melbourne",
              align = "center",
              style = "background-color: #ecf0f5;
                       height: 30px;")
  )
  

)




