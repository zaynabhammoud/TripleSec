#' one prune tree
#'
#' one prune tree splits the given data and data parameters into training and test data.
#' The training data is used to calculate the cutoff values (via function design tree). Afterwards the test data and parameters,
#' as well as the calculated cutoff values are used to predict the risk of each patient (via function predict tree).
#'
#' @param inputData input data given from the user ;used to be y
#'
#' @param inputParam input parameters, given by user,
#' amount of (min. 2)/names should remain open, to allow user to define them themselves, dependent on availability
#' and need; used to be X (f.ex. support for MS instead of AD etc.)
#'
#' @param seq sequence
#'
#' @param pHigh risk-threshold p_high, user defined, needed to calculate the cutoff value; used to be alpha.left
#' @param pLow risk-threshold p_low, user defined, needed to calculate the cutoff value; used to be alpha.right
#'
#' @return fit, table with the prediction for the patients
#' @export
#' @examples

CV.one.prune.tree <-
  function(inputData,
           inputParam,
           seq,
           pHigh,
           pLow) {

    n <- length(inputData) # n = how much data was given

    data <- data.frame(inputData, inputParam, ID = 1:n) # table is created with the input data and parameters

    result <- NULL # variable result is declared equaling NULL

    effective = TRUE #variable effective is declared equaling True, gibt es ein overlap

    for (k in 1:n) { # given data (input data combined with input parameters) is divided into training and testing data
      dataTrain <- as.data.frame(data[-k,])
      dataTest <- data[k,]

      inputDataTrain <- dataTrain$inputData #training dataset is divided into input data...

      inputParamTrain <- data.frame( # ... and input parameters
        p_tau = dataTrain$p_tau,
        #p_tau = data for the p_tau protein value in cerebro-spinal fluid (CSF) (training data)
        fdgPet = dataTrain$fdgPet,
        #fdgPet = data for a 2-deoxy-2[18F]Fluoro-D-glucose (FDG) PET analysis (training data)
        hippoVolume = dataTrain$hippoVolume,
        # hippoVolume = data for the volume of the hippocampal volume (training data)
        adasCog = dataTrain$adasCog
        # adasCog = data for neuropsychology by Alzheimer's Disease Assessment Scale-cognitive subscale (ADAS-cog) (training data)
      )


      inputDataTest <- dataTest$inputData #test data set is divided into input data...

      inputParamTest <- #... and input parameters
        data.frame(
          p_tau = dataTest$p_tau,
          #p_tau = data for the p_tau protein value in cerebro-spinal fluid (CSF) (test data)
          fdgPet = dataTest$fdgPet,
          #fdgPet = data for a 2-deoxy-2[18F]Fluoro-D-glucose (FDG) PET analysis (test data)
          hippoVolume = dataTest$hippoVolume,
          # hippoVolume = data for the volume of the hippocampal volume (test data)
          adasCog = dataTest$adasCog
          # adasCog = data for neuropsychology by Alzheimer's Disease Assessment Scale-cognitive subscale (ADAS-cog) (test data)
        )

      model <- # model / design tree is used to calculate the cutoff values (view function for more information)
        design.tree(inputDataTrain, #input data, training set
                    inputParamTrain, # input parameters, training set
                    seq, # sequence
                    pHigh = pHigh, #p_high value, user defined risk threshold
                    pLow = pLow) #p_low value, user defined risk threshold

      if (!(model$effective)) {
        effective = FALSE #model is not effective then set effective to false, why? or is this indiscriminate?

      }
      #print(model)
      result <- # create matrix with the risk predictions of the test data
        rbind(result, as.matrix( # prediction is the result of the function predict.tree given the cutoff calculated with the training data in model and the test data set
          predict.tree(model$cutoff, inputDataTest, inputParamTest)
        ))

      cat("CV ", k, "with low risk", pHigh, " Finished", "\n")

    }
    fit <- NULL # create variable fit equaling NULL

    fit$result <- result # fit is an object with a link to the matrix result

    fit$accuracy <- # create column accuracy in matrix fit, filling this with the patients that are indiscriminate ??
      sum(result[, 1] == result[, 2]) / (n - sum(result[, 2] == 100))

    fit$effective = effective # create column effective in matrix fit, filling this with the effective value
    return(fit) #return table fit with the prediction for the patients
  }
