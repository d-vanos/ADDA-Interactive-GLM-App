

debug_UI <- function(id) {
  
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  tagList(
    rHandsontableOutput(ns("check_table")),
    tableOutput(ns("table"))

  )
}


# Server 
debug_server <- function(id, parameters){
  moduleServer(
    id,
    function(input, output, session){
      
      # Allow user to change inputs 
      output$check_table <- renderRHandsontable({
        df <- data.frame(group_1 = rep(0, 3), group_2 = rep(0,3), group_3 = rep(0,3))
        rhandsontable(df)
      })
      
      # Save table output
      table <- reactive({
        if(!is.null(parameters$factorial_anova())){
          as.data.frame(hot_to_r(parameters$factorial_anova()))
        }
      })
      
      # Print table output
      output$table <- renderTable({
        table()
      })
    }
  )
}

