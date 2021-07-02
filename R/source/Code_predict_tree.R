#' predict tree
#'Predicts the risk of a patients conversion to alzheimers, based on the given data and cutoff values.
#'
#' @param cutoffValues used to be final.tree
#' @param inputDataTest input data given from the user ;used to be y.new
#' @param inputParamTest input parameters, given by user,
#' amount of (min. 2)/names should remain open, to allow user to define them themselves, dependent on availability
#' and need; used to be X.new (f.ex. support for MS instead of AD etc.)
#'
#' @return matrix result, with the prediction of the patients and their corresponding class (high risk, low risk, indiscriminate)
#' @export
#'
#' @examples

predict.tree <- function(cutoffValues, inputDataTest, inputParamTest) {

  tree <- as.matrix(cutoffValues) #creates a matrix with the cutoff values

  amountPat <- nrow(inputParamTest) #amountPat = amount of patients, which should be predicted

  class <- rep(100, amountPat)

  amountCut <- nrow(tree) #amountCut = amount of cutoff values

  for (i in 1:amountPat) { # for each feature
    flag <- 0 # variable flag is created and set to 0 (representative for biomarker)
    t = 1 # variable flag is created and set to 1

    while (t <= amountCut & flag == 0) { # while t is smaller or equal to the amount of cutOff values and flag equals 0...
      if (tree[t, 1] == 1) { # check if the cutoff value t (tree[t,1]) is equal to 1
        if ((!is.na(tree[t, 2]))) { # if the cutoff value t is equal to 1 -> check if the next cutoff value (tree[t,2]) is available
          if (inputParamTest[i, 1] <= tree[t, 2]) { # if the next cutoff value is available -> check if in the value in the given parameter data (row i, column 1)  is smaller of equal to the cutoff value (tree[t,2])
            class[i] = 0 # if the value in the given parameter data is smaller of equal to the cutoff value, assign class 0 to the i parameter
            flag = 1 # and set flag to 1
          }
        }

        if ((!is.na(tree[t, 5]))) { # check if the cutoff value
          if (inputParamTest[i, 1] >= tree[t, 5]) {
            class[i] = 1
            flag = 1
          }
        }

      }
      if (tree[t, 1] == 2) {
        if ((!is.na(tree[t, 2]))) {
          if (inputParamTest[i, 2] >= tree[t, 2]) {
            class[i] = 0
            flag = 1
          }
        }

        if ((!is.na(tree[t, 5]))) {
          if (inputParamTest[i, 2] <= tree[t, 5]) {
            class[i] = 1
            flag = 1
          }
        }

      }
      if (tree[t, 1] == 3) {
        if ((!is.na(tree[t, 2]))) {
          if (inputParamTest[i, 3] >= tree[t, 2]) {
            class[i] = 0
            flag = 1
          }
        }

        if ((!is.na(tree[t, 5]))) {
          if (inputParamTest[i, 3] <= tree[t, 5]) {
            class[i] = 1
            flag = 1
          }
        }

      }
      if (tree[t, 1] == 4) {
        if ((!is.na(tree[t, 2]))) {
          if (inputParamTest[i, 4] <= tree[t, 2]) {
            class[i] = 0
            flag = 1
          }
        }

        if ((!is.na(tree[t, 5]))) {
          if (inputParamTest[i, 4] >= tree[t, 5]) {
            class[i] = 1
            flag = 1
          }
        }

      }
      t <- t + 1

    }
  }
  result <- cbind(inputDataTest, class)

  return(result)

}
