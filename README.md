# TripleSec
Creating a clinical support system for neurological disease.

## Introduction
In the day and age, where more data per patient arises and has to be evaluated, clinical support algorithms (CDS) are becoming more and more relevant for health care providers, providing them with a helping tool for sifting through data and suggesting further steps of treatment.
The Triple Sec Algorithm is a clinical support algorithm for risk assessment of Alzheimers disease.
It's goal is to categorize patients with neurological symptoms into three 
categories. These three categories, high risk, low risk and indiscriminate, represent the risk of the patient progressing to Alzheimer's disease, dependent on the given biomarker values.
The categories are defined by cutoff values of the biomarkers. These cutoff values are calculated dependent on user defined risk-threshold and ratio of patients.

The user defined risk-thresholds, pHigh and pLow, are given to the algorithm. They present the percentage of patients which are supposed to have a certain value >=x/ <=x to determin the cutoff values.

![alt text](https://github.com/zaynabhammoud/TripleSec/blob/KAP/img/principle.png "principle")

This calculation is repeated for each biomarker given from the user, filtering out the patients which have been categorized into high or low risk, therefor minimizing the amount of patients the algorithm categorizes as indiscriminate ("unknown risk").

![alt text](https://github.com/zaynabhammoud/TripleSec/blob/KAP/img/repeat.png "repeat")

The algorithm is made up of four functions:
[pruneTree](https://github.com/zaynabhammoud/TripleSec/blob/KAP/R/pruneTree.R) , 
[calCutOff](https://github.com/zaynabhammoud/TripleSec/blob/KAP/R/calCutOff.R) ,
[predictTree](https://github.com/zaynabhammoud/TripleSec/blob/KAP/R/predictTree.R) and [predictTreeRec](https://github.com/zaynabhammoud/TripleSec/blob/KAP/R/predictTree.R).
An additional function [prepareData](https://github.com/zaynabhammoud/TripleSec/blob/KAP/R/prepareData.R) is included in the package offering an easy solution to preparing the users data for the algorithm. 
The data as well as the name of the first feature column and a list of names of all columns the user is interested in, is given to [prepareData](https://github.com/zaynabhammoud/TripleSec/blob/KAP/R/prepareData.R) which then creates a data frame including a column for the ID, a column for the conversion rate and all columns the user listed. This data frame and the user given threshold for high and low risk are the input parameters for [pruneTree](https://github.com/zaynabhammoud/TripleSec/blob/KAP/R/pruneTree.R), the first function of the TripleSec algorithm.

The function [pruneTree](https://github.com/zaynabhammoud/TripleSec/blob/KAP/R/pruneTree.R) divides the input data frame into training and test data using [calCutOff](https://github.com/zaynabhammoud/TripleSec/blob/KAP/R/calCutOff.R) with the test data to calculate the cut off values for each biomarker and then using the cut off values and [predictTree](https://github.com/zaynabhammoud/TripleSec/blob/KAP/R/predictTree.R) to predict the risk of conversion for the test data.
pruneTree returns the variable result which contains a link to a data table including each patient and their risk assessment as well as a link to matrix containing the average cut off values used throughout the algorithms calculations.

<!---# ## Publication
# More information and references can be found in the following papers:--->

## Available functions in package
The algorithm is based upon four functions:
[pruneTree](https://github.com/zaynabhammoud/TripleSec/blob/KAP/R/pruneTree.R) , 
[calCutOff](https://github.com/zaynabhammoud/TripleSec/blob/KAP/R/calCutOff.R) ,
[predictTree](https://github.com/zaynabhammoud/TripleSec/blob/KAP/R/predictTree.R) and [predictTreeRec](https://github.com/zaynabhammoud/TripleSec/blob/KAP/R/predictTree.R)

additional function: [prepareData](https://github.com/zaynabhammoud/TripleSec/blob/KAP/R/prepareData.R)

| Function |Description|
| --------------- |-----------|

|`pruneTree(inputData, pHigh, pLow)`|This function divides the given input data frame into training and test data. It calls the function calCutOff for the training data, which returns a matrix containing the calculated cut off values. Using this matrix and the test data, pruneTree then calls predictTree for the test data. predictTree returns the risk assessment for the test data to pruneTree.|
|`calCutOff(inputData, pHigh, pLow)`|This function is used to calculate the cut off values for low-risk and high-risk groups. <br/>The values are calculated by the proportion between converters with a value and all patients having this certain value corresponding with the given pHigh and pLow values. For each feature cutoff calculation all patients that have not been categorized into the high or low risk categories will be used.|
|`predictTree(cutoffValues, inputData)`| This function calls the recursive function predictTreeRec. The function returns a variable with a link to a patient data table containing their risk assessments and a link to the average cutoff value matrix.|
|`predictTreeRec(cutoffValues, inputData)`| This recursive function calculates the cutoff value for each parameter dependent upon the patient ratio, it also verifies if the model is effective (cut_high > cut_low).|
|`prepareData(data, firstFeature, featureList)`| This function transforms the given data into a data frame containing only the columns necessary for the TripleSec algorithm, therefor for the risk assessment.|

