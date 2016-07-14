EXPORT GenerateCode_K(algorithm, datasetNames, clusterNumbers, performance_scores):= FUNCTIONMACRO
        #DECLARE(source_code)
        #SET(source_code, '');
        #DECLARE(indexs);
        #SET(indexs, 1);
        

        #LOOP
        	#IF(%indexs%> cluster_no_of_elements)	
        		#BREAK
        	#ELSE
                        #APPEND(source_code, 'result_' + datasetNames[%indexs%] + ' := ' + algorithm + '(' + QualifiedName('Clustering.Datasets.', datasetNames[%indexs%]));
                        #APPEND(source_code,', 1,' + clusterNumbers[%indexs%] + ');\n');
                        #SET(indexs,%indexs%+1);
                #END
        #END
        
        #APPEND(source_code, 'final_results := DATASET([');
        #SET(indexs, 1);
        #LOOP
        	#IF(%indexs%>cluster_no_of_elements)	
        		#BREAK
        	#ELSE
                        #APPEND(source_code, '{' + %indexs% + ',\'' + datasetNames[%indexs%] + '\', result_' + datasetNames[%indexs%] + ',' + performance_scores[%indexs%] + '}');
                        #IF(%indexs%<cluster_no_of_elements)
                                #APPEND(source_code, ',\n');
                        #ELSE
                                #APPEND(source_code, '\n');
                        #END
                        #SET(indexs,%indexs%+1);
                #END
        #END
        #APPEND(source_code, '], dataset_record);\n');
        
        // #EXPAND(%'source_code'%);
        #APPEND(source_code, 'transormed_data_set_record := RECORD\n');
        #APPEND(source_code, 'final_results;\n');
        #APPEND(source_code, 'STRING Status;\n');
        #APPEND(source_code, 'END;\n');
        #APPEND(source_code, 'transormed_data_set_record assign_status(dataset_record L) := TRANSFORM\n');
        //Less the better. Less than 110% of scikit learn performance.
        #APPEND(source_code, 'SELF.Status := IF( L.ecl_performance < L.scikit_learn_performance * 1.1, \'PASS\', \'FAIL\');\n');
        #APPEND(source_code, 'SELF:= L;\n');
        #APPEND(source_code, 'END;\n');
        %source_code%

        t_final_results := PROJECT(final_results, assign_status(LEFT));
        RETURN t_final_results;
        
ENDMACRO;   

/*
QualifiedName(prefix, datasetname):=  FUNCTIONMACRO
        RETURN prefix + datasetname + '.content';
ENDMACRO;

SET OF STRING clusteringDatasetNames := ['ionek_f_eight_c_sixDS'];   
SET OF INTEGER ClusterNumbers := [6, 2, 4, 8, 8, 2, 8];  
SET OF REAL km_performance_scores := [1, 1, 1, 1, 1, 1, 1, 1]; 
INTEGER cluster_no_of_elements := COUNT(clusteringDatasetNames); 
GenerateCode_K('Clustering.TestKmeans', clusteringDatasetNames, ClusterNumbers, km_performance_scores)
*/
