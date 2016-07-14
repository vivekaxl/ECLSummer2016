IMPORT Std;
IMPORT * FROM ML;
IMPORT ML.Tests.Explanatory as TE;
IMPORT * FROM ML.Types;
IMPORT * FROM TestingSuite.Utils;
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

SET OF STRING regressionDatasetNames := ['AbaloneDS'];//, 'friedman1DS', 'friedman2DS', 'friedman3DS', 'housingDS', 'servoDS'];                                                                                

INTEGER r_no_of_elements := COUNT(regressionDatasetNames);

lr_results := GenerateCode_R('Regression.TestLinearRegression', regressionDatasetNames);

OUTPUT(lr_results, NAMED('Regression_LR'));

