EXPORT GenerateCodeTS(algorithm, datasetNames):= FUNCTIONMACRO

        SET OF REAL8 param1:= [1, 0, 1];
        SET OF REAL8 param2:= [2, 0, 2];
        SET OF REAL8 param3:= [2, 1, 2];
        #DECLARE(source_code)
        #SET(source_code, '');
        #DECLARE(indexs);
        #SET(indexs, 1);
        

        #LOOP
        	#IF(%indexs%> ts_no_of_elements)	
        		#BREAK
        	#ELSE
                        #EXPAND('result_' + datasetNames[%indexs%] + '101') := TimeSeries.TestArima(#EXPAND('TimeSeries.Datasets.' + datasetNames[%indexs%] +'TS'), param1);
                        #EXPAND('R_' + datasetNames[%indexs%] + '101') := TimeSeries.TestRArima(#EXPAND('TimeSeries.Datasets.' + datasetNames[%indexs%] +'TS'), param1, #EXPAND('TimeSeries.Datasets.' + datasetNames[%indexs%] +'_101'));
                        #EXPAND('result_' + datasetNames[%indexs%] + '202') := TimeSeries.TestArima(#EXPAND('TimeSeries.Datasets.' + datasetNames[%indexs%] +'TS'), param2);
                        #EXPAND('R_' + datasetNames[%indexs%] + '202') := TimeSeries.TestRArima(#EXPAND('TimeSeries.Datasets.' + datasetNames[%indexs%] +'TS'), param2, #EXPAND('TimeSeries.Datasets.' + datasetNames[%indexs%] +'_202'));
                        #EXPAND('result_' + datasetNames[%indexs%] + '212') := TimeSeries.TestArima(#EXPAND('TimeSeries.Datasets.' + datasetNames[%indexs%] +'TS'), param3);
                        #EXPAND('R_' + datasetNames[%indexs%] + '212') := TimeSeries.TestRArima(#EXPAND('TimeSeries.Datasets.' + datasetNames[%indexs%] +'TS'), param3, #EXPAND('TimeSeries.Datasets.' + datasetNames[%indexs%] +'_212'));
                        #SET(indexs,%indexs%+1);
                #END
        #END
             
        #APPEND(source_code, 'final_results := DATASET([');
                #SET(indexs, 1);
                #LOOP
                        #IF(%indexs%>ts_no_of_elements)	
                                #BREAK
                        #ELSE
                                #APPEND(source_code, '{' + %indexs% + '101,\'' + datasetNames[%indexs%] + '\', result_' + datasetNames[%indexs%] + '101, R_' + datasetNames[%indexs%] + '101},\n');
                                #APPEND(source_code, '{' + %indexs% + '202,\'' + datasetNames[%indexs%] + '\', result_' + datasetNames[%indexs%] + '202, R_' + datasetNames[%indexs%] + '202},\n');
                                #APPEND(source_code, '{' + %indexs% + '212,\'' + datasetNames[%indexs%] + '\', result_' + datasetNames[%indexs%] + '212, R_' + datasetNames[%indexs%] + '212}');
                                #IF(%indexs%<ts_no_of_elements)
                                        #APPEND(source_code, ',\n');
                                #ELSE
                                        #APPEND(source_code, '\n');
                                #END
                                #SET(indexs,%indexs%+1);
                        #END
                #END
                #APPEND(source_code, '], dataset_record);\n');        
        %source_code%;
        RETURN final_results;
        // %'source_code'%;
        // t_final_results := PROJECT(final_results, assign_status(LEFT));
        // RETURN t_final_results;
        
ENDMACRO;   

/*
QualifiedName(prefix, datasetname):=  FUNCTIONMACRO
        RETURN prefix + datasetname + '.content';
ENDMACRO;

SET OF STRING regressionDatasetNames := ['AbaloneDS', 'friedman1DS', 'friedman2DS', 'friedman3DS', 'housingDS', 'servoDS'];  
INTEGER r_no_of_elements := COUNT(regressionDatasetNames);*/

// INTEGER ts_no_of_elements := COUNT(timeseries
// GenerateCodeTS('TimeSeries.TestArima', regressionDatasetNames);

