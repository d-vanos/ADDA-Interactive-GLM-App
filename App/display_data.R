
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

display_data_server <- function(id, data, predictor_type, n_groups){
  moduleServer(
    id,
    function(input, output, session) {
      
      subset_cols <- reactive(

        if(predictor_type() == "Continuous"){
          columns <- colnames(data())
          return(columns)
        }
        
        else if(predictor_type() == "Categorical" & n_groups() == 2){
          columns <- colnames(data())
          columns <- columns[!columns %in% c("group_2", "group_3", "group_4")]
          return(columns)
        }
        
        else if(predictor_type() == "Categorical" & n_groups() == 3){
          columns <- colnames(data())
          columns <- columns[!columns %in% c("group_3", "group_4")]
          return(columns)
        }
        
        else if(predictor_type() == "Categorical" & n_groups() == 4){
          columns <- colnames(data())
          columns <- columns[!columns %in% c("group_4")]
          return(columns)
        }
        
        else if(predictor_type() == "Categorical" & n_groups() == 5){
          columns <- colnames(data())
          return(columns)
        }
        
      )
      
      
      
      
      # Render Table 
      output$dataset <- renderDataTable(
        round(
          data()[,subset_cols()], 
          2),
        options = list(lengthChange = FALSE,
                       searching = FALSE,
                       pageLength = 10)
      )
    }
  )
}