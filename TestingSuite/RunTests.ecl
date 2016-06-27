IMPORT Std;
IMPORT * FROM ML;
IMPORT ML.Tests.Explanatory as TE;
IMPORT * FROM ML.Types;
IMPORT * FROM TestingSuite.Utils;
IMPORT TestingSuite.Classification as Classification;
IMPORT TestingSuite.Clustering as Clustering;
IMPORT TestingSuite.Regression as Regression;

dataset_record := RECORD
	INTEGER dataset_id;
	STRING dataset_name;
	REAL ecl_performance;
        REAL scikit_learn_performance;
END;

QualifiedName(prefix, datasetname):=  FUNCTIONMACRO
        RETURN prefix + datasetname + '.content';
ENDMACRO;


SET OF STRING classificationDatasetNames := ['ecoliDS','GermanDS'];/*,'glassDS','houseVoteDS','ionosphereDS',
        'letterrecognitionDS','liverDS','ringnormDataDS','satimagesDS','segmentationDS', 
        'soybeanDS', 'VehicleDS', 'waveformDS'];   */
        
SET OF STRING clusteringDatasetNames := ['ionek_f_eight_c_sixDS', 
                                        'ionek_f_fiveonetwo_c_twoDS'];/*, 
                                        'ionek_f_four_c_fourDS', 
                                        'ionek_f_sixteen_c_eightDS', 
                                        'ionek_f_thirty_two_c_eightDS', 
                                        'ionek_f_two_c_twoDS', 
                                        'ionek_f_twofiftysix_c_eightDS' ];    */

SET OF STRING regressionDatasetNames := ['AbaloneDS', 'friedman1DS', 'friedman2DS', 'friedman3DS', 'housingDS', 'servoDS'];                                                                                
                                        
SET OF INTEGER ClusterNumbers := [6, 2, 4, 8, 8, 2, 8];   
                                        
SET OF REAL rfc_performance_scores := [0.818382927132, 0.748551052155, 0.703538248268, 0.963527328494, 0.926703202267,
                                        0.93904331765, 0.68403997834, 0.953616310418, 0.905047973842, 0.96728582798, 0.850413659417, 0.84263765448, 0.723008982605];
SET OF REAL dtc_performance_scores := [0.745,0.674,0.633,0.961,0.861,0.827,0.612,0.868,0.838,0.945,0.751,0.649,0.746];

SET OF REAL km_performance_scores := [1931.17931337, 127744.452565,965.716935032,3900.11341027,7859.6831514,475.981431328,63550.3353695];


INTEGER c_no_of_elements := COUNT(classificationDatasetNames);
INTEGER cluster_no_of_elements := COUNT(clusteringDatasetNames);
INTEGER r_no_of_elements := COUNT(regressionDatasetNames);


rf_results := GenerateCode('Classification.TestRandomForestClassification',  classificationDatasetNames, rfc_performance_scores);
dt_results := GenerateCode('Classification.TestDecisionTreeClassifier',  classificationDatasetNames, dtc_performance_scores);
kmeans_results := GenerateCode_K('Clustering.TestKmeans', clusteringDatasetNames, ClusterNumbers, km_performance_scores);
lr_results := GenerateCode_R('Regression.TestLinearRegression', regressionDatasetNames);

OUTPUT(rf_results, NAMED('Classification_RandomForest'));
OUTPUT(dt_results, NAMED('Classification_DecisionTree'));
OUTPUT(kmeans_results, NAMED('Clustering_KMeans'));
OUTPUT(lr_results, NAMED('Regression_LR'));

