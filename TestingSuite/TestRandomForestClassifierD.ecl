IMPORT Std;
IMPORT * FROM ML;
IMPORT ML.Tests.Explanatory as TE;
IMPORT * FROM ML.Types;
IMPORT * FROM TestingSuite.Utils;
IMPORT TestingSuite.Classification as Classification;

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

INTEGER c_no_of_elements := COUNT(classificationDatasetNamesD);

rf_results := GenerateCode('Classification.TestRandomForestClassificationD',  classificationDatasetNamesD, rfc_performance_scoresD, c_no_of_elements);

OUTPUT(rf_results, NAMED('Classification_RandomForestD'));


