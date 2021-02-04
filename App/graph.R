


# graph_UI <- function(id) {
#   
#   # `NS(id)` returns a namespace function, which was save as `ns` and will
#   # invoke later.
#   ns <- NS(id)
#   
#   tagList(
#     
#     plotOutput("graph")
#     
#   )
# }

# Server 
graph_server <- function(id, data){
  moduleServer(
    id,
    function(input, output, session){
      
      graph <- ggplot(data = data(), mapping = aes(x = x, y = y)) + 
        geom_point() + 
        stat_smooth(method = "lm")
      
      return(graph)
      
    }
  )
}

