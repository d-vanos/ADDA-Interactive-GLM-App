


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
        x <- rep(c(seq.int(from = 0, to = input$n_groups-1)), each = input$sample_size * input$n_variables)

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
          
          if(input$n_variables == 1){

              y <- as.vector(                               # Create single list, rather than a matrix
                  mapply(                                   # Create groups with user specified means
                    mvrnorm, 
                    n = input$sample_size, 
                    mu = c(parameters$mean_0(),             # Iterating over a list of group means 
                           parameters$mean_1(),  
                           parameters$mean_2(),  
                           parameters$mean_3(),  
                           parameters$mean_4()),
                    Sigma = input$within_groups_variance, 
                    empirical = TRUE)
                )
            }
          
          else if(input$n_variables == 2){
          
            y <- as.vector(                               # Create single list, rather than a matrix
              mapply(                                     # Create groups with user specified means
                mvrnorm, 
                n = input$sample_size, 
                mu = as_vector(                           # Creates a list from the dataframe
                  as.data.frame(                          # Creates a dataframe from an R object
                    hot_to_r(                             # Creates an R object from a htmlwidget
                      parameters$factorial_anova()        # User-specified factorial ANOVA means
                      )
                    )
                  ),
                Sigma = input$within_groups_variance, 
                empirical = TRUE)
            )
            
            
          }
          
          # Calculate total sample size
          total_sample <- input$sample_size * input$n_groups * input$n_variables
          
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
          ID <- seq.int(from = 1, to = input$sample_size * input$n_groups * input$n_variables)
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
        
        # Continuous IV
        if(input$predictor_type == "Continuous"){
          data <- tibble(
            ID = ID(), 
            x = x_axis(),
            y = y_axis()
          )
        }
        
        # Categorical IV (one predictor)
        else if(input$predictor_type == "Categorical" & input$n_variables == 1){
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
        
        # Categorical IV (two predictors)
        else if(input$predictor_type == "Categorical" & input$n_variables == 2){
          data <- tibble(
            ID = ID(), 
            x = x_axis(),
            #var_2 = rep(x = c(0:(input$n_groups - 1)), (input$sample_size * 2)),
            var_2 = rep(rep(c(seq.int(from = 0, to = 1)), each = input$sample_size), input$n_groups),
            y = y_axis(),
            group_1 = ifelse(x == 1, 1, 0),
            group_2 = ifelse(x == 2, 1, 0),
            group_3 = ifelse(x == 3, 1, 0),
            group_4 = ifelse(x == 4, 1, 0)
          )
        }


        
      })
      
      return(df)
    }
  )
}