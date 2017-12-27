
library(shiny)
library(stringr)
library(tm)

#load two-gram, three-gram, and four-gram words matrix frequencies
if (FALSE) {
bg <- readRDS('twogram.RData')
tg <- readRDS('threegram.RData')
qg <- readRDS('fourgram.RData')
}
bg <- readRDS('two_gram_new.RData')
tg <- readRDS('three_gram_new.RData')
qg <- readRDS('four_gram_new.RData')
message <- ""

if (FALSE) {
#arrange them into data frame
#two-gram
bg <- data.frame(table(bg))
bg <- bg[order(bg$Freq, decreasing = TRUE),]
names(bg) <- c("words","freq")
bg$words <- as.character(bg$words)
str2 <- strsplit(bg$words, split=" ")
bg <- transform(bg,
                one=sapply(str2,"[[",1),
                two=sapply(str2,"[[",2))
bg <- data.frame(w1=bg$one, w2=bg$two,
                 freq=bg$freq, stringsAsFactors = FALSE)

#three-gram
tg <- data.frame(table(tg))
tg <- tg[order(tg$Freq, decreasing = TRUE),]
names(tg) <- c("words","freq")
tg$words <- as.character(tg$words)
str3 <- strsplit(tg$words, split=" ")
tg <- transform(tg,
                one=sapply(str3,"[[",1),
                two=sapply(str3,"[[",2),
                three=sapply(str3,"[[",3))
tg <- data.frame(w1=tg$one, w2=tg$two,w3=tg$three,
                 freq=tg$freq, stringsAsFactors = FALSE)

#four-gram
qg <- data.frame(table(qg))
qg <- qg[order(qg$Freq, decreasing = TRUE),]
names(qg) <- c("words","freq")
qg$words <- as.character(qg$words)
str4 <- strsplit(qg$words, split=" ")
qg <- transform(qg,
                one=sapply(str4,"[[",1),
                two=sapply(str4,"[[",2),
                three=sapply(str4,"[[",3),
                four=sapply(str4,"[[",4))
qg <- data.frame(w1=qg$one, w2=qg$two,w3=qg$three,w4=qg$four,
                 freq=qg$freq, stringsAsFactors = FALSE)
}
#function predicting the next word
nextWord <- function(inputPhrase) {
  #cleansing the input
  input <- tolower(inputPhrase)
  input <- removePunctuation(input, preserve_intra_word_dashes=TRUE)
  input <- removeNumbers(input)
  input <- stripWhitespace(input)
  #splitting the input into list
  words <- strsplit(input," ")[[1]]
  n <- length(words)
  if (n==1) {
    input2 <- as.character(tail(words,1))
    Bigram(input2)
  }
  else if (n==2) {
    input2 <- as.character(tail(words,2))
    Trigram(input2)
  }
  else if (n>=3) {
    input2 <- as.character(tail(words,3))
    Quadgram(input2)
  }
}

#function Bigram
Bigram <- function(input) {
  if (identical(character(0),as.character(head(bg[bg$w1==input[1],2],1)))){
    message <<- "If no word found the most used word 'just' in English will be returned"
    as.character(head("just",1))
  }
  else {
    message <<- "Predicting the next word using two-gram frequency matrix"
    as.character(head(bg[bg$w1==input[1],2],1))
  }
}
#function Trigram
Trigram <- function(input) {
  if (identical(character(0),as.character(head(tg[tg$w1==input[1] &
                                                  tg$w2==input[2],3],1)))) {
    as.character(nextWord(input[2]))
  }
  else {
    message <<- "Predicting the next word using three-gram frequency matrix"
    as.character(head(tg[tg$w1==input[1] &
                           tg$w2==input[2],3],1))
  }
}
#function Quadgram
Quadgram <- function(input) {
  if (identical(character(0),as.character(head(tg[tg$w1==input[1] &
                                                  tg$w2==input[2] &
                                                  tg$w2==input[3],4],1)))) {
    as.character(nextWord(paste(input[2],input[3],sep=" ")))
  }
  else {
    message <<- "Predicting the next word using four-gram frequency matrix"
    as.character(head(tg[tg$w1==input[1] &
                         tg$w2==input[2] &
                         tg$w3==input[3],4],1))
  }
}

# Shiny Server
shinyServer(function(input, output) {
   
  output$prediction <- renderPrint({
    result <- nextWord(input$inputText)
    output$sentence2 <- renderText({message})
    result
  });
  output$sentence1 <- renderText({
    input$inputText
  });
  
})
