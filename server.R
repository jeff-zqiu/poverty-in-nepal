library(rgdal)
library(tmap)
library(tidyverse)

# load data
nepal <- readOGR("nepal", "nepal")
nepal$population_n <- as.numeric(as.character(nepal$population))


### Preprocessing

# feature scaling normalization
normalize <- function(df) {
  return ((df-min(df))/(max(df)-min(df)))
}

# preprocessing data
factors <- data.frame(water = normalize(nepal$nosafh20), 
                      hunger = normalize(nepal$malkids), 
                      literacy = normalize(nepal$ad_illit))

income <- 1-normalize(as.numeric(nepal$pcincmp))

server <- function(input, output) {
  
  output$povIdxMap <- renderPlot({
    dinominator <- input$c_water+input$c_hunger+input$c_literacy
    povidx <- (input$c_water*factors$water
               +input$c_hunger*factors$hunger
               +input$c_literacy*factors$literacy)/dinominator
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
  
  
}

