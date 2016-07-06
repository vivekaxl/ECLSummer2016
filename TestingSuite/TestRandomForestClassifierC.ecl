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

rf_results := GenerateCode('Classification.TestRandomForestClassificationC',  classificationDatasetNamesC, rfc_performance_scoresC, c_no_of_elements);

OUTPUT(rf_results, NAMED('Classification_RandomForestC'));


