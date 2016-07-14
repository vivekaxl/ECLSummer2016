        IMPORT * FROM ML;
        IMPORT * FROM ML.Types;
        IMPORT * FROM ParameterTuning;

        DE(DATASET(PLTypes.tuning_range_rec) t_ranges, REAL CF=0.75, REAL F=0.3) := MODULE        
                SHARED REAL real_random_between(INTEGER lower_limit, ANY upper_limit) := FUNCTION
                        RETURN lower_limit + ((RANDOM()%100)/100) * (upper_limit - lower_limit);
                END;

                SHARED REAL ObjectiveFunction(PLTypes.indep_de_rec individual):= FUNCTION
                                RETURN individual.indep1 + individual.indep2 + individual.indep3 + individual.indep4 ;
                        END;

                SHARED PLTypes.de_rec evaluate_individual(PLTypes.indep_de_rec indi):= TRANSFORM
                        SELF.objective := ObjectiveFunction(indi);
                        SELF := indi;
                END;        
                
                EXPORT DATASET(PLTypes.de_rec)  generate_population():= FUNCTION
                        
                        PLTypes.indep_de_rec generate_individual(INTEGER id=-1, INTEGER gen=0):= TRANSFORM
                                SELF.individual_id := id;
                                SELF.generation_id := gen;
                                SELF.indep1 := (INTEGER)real_random_between(t_ranges(parameter_id=1)[1].minimun_value, t_ranges(parameter_id=1)[1].maximum_value);
                                SELF.indep2 := (REAL)real_random_between(t_ranges(parameter_id=2)[1].minimun_value, t_ranges(parameter_id=2)[1].maximum_value);
                                SELF.indep3 := (REAL)real_random_between(t_ranges(parameter_id=3)[1].minimun_value, t_ranges(parameter_id=3)[1].maximum_value);
                                SELF.indep4 := (INTEGER)real_random_between(t_ranges(parameter_id=4)[1].minimun_value, t_ranges(parameter_id=4)[1].maximum_value);
                        END;

                        independent_population := DATASET(20, generate_individual(COUNTER));
                        evaluated_population := PROJECT(independent_population, evaluate_individual(LEFT));
                        RETURN evaluated_population;
                END;


                EXPORT DATASET(PLTypes.de_rec)  run_one_generation(DATASET(PLTypes.de_rec) population , INTEGER gen):= FUNCTION
                        REAL de_style_mutation(REAL a, REAL b, REAL c):= FUNCTION
                                RETURN a + F * (b - a);
                        END;
                        PLTypes.de_rec fetch_random_member():= FUNCTION
                                RETURN population[(INTEGER)real_random_between(1, COUNT(population))];
                        END;
                        PLTypes.indep_de_rec new_member(PLTypes.de_rec one, PLTypes.de_rec two, PLTypes.de_rec three, INTEGER pid):= TRANSFORM
                                SELF.individual_id := pid;
                                SELF.generation_id := gen;
                                SELF.indep1 := (INTEGER)IF(real_random_between(0, 1) < CF, de_style_mutation(one.indep1, two.indep1, three.indep1), one.indep1);
                                SELF.indep2 := (REAL)IF(real_random_between(0, 1) < CF, de_style_mutation(one.indep2, two.indep2, three.indep2), one.indep2);
                                SELF.indep3 := (REAL)IF(real_random_between(0, 1) < CF, de_style_mutation(one.indep3, two.indep3, three.indep3), one.indep3);
                                SELF.indep4 := (INTEGER)IF(real_random_between(0, 1) < CF, de_style_mutation(one.indep4, two.indep4, three.indep4), one.indep4);        
                        END;
                        new_independent_population := DATASET(COUNT(population), new_member(population[COUNTER], fetch_random_member(),fetch_random_member(), COUNTER));
                        new_evaluated_population := PROJECT(new_independent_population, evaluate_individual(LEFT));
                        PLTypes.de_rec filter_it( PLTypes.de_rec L, PLTypes.de_rec R) := TRANSFORM
                                SELF := IF(L.objective > R.objective, L, R)
                        END;
                        filtered_population := JOIN(population, new_evaluated_population, LEFT.individual_id = RIGHT.individual_id, filter_it(LEFT, RIGHT));
                        RETURN filtered_population;
                END;
                
                EXPORT DATASET(PLTypes.de_rec)  run_multiple_generation(DATASET(PLTypes.de_rec) population , INTEGER number_of_generations):= FUNCTION
                        // final_population := LOOP(population, COUNTER<number_of_generations, run_one_generation(ROWS(LEFT),COUNTER+1));
                        final_population := LOOP(population,    
                                                COUNTER <= number_of_generations,
                                                run_one_generation(ROWS(LEFT) , COUNTER+1)
                                                );
                        RETURN final_population;
                END;
        END; 



tuning_range := DATASET([
        {1, 40, 80, 40},
        {2, 3, 4, 1},
        {3, 0.9, 1.0, 0.1},
        {4, 28, 36, 1}],
        PLTypes.tuning_range_rec);

OUTPUT(tuning_range(parameter_id=1));
EA := DE(tuning_range);
zero_pop := EA.generate_population();
OUTPUT(zero_pop, NAMED('GEN0'));
// first_pop := EA.run_one_generation(zero_pop, 1);
// OUTPUT(first_pop, NAMED('GEN1'));
final_pop := EA.run_multiple_generation(zero_pop, 20);
OUTPUT(final_pop);