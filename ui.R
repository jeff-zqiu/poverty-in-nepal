library(shiny)

fluidPage(
  
  # include the MathJax template
  # includeScript(path = "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML"),
  
  # App title
  titlePanel("SOSC 13220 Final Project - Poverty in Nepal"),
  
  sidebarLayout(
      
      # Sidebar panel for inputs
      sidebarPanel(
        
        withTags({
          div(class="header", checked=NA,
              h3("Spatial Autocorrelation"),
              p("Select variable to perform local spatial correlation analysis.")
          )
        }),
        
        radioButtons("var", "Variable", c("Water Access" = "water", 
                                          "Literacy" = "literacy",
                                          "Food Access" = "hunger"))
      ),
      
      mainPanel(
        
        tabsetPanel(type = "tabs",
                    tabPanel("LISA", plotOutput('LISAcorrelation')),
                    tabPanel("Data", plotOutput("mapData"))
        ),
        # Output: Method 2
        
        
        withTags({
          div(p("Eliminating the possibility of false positive (p<0.05), the maps show that a few areas display strong spatial 
                autocorrelation. The qualitative reason for this spatial distribution remain inconclusive, but the correlation does not 
                seem to be related to the data. As the data visualizations show, the spatially correlated clusters has different data 
                accross the regions."))
        })
      )
        
  ),
  
  # Sidebar layout with input and output definitions
  sidebarLayout(
    
    # Sidebar panel for inputs
    sidebarPanel(
      
      withTags({
        div(class="header", checked=NA,
            h3("Understanding Poverty"),
            p("Adjust the variables to see what contribute the most to poverty.")
        )
      }),
      
      # Input: Sliders
      sliderInput(inputId = "c_water", label = "Percentage population without safe water:", min = 0, max = 5, value = 1.3, step = 0.1),
      sliderInput(inputId = "c_hunger", label = "Percentage of children under age five who are malnourished:", min = 0, max = 5, value = 0.7, step = 0.1),
      sliderInput(inputId = "c_literacy", label = "Adult illiteracy rate:", min = 0, max = 5, value = 3.9, step = 0.1)
      
      

    ),
    
    # Main panel for displaying outputs
    mainPanel(
      
      
      # Output: Method 1
      tabsetPanel(type = "tabs",
        tabPanel("Map", plotOutput("povIdxMap"))),
      
      htmlOutput("povIdxScore"),
      
      withTags({
        div(p("Prediction is calculated by the weighted average of three variables.
              Accuracy is calculated as the percentage difference between prediction and actual income. 
              All variables are normalized through feature scaling."),
            p('The most accurate weight combination for the three variables are (0.5, 1.3, 3.7), with an overall accuracy of 61.11%.
              While a single linear model is hardly accurate, it does provide a perspective between these variables: education
              is a better indicator of income in Nepal than food or water access. A plausible explaination may be that income level can
              increase drastically with better education, while improvement in basic needs may lead to decrease in poverty but no significant
              increase in income level.'),
            p('The model also provide insight into the regional differences. In some regions, giving one factor more wright can leads to 
              better prediction of these regions but worse in others, which may be an indication that the factor plays a more significance 
              role in poverty in these areas than other.'))
      })
      
    )
  )
)