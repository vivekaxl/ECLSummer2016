IMPORT Std;
IMPORT * FROM ML;
IMPORT ML.Tests.Explanatory as TE;
IMPORT * FROM ML.Types;
IMPORT * FROM TestingSuite.Utils;
IMPORT TestingSuite.Clustering as Clustering;

dataset_record := RECORD
	INTEGER dataset_id;
	STRING dataset_name;
	REAL ecl_performance;
        REAL scikit_learn_performance;
END;

QualifiedName(prefix, datasetname):=  FUNCTIONMACRO
        RETURN prefix + datasetname + '.content';
ENDMACRO;

SET OF STRING clusteringDatasetNames := ['ionek_f_eight_c_sixDS', 
                                        'ionek_f_fiveonetwo_c_twoDS'];/*, 
                                        'ionek_f_four_c_fourDS', 
                                        'ionek_f_sixteen_c_eightDS', 
                                        'ionek_f_thirty_two_c_eightDS', 
                                        'ionek_f_two_c_twoDS', 
                                        'ionek_f_twofiftysix_c_eightDS' ];    */                                                                              
                                        
SET OF INTEGER ClusterNumbers := [6, 2, 4, 8, 8, 2, 8];   

SET OF REAL km_performance_scores := [1931.17931337, 127744.452565,965.716935032,3900.11341027,7859.6831514,475.981431328,63550.3353695];


INTEGER cluster_no_of_elements := COUNT(clusteringDatasetNames);

kmeans_results := GenerateCode_K('Clustering.TestKmeans', clusteringDatasetNames, ClusterNumbers, km_performance_scores);

OUTPUT(kmeans_results, NAMED('Clustering_KMeans'));


