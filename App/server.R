
#

library(shiny)
library(MASS) # For random data generation with exact means 

# Define server
shinyServer(function(input, output) {
  
  group_1 <- reactive(mvrnorm(n = input$sample_size, mu = input$mean_1, Sigma = input$within_groups_variance, empirical = TRUE))
  group_2 <- reactive(mvrnorm(n = input$sample_size, mu = input$mean_2, Sigma = input$within_groups_variance, empirical = TRUE))
  # group_3 <- reactive(mvrnorm(n = input$sample_size, mu = input$mean_3, Sigma = input$within_groups_variance, empirical = TRUE))
  # group_4 <- reactive(mvrnorm(n = input$sample_size, mu = input$mean_4, Sigma = input$within_groups_variance, empirical = TRUE))
  # group_5 <- reactive(mvrnorm(n = input$sample_size, mu = input$mean_5, Sigma = input$within_groups_variance, empirical = TRUE))
  
  sample_size <- reactive(input$sample_size)
  n_groups <- reactive(input$n_groups - 1)
  y <-  c(group_1, group_2)#, group_3, group_4, group_5)
  
  # Create dataset 
  df <- reactive(tibble(group_n = as_factor(rep(c(0:1), each = reactive(input$sample_size)))))#,
                        #y = y))
  
  # Print dataset 
  output$dataset <- renderDataTable(
    df(), 
    options = list(lengthChange = FALSE,
                   searching = FALSE),
    rownames = FALSE
  )
  
  # Print data 
  output$data <- renderText(
    as.character(group_1)
  )
  
  # Print graph
  output$graph <- renderPlot({
    reactive(ggplot(data = df, mapping = aes(x = group_n, y = y)) + 
      geom_point()) 
  })

})
