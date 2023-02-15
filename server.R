library(shiny)
library(tidyverse)
library(stringr)
library(tm)

one_gram <- na.omit(readRDS("./clean_repos/uni_words.rds"))
two_gram <- na.omit(readRDS("./clean_repos/bi_words.rds"))
three_gram <- na.omit(readRDS("./clean_repos/tri_words.rds"))
four_gram <- na.omit(readRDS("./clean_repos/quad_words.rds"))
five_gram <- na.omit(readRDS("./clean_repos/quint_words.rds"))

dict_look_up <- 1:nrow(one_gram)
names(dict_look_up) <- one_gram$word1
dict_look_up_length <- length(dict_look_up)

##l_up function
l_up <- function(x) {
  for (i in 1:dict_look_up_length) {
    if (names(dict_look_up[i]) == x) {
      return(i)
    }
  }
  return(NULL)
}

predict <- function(input, max = 4) {
  input <- tolower(input)
  input <- removePunctuation(input)
  input <- removeNumbers(input)
  input <- stripWhitespace(input)
  input_split <- unlist(strsplit(input, " "))
  input_length <- length(input_split)
  
  if (input_length == 1) {
    indx_word1 <- (input_split[1])
    bigrams_updated <- head(two_gram[two_gram$word1 == indx_word1,"word2"],n=5)
    if (nrow(bigrams_updated) == 0) {
      res <- paste("No Result Found")
    }
    else {
      res <- head(bigrams_updated, n=5)$word2
    }
  }
  
  if (input_length == 2) {
    indx_word1 <- (input_split[1])
    indx_word2 <- (input_split[2])
    trigrams_updated <- head(three_gram[three_gram$word1 == indx_word1 & three_gram$word2 == indx_word2,"word3"],n=5)
    if (nrow(trigrams_updated) == 0) {
      bigrams_updated <- head(two_gram[two_gram$word1 == indx_word2,"word2"],n=5)
      if (nrow(bigrams_updated) == 0) {
        res <- paste("No Result Found")
      }
      else {
        res <- head(bigrams_updated, n=5)$word2
      }
    }
    else{
      res <- head(trigrams_updated, n=5)$word3
    }
  }
  
  if (input_length == 3) {
    indx_word1 <- (input_split[1])
    indx_word2 <- (input_split[2])
    indx_word3 <- (input_split[3])
    quadgram_updated <- head(four_gram[four_gram$word1 == indx_word1 & four_gram$word2 == indx_word2 & four_gram$word3 == indx_word3,"word4"],n=5)
    if (nrow(quadgram_updated) == 0) {
      trigrams_updated <- head(three_gram[three_gram$word1 == indx_word2 & three_gram$word2 == indx_word3,"word3"],n=5)
      if (nrow(trigrams_updated) == 0) {
        bigrams_updated <- head(two_gram[two_gram$word1 == indx_word3,"word2"],n=5)
        if (nrow(bigrams_updated) == 0) {
          res <- paste("No Result Found")
        }
        else {
          res <- head(bigrams_updated, n=5)$word2
        }
      }else{
        res <- head(trigrams_updated, n=5)$word3
      }
    }else{
      res <- head(quadgram_updated, n=5)$word4
    }
  }
  
  if (input_length == 4) {
    indx_word1 <- (input_split[1])
    indx_word2 <- (input_split[2])
    indx_word3 <- (input_split[3])
    indx_word4 <- (input_split[4])
    
    quintagram_updated <- head(five_gram[five_gram$word1 == indx_word1 & five_gram$word2 == indx_word2 & five_gram$word3 == indx_word3 
                                         & five_gram$word4 == indx_word4,"word5"],n=5)
    
    if (nrow(quintagram_updated) == 0) {
      quadgram_updated <- head(four_gram[four_gram$word1 == indx_word2 & four_gram$word2 == indx_word3 & four_gram$word3 == indx_word4,"word4"],n=5)
      
      if (nrow(quadgram_updated) == 0) {
        trigrams_updated <- head(three_gram[three_gram$word1 == indx_word3 & three_gram$word2 == indx_word4,"word3"],n=5)
        
        if (nrow(trigrams_updated) == 0) {
          bigrams_updated <- head(two_gram[two_gram$word1 == indx_word4,"word2"],n=5)
          
          if (nrow(bigrams_updated) == 0) {
            res <- paste("No Result Found")
          }else {
            res <- head(bigrams_updated, n=5)$word2
          }
        }else{
          res <- head(trigrams_updated, n=5)$word3
        }
      }else{
        res <- head(quadgram_updated, n=5)$word4
      }
    }else{
      res <- head(quintagram_updated, n=5)$word5
    }
  }
  
  next_word <- names(dict_look_up[res])
  next_word
}

server <- function(input, output) {
  output$value1 <- reactive(predict({input$caption})[1])
  output$value2 <- reactive(predict({input$caption})[2])
  output$value3 <- reactive(predict({input$caption})[3])
}