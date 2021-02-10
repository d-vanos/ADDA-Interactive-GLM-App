

mean_UI <- function(id, label) {

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



mean_server <- function(id){
  moduleServer(
    id,
    function(input, output, session){
      
      mean <- reactive({input$mean})
      
      return(mean)
    }
  )
}