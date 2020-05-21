
library(shiny)
library(leaflet)
library(formattable)
library(tidyr)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Brazilian Grain Production"),

    # Dropdown list with input list for type of grain
    sidebarLayout(
        sidebarPanel("The goal of this app is to monitor the progress of
                     Brazilian grain harvest. Choose from the dropdown list
                     below the grain of interest to render the map with crop
                     location and quantity.",
           selectInput("grains", # name of the dropdown list
                       "Grains:", # label of the drop down list
                       choices = c("Corn", "Soybeans", "Wheat")) # list of crops
                                                                 # in the dropdown
        ),

        # Show a Leaflet map of the grain production per state
        mainPanel(
            leafletOutput("mapCrop"), # output rendered by the app.
            p()
        )
    )
))
