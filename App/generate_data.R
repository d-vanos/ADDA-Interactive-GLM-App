

# generate_data_UI <- function(id) {
# 
#   # `NS(id)` returns a namespace function, which was save as `ns` and will
#   # invoke later.
#   ns <- NS(id)
# 
#   tagList(
#     dataTableOutput(ns("dataset"))
#   )
# }

generate_data_server <- function(id){
  moduleServer(
    id,
    function(input, output, session) {
      
      #### Generate data ### 
      # Generate axes
      x <- reactive(
        round(mvrnorm(n = input$sample_size, 
                            mu = 0, 
                            Sigma = input$variance, 
                            empirical = TRUE),
          digits = 2)
        )
      
      y <- reactive(
        round(input$intercept + input$slope*x() + mvrnorm(n = input$sample_size,
                                                mu = 0, Sigma = input$variance,
                                                empirical = TRUE),
        digits = 2)
      )

      
      # Generate regression data
      df <- reactive({
        tibble(
          ID = seq.int(from = 1, to = input$sample_size), # need to change this once I add in groups
          x = x(),
          y = y()
          )
        })
      
      ### Render Table ####
      # output$dataset <- renderDataTable(
      #   data(),
      #   options = list(lengthChange = FALSE,
      #                  searching = FALSE)
      # )
      
      return(df)
    }
  )
}


         