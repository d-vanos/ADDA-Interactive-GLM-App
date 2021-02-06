
generate_data_server <- function(id){
  moduleServer(
    id,
    function(input, output, session) {
      
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
      df <- reactive(
        tibble(
          ID = seq.int(from = 1, to = input$sample_size), # need to change this once I add in groups 
          x = x(), 
          y = y()
          ) 
        )
      return(df)
    }
  )
}


         