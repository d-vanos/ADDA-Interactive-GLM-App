
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
                  max     = 3, # Consider changing this - fiddle with it 
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
                  max     = 3, 
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
                  min = -10,
                  max = +10,
                  value = 0),
      
      bsTooltip(id = ns("intercept"), 
                title = "The intercept is the value of the y-axis when x = 0. When your predictor variable is continuous, the intercept is the mean value of the first group, which is known as the reference group.", 
                placement = "top"),
      
      sliderInput(inputId = ns("slope"),
                  label = "Slope",
                  min = -3,
                  max = +3,
                  value = 0)
    ),
    
    
    
    # Selection options if the predictor type is categorical
      # Various group sizes - DEBUG: figure out how to make this code more efficient
      # 1 group - type of t-test 
      # 2+ groups
      conditionalPanel(
        ns = ns,
        condition = "input.predictor_type == 'Categorical'",
        sliderInput(inputId = ns("mean_1"),
                    label   = "Group 1 Mean",
                    min     = 0,
                    max     = 100, 
                    value   = 50, 
                    step    = 1),
        
        sliderInput(inputId = ns("mean_2"),
                    label   = "Group 2 Mean",
                    min     = 0,
                    max     = 100, 
                    value   = 50, 
                    step    = 1),
        
      ),
      
      # 3+ groups
      conditionalPanel(
        ns = ns,
        condition = "input.n_groups == 3 | input.n_groups == 4 | input.n_groups == 5",
        sliderInput(inputId = ns("mean_3"),
                    label   = "Group 3 Mean",
                    min     = 0,
                    max     = 100,
                    value   = 50,
                    step    = 1),
      ),
      
      # 4+ groups
      conditionalPanel(
        ns = ns,
        condition = "input.n_groups == 4 | input.n_groups == 5",
        sliderInput(inputId = ns("mean_4"),
                    label   = "Group 4 Mean",
                    min     = 0,
                    max     = 100,
                    value   = 50,
                    step    = 1),
      ),
      
      # 5 groups
      conditionalPanel(
        ns = ns,
        condition = "input.n_groups == 5",
        sliderInput(inputId = ns("mean_5"),
                    label   = "Group 5 Mean",
                    min     = 0,
                    max     = 100,
                    value   = 50,
                    step    = 1)
      )
    )
}

# TO WORK ON: returning multiple reactive values
parameters_server <- function(id) {
  moduleServer(
    id,
    function(input, output, session){
      return(
        list(show_regression_line = reactive(input$show_regression_line),
             sample_size = reactive(input$sample_size)
             )
        )
    }
  )
}


