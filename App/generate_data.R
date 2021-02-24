


# -----------------------------------------------------------------
#
# This module generates data based on user inputs.
# This module is called in the main script and used in generating
# the datatable and creating the graph. 
#
# ----------------------------------------------------------------- 

generate_data_server <- function(id, parameters){ 
  moduleServer(
    id,
    function(input, output, session) {
      
      ####-----------------####
      #### Generate x axis ####
      ####-----------------####
      

      x_axis <- reactive(
      if(input$predictor_type == "Categorical"){

        # Creating a list of values from 0 to 1 less than the number of groups, and repeating it as many times as the sample size per group
        x <- rep(c(seq.int(from = 0, to = input$n_groups-1)), each = input$sample_size)

        return(x)
      }

      else if(input$predictor_type == "Continuous"){

        x <- round(rnorm(n = input$sample_size), 2)
        
        return(x)
      }
      )
      
      #####-----------------####
      ##### Generate y axis ####
      #####-----------------####
      
      y_axis <- reactive({
        
        # Categorical IV
        if(input$predictor_type == "Categorical"){
          
          # Create groups 
          group_1 <- mvrnorm(n = input$sample_size, mu = parameters$mean_0(), Sigma = input$within_groups_variance, empirical = TRUE)
          group_2 <- mvrnorm(n = input$sample_size, mu = parameters$mean_1(), Sigma = input$within_groups_variance, empirical = TRUE)
          group_3 <- mvrnorm(n = input$sample_size, mu = parameters$mean_2(), Sigma = input$within_groups_variance, empirical = TRUE)
          group_4 <- mvrnorm(n = input$sample_size, mu = parameters$mean_3(), Sigma = input$within_groups_variance, empirical = TRUE)
          group_5 <- mvrnorm(n = input$sample_size, mu = parameters$mean_4(), Sigma = input$within_groups_variance, empirical = TRUE)
          y <- c(group_1, group_2, group_3, group_4, group_5)
          
          # Calculate total sample size
          total_sample <- input$sample_size * input$n_groups
          
          # Keep only data from the number of groups selected
          y <- y[1:total_sample] 
          
          return(y)
          
        }
        
        # Continuous IV
        else if(input$predictor_type == "Continuous"){
          y <- round(input$intercept + input$slope*x_axis() + mvrnorm(n = input$sample_size,
                                                                      mu = 0, Sigma = input$variance,
                                                                      empirical = TRUE),
                     digits = 2)
          
          return(y)
        }
      })
      
      # Generate ID 
      ID <- reactive({
        if(input$predictor_type == "Categorical"){
          ID <- seq.int(from = 1, to = input$sample_size * input$n_groups)
          return(ID)
        }
        
        else if(input$predictor_type == "Continuous"){
          ID <- seq.int(from = 1, to = input$sample_size)
        }
      })
      
      ####------------------####
      #### Generate dataset ####
      ####------------------####
      
      df <- reactive({
        
        # Categorical IV
        if(input$predictor_type == "Continuous"){
          data <- tibble(
            ID = ID(), 
            x = x_axis(),
            y = y_axis()
          )
          data 
        }
        
        # Categorical IV
        else if(input$predictor_type == "Categorical"){
          data <- tibble(
            ID = ID(), 
            x = x_axis(),
            y = y_axis(),
            group_1 = ifelse(x == 1, 1, 0),
            group_2 = ifelse(x == 2, 1, 0),
            group_3 = ifelse(x == 3, 1, 0),
            group_4 = ifelse(x == 4, 1, 0)
            )
          }
          
          data


        
      })
      
      return(df)
    }
  )
}