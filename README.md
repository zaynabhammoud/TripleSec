# TripleSec
Creating a clinical support system for neurological disease.

## Introduction
In the day and age, where more data per patient arises and has to be evaluated, clinical support algorithms (CDS) are becoming more and more relevant for healthcare providers, providing them with a helping tool for sifting through data and suggesting further steps of treatment.
The Triple Sec Algorithm is a clinical support algorithm for risk assessment of Alzheimers disease.
It's goal is to categorize patients with neurological symptoms into three 
categories. These three categories represent the risk of the patient progressing 
to Alzheimer's disease, dependent on the given biomarker values.
The three catergories, high risk, indiscriminate risk and low risk are defined by 
cutoff values of the biomarkers. These cutoff values are calculated
dependent on user defined risk-threshold and ratio of patients.

![alt text](https://github.com/zaynabhammoud/TripleSec/blob/KAP/img/principle.png "principle")

The algorithm is made up of three functions: CV.one.prune.tree, design.tree and predict.tree.
The data, data parameters as well as the risk-threshold are given to CV.one.prune.tree. 
This function creates a table with all data and splits this in half, using the first half of the data to calculate the cutoff values, via 
design.tree and using the second half of the data to test the cutoff values via the function predict.tree.
Once predict.tree has returned the predictions for the data given, CV.one.prune.tree returns a table with the predicted data to the user including
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
|`CV.one.prune.tree(inputData,inputParam,seq,pHigh,pLow)`|Splits the given data and data parameters into training and test data.The training data is used to calculate the cutoff values (via function design tree). Afterwards the test data and parameters,as well as the calculated cutoff values are used to predict the risk of each patient (via function predict tree).|
|`design.tree(inputData, inputParam,seq = c(1, 2, 3),pHigh, pLow, minNum = 5,repeats = 100)`|Function used to calculate the cutoff values for low-risk and high risk groups.The values correspond to the risk-threshold values given by the user, pHigh and pLow.|
|`predict.tree(cutoffValues, inputDataTest, inputParamTest)`| Predicts the risk of a patients conversion to alzheimers, based on the given data and cutoff values.|
