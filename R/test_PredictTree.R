
#function/lines to test predictTree

library(readr) #loading readr package
predictAD <- read_csv( #loading data table
  #load data
  "R/predictAD.csv",
  col_types = cols(
    RID = col_integer(),
    conversion = col_logical(),
    TimeToConversion = col_integer(),
    Ab1to42 = col_integer(),
    p_tau = col_integer(),
    fdgPet = col_double(),
    hippoVolume = col_integer(),
    ApoE4 = col_factor(levels = c("positive",
                                  "negative")),
    AVLT = col_integer(),
    sex = col_factor(levels = c("female",
                                "male")),
    age = col_double(),
    edu = col_integer(),
    adasCog = col_integer()
  )
)
#View(predictAD) ; viewing created table

inputDataAll <- data.frame( #creating inputDataAll, table containing all information and given column names
  ID = predictAD$RID,
  p_tau = predictAD$p_tau,#p_tau = data for the p_tau protein value in cerebro-spinal fluid (CSF) (training data)
  fdgPet = predictAD$fdgPet, #fdgPet = data for a 2-deoxy-2[18F]Fluoro-D-glucose (FDG) PET analysis (training data)
  hippoVolume = predictAD$hippoVolume,# hippoVolume = data for the volume of the hippocampal volume (training data)
  adasCog = predictAD$adasCog # adasCog = data for neuropsychology by Alzheimer's Disease Assessment Scale-cognitive subscale (ADAS-cog) (training data)
)
inputData <- inputDataAll[1,] #create inputData, table containing one of the many given patients
data <- c(28.5, 30, 1.0301, 3, 2,6, 7,19) #create cutoff matrix
cutOff <- matrix(data, ncol=4, byrow = FALSE) #... with certain values (from the paper)
colnames(cutOff) <- c("p_tau", "fdgPet","hippoVolume", "adasCog") # ... and certain column names

final <- predictTree(cutOff, inputData) #run predict tree
#print(final) ; print resulting solution of predict tree (final)
