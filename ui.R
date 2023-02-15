library(shinythemes)
  
ui <- navbarPage(theme=shinytheme("readable"),"Coursera's Data Science Capstone: Next Word Prediction App",

    tabPanel("Next Word Predictor",
             div("Next Word Prediction is a Shiny app that uses a text prediction algorithm to predict the next word(s)
                            based on text entered by a user.  The predicted next word will be shown when the app
                            detects that you have finished typing one or more words. When entering text, please allow a few
                            seconds for the output to appear.",
                 br(),
                 br(),
                 br()),

                # Sidebar
                  sidebarPanel(
                    textInput("caption","Please enter a partial phrase of up to 3 words here",value = "I am done!!"),
                  ),
    
                  mainPanel(
                  helpText("The prediction(s) for your next word in order of decreasing probability are:"),
                  verbatimTextOutput("value1"),
                  verbatimTextOutput("value2"),
                  verbatimTextOutput("value3")
                  ),
                ),
  
  tabPanel("About",
           div("Created by Tom G.",
               br(),
               br(),
               "The objective of the Capstone Project is to create an application that can predict next word based on a partial sentence or 
                    phrase entered by user. This concept is similar to ones used in various mobile keyboard applications.",
               br(),
               br(),
               "The application I created uses Natural Language Processing (NLP) techniques to predict the next word. Key model steps include:",
               br(),
                    "     1. Input: raw text files for model training",
               br(),
                    "     2. Clean training data; separate into 2 word, 3 word, and 4 word n grams, save as tibbles",
               br(),
                    "     3. Sort n grams tibbles by frequency, save as repos",
               br(),
                    "     4. N grams function: uses a 'back-off' type prediction model",
               br(),
                    "          - user supplies an input phrase",
               br(),
                    "          - model uses last 3, 2, or 1 words to predict the best 4th, 3rd, or 2nd match in the repos",
               br(),
                  "     5. Output: next word prediction ",
               br()
           ))
  )
  