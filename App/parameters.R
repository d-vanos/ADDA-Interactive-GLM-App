
# -----------------------------------------------------------------
#
# This module contains all the buttons in the parameter box on the
# page 'Visualising the GLM', and returns these values. 
#
# ----------------------------------------------------------------- 


parameters_UI <- function(id) {
  
  # `NS(id)` returns a namespace function, which is saved as `ns` and will be invoked later.
  ns <- NS(id)
  
  useShinyjs()
  
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
                   max     = 2)
    ),
    
    #------------------------------------------#
    # !!!! WARNING: CURRENTLY NOT VISIBLE !!!! #
    #------------------------------------------#
    
    conditionalPanel("input.donotshow == 'donotshow'", 
    radioButtons(inputId = ns("outcome_type"), 
                 label = "Outcome Variable Type",
                 choices = c("Continuous", "Categorical"),
                 inline = TRUE)
    ),
    
    #------------------------------------------#
    #------------------------------------------#
    
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
                label   = "Sample Size",
                value   = 50, 
                min     = 1, 
                max     = 1000),
    
    bsTooltip(id = ns("sample_size"), 
              title = "If your predictor variable is categorical and you have selected more than one group, this refers to the sample size per group.", 
              placement = "top"),
    
    conditionalPanel(
      ns = ns,
      condition = "input.predictor_type == 'Continuous'",
      
      helpText(HTML("<p style='color:black;'> <b> Variance (SD) </b> </b>")),
      
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
      
      
      
      sliderInput(inputId = ns("within_groups_variance"),
                  label   = "Within-groups Variance",
                  min     = 0,
                  max     = 20, 
                  value   = 1, 
                  step    = 0.01),
      
      bsTooltip(id = ns("within_groups_variance"), 
                title = "Note: this assumes the within-groups variance is the same for all groups, which may not be the case.", 
                placement = "top"),
      
      #------------------------------------------#
      # !!!! WARNING: CURRENTLY NOT VISIBLE !!!! #
      #------------------------------------------#
      # NOTE: THIS WILL HAVE TO INTERACT WITH THE MEANS SPECIFIED BELOW
      conditionalPanel("input.donotshow == 'donotshow'", 
      sliderInput(inputId = ns("between_groups_variance"),
                  label   = "Between-groups Variance",
                  min     = 0,
                  max     = 3,
                  value   = 1, 
                  step    = 0.01)
      ),
      
      #-----------------------------------------#
      #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#
      
      
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
        helpText(HTML("<p style='color:black;'><b> Means </b></p>")),
        mean_slider_UI(id = ns("mean_0"), label = "Group 0"),
        mean_slider_UI(id = ns("mean_1"), label = "Group 1"),
        
      ),
      
      # 3+ groups
      conditionalPanel(
        ns = ns,
        condition = "input.predictor_type == 'Categorical'  & input.n_variables == 1 & (input.n_groups == 3 | input.n_groups == 4 | input.n_groups == 5)",
        
        mean_slider_UI(id = ns("mean_2"), label = "Group 2"),
      ),
      
      # 4+ groups
      conditionalPanel(
        ns = ns,
        condition = "input.predictor_type == 'Categorical'  & input.n_variables == 1 & (input.n_groups == 4 | input.n_groups == 5)",
        mean_slider_UI(id = ns("mean_3"), label = "Group 3"),
      ),
      
      # 5 groups
      conditionalPanel(
        ns = ns,
        condition = "input.predictor_type == 'Categorical'  & input.n_variables == 1 & input.n_groups == 5",
        mean_slider_UI(id = ns("mean_4"), label = "Group 4"),
      ),
    
    # Factorial/2-way ANOVA
    conditionalPanel(
      ns = ns,
      condition = "input.predictor_type == 'Categorical'  & input.n_variables == 2",
      
      column(width = 12,
      HTML("<b> Means <br>
           <center> Variable 1 </center> </b>")
      ),
      
      #uiOutput(ns("factorial_matrix")),
      rHandsontableOutput(ns("factorial_table")),
      tableOutput(ns("table"))
      
    )
    
  )
}

# TO WORK ON: returning multiple reactive values
parameters_server <- function(id) {
  moduleServer(
    id,
    function(input, output, session){
      

      # Allow user to change inputs 
      df <- reactive({
        anova_mat <- matrix(nrow = 2, ncol = input$n_groups, data = 0)
        colnames(anova_mat) <- paste(rep("Group", input$n_groups), 1:input$n_groups) 
        rownames(anova_mat) <- c("Group 1", "Group 2")
        
        df <- as.data.frame(x = anova_mat)
        return(df)
      })
      
      output$factorial_table <- renderRHandsontable({
        rhandsontable(df())
      })
      
      # Save table output
      factorial_table <- reactive({
        if(!is.null(input$factorial_table)){
          hot_to_r(input$factorial_table)
        }
      })
      
      # Print table output 
      output$table <- renderTable({
        as.data.frame(factorial_table())
      })

         
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
             mean_0 = mean_slider_server(id = "mean_0"),
             mean_1 = mean_slider_server(id = "mean_1"),
             mean_2 = mean_slider_server(id = "mean_2"),
             mean_3 = mean_slider_server(id = "mean_3"),
             mean_4 = mean_slider_server(id = "mean_4"),
             factorial_anova = reactive(input$factorial_table)
             )
        )
    }
  )
}


