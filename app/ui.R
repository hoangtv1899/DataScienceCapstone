
library(shiny)
library(markdown)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("DATA SCIENCE CAPSTONE - PREDICTING NEXT WORD"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       helpText("Enter a word or a sentence to preview next word prediction"),
       hr(),
       textInput("inputText", "Enter the word/ sentence here", value=""),
       hr()
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       h2("The predicted next word at this box:"),
       verbatimTextOutput("prediction"),
       strong("You entered:"),
       strong(code(textOutput('sentence1'))),
       br(),
       strong("Using search at n-grams to show the next word:"),
       strong(code(textOutput('sentence2'))),
       hr(),
       hr(),
       hr(),
       img(src='swiftkey_logo.jpg',height=50,width=250),
       img(src='jhu_logo.jpg',height=100,width=250),
       hr(),
       hr(),
       img(src='coursera_logo.png',height=122,width=467),
       hr()
    )
  )
))
