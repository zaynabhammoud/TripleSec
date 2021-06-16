#' pruneTree
#' pruneTree splits the given data table into training and test data. Then calls calCutOff for the training data
#' and predictTree with the calculated cutOff values of calCutOff and the test data.
#'
#' @param inputData input data table, given by the user (shoud be a data frame)
#' @param pHigh risk-threshold, defined by the user (should be a percentage value!)
#' @param pLow risk-threshold, defined by the user (should be a percentage value!)
#'
#' @return fit, a table with the prediction of each patient to convert
#' @export
#' @examples

pruneTree <-
  function(inputData, pHigh, pLow) {

    n = nrow(inputData) # n equals the amount/length of data given; number of patients

    effective = TRUE #create variable effective is declared equaling True
    result <- NULL #create variable result, which later retains the prediction of the patient conversion risk

    fit <- NULL #create variable fit, which later retains a link to the calculated cutoff value matrix and the effectiveness of the model

    for (k in 1:n){ # for-loop enabling the division of data
      dataTrain <- as.data.frame(inputData[-k,]) #data is divided into training data (all rows except row k)...
      dataTest <- inputData[k,-2] # ... and testing data (only row k)

      fit <- calCutOff(dataTrain, pHigh, pLow) #calculate cutOff values and effectiveness

      if((fit$effective)){ #if effective is true, cut_high > cut_low
        result <- rbind(result, predictTree(fit$cutOff, dataTest)) #combines the previous patient predictions with newly calculated one
      }else{
        print("problem")
      }

    }
    return(result)
  }


