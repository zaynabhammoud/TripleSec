#prep
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

pHigh <- 0.9 #create pHigh
pLow <- 0.1 #create pLow


#start test
seq = c(1, 2, 3)
minNum = 5
inputData <- inputData[-1,-1] # for design tree (training) every patient but 1 is used

caseCount <- nrow(inputData)
inputParam <- cbind(inputData, marker = rep(0, caseCount), class = rep(NA, caseCount), ID = 1:caseCount)
inputData0 <- inputData[inputParam$marker == 0,]

#order2 <- inputData0[order(inputParam[,1]),]

order2 <- order(inputData0[,2])
order.left <- NULL #cutHigh
order.right <- NULL #cutLow

#start design.tree tests

for(i in 1:caseCount){
  order.right[i] <- sum(order2[i:caseCount])/(caseCount - i + 1)
  order.left[i] <- 1 - sum(order2[1:i]) / i
}

print(as.data.frame(order.left))

print(sum(order.left >= pHigh, na.rm = TRUE))

print(sum(order.right >= pLow, na.rm = TRUE))


