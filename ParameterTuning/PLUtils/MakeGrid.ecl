IMPORT ML;
EXPORT MakeGrid(tuning_ranges) := FUNCTIONMACRO
        make_list_rec := RECORD
                INTEGER id;
                REAL value;
        END;

        make_list(REAL low, REAL high, REAL c) := FUNCTION
                reps := ((high-low)/c) + 1;
                a := DATASET(reps, TRANSFORM(make_list_rec, 
                                                        SELF.id := COUNTER;
                                                        SELF.value := (REAL)((REAL)((COUNTER - 1) * c) + low);
                                        ));
                RETURN a;
        END;
        
        #DECLARE(number_of_parameter);#SET(number_of_parameter, COUNT(tuning_ranges));
        #DECLARE(indexs); #SET(indexs, 1);
        #DECLARE(new_rec_code);        #SET(new_rec_code, '');
        /*Generated All the list of parameters*/
        #LOOP
                #IF(%indexs% > %number_of_parameter%) #BREAK  #END
                #EXPAND('param_' + %'indexs'%) := make_list(tuning_ranges[%indexs%].minimun_value, tuning_ranges[%indexs%].maximum_value, tuning_ranges[%indexs%].step_size);
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

        #DECLARE(indexs2);
        #SET(indexs2, 1);
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
                                #ELSE
                                       #APPEND(new_rec_code,'*'); 
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
        
        #DECLARE(indexs5);
        #SET(indexs5, 1);
        #APPEND(new_rec_code, 'no_of_elements := ');
        #LOOP
                #APPEND(new_rec_code, 'COUNT(param_' + %'indexs5'% +')');
                #SET(indexs5, %indexs5%+1)
                #IF(%indexs5% > %number_of_parameter%)#BREAK;
                #ELSE
                        #APPEND(new_rec_code, '*');
                #END;
        #END
        #APPEND(new_rec_code, ';\n');
        %new_rec_code%;
        result := DATASET(no_of_elements, join_records(COUNTER));
        ML.ToField(result, nf_result);
        RETURN nf_result;
ENDMACRO;