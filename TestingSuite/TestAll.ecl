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


SET OF STRING classificationDatasetNamesD := ['discrete_GermanDS', 'discrete_houseVoteDS',
        'discrete_letterrecognitionDS','discrete_liverDS', 'discrete_satimagesDS',
        'discrete_soybeanDS', 'discrete_VehicleDS'];   
                                               
SET OF REAL rfc_performance_scoresD := [0.748551052155,  
                                        0.963527328494, 
                                        0.93904331765, 
                                        0.68403997834, 
                                        0.905047973842, 
                                        0.850413659417, 
                                        0.84263765448 ];


// For Testing KMeans        
SET OF STRING clusteringDatasetNames := ['ionek_f_eight_c_sixDS',  
                                        'ionek_f_four_c_fourDS', 
                                        'ionek_f_sixteen_c_eightDS', 
                                        'ionek_f_thirty_two_c_eightDS', 
                                        'ionek_f_two_c_twoDS' ];    
SET OF INTEGER ClusterNumbers := [6, 4, 8, 8, 2]; 
SET OF REAL km_performance_scores := [1931.17931337, 127744.452565,965.716935032,3900.11341027,7859.6831514,475.981431328,63550.3353695]; 


SET OF STRING classificationDatasetNamesC := ['continious_ecoliDS',
                                                'continious_glassDS',
                                                'continious_ionosphereDS',
                                                'continious_ringnormDataDS',
                                                'continious_segmentationDS', 
                                                'continious_waveformDS'
                                                ];   
                                               
SET OF REAL rfc_performance_scoresC := [0.818382927,
                                        0.703538248,
                                        0.926703202,
                                        0.95361631,
                                        0.967285828,
                                        0.723008983
                                        ];

SET OF STRING regressionDatasetNames := ['AbaloneDS', 'friedman1DS', 'friedman2DS', 'friedman3DS', 'housingDS', 'servoDS'];                                                                                
                                        
  
                                        

SET OF REAL dtc_performance_scores := [0.671,
                                        0.951,
                                        0.832,
                                        0.621,
                                        0.837,
                                        0.798,
                                        0.661
                                        ];


timeseriesDatasetNames := ['default', 'milk', 'barley', 'pigs', 'sheep', 'unemployed'];
ts_no_of_elements := COUNT(timeseriesDatasetNames);

INTEGER c_no_of_elementsD := COUNT(classificationDatasetNamesD);
INTEGER c_no_of_elementsC := COUNT(classificationDatasetNamesC);
INTEGER cluster_no_of_elements := COUNT(clusteringDatasetNames);
INTEGER r_no_of_elements := COUNT(regressionDatasetNames);


// rf_resultsC := GenerateCode('Classification.TestRandomForestClassificationC',  classificationDatasetNamesC, rfc_performance_scoresC, c_no_of_elementsC);
// rf_resultsD := GenerateCode('Classification.TestRandomForestClassificationD',  classificationDatasetNamesD, rfc_performance_scoresD, c_no_of_elementsD);
// dt_results := GenerateCode('Classification.TestDecisionTreeClassifier',  classificationDatasetNamesD, dtc_performance_scores, c_no_of_elementsD);
// kmeans_results := GenerateCode_K('Clustering.TestKmeans', clusteringDatasetNames, ClusterNumbers, km_performance_scores);
// lr_results := GenerateCode_R('Regression.TestLinearRegression', regressionDatasetNames);

SEQUENTIAL(
        OUTPUT(GenerateCode('Classification.TestRandomForestClassificationC',  classificationDatasetNamesC, rfc_performance_scoresC, c_no_of_elementsC), NAMED('Classification_RandomForestC')),
        OUTPUT(GenerateCode('Classification.TestRandomForestClassificationD',  classificationDatasetNamesD, rfc_performance_scoresD, c_no_of_elementsD), NAMED('Classification_RandomForestD')),
        OUTPUT(GenerateCode('Classification.TestDecisionTreeClassifier',  classificationDatasetNamesD, dtc_performance_scores, c_no_of_elementsD), NAMED('Classification_DecisionTree')),
        OUTPUT(GenerateCode_K('Clustering.TestKmeans', clusteringDatasetNames, ClusterNumbers, km_performance_scores), NAMED('Clustering_KMeans')),
        OUTPUT(GenerateCode_R('Regression.TestLinearRegression', regressionDatasetNames), NAMED('Regression_LR')),
        OUTPUT(GenerateCodeTS('TimeSeries.TestArima', timeseriesDatasetNames), NAMED('ARIMA'))
);



                                                                              
                                        
