 IMPORT ML;
IMPORT ParameterTuning AS PL;
IMPORT PL.PLAlgorithms.DE AS DE;
tuning_range := DATASET([
                        {1, 40, 80, 40},
                        {2, 3, 4, 1},
                        {3, 0.9, 1.0, 0.1},
                        {4, 28, 29, 1}
                        ],
                        PL.PLTypes.tuning_range_rec);


zero_pop := DE.generate_population(tuning_range);
OUTPUT(zero_pop);
temp_population := DE.run_one_generation(tuning_ranges, zero_pop, 1, 4);
OUTPUT(temp_population);
final_pop := DE.run_multiple_generations(tuning_range, zero_pop, 20, 4);
final_pop;