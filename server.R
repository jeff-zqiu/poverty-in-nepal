library(rgdal)
library(tmap)
library(tidyverse)
library(ncf)

# load data
nepal <- readOGR("nepal", "nepal")
nepal$population_n <- as.numeric(as.character(nepal$population))


### Preprocessing

# feature scaling normalization
normalize <- function(df) {
  return ((df-min(df))/(max(df)-min(df)))
}

# normalized variables
v <- data.frame(water = normalize(nepal$nosafh20), 
                hunger = normalize(nepal$malkids), 
                literacy = normalize(nepal$ad_illit))
income <- 1-normalize(as.numeric(nepal$pcincmp))

# find center of each region and covert SpatialPolygon to SpatialPointsDataFrame
nepal.cent <- gCentroid(nepal,byid = TRUE)
nepal.cent <- SpatialPointsDataFrame(nepal.cent@coords, data.frame(income, v), proj4string = nepal.cent@proj4string)


### Server logic
server <- function(input, output) {
  
  output$povIdxMap <- renderPlot({
    dinominator <- input$c_water+input$c_hunger+input$c_literacy
    povidx <- (input$c_water*v$water
               +input$c_hunger*v$hunger
               +input$c_literacy*v$literacy)/dinominator
    nepal$predictedpvt<- abs(income - povidx)*100
    povertyIdxMap <- 
      tm_shape(nepal) + 
      tm_borders(alpha=0.3) + 
      tm_layout(title= '% Difference between Prediction and Actual Income', 
                title.position = c('right', 'top'), 
                legend.position = c('left', 'bottom'),frame = FALSE) +
      tm_fill("predictedpvt", palette = "Blues", style = "fixed", breaks=c(0, 10, 20, 30, 40), title = "Percentage %")
    
    output$povIdxScore <- renderText({
      paste("<p><b>Overall prediction accuracy: ", round(100-(mean(nepal$predictedpvt)/mean(povidx)), 2), '%</b></p>')
    })
    
    povertyIdxMap
  })
  
  output$mapData <- renderPlot({
    nepal$flex_data <- v[[input$var]]
    tm_shape(nepal) +
      tm_fill('flex_data', palette = "Blues", style = "jenks", title = "Value") +
      tm_borders(alpha=0.3) +
      tm_layout(title= input$var, title.position = c('right', 'top'), legend.position = c('left', 'bottom'),frame = FALSE)
  })
  
  output$LISAcorrelation <- renderPlot({

    lisa_result <- lisa(nepal.cent@coords[,1],nepal.cent@coords[,2], nepal.cent@data[[input$var]], neigh=4)

    nepal$lisa_correlation <- ifelse (abs(lisa_result$p)<0.05, lisa_result$correlation ,NaN)

    tm_shape(nepal) +
      tm_fill("lisa_correlation", palette = "Spectral", style = "jenks", title = "Correlation", midpoint=0) +
      tm_borders(alpha=0.3) +
      tm_layout(title= 'LISA Cluster Map', title.position = c('right', 'top'), legend.position = c('left', 'bottom'),frame = FALSE)
  })
  
}

