
# -----------------------------------------------------------------
#
# This module renders a datatable from a dataset and displays it.
#
# ----------------------------------------------------------------- 


display_data_UI <- function(id) {

  ns <- NS(id)

  tagList(
    dataTableOutput(ns("dataset"))
  )
}

display_data_server <- function(id, data){
  moduleServer(
    id,
    function(input, output, session) {
      
      # Render Table 
      output$dataset <- renderDataTable(
        round(data(), 2),
        options = list(lengthChange = FALSE,
                       searching = FALSE,
                       pageLength = 10)
      )
    }
  )
}