


graph_UI <- function(id) {

  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)

  tagList(
    
    textOutput(ns("regress")),
    plotOutput(ns("graph_render")),
    column(width = 6,
           textInput(input = ns("y_axis_label"),
                     label = "Y axis label",
                     value = "y")),
    column(width = 6,
           textInput(input = ns("x_axis_label"),
                     label = "X axis Label",
                     value = "x"))
  )
}

# Server 
graph_server <- function(id, data, regression){
  moduleServer(
    id,
    function(input, output, session){
      
      output$regress <- renderText({
        regression()
      })
      
      # Select whether regression line is shown based on user input 
      regression_line_shown <- reactive({
        
        # Create the base graph
        graph <- ggplot(data = data(), mapping = aes(x = x, y = y)) +
          geom_point() +
          xlab(label = input$x_axis_label) 
        
        # Add a regression line if this is selected, else return the original graph
        if(regression() == TRUE){
            graph <- graph + 
            stat_smooth(method = "lm")
            return(graph)
        }
        else if(regression() == FALSE){
          return(graph)
        }
      })
      
      # Render the graph 
      output$graph_render <- renderPlot({
        regression_line_shown()
      })

    }
  )
}


