﻿IMPORT Std;
IMPORT TS;
IMPORT ML;
IMPORT ML.Types;
IMPORT TestingSuite;
IMPORT TestingSuite.BenchmarkResults AS BenchmarkResults;
IMPORT TestingSuite.Utils;
IMPORT TestingSuite.Classification as Classification;
IMPORT TestingSuite.BenchmarkResults AS BenchmarkResults;

dataset_record := RECORD
	INTEGER dataset_id;
	STRING dataset_name;
	REAL ecl_performance;
        REAL scikit_learn_performance;
END;

QualifiedName(prefix, datasetname):=  FUNCTIONMACRO
        RETURN prefix + datasetname + '.content';
ENDMACRO;


SET OF STRING classificationDatasetNamesC := ['continious_ecoliDS',
                                                'continious_glassDS'];/*,
                                                'continious_ionosphereDS',
                                                'continious_ringnormDataDS',
                                                'continious_segmentationDS', 
                                                'continious_waveformDS'
                                                ];   */
                                               
SET OF REAL rfc_performance_scoresC := [0.818382927,
                                        0.703538248,
                                        0.926703202,
                                        0.95361631,
                                        0.967285828,
                                        0.723008983
                                        ];

INTEGER c_no_of_elements := COUNT(classificationDatasetNamesC);

rf_results := Utils.GenerateCode('Classification.TestRandomForestClassificationC',  classificationDatasetNamesC, BenchmarkResults.rfc_performance_scores_c, c_no_of_elements);

OUTPUT(rf_results, NAMED('Classification_RandomForestC'));


