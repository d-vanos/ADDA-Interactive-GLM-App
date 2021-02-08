

free_explore_UI <- function(id) {
  ns <- NS(id)
  tagList(
    dataTableOutput(ns("dataset")),
    plotOutput(ns("graph"))
  )
}

free_explore_server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
      #### Generate data ####
      data <- generate_data_server(id = "parameters") # data is generated in a separate script called dataset_server.R 
      
      #### Outputs ####
      # Print dataset 
      output$dataset <- renderDataTable(
        data(), 
        options = list(lengthChange = FALSE,
                       searching = FALSE)
      )
      
      # Print graph
      output$graph <- renderPlot({
        graph_server(id = "graph_free_explore", data = data)
      })
      
    }
  )
}