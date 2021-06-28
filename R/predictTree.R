#' predictTree
#' This function predicts the risk of a patient conversion to alzheimers, based
#' on the user given data/parameters and previously calculated cutoff values (calculated in design tree).
#'
#'
#'@param cutOff the calculated cutOff values for each parameter (type: matrix)
#'@param inputData the inputData / patient, that the previously calculated cutOff values are tested on (type: matrix)
#'
#'@return result, variable result with its links to the cutOff matrix and predicted patient information


predictTree <- function(cutOff, inputData) {
  #creates table result with the patient ID and previously calculated parameter predictions
  result <- cbind(inputData$ID, predictTreeRec(cutOff, inputData))
  #sets column names of the created table to ID and used parameter name
  colnames(result) = c("ID", colnames(result)[-1])
  #return the created variable result with its links to the cutOff matrix and predicted patient information
  return(result)
}

#' predictTreeRec
#' This recursive function calculates the cutoff value for each parameter dependent
#' upon the patient ratio, it also verifies if the model is effective (cut_high > cut_low).
#'
#' @param cutOff the calculated cutOff values for each parameter (type: matrix)
#' @param inputData the inputData / patient, that the previously calculated cutOff values are tested on (type: matrix)
#'
#' @return result, variable result with its links to the cutOff matrix and predicted patient information

predictTreeRec <- function(cutOff, inputData) {
  #creates a matrix with cutOff values, given to the function
  cutOffmat <-
    as.matrix(cutOff)

  #biomarker/feature count = count of given data - the first column (patient ID)
  featureCount <-
    dim(inputData)[2]

  #creates variable riskClass, assigning the value NA, unknown
  riskClass <-NA

  #if there is only one last feature left then...
  if (featureCount == 2) {
    # save feature value
    featureValue <- inputData[1, 2]
    # save feature name
    featureName <- colnames(inputData[2])
    # find corresponding cutOff values according to feature name
    featureCutOffs <-
      cutOff[, featureName]

    #if patient feature value is equal or larger than cut_high...
    if (featureValue >= featureCutOffs[2]) {
      #... riskClass = 1, so the patient has a high conversion rate
      riskClass = 1
    } else{
      # if the value is lower than cut_high the patient has a low conversion rate and therefore riskClass = 0
      riskClass = 0
    }

    #create table result with the parameter value and corresponding, calculated, risk class
    result <- cbind(inputData[, -1], riskClass)
    #sets column names for created table: feature name, riskClass
    colnames(result) = c(featureName, "riskClass")
    #return the resulting table result
    return(result)

  }
  #if there are several features left start recursion
  result <-
    #combine the result of all columns except column two
    cbind(predictTreeRec(cutOffmat, inputData[, 1:2]),
          # with the result of column two
          predictTreeRec(cutOffmat, inputData[, -2]))

  #return the resulting table result
  return(result)


}
