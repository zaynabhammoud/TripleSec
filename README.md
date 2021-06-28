# TripleSec
Creating a clinical support system for neurological disease.

## Introduction
In the day and age, where more data per patient arises and has to be evaluated, clinical support algorithms (CDS) are becoming more and more relevant for health care providers, providing them with a helping tool for sifting through data and suggesting further steps of treatment.
The Triple Sec Algorithm is a clinical support algorithm for risk assessment of Alzheimers disease.
It's goal is to categorize patients with neurological symptoms into three 
categories. These three categories, high risk, low risk and indiscriminate, represent the risk of the patient progressing to Alzheimer's disease, dependent on the given biomarker values.
The categories are defined by cutoff values of the biomarkers. These cutoff values are calculated
dependent on user defined risk-threshold and ratio of patients.

The user defined risk-thresholds, pHigh and pLow, are given to the algorithm. They present the percentage of patients which are supposed to have a certain value >=x/ <=x to determin the cutoff values.

![alt text](https://github.com/zaynabhammoud/TripleSec/blob/KAP/img/principle.png "principle")

This calculation is repeated for each biomarker given from the user, filtering out the patients which have been categorized into high or low risk. The reason the algorithm focuses on the indiscriminate category is to minimize this which each step and reducing the amount of patients, the algorithm categorizes as indiscriminate ("unknown risk").

![alt text](https://github.com/zaynabhammoud/TripleSec/blob/KAP/img/repeat.png "repeat")

The algorithm is made up of three functions: CV.one.prune.tree, design.tree and predictTree.
The data, data parameters as well as the risk-threshold are given to CV.one.prune.tree. 
This function creates a table with all data and splits this in half, using the first half of the data to calculate the cutoff values, via 
design.tree and using the second half of the data to test the cutoff values via the function predict.tree.
Once predictTree has returned the predictions for the data given, CV.one.prune.tree returns a table with the predicted data to the user including
a column for the prediction as well the accuracy and the effectiveness.


<!---# ## Publication
# More information and references can be found in the following papers:--->

## Available functions
The algorithm is made up of three functions: 
[CV.one.prune.tree](https://github.com/zaynabhammoud/TripleSec/blob/KAP/R/Code_CV_one_prune_tree.R) , 
[design.tree](https://github.com/zaynabhammoud/TripleSec/blob/KAP/R/Code_design_tree.R) ,
[predict.tree](Code_predict_tree.R)


| Function |Description|
| --------------- |-----------|
|`pruneTree(inputData, pHigh, pLow)`|This function splits the given data table into training and test data. Then calls calCutOff for the training data and predictTree with the calculated cutOff values of calCutOff and the test data.|
|`calCutOff(inputData, pHigh, pLow)`|This function is used to calculate the cutoff values for low-risk and high-risk groups. <br/>The values are calculated by the proportion between converters with a value and all patients having this certain value corresponding with the given pHigh and pLow values. For each feature cutoff calculation all patients that have not been categorized into the high or low risk categories will be used.|
|`predictTree(cutoffValues, inputData)`| This function calls the recursive function predictTreeRec. The function returns a variable with a link to a patient data table containing their risk assesments and a link to the average cutoff value matrix.|
|`predictTreeRec(cutoffValues, inputData)`| This recursive function calculates the cutoff value for each parameter dependent upon the patient ratio, it also verifies if the model is effective (cut_high > cut_low).|
