
# -----------------------------------------------------------------
#
# Run this script to update the app.
#
# -----------------------------------------------------------------

# To deploy app
require(rsconnect)
library(readr)

# Read in account details 
account_info <- read_csv("app/account_info.csv")

# Generate details for deployment 
app_name <- "Exploring-the-GLM"
account_name <- as.character(account_info[account_info$info == "account_name", "value"])
token <- as.character(account_info[account_info$info == "account_token", "value"])
secret <- as.character(account_info[account_info$info == "account_secret", "value"])

# Run this if signing in for the first time 
# rsconnect::setAccountInfo(name= account_name,
#                           token= token,
#                           secret= secret)


# Deploy the app
deployApp(appDir = "app", 
          appName = app_name,
          account = account_name)

