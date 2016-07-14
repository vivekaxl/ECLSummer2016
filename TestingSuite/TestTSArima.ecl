IMPORT TS;
IMPORT * FROM TestingSuite.Utils;
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

timeseriesDatasetNames := ['default', 'milk', 'barley', 'pigs', 'sheep', 'unemployed'];
ts_no_of_elements := COUNT(timeseriesDatasetNames);
GenerateCodeTS('TimeSeries.TestArima', timeseriesDatasetNames);