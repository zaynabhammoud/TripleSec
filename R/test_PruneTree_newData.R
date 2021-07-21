#function/lines to test calCutOff

library(readr)
dataADASmain <- read_csv(
  "R/dataADASmain.csv",
  col_types = cols(
    RID = col_integer(),
    conversion = col_logical(),
    TimeToConversion = col_integer(),
    Ab1to42 = col_integer(),
    adasCog = col_integer(),
    p_tau = col_integer(),
    fdgPet = col_double(),
    hippoVolume = col_integer(),
    ApoE4 = col_character(),
    AVLT = col_integer(),
    sex = col_factor(levels = c("female",
                                "male")),
    age = col_double(),
    edu = col_integer()
  )
)
#View(dataADASmain) ; viewing created table

inputData <-
  data.frame(
    #creating inputDataAll, table containing all information and given column names
    ID = dataADASmain$RID,
    #did the patient convert to Alzheimers
    conversion = dataADASmain$conversion,
    # adasCog = data for neuropsychology by Alzheimer's Disease Assessment Scale-cognitive subscale (ADAS-cog) (training data)
    adasCog = dataADASmain$adasCog,
    #p_tau = data for the p_tau protein value in cerebro-spinal fluid (CSF) (training data)
    p_tau = dataADASmain$p_tau,
    #fdgPet = data for a 2-deoxy-2[18F]Fluoro-D-glucose (FDG) PET analysis (training data)
    fdgPet = dataADASmain$fdgPet
  )

pHigh <- 0.8 #create pHigh
pLow <- 0.2 #create pLow


result <- pruneTree(inputData, pHigh, pLow) #run calCutOff
print(result$cutOff) # print resulting table

