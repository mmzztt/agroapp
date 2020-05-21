##DATA PROCESSING AND SERVER.R FUNCTION

# Load required packages
library(formattable)
library(tidyr)
library(leaflet)
library(shiny)

# Load the data

grains <- read.csv("grains.csv") # dataset grain production (corn, soybeans, wheat)
cane <- read.csv("Sugarcane_production.csv") # alternative dataset to import info

# Data processing
grains <- as.data.frame(grains) # creates a data frame with variables of interesse
grains <- grains[, c(1,4,5,6)]  # for grains.
names(grains) <- c("Code", "Corn", "Soybeans", "Wheat")

cane <- as.data.frame(cane)
cane <- cane[, -(2)]

crops <- merge(cane, grains, by = "Code") # creates new data frame with all
# information of the two sets

longCrops <- crops[,c(7:9)] # transform the dataset from short to long form
gatherCrops <- longCrops %>% gather("Grains", "Production")

# Creates a new column to assign colors according grain type 
gatherCrops$Color <- ifelse(gatherCrops$Grains == "Corn", "darkgreen",
                            ifelse(gatherCrops$Grains == "Soybeans", "darkorchid",
                                   "darkorange"))

# Add new colums from the crop dataset
gatherCrops$Code <- crops[,1]
gatherCrops$State <- crops[,2]
gatherCrops$lat <- crops[,3]
gatherCrops$lng <- crops[,4]

agroApp <- gatherCrops # final dataset

# Server.R

# Define server logic required to create Leaflet map
shinyServer(function(input, output) {
    
    observe({           # creates a reactive expression in that it can read reactive
                        # values and call reactive expressions, and will automatically
                        # re-execute when those dependencies change
        # sets up a special reactive context that automatically tracks what inputs
        #the output uses
        output$mapCrop <- renderLeaflet({  
        # filter de dataset according the input selected in the dropdownlist
        agroSub <-subset(agroApp, agroApp$Grains == input$grains)
        # create an interactive map that displays crop data for each type of grain
        agroSub %>%
            leaflet() %>%
            addTiles() %>%
            addCircles(weight = 2, radius = sqrt(as.numeric(agroSub$Production))*90,
                       lat=agroSub$lat, lng = agroSub$lng, color = agroSub$Color,
                       popup = paste(input$grains, "Production (tons):",
                                     comma(agroSub$Production, digits = 0))) %>% 
            addLegend(labels = c("Corn", "Soybeans", "Wheat"),
                      colors = c("darkgreen", "darkorchid", "darkorange"))
        })
    })
}
)

    