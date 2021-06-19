#' calCutOff
#'
#' calCutOff is the function used to calculate the cutoff values for low-risk and high-risk groups.
#' The values of the cutoffs correspond to the given risk-threshold given by the user, pHigh and pLow.
#'
#' @param inputData input data given by the user (type: data.frame)
#' @param pHigh risk-threshold, defined by the user (should be a percentage value!)
#' @param pLow risk-threshold, defined by the user (should be a percentage value!)
#'
#' @return fit, table with the cutoff values and the predictions
#' @export
#' @examples

calCutOff <- function(inputData, pHigh, pLow){ #function which calls the recursive function calCutOffRec
    fit <- NULL #create variable fit
    fit <- calCutOffRec(inputData, pHigh, pLow) #creates fit with the calculated values of all parameters (each parameter cutoff calculated separately in calCutOffRec)
    return(fit)
}

calCutOffRec <- function(inputData, pHigh, pLow) { #recursive function, calculates the cutoff value for each parameter dependent upon the patient ratio, it also verifies if the model is effective (cut_high > cut_low)
  featureCount <- ncol(inputData) - 2 # feature count = column count/feature count of given data -ID and -conversion
  cutOff <- matrix(nrow = 2, ncol = featureCount) #creates matrix with two rows (cutHigh and cutLow), feature count columns
  effective <- TRUE #create variable effective, default true
  if (featureCount == 1) { #if there is only one last feature left then...
    cutHigh = 100
    valueMax = max(inputData[,3]) #calulates maximum value in feature column
    x = valueMax * 0.05 #decrement steps
    portionMaxPat = 1
    while(portionMaxPat >= pHigh){
      conWithValue <- nrow(subset(inputData, inputData$conversion == TRUE & inputData[,3] >= valueMax)) #counts patients who converted to Alzheimers and have a value bigger or equal to valueMax
      nonWithValue <- nrow(subset(inputData, inputData$conversion == FALSE & inputData[,3] >= valueMax)) #counts patients who did NOT convert to Alzheimers and have a value bigger or equal to valueMax
      portionMaxPat <- conWithValue/(nonWithValue + conWithValue) #calculates the proportion between converters with feature-value valueMax and all patients with feature-value valueMax
      valueMax = valueMax - x #subtracts decrement step from value
    }
    cutOff[1,1] = valueMax #fill cutOff matrix with the just calculated cutoff_high value

    cutLow = 0
    valueMin = min(inputData[,3]) #calulates minimum value in feature column
    x = valueMin * 0.05 #increment steps
    portionMinPat = 0
    while(portionMinPat <= pLow){
      conWithValue <- nrow(subset(inputData, inputData$conversion == TRUE & inputData[,3] <= valueMin)) #counts patients who converted to Alzheimers and have a value smaller or equal to valueMin
      nonWithValue <- nrow(subset(inputData, inputData$conversion == FALSE & inputData[,3] <= valueMin)) #counts patients who did NOT convert to Alzheimers and have a value smaller or equal to valueMin
      portionMinPat <- conWithValue/(nonWithValue + conWithValue) #calculates the proportion between converters with feature-value valueMin and all patients with feature-value valueMin
      valueMin = valueMin + x #adds increment step from valueMin
    }
    cutOff[2,1] = valueMin #fill cutOff matrix with the just calculated cutoff_low value
    colnames(cutOff) <- colnames(inputData)[3]
    effective <- valueMin < valueMax #if there is an overlap between cutoff_high and cutoff_low, the model is not effective
    rownames(cutOff) <- c("cut_high","cut_low")
    fit <- NULL #create variable fit
    fit$cutOff <- cutOff #create link between fit and cutoff matrix
    fit$effective <- effective #create link between fit and effective
    return(fit) #return the calculated cutoff values for this parameter

  } #if there are several features left start recursion
  oneFeature <- calCutOffRec(inputData[,1:3], pHigh, pLow)
  otherFeatures <- calCutOffRec(inputData[,-3], pHigh, pLow)
  fit <- NULL #create variable fit
  fit$cutOff <-
    cbind(oneFeature$cutOff, #combine the cutOff values of all features except the second feature
          otherFeatures$cutOff) # with the cutOff value of the second feature
  fit$effective <- oneFeature$effective #create link between fit and effective
  return(fit) #return the resulting table result

}
