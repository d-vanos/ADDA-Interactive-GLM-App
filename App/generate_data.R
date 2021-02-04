
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
      df <- reactive(tibble(x = x(), 
                            y = y()))
      return(df)
      
    }
  )
}