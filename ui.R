library(shiny)

# Define UI for application that draws a histogram
fluidPage(
  
  # include the MathJax template
  includeScript(path = "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML"),
  
  # App title ----
  titlePanel("SOSC 13220 Final Project"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      withTags({
        div(class="header", checked=NA,
            h3("Understanding Poverty"),
            p("Adjust the variables to see what contribute the most to poverty.")
        )
      }),
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "c_water", label = "Percentage population without safe water:", min = 0, max = 5, value = 1.3, step = 0.1),
      sliderInput(inputId = "c_hunger", label = "Percentage of children under age five who are malnourished:", min = 0, max = 5, value = 0.7, step = 0.1),
      sliderInput(inputId = "c_literacy", label = "Adult illiteracy rate:", min = 0, max = 5, value = 3.9, step = 0.1)
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      

      
      # Output: Histogram ----
      plotOutput("povIdxMap"),
      
      htmlOutput("povIdxScore"),
      
      withTags({
        div(p("Prediction is calculated by the weighted average of three variables.
              Accuracy is calculated as the percentage difference between prediction and actual income. 
              All variables are normalized through feature scaling."),
            p('The most accurate weight combination for the three variables are (1.3, 0.7, 3.9), with an overall accuracy of 60.37%.
              While a single linear model is hardly accurate, it does provide a perspective between these variables: education
              is a better indicator of income in Nepal than food or water access. A plausible explaination may be that income level can
              increase drastically with better education, while improvement in basic needs may lead to decrease in poverty but no significant
              increase in income level.'),
            p('For a better non-spatial model, a deep neural network could be helpful when making prediction across multiple variables. 
              This specific dataset, however, may not have enough observations to support a training set.'))
        # div(p("1.3, 0.7, 3.9"))
      })
      
    )
  )
)