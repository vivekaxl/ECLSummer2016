run_randomForest <- function(indep,dep){
  
  # To use 66% of the total data as training and rest as testing
  
  split_index <- as.integer(nrow(indep) * 0.66)
  
  training.indep <- indep[1:split_index,]
  training.dep <- dep[1:split_index]
  
  testing.indep <- indep[split_index:nrow(indep),]
  testing.dep <- dep[split_index:nrow(indep)]
  
  
  # From http://tinyurl.com/TH-RF-Example 
  my.randomForest <- randomForest(x=training.indep,y=training.dep, importance=TRUE, proximity=TRUE, ntree=25,mtry=4)
  my.randomForest.predict <- predict(my.randomForest, testing.indep)
  len.randomForest.predict <- length(my.randomForest.predict)
  
  my.randomForest.result <- vector()
  my.randomForest.matches <- 0
  
  for ( i in 1:len.randomForest.predict ){
    if ( my.randomForest.predict[i] == testing.dep[i] ){
      my.randomForest.matches <- my.randomForest.matches + 1
    }
  }
  
  return(my.randomForest.matches/len.randomForest.predict)
}

multiple_runs <- function(){
  repeats <- 100
  average_correct <- 0;
  original.golf <- read.csv("Golf.csv", header = T)
  train <- 1:4
  test <- 5
  
  proportion_correct <-vector()
  for( i in 1:repeats){
    # Over sampling the data, so as to have increase the number of instances.
    golf <- original.golf[sample(nrow(original.golf), 20, replace = TRUE),]
    
    # change the dependent variable from numeric to a class variable
    golf$play <- factor(golf$play)
    proportion_correct[i] <- run_randomForest(golf[,train],golf[,test])
    average_correct <- average_correct + proportion_correct[i]
  }
  
  a <- round((average_correct/repeats)*100,digits=1)
  x <- paste("Average correct over ", repeats, " runs is ",a,"%", sep="");
  print(x);
}

# For sake of reproducibility
set.seed(141)

multiple_runs()