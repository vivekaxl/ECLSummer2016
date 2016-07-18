IMPORT ML;
IMPORT ML.Types;
IMPORT ParameterTuning AS PL;


EXPORT GridSearch(DATASET(Types.DiscreteField) trainIndepData, DATASET(Types.DiscreteField) trainDepData, DATASET(Types.DiscreteField) tuneIndepData, DATASET(Types.DiscreteField) tuneDepData):= MODULE
        EXPORT RunGrid(t_algorithm, i_tuning_range, grid_elements, c_parameters) := FUNCTIONMACRO
                make_list_rec := RECORD
                        INTEGER id;
                        REAL value;
                END;
                make_list(REAL ml_low, REAL ml_high, REAL ml_c) := FUNCTION
                        reps := ROUNDUP((ml_high-ml_low)/ml_c) + 1;
                        a := DATASET(reps, TRANSFORM(make_list_rec, 
                                                                SELF.id := COUNTER;
                                                                SELF.value := (REAL)((REAL)((COUNTER - 1) * ml_c) + ml_low);
                                                ));
                        RETURN a;
                END;
                #DECLARE(number_of_parameter);#SET(number_of_parameter, c_parameters);
                #DECLARE(indexs); #SET(indexs, 1);
                #DECLARE(new_rec_code);        #SET(new_rec_code, '');
                /*Generated All the list of parameters*/
                #LOOP
                        #IF(%indexs% > %number_of_parameter%) #BREAK  #END
                        #EXPAND('param_' + %'indexs'%) := make_list(i_tuning_range[%indexs%].minimun_value, i_tuning_range[%indexs%].maximum_value, i_tuning_range[%indexs%].step_size);
                        #SET(indexs, %indexs%+1);       
                #END;
                
                #DECLARE(indexs1);        #SET(indexs1, 1);    
                #APPEND(new_rec_code, 'new_rec := RECORD\nINTEGER id;\n');
                #LOOP
                        #IF(%indexs1% > %number_of_parameter%) #BREAK;#END
                        #APPEND(new_rec_code, 'REAL v'+%'indexs1'%+';\n');
                        #SET(indexs1, %indexs1%+1);
                #END;
                #APPEND(new_rec_code, 'END;\n');

                #DECLARE(indexs2);   #SET(indexs2, 1);
                #DECLARE(indexs3);
                #LOOP
                        #IF(%indexs2% > %number_of_parameter%)                        #BREAK;
                        #ELSEIF(%indexs2% = %number_of_parameter%)
                                #APPEND(new_rec_code,'len_param_'+%'indexs2'% +':= COUNT(param_' + %'indexs2'%+');\n');
                        #ELSE
                                #SET(indexs3, %indexs2%+1);
                                #APPEND(new_rec_code, 'len_param_'+%'indexs2'% + ':= ');
                                #LOOP
                                        #APPEND(new_rec_code,'COUNT(param_' + %'indexs3'%+')');
                                        #SET(indexs3, %indexs3%+1);
                                        #IF(%indexs3% > %number_of_parameter%)  #BREAK;
                                        #ELSE  #APPEND(new_rec_code,'*'); 
                                        #END
                                #END
                                #APPEND(new_rec_code, ';\n');
                        #END
                        #SET(indexs2, %indexs2%+1);
                #END

                #DECLARE(indexs4);
                #SET(indexs4, 1);
                #APPEND(new_rec_code, 'new_rec join_records(c) := TRANSFORM\nSELF.id := c;\n');
                #LOOP
                        #IF(%indexs4% > %number_of_parameter%)#BREAK;
                        #ELSEIF(%indexs4% = %number_of_parameter%)
                                #APPEND(new_rec_code, 'SELF.v'+%'indexs4'%+':= param_'+%'indexs4'%+'[(c-1)%len_param_'+%'indexs4'%+'+1].value;\n');
                        #ELSE
                                #APPEND(new_rec_code, 'SELF.v'+%'indexs4'%+':= param_'+ %'indexs4'% +'[(((c-1)%(COUNT(param_'+%'indexs4'%+')* len_param_'+%'indexs4'%+'))/len_param_'+%'indexs4'%+')+1].value;\n');
                        #END;
                        #SET(indexs4, %indexs4%+1)
                #END
                #APPEND(new_rec_code, 'END;\n');
                
                #DECLARE(indexs5); #SET(indexs5, 1);
                #APPEND(new_rec_code, 'no_of_elements := ');
                #LOOP
                        #APPEND(new_rec_code, 'COUNT(param_' + %'indexs5'% +')');
                        #SET(indexs5, %indexs5%+1)
                        #IF(%indexs5% > %number_of_parameter%)#BREAK;
                        #ELSE #APPEND(new_rec_code, '*');
                        #END;
                #END
                #APPEND(new_rec_code, ';\n');
                %new_rec_code%;
                grid := DATASET(no_of_elements, join_records(COUNTER));

                #DECLARE(rgs_source_code)
                #SET(rgs_source_code, '');
                #DECLARE(rgs_indexs);
                #SET(rgs_indexs, 1);
                #DECLARE(rgs_param_index);
                // Running all the tests
                
                #LOOP
                        #IF(%rgs_indexs%>grid_elements) #BREAK
                        #ELSE
                                #APPEND(rgs_source_code, 'plgresult_' + %rgs_indexs% + ':=' + t_algorithm + '(trainIndepData, trainDepData, tuneIndepData, tuneDepData,');
                                #SET(rgs_param_index, 1);
                                #LOOP
                                        #APPEND(rgs_source_code,'grid[' + %rgs_indexs% + '].v' + %rgs_param_index%);
                                        #IF(%rgs_param_index%<c_parameters)	
                                                #APPEND(rgs_source_code,',');
                                                #SET(rgs_param_index,%rgs_param_index%+1);
                                        #ELSE #BREAK                                        
                                        #END
                                #END
                                #APPEND(rgs_source_code, ');\n');
                        #END
                        #SET(rgs_indexs,%rgs_indexs%+1);
                #END
                
                // Collecting all results
                #APPEND(rgs_source_code, 'rec_test := RECORD \nINTEGER id; \nREAL result \nEND;');
                #APPEND(rgs_source_code, 'results_grid := DATASET([\n');
                #SET(rgs_indexs, 1);
                #LOOP
                        #APPEND(rgs_source_code, '{' + %rgs_indexs% + ', plgresult_' + %rgs_indexs% + '}');
                        #IF(%rgs_indexs%<grid_elements) #APPEND(rgs_source_code,',\n');
                        #ELSE #BREAK;                        
                        #END
                        #SET(rgs_indexs,%rgs_indexs%+1);
                #END
                #APPEND(rgs_source_code, '], rec_test);\n');
                
                // Finding the best configuration
                #APPEND(rgs_source_code, 'max_id := SORT(results_grid, -result)[1];\n');
                #APPEND(rgs_source_code, 'chosen_parameter := grid[max_id.id];\n');
                %rgs_source_code%;
                ML.ToField(DATASET(chosen_parameter), tf_chosen_parameter)
                RETURN tf_chosen_parameter;//%'rgs_source_code'%;        
        ENDMACRO;
END;


