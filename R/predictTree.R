#' predictTree
#' This function predicts the risk of a patient conversion to alzheimers, based
#' on the user given data/parameters and previously calculated cutoff values (calculated in design tree).
#'
#'
#'@param cutOff the calculated cutOff values for each parameter (type: matrix)
#'@param inputData the inputData / patient, that the previously calculated cutOff values are tested on (type: matrix)
#'
#'@return result, matrix including the patient and prediction of their conversion risk (riskClass)
#'@export
#'@examples


predictTree <- function(cutOff, inputData) { #function which calls the recursive function predictTreeRec
  result <- cbind(inputData$ID, predictTreeRec(cutOff, inputData)) #creates table result with the patient ID and previously calculated parameter predictions
  colnames(result) = c("ID", colnames(result)[-1]) #sets column names of the created table to ID and used parameter name
  return(result)
}

predictTreeRec <- function(cutOff, inputData) { #recursive function, calculates the risk of conversion to alzheimers for each given parameter
  cutOffmat <-
    as.matrix(cutOff) #creates a matrix with cutOff values, given to the function
  featureCount <-
    dim(inputData)[2]  #biomarker/feature count = count of given data - the first column (patient ID)

  riskClass <-
    100 #creates variable riskClass, assigning the value 100, value not equal to 0 or 1

  if (featureCount == 2) { #if there is only one last feature left then...
    featureValue <- inputData[1, 2] # save feature value
    featureName <- colnames(inputData[2]) # save feature name
    featureCutOffs <-
      cutOff[, featureName] # find corresponding cutOff values according to feature name

    if (featureValue >= featureCutOffs[2]) {
      #if patient feature value is equal or larger than cut_high...
      riskClass = 1 #... riskClass = 1, so the patient has a high conversion rate
    } else{
      riskClass = 0 # if the value is lower than cut_high the patient has a low conversion rate and therefore riskClass = 0
    }

    result <- cbind(inputData[, -1], riskClass) #create table result with the parameter value and corresponding, calculated, risk class
    colnames(result) = c(featureName, "riskClass") #sets column names for created table: feature name, riskClass
    return(result) #return the resulting table result

  } #if there are several features left start recursion
  result <-
    cbind(predictTreeRec(cutOffmat, inputData[, 1:2]), #combine the result of all columns except column two
          predictTreeRec(cutOffmat, inputData[, -2])) # with the result of column two
  return(result) #return the resulting table result


}
