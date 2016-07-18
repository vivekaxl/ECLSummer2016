IMPORT ML;
IMPORT ML.Types;
IMPORT ParameterTuning AS PL;
IMPORT PL.PLAlgorithms.DE AS DE;

// EXPORT run_multiple_generations(tuning_ranges, population , number_of_generations):= FUNCTIONMACRO
        // LOCAL generation_1 := population;
        // #DECLARE(sc_run_multiple_generations) #SET(sc_run_multiple_generations, '')
        // #DECLARE(ngenerations); #SET(ngenerations, 1);
        // #LOOP
                // #IF(%ngenerations% <= number_of_generations)
                        // #APPEND(sc_run_multiple_generations, 'LOCAL generation_' + (%ngenerations%+1)+ ':= DE.run_one_generation(tuning_ranges, generation_' + %'ngenerations'% + ',' +%ngenerations%+');\n')
                // #ELSE #BREAK;
                // #END
                // #SET(ngenerations, %ngenerations%+1);
        // #END
        // %sc_run_multiple_generations%
        // LOCAL result := #EXPAND('generation_' + (%ngenerations%))
        // RETURN  result;
// ENDMACRO;

EXPORT DATASET(ML.Types.NumericField)run_multiple_generations(DATASET(PL.PLTypes.tuning_range_rec)tuning_ranges, DATASET(ML.Types.NumericField) t_population , INTEGER number_of_generations=20, INTEGER number_of_paramaters=3):= FUNCTION
                        // final_population := LOOP(population, COUNTER<number_of_generations, run_one_generation(ROWS(LEFT),COUNTER+1));
                        // temp_population := DE.run_one_generation(tuning_ranges, t_population, 1, 4);
                        final_population := LOOP(t_population,    
                                                COUNTER <= number_of_generations,
                                                run_one_generation(tuning_ranges, ROWS(LEFT), COUNTER+1, 3)
                                                );
                        RETURN final_population;
                END;