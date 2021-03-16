

# -----------------------------------------------------------------
#
# This code loads all the relevant packages required by the app.
# It also loads the elements and scripts required by the UI.
#
# ----------------------------------------------------------------- 


# Turn off scientific notation
options(scipen = 999)


# -------------------------------------------------------------------------
#
#
# Load libraries 
# 
#
# -------------------------------------------------------------------------

# Note to students: make sure to install these libraries if you 
# do not already have them installed. You can install a library
# like this: 

# install.packages("shiny")


# Shiny libraries
library(shiny)
library(shinydashboard)
library(shinyBS)
library(shinyMatrix) # matrix input
library(shinyjs)     # Hide sections of app
library(rhandsontable)

# Other relevant libraries
library(tidyverse)
library(MASS) # For random data generation with exact means 
library(knitr) # To knit Rmarkdown files









# -------------------------------------------------------------------------
#
#
# Load scripts
# 
#
# -------------------------------------------------------------------------


source("parameters.R") # Contains all possible parameters for free explore
source("model_info.R")
source("display_data.R")
source("debug.R")
source("means.R")
source("equation_info.R")
source("R_model_output.R")
source("generate_data.R") # Generate the data for the table and graph
source("graph.R") # Create the graph 


















