
# -----------------------------------------------------------------
#
# This module contains all the buttons in the parameter box on the
# page 'Visualising the GLM', and returns these values. 
#
# ----------------------------------------------------------------- 


parameters_UI <- function(id) {
  
  # `NS(id)` returns a namespace function, which is saved as `ns` and will be invoked later.
  ns <- NS(id)
  
  tagList(
    
    # Predictor Type
    radioButtons(inputId = ns("predictor_type"), 
                 label = "Predictor Variable Type",
                 choices = c("Continuous", "Categorical"),
                 inline = TRUE),
    
    conditionalPanel(
      ns = ns,
      condition = "input.predictor_type == 'Categorical'",
      
      numericInput(inputId = ns("n_groups"),
                   label   = "Number of groups",
                   value   = 2, 
                   min     = 2, 
                   max     = 5), # Could be higher but that might make it difficult to select means for each group
      
      numericInput(inputId = ns("n_variables"),
                   label   = "Number of predictor variables",
                   value   = 1, 
                   min     = 1, 
                   max     = 2),
    ),
    radioButtons(inputId = ns("outcome_type"), 
                 label = "Outcome Variable Type",
                 choices = c("Continuous", "Categorical"),
                 inline = TRUE),
    
    conditionalPanel(
      ns = ns,
      condition = "input.outcome_type == 'Categorical'",
      
      numericInput(inputId = ns("n_response_options"),
                   label   = "Number of response options",
                   value   = 2, 
                   min     = 1, 
                   max     = 4), 
    ),
    bsTooltip(id = ns("n_response_options"), 
              title = "The maximum number of response options in this app is 4, but in reality you can have many more response options.", 
              placement = "top"),
    
    checkboxInput(inputId = ns("show_regression_line"),
                  label = "Show Regression Line"),
    
    sliderInput(inputId = ns("sample_size"),
                label   = "Sample Size per Group",
                value   = 50, 
                min     = 1, 
                max     = 1000),
    
    bsTooltip(id = ns("sample_size"), 
              title = "If your predictor variable is categorical and you have selected more than one group, this refers to the sample size per group.", 
              placement = "top"),
    
    helpText(HTML("<b> Variance </b>")),
    
    conditionalPanel(
      ns = ns,
      condition = "input.predictor_type == 'Continuous'",
      
      sliderInput(inputId = ns("variance"),
                  label   = NULL,
                  min     = 0,
                  max     = 10, # Consider changing this - fiddle with it 
                  value   = 1, 
                  step    = 0.01)
    ),
    
    conditionalPanel(
      ns = ns,
      condition = "input.predictor_type == 'Categorical'",
      
      # NOTE: THIS WILL HAVE TO INTERACT WITH THE MEANS SPECIFIED BELOW
      sliderInput(inputId = ns("within_groups_variance"),
                  label   = "Within-groups Variance",
                  min     = 0,
                  max     = 10, 
                  value   = 1, 
                  step    = 0.01),
      
      bsTooltip(id = ns("within_groups_variance"), 
                title = "Note: this assumes the within-groups variance is the same for all groups, which may not be the case.", 
                placement = "top"),
      
      sliderInput(inputId = ns("between_groups_variance"),
                  label   = "Between-groups Variance",
                  min     = 0,
                  max     = 3,
                  value   = 1, 
                  step    = 0.01),
      
      
    ),
    
    # Selection options if the predictor type is continuous
    conditionalPanel(
      ns = ns,
      condition = "input.predictor_type == 'Continuous'",
      
      sliderInput(inputId = ns("intercept"),
                  label = "Intercept",
                  min = 0,
                  max = +20,
                  value = +10),
      
      bsTooltip(id = ns("intercept"), 
                title = "The intercept is the value of the y-axis when x = 0. When your predictor variable is continuous, the intercept is the mean value of the first group, which is known as the reference group.", 
                placement = "top"),
      
      sliderInput(inputId = ns("slope"),
                  label = "Slope",
                  min = -7,
                  max = +7,
                  value = 0, 
                  step = 0.1)
    ),
    
    
    
    # Selection options if the predictor type is categorical and there is only 1 variable
      conditionalPanel(
        ns = ns,
        condition = "input.predictor_type == 'Categorical'  & input.n_variables == 1",
        mean_slider_UI(id = ns("mean_1"), label = "Group 1"),
        mean_slider_UI(id = ns("mean_2"), label = "Group 2"),
        
      ),
      
      # 3+ groups
      conditionalPanel(
        ns = ns,
        condition = "input.predictor_type == 'Categorical'  & input.n_variables == 1 & (input.n_groups == 3 | input.n_groups == 4 | input.n_groups == 5)",
        
        mean_slider_UI(id = ns("mean_3"), label = "Group 3"),
      ),
      
      # 4+ groups
      conditionalPanel(
        ns = ns,
        condition = "input.predictor_type == 'Categorical'  & input.n_variables == 1 & (input.n_groups == 4 | input.n_groups == 5)",
        mean_slider_UI(id = ns("mean_4"), label = "Group 4"),
      ),
      
      # 5 groups
      conditionalPanel(
        ns = ns,
        condition = "input.predictor_type == 'Categorical'  & input.n_variables == 1 & input.n_groups == 5",
        mean_slider_UI(id = ns("mean_5"), label = "Group 5"),
      ),
    
    # Factorial/2-way ANOVA
    conditionalPanel(
      ns = ns,
      condition = "input.predictor_type == 'Categorical'  & input.n_variables == 2",
      
      
      HTML("<b> Means <br>
           <center> Variable 1 </center> </b>"),
      
      uiOutput(ns("means_factorial_anova"))
    )
    
  )
}

matrix(nrow = 3, ncol = 3, data = 0) %>% 
  colnames(.) 
# TO WORK ON: returning multiple reactive values
parameters_server <- function(id) {
  moduleServer(
    id,
    function(input, output, session){
      
      mat <- reactive({
        # Make the column size for factorial ANOVA depend on the number of groups selected
        # Only presenting means for 2 groups per variable 
        if(input$n_groups == 2){
          mat <- matrix(nrow = 2, ncol = 2, data = 0)
          colnames(mat) <- c("Group 1", "Group 2")
          rownames(mat) <- c("Group 1", "Group 2")
        }

        #  Only presenting means for 3 groups per variable
        else if(input$n_groups == 3){
          mat <- matrix(nrow = 3, ncol = 3, data = 0)
          colnames(mat) <- c("Group 1", "Group 2", "Group 3")
          rownames(mat) <- c("Group 1", "Group 2", "Group 3")
        }
        
        #  Only presenting means for 4 groups per variable
        else if(input$n_groups == 4){
          mat <- matrix(nrow = 4, ncol = 4, data = 0)
          colnames(mat) <- c("Group 1", "Group 2", "Group 3", "Group 4")
          rownames(mat) <- c("Group 1", "Group 2", "Group 3", "Group 4")
        }
        
        #  Only presenting means for 5 groups per variable
        else if(input$n_groups == 5){
          mat <- matrix(nrow = 5, ncol = 5, data = 0)
          colnames(mat) <- c("Group 1", "Group 2", "Group 3", "Group 4", "Group 5")
          rownames(mat) <- c("Group 1", "Group 2", "Group 3", "Group 4", "Group 5")
        }
        

        return(mat)
      })

      output$means_factorial_anova <- renderUI(
        fluidRow(
          column(width = 1,
                 # DEBUG: rotate 90 degrees so it is vertical using CSS styling
                 HTML("<br><br><br> <b> Var 2 </b>")
                 ),
               column(width = 11,
         matrixInput(inputId = "factorial_matrix",
                     class = "numeric",
                     value = mat(),
                     rows = list(names = TRUE),
                     cols = list(names = TRUE))
               )
        )
         
        # div(
        #   fluidRow(
        #     column(width = 12, align = "center",
        #                   HTML("<b> Variable 1 </b> "))),
        #   fluidRow(
        #     column(width = 1,
        #            # DEBUG: rotate 90 degrees so it is vertical using CSS styling 
        #            HTML("V2")),
        #     column(width = 1, 
        #            helpText(HTML("<br> <br> G1"))),
        #     column(width = 12/input$n_groups-1,
        #            HTML("<b> Group 1 </b>"),
        #                   if(input$n_groups %in% c(2, 3)){
        #                     list(
        #                       mean_slider_UI(id = "Var1Group1_Var2Group1", label = ""),
        #                       mean_slider_UI(id = "var_1_group_2", label = "Variable 1 Group 2")
        #                     )
        #                     
        #                   },
        #                   if(input$n_groups == 3){
        #                     mean_slider_UI(id = "var_1_group_3", label = "Variable 1 Group 3")
        #                   }
        #   ),
        #   column(width = 12/input$n_groups,
        #          HTML("<b> Group 2 </b>"))
        #   )
        # )
       )

      return(
        list(predictor_type = reactive(input$predictor_type),
             n_groups = reactive(input$n_groups),
             n_variables = reactive(input$n_variables),
             outcome_type = reactive(input$outcome_type),
             n_response_options = reactive(input$n_response_options),
             show_regression_line = reactive(input$show_regression_line),
             sample_size = reactive(input$sample_size),
             variance = reactive(input$variance),
             within_groups_variance = reactive(input$within_groups_variance),
             between_groups_variance = reactive(input$between_groups_variance),
             intercept = reactive(input$intercept),
             slope = reactive(input$slope),
             mean_1 = mean_slider_server(id = "mean_1"),
             mean_2 = mean_slider_server(id = "mean_2"),
             mean_3 = mean_slider_server(id = "mean_3"),
             mean_4 = mean_slider_server(id = "mean_4"),
             mean_5 = mean_slider_server(id = "mean_5")
             )
        )
    }
  )
}


