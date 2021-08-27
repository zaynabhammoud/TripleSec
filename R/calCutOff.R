#' calCutOff
#'
#' This function is used to calculate the cut off values for low-risk and
#' high-risk groups. The values are calculated by the proportion between
#' converters with a value and all patients having this certain value
#' corresponding with the given pHigh and pLow values. For each feature cutoff
#' calculation all patients that have not been categorized into the high or low
#' risk categories will be used.
#'
#' @param inputData input data given by the user (type: data.frame)
#' @param pHigh risk-threshold, defined by the user (type: double, value between 0 and 1)
#' @param pLow risk-threshold, defined by the user (type: double, value between 0 and 1)
#'
#' @return fit, a variable which contains links to the calculated cutOff table, filtered data and effectiveness of the cutOff values

calCutOff <- function(inputData, pHigh, pLow){

  #create variable featureCount which contains the amount of features given (all columns minus the ID and conversion column)
  featureCount <- ncol(inputData) - 2

  #create variable fit (return variable which contains links to the calculated cutOff table, filtered data and effectivness of the cutOff values)
  fit <- NULL

  #create a cutOff matrix, filled with 0 (which will later contain the cutOff values for each feature)
  cutOff <- matrix(0L, nrow = 2, ncol = featureCount)
  #add column names to the cutoff matrix
  colnames(cutOff) <- colnames(inputData[,3:ncol(inputData)])
  #add row names to the cutoff matrix
  rownames(cutOff) <- c("cut_high", "cut_low")

  #create variable containing not-categorized patients
  data <- inputData

  #create variable effective (default = TRUE; TRUE, there is NO overlap between cutHigh and cutLow, FALSE, there is an overlap between pHigh and pLow)
  effective <- TRUE

  for(i in 1:featureCount){
    #calculate the maximum feature value
    valueMax = max(data[,3])
    #calculate 5% of this max value as decrease steps
    dec = valueMax * 0.05
    #add dec once before the loop
    valueMax = valueMax + dec

    #calculate the minimum feature value
    valueMin = min(data[,3])
    #calculate 5% of this min value as increase steps
    inc = valueMin * 0.05
    #subtract inc once before the loop
    valueMin = min(data[,3]) - inc

    #portion of converters with feature-value valueMax and all patients with feature-value valueMax, currently 100%
    portionMaxPat = 1

    #portion of converters with feature-value valueMin and all patients with feature-value valueMin, currently 0%
    portionMinPat = 0

    #while loop, decreasing the value of valueMax until the portion of converters divided by all patients having the value is less than pHigh and valueMax is still higher than valueMin
    while(portionMaxPat >= pHigh & valueMax > valueMin){
      #decrease valueMax
      valueMax <- valueMax - dec
      #calculate the amount of patients who convert to Alzheimers and have the value valueMax or higher
      conWithValue <- nrow(data[which(data$conversion == TRUE & data[,3] >= valueMax),])
      #calculates the amount of patients that have the value valueMax or higher
      allWithValue <- nrow(data[which(data[,3] >= valueMax),])
      #recalculates the portion of converters with feature-value valueMax and all patients with feature-value valueMax
      portionMaxPat <- conWithValue / allWithValue
    }

    #enter the calculated cutoff_high value into the feature column and first row
    cutOff[1, i] = valueMax

    #while loop, increasing the value of valueMin until the portion of converters divided by all patients having the value is higher than pLow and valueMin is still smaller than the maximum value in the column
    while(portionMinPat <= pLow & max(data[,3]) > valueMin){
      #increase valueMin
      valueMin <- valueMin + inc
      #calculate the amount of patients who convert to Alzheimers and have the value valueMin or lower
      conWithValue <- nrow(data[which(data$conversion == TRUE & data[,3] <= valueMin),])
      #calculates the amount of patients that have the value valueMin or lower
      allWithValue <- nrow(data[which(data[,3] <= valueMin),])
      #recalculates the portion of converters with feature-value valueMin and all patients with feature-value valueMin
      portionMinPat <- conWithValue / allWithValue

    }


    #enter the calculated cutoff_low value into the feature column and second row
    cutOff[2, i] = valueMin

    #patients that have values bigger than cutoff_low and smaller than cutoff_high
    data <- data[which(data[,3] > valueMin & data[,3] < valueMax),]
    #all not-categorized patients excluding one feature
    data <- data[,-3]

    #check effectiveness of cutoff values, is valueMin smaller than valueMax
    effective <- valueMin < valueMax

  }
  #create links between fit and ...
  # ...cutOff table
  fit$cutOff <- cutOff
  # ...filtered data
  fit$data <- data
  # ...effective
  fit$effective <- effective

  #return fit, with its links
  return(fit)
}

