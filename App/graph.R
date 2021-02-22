
# -----------------------------------------------------------------
#
# This module creates the graph, renders it, and displays it on 
# the 'Visualising the GLM' page. 
#
# ----------------------------------------------------------------- 


graph_UI <- function(id) {

  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)

  tagList(
    
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
graph_server <- function(id, data, regression, predictor_type){
  moduleServer(
    id,
    function(input, output, session){
      
      # Select whether regression line is shown based on user input 
      graph <- reactive({
        
        # Create the base graph
        graph <- ggplot(data = data(), mapping = aes(x = x, y = y)) +
          geom_point(colour = "red") +
          xlab(label = input$x_axis_label) +
          ylab(label = input$y_axis_label) + 
          ylim(0, 20)
        
        # Add a regression line if this is selected, else return the original graph
        if(regression() == TRUE){
            graph <- graph + 
            stat_smooth(method = "lm")
            
        }
        
        # Add x range
        if(predictor_type() == 'Continuous'){
          graph <- graph +
            xlim(-4, 4)
          
        }
        else if (predictor_type() == 'Categorical'){
          graph <- graph +
            xlim(0, 4)
          

        }
        
        return(graph)
      })
      
      # Render the graph 
      output$graph_render <- renderPlot({
        graph()
      })

    }
  )
}


