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


SET OF STRING classificationDatasetNames := ['discrete_GermanDS', 'discrete_houseVoteDS',
        'discrete_letterrecognitionDS','discrete_liverDS', 'discrete_satimagesDS',
        'discrete_soybeanDS', 'discrete_VehicleDS']; 
       
SET OF REAL dtc_performance_scores := [
                                        0.674,
                                        0.961,
                                        0.827,
                                        0.612,
                                        0.838,
                                        0.751,
                                        0.649
                                        ];



INTEGER c_no_of_elements := COUNT(classificationDatasetNames);


dt_results := GenerateCode('Classification.TestDecisionTreeClassifier',  classificationDatasetNames, dtc_performance_scores, c_no_of_elements);

OUTPUT(dt_results, NAMED('Classification_DecisionTree'));


