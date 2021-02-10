

mean_slider_UI <- function(id, label) {

  ns <- NS(id)
  
  tagList(
    sliderInput(inputId = ns("mean"),
                label   = label,
                min     = 0,
                max     = 20,
                value   = 10,
                step    = 0.5)
  )
}



mean_slider_server <- function(id){
  moduleServer(
    id,
    function(input, output, session){
      
      mean <- reactive({input$mean})
      
      return(mean)
    }
  )
}

mean_numeric_UI <- function(id, label) {
  
  ns <- NS(id)
  
  tagList(
    numericInput(inputId = ns("mean"), 
                 label = label,
                 min     = 0,
                 max     = 20,
                 value   = 10,)
  )
}



mean_numeric_server <- function(id){
  moduleServer(
    id,
    function(input, output, session){
      
      mean <- reactive({input$mean})
      
      return(mean)
    }
  )
}