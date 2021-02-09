

# -----------------------------------------------------------------
#
# This code loads all the relevant packages required by the app.
# It also loads the elements and scripts required by the UI.
#
# ----------------------------------------------------------------- 






# -------------------------------------------------------------------------
#
#
# Load libraries 
# 
#
# -------------------------------------------------------------------------

# Shiny libraries
library(shiny)
library(shinydashboard)
library(shinyBS)

# Other relevant libraries
library(tidyverse)
library(MASS) # For random data generation with exact means 
library(knitr) # To knit Rmarkdown files








# -------------------------------------------------------------------------
#
#
# Load scripts for the UI 
# 
#
# -------------------------------------------------------------------------


source("parameters.R") # Contains all possible parameters for free explore
source("model_info.R")
source("display_data.R")



# -------------------------------------------------------------------------
#
#
# Load scripts for the server 
# 
#
# -------------------------------------------------------------------------

source("generate_data.R") # Generate the data for the table and graph
source("graph.R") # Create the graph 


















