IMPORT Std;
IMPORT TS;
IMPORT * FROM ML;
IMPORT ML.Tests.Explanatory as TE;
IMPORT * FROM ML.Types;
IMPORT * FROM TestingSuite.Utils;
IMPORT TestingSuite.Classification as Classification;
IMPORT TestingSuite.Clustering as Clustering;
IMPORT TestingSuite.Regression as Regression;
IMPORT TestingSuite.TimeSeries as TimeSeries;

dataset_record := RECORD
	INTEGER dataset_id;
	STRING dataset_name;
	REAL ecl_performance;
        REAL scikit_learn_performance;
END;

QualifiedName(prefix, datasetname):=  FUNCTIONMACRO
        RETURN prefix + datasetname + '.content';
ENDMACRO;


SET OF STRING classificationDatasetNamesD := ['discrete_houseVoteDS'];
SET OF REAL rfc_performance_scoresD := [ 0.963527328494];

// For Testing KMeans        
SET OF STRING clusteringDatasetNames := ['ionek_f_two_c_twoDS' ];    
SET OF INTEGER ClusterNumbers := [2]; 
SET OF REAL km_performance_scores := [63550.3353695]; 

SET OF STRING classificationDatasetNamesC := ['continious_ecoliDS'];                                                  
SET OF REAL rfc_performance_scoresC := [0.818382927];
SET OF STRING regressionDatasetNames := ['AbaloneDS'];   
SET OF REAL dtc_performance_scores := [0.671];


timeseriesDatasetNames := ['default'];
ts_no_of_elements := COUNT(timeseriesDatasetNames);

INTEGER c_no_of_elementsD := COUNT(classificationDatasetNamesD);
INTEGER c_no_of_elementsC := COUNT(classificationDatasetNamesC);
INTEGER cluster_no_of_elements := COUNT(clusteringDatasetNames);
INTEGER r_no_of_elements := COUNT(regressionDatasetNames);

SEQUENTIAL(
        OUTPUT(GenerateCode('Classification.TestRandomForestClassificationC',  classificationDatasetNamesC, rfc_performance_scoresC, c_no_of_elementsC, 1), NAMED('Classification_RandomForestC')),
        OUTPUT(GenerateCode('Classification.TestRandomForestClassificationD',  classificationDatasetNamesD, rfc_performance_scoresD, c_no_of_elementsD, 1), NAMED('Classification_RandomForestD')),
        OUTPUT(GenerateCode('Classification.TestDecisionTreeClassifier',  classificationDatasetNamesD, dtc_performance_scores, c_no_of_elementsD, 1), NAMED('Classification_DecisionTree')),
        OUTPUT(GenerateCode_K('Clustering.TestKmeans', clusteringDatasetNames, ClusterNumbers, km_performance_scores, 1), NAMED('Clustering_KMeans')),
        OUTPUT(GenerateCode_R('Regression.TestLinearRegression', regressionDatasetNames), NAMED('Regression_LR')),
        OUTPUT(GenerateCodeTS('TimeSeries.TestArima', timeseriesDatasetNames), NAMED('ARIMA'))
);



                                                                              
                                        
