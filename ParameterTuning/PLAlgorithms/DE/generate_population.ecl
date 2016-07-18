IMPORT ML;
IMPORT ML.Types;
IMPORT ParameterTuning AS PL;

 EXPORT generate_population(t_ranges, number_of_elements=20):= FUNCTIONMACRO
        number_of_paramaters := COUNT(t_ranges);
        #DECLARE(gindexs); #SET(gindexs, 1);
        // Generate indep DE record structure on the fly
        indep_de_rec := RECORD
                INTEGER id;
                INTEGER generation_id;                                
                #LOOP
                        #IF(%gindexs% <= number_of_paramaters) REAL #EXPAND('indep'+%'gindexs'%)
                        #ELSE #BREAK;
                        #END
                        #SET(gindexs, %gindexs%+1);
                #END
        END; 
        // Generate a Random Number between lower limit and upper limit
        REAL real_random_between(INTEGER lower_limit, ANY upper_limit) :=  lower_limit + ((RANDOM()%100)/100) * (upper_limit - lower_limit);
        
        indep_de_rec generate_individual(INTEGER id=-1, INTEGER gen=0):= TRANSFORM
                SELF.id := id;
                SELF.generation_id := gen;
                #DECLARE(indexs); #SET(indexs, 1);
                #LOOP
                        #IF(%indexs% <= number_of_paramaters)
                                #EXPAND('SELF.indep' + %'indexs'%):= (REAL)real_random_between(t_ranges(parameter_id=%indexs%)[1].minimun_value, 
                                                                        t_ranges(parameter_id=%indexs%)[1].maximum_value);
                        #ELSE #BREAK;
                        #END
                        #SET(indexs, %indexs%+1);
                #END
        END;
        
        independent_population := DATASET(number_of_elements, generate_individual(COUNTER));
        // Generate dependent DE record structure on the fly
        de_rec := RECORD
                RECORDOF(indep_de_rec);
                REAL objective;
        END;
        
        // Dummy Structure for objective function
        REAL ObjectiveFunction(indep_de_rec individual):= FUNCTION
                RETURN individual.indep1 + individual.indep2 + individual.indep3;// + individual.indep4 ;
        END;
        
        de_rec evaluate_individual(indep_de_rec indi):= TRANSFORM
                SELF.objective := ObjectiveFunction(indi);
                SELF := indi;
        END; 
        
        evaluated_population := PROJECT(independent_population, evaluate_individual(LEFT));
        ML.ToField(evaluated_population, nf_dependent_population);
        RETURN nf_dependent_population;
ENDMACRO;