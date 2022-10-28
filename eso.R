library(shiny)
#if(!require(shinysurveys)){install.packages("shinysurveys",force=T)}
#if(!require(googlesheets4)){install.packages("googlesheets4")}
invisible("https://www.jdtrat.com/blog/connect-shiny-google/")

#googledrive::drive_auth() 
#googlesheets4::gs4_auth() 

#list.files( paste0(getwd(),"/.secrets/"))
# google_df <-
# googlesheets4::gs4_create(name = "encuesta", 
#                           # Create a sheet called main for all data to 
#                           # go to the same place
#                           sheets = "main", locale = "es_ES")
# googledrive::drive_get("encuesta")$id
# 


# Define shiny server
server <- function(input, output, session) {
  renderSurvey()
  
  observeEvent(input$submit, {
    response_data <- getSurveyData()
    
    # Read our sheet
    values <- read_sheet(ss = sheet_id, 
                         sheet = "main")
    
    # Check to see if our sheet has any existing data.
    # If not, let's write to it and set up column names. 
    # Otherwise, let's append to it.
    
    if (nrow(values) == 0) {
      sheet_write(data = response_data,
                  ss = sheet_id,
                  sheet = "main")
    } else {
      sheet_append(data = response_data,
                   ss = sheet_id,
                   sheet = "main")
    }
    
  })
  
}


library(shiny)
library(shinysurveys)
library(googledrive)
library(googlesheets4)

options(
  # whenever there is one account token found, use the cached token
  gargle_oauth_email = TRUE,
  # specify auth tokens should be stored in a hidden directory ".secrets"
  gargle_oauth_cache = "./secrets"
)

# Get the ID of the sheet for writing programmatically
# This should be placed at the top of your shiny app
sheet_id <- drive_get("encuesta")$id

# Define questions in the format of a shinysurvey
survey_questions <- data.frame(
  question = c("What is your favorite food?",
               "What's your name?"),
  option = NA,
  input_type = "text",
  input_id = c("favorite_food", "name"),
  dependence = NA,
  dependence_value = NA,
  required = c(TRUE, T)
)

# Define shiny UI
ui <- fluidPage(
  surveyOutput(survey_questions,
               survey_title = "Tamizaje de introducción al Taller de Profundización de R",
               survey_description = "Servirá para saber cuáles son sus intereses y cuánto saben de las temáticas a abordar",
               theme = "#DD3333")
)

# Define shiny server
server <- function(input, output, session) {
  renderSurvey()
  
  observeEvent(input$submit, {
    response_data <- getSurveyData()
    
    # Read our sheet
    values <- read_sheet(ss = sheet_id, 
                         sheet = "main")
    
    # Check to see if our sheet has any existing data.
    # If not, let's write to it and set up column names. 
    # Otherwise, let's append to it.
    
    if (nrow(values) == 0) {
      sheet_write(data = response_data,
                  ss = sheet_id,
                  sheet = "main")
    } else {
      sheet_append(data = response_data,
                   ss = sheet_id,
                   sheet = "main")
    }
    
  })
  
}

# Run the shiny application
shinyApp(ui, server)

shinyApp(ui = ui, server = server)