IMPORT ML;
IMPORT ML.Types;
IMPORT ParameterTuning AS PL;

EXPORT run_one_generation(t_ranges, r_population , gen, number_of_paramaters,  CF=0.75, F=0.3):= FUNCTIONMACRO
        #DECLARE(gindexs); #SET(gindexs, 1);
        // Generate indep DE record structure on the fly
        LOCAL indep_de_rec := RECORD
                INTEGER id;
                INTEGER generation_id;                                
                #LOOP
                        #IF(%gindexs% <= number_of_paramaters) REAL #EXPAND('indep'+%'gindexs'%)
                        #ELSE #BREAK;
                        #END
                        #SET(gindexs, %gindexs%+1);
                #END
        END;                
        // Generate dependent DE record structure on the fly
        LOCAL de_rec := RECORD
                RECORDOF(indep_de_rec);
                REAL objective;
        END;
        
        ML.FromField(r_population, de_rec, temp_pop);
        LOCAL population := temp_pop;
        REAL de_style_mutation(REAL a, REAL b, REAL c):= FUNCTION
                RETURN a + F * (b - a);
        END;
        // Generate a Random Number between lower limit and upper limit
        REAL real_random_between(INTEGER lower_limit, ANY upper_limit) :=  lower_limit + ((RANDOM()%100)/100) * (upper_limit - lower_limit);
        
        de_rec fetch_random_member():= FUNCTION
                RETURN population[(INTEGER)real_random_between(1, COUNT(population))];
        END;
        indep_de_rec new_member(de_rec one, de_rec two, de_rec three, INTEGER pid):= TRANSFORM
                SELF.id := pid;
                SELF.generation_id := gen;
                #DECLARE(indexs); #SET(indexs, 1);
                #LOOP
                        #IF(%indexs% <= number_of_paramaters)
                                #EXPAND('SELF.indep' + %'indexs'%):= (REAL)IF(real_random_between(0, 1) < CF, 
                                                                        de_style_mutation(#EXPAND('one.indep' + %'indexs'%), 
                                                                                          #EXPAND('two.indep' + %'indexs'%), 
                                                                                          #EXPAND('three.indep' + %'indexs'%)), 
                                                                                          #EXPAND('one.indep' + %'indexs'%));
                        #ELSE #BREAK;
                        #END
                        #SET(indexs, %indexs%+1);
                #END   
        END;
        // Dummy Structure for objective function
        REAL ObjectiveFunction(indep_de_rec individual):= FUNCTION
                RETURN individual.indep1 + individual.indep2 + individual.indep3;// + individual.indep4 ;
        END;
        de_rec evaluate_individual(indep_de_rec indi):= TRANSFORM
                SELF.objective := ObjectiveFunction(indi);
                SELF := indi;
        END;
        LOCAL new_independent_population := DATASET(COUNT(population), new_member(population[COUNTER], fetch_random_member(),fetch_random_member(), COUNTER));
        LOCAL new_evaluated_population := PROJECT(new_independent_population, evaluate_individual(LEFT));
        de_rec filter_it(de_rec L, de_rec R) := TRANSFORM
                SELF := IF(L.objective > R.objective, L, R)
        END;
        LOCAL filtered_population := JOIN(population, new_evaluated_population, LEFT.id = RIGHT.id, filter_it(LEFT, RIGHT));
        ML.ToField(filtered_population, nf_filtered_population);
        RETURN nf_filtered_population;
ENDMACRO;