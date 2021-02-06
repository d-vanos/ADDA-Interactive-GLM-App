


graph_UI <- function(id) {

  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)

  tagList(

    plotOutput("graph"),
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
graph_server <- function(id, data){
  moduleServer(
    id,
    function(input, output, session){
      
      
      graph <- ggplot(data = data(), mapping = aes(x = x, y = y)) + 
        geom_point() + 
        stat_smooth(method = "lm") + 
        xlab(label = input$x_axis_label)+ 
        ylab(label = input$y_axis_label)#+ 
        # xlim(0, 10) + 
        # ylim(0, 10)
      
      return(graph)
      
    }
  )
}


