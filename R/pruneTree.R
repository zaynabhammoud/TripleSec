#' pruneTree
#' This function divides the given input data frame into training and test data.
#' It calls the function \code{\link{calCutOff}} for the training data, which
#' returns a matrix containing the calculated cut off values. Using this matrix
#' and the test data, pruneTree then calls \code{\link{predictTree}} for the
#' test data. \code{\link{predictTree}} returns the risk assessment for the test
#' data to pruneTree.
#'
#' @param inputData input data table, given by the user (shoud be a data frame)
#' @param pHigh risk-threshold, defined by the user (should be a percentage value!)
#' @param pLow risk-threshold, defined by the user (should be a percentage value!)
#'
#' @return result, a variable with a link to the average cutoff values for each feature and a table data with the patients and feature and their risk assessment


pruneTree <-
  function(inputData, pHigh, pLow) {
    # n equals the amount/length of data given; number of patients
    n = nrow(inputData)

    #create variable effective is declared equaling True
    effective = TRUE

    #create empty cutoff table with two rows (cutHigh and cutLow), one column for each feature
    cutOff <- matrix(0L, nrow = 2, ncol = ncol(inputData) - 2)
    #name columns (feature names)
    colnames(cutOff) <- colnames(inputData)[3:ncol(inputData)]
    #name rows (cut_high, cut_low)
    rownames(cutOff) <- c("cut_high", "cut_low")

    #create variable result, which later retains the prediction of the patient conversion risk
    result <- NULL

    #create data
    data <- NULL
    #create link between result and data
    result$data <- data
    #create link beween result and cutOff table
    result$cutOff <- cutOff

    #create variable fit, which later retains a link to the calculated cutoff value matrix and the effectiveness of the model
    fit <- NULL

    #create link between fit and cutoff matrix
    fit$cutOff <- cutOff

    #create variable values
    values <- NULL

    # for-loop enabling the division of data
    for (k in 1:n){
      #data is divided into training data (all rows except row k)...
      dataTrain <- as.data.frame(inputData[-k,])
      # ... and testing data (only row k)
      dataTest <- inputData[k,-2]


      #calculate cutOff values and effectivenes
      values <- calCutOff(dataTrain, pHigh, pLow)

      #added cutOff values of each for loop
      fit$cutOff <- as.matrix(fit$cutOff + values$cutOff)
      #print(fit$cutOff)
      #if effective is true, cut_high > cut_low
      if((values$effective)){
        #combines the previous patient predictions with newly calculated one
        result$data <- rbind(result$data, predictTree(values$cutOff, dataTest))
      }else{
        #if there is an overlap, print problem - emercency solution
        print("problem")
      }

    }
    #create a link between result and the calculated average of cut_high and cut_low values
    result$cutOff <- fit$cutOff / n

    #return result with a link to the average cutoff values for each feature, as well as the data with each patient and feature risk assesment
    return(result)
  }


