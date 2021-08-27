#' prepareData
#' This function transforms the given data into a data frame containing only the columns necessary for the TripleSec algorithm, therefor for the risk assessment.
#'
#' @param data the data table with patients and all available data
#' @param firstFeature the first Feature which should be set
#' @param featureList the other features, excluding the first feature
#'
#' @return inputData, data table including only all relevant information for the Triple Sec algorithm

prepareData <- function(data, firstFeature, featureList){

  #create the data frame inputData, with a row for each patient and columns for their ID and conversion, and also the first feature
  inputData <-
    data.frame(
      #creating inputDataAll, table containing all information and given column names
      ID = data$RID,
      #did the patient convert to Alzheimers
      conversion = data$conversion,
      # firstFeature
      firstFeature = data[,which(colnames(data) == firstFeature)]
    )

  #for loop adding a column for each given feature in the feature list
  for(i in 1:length(featureList)){
    #add a column for the i-th feature in the list
    inputDataAll <- cbind(inputDataA, data[,which(colnames(data) == featureList[i])])
  }
  #return the created inputData data frame for further usage
  return(inputData)

}


