#function/lines to test calCutOff

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

inputData <- data.frame( #creating inputDataAll, table containing all information and given column names
  ID = predictAD$RID,
  conversion = predictAD$conversion, #did the patient convert to Alzheimers
  p_tau = predictAD$p_tau,#p_tau = data for the p_tau protein value in cerebro-spinal fluid (CSF) (training data)
  fdgPet = predictAD$fdgPet, #fdgPet = data for a 2-deoxy-2[18F]Fluoro-D-glucose (FDG) PET analysis (training data)
  hippoVolume = predictAD$hippoVolume,# hippoVolume = data for the volume of the hippocampal volume (training data)
  adasCog = predictAD$adasCog # adasCog = data for neuropsychology by Alzheimer's Disease Assessment Scale-cognitive subscale (ADAS-cog) (training data)
)

pHigh <- 0.8 #create pHigh
pLow <- 0.2 #create pLow

result <- pruneTree(inputData, pHigh, pLow) #run calCutOff
#print(result) # print resulting table


