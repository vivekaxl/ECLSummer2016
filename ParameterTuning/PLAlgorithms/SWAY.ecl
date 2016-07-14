IMPORT * FROM ML;
IMPORT * FROM ML.Types;
IMPORT * FROM ParameterTuning;

SWAY(DATASET(PLTypes.tuning_range_rec) t_ranges, REAL CF=0.75, REAL F=0.3) := MODULE  
         SHARED REAL euclidean_distance(DATASET(Types.NumericField) a, DATASET(Types.NumericField) b):= FUNCTION
                        temp := JOIN(a, b, LEFT.number = RIGHT.number, TRANSFORM(Types.NumericField, 
                                                                        SELF.id := -1;
                                                                        SELF.number := LEFT.number;
                                                                        SELF.value := POWER(LEFT.value-RIGHT.value, 2)
                                                                        ));
                        return (SQRT(SUM(temp, temp.value)));
        END;
        
        SHARED REAL real_random_between(INTEGER lower_limit, ANY upper_limit) := FUNCTION
                        RETURN lower_limit + ((RANDOM()%100)/100) * (upper_limit - lower_limit);
                END;
                
        EXPORT DATASET(Types.NumericField)  generate_population(INTEGER population_size=20):= FUNCTION
                PLTypes.indep_sway_rec generate_individual(INTEGER id=-1, INTEGER gen=0):= TRANSFORM
                        SELF.id := id;
                        SELF.indep1 := (INTEGER)real_random_between(t_ranges(parameter_id=1)[1].minimun_value, t_ranges(parameter_id=1)[1].maximum_value);
                        SELF.indep2 := (REAL)real_random_between(t_ranges(parameter_id=2)[1].minimun_value, t_ranges(parameter_id=2)[1].maximum_value);
                        SELF.indep3 := (REAL)real_random_between(t_ranges(parameter_id=3)[1].minimun_value, t_ranges(parameter_id=3)[1].maximum_value);
                        SELF.indep4 := (INTEGER)real_random_between(t_ranges(parameter_id=4)[1].minimun_value, t_ranges(parameter_id=4)[1].maximum_value);
                END;

                independent_population := DATASET(population_size, generate_individual(COUNTER));
                ToField(independent_population, nf_zero_pop);
                RETURN nf_zero_pop;
        END;
        
        EXPORT DATASET(ML.Types.NumericField) run_one_split(DATASET(ML.Types.NumericField) nf_zero_pop) := FUNCTION
                Distances := Cluster.distances(nf_zero_pop, nf_zero_pop);
                poles_indexes := Distances(value = MAX(Distances, Distances.value));
                east := nf_zero_pop(id = poles_indexes[1].x);
                west := nf_zero_pop(id = poles_indexes[1].y);
                c_2 := POWER(poles_indexes[1].value, 2);
                
                INTEGER projected(DATASET(Types.NumericField) east, DATASET(Types.NumericField) west, INTEGER individual_id, DATASET(Types.NumericField) population):= FUNCTION
                        t_individual := population(id=individual_id);
                        a_2 := POWER(euclidean_distance(east, t_individual), 2);
                        b_2 := POWER(euclidean_distance(west, t_individual), 2);
                        RETURN (a_2 + c_2 - b_2) / (2*SQRT(c_2));
                END;

                add_proj_rec := RECORD
                      INTEGER id;
                      REAL projected_distance;
                END;

                // Find projections on to the first principal component                
                ids := DEDUP(SORT(nf_zero_pop, id), id);
                projected_population := SORT(PROJECT(ids, TRANSFORM(add_proj_rec, 
                                                                                SELF.projected_distance := projected(east, west, LEFT.id, nf_zero_pop);
                                                                                SELF.id := LEFT.id;
                                                                                )), projected_distance);
                split_point := COUNT(projected_population)/2;
                DATASET(ML.Types.NumericField) get_split_data(DATASET(add_proj_rec) selected_points, DATASET(ML.Types.NumericField) population) := FUNCTION
                        RETURN JOIN(selected_points, population, LEFT.id = RIGHT.id, TRANSFORM(RECORDOF(population),SELF := RIGHT));
                END;

                REAL ObjectiveFunction(DATASET(ML.Types.NumericField) individual):= FUNCTION
                                                RETURN SUM(individual, individual.value) ;
                END;
                
                surviving_split := IF(ObjectiveFunction(east) >=  ObjectiveFunction(west),
                                        get_split_data(projected_population[1..split_point], nf_zero_pop), 
                                        get_split_data(projected_population[split_point+1..COUNT(projected_population)], nf_zero_pop)
                                        );
                RETURN surviving_split;
        END;
        
END;

tuning_range := DATASET([
        {1, 40, 80, 40},
        {2, 3, 4, 1},
        {3, 0.9, 1.0, 0.1},
        {4, 28, 36, 1}],
        PLTypes.tuning_range_rec);
        
EA := SWAY(tuning_range);
nf_zero_pop := EA.generate_population(100);

// Change into Field

after_first_split := EA.run_one_split(nf_zero_pop);
OUTPUT(after_first_split, ALL);






/*
// To reuse distances
subset_distances_1 := JOIN(surviving_split, Distances, LEFT.id = RIGHT.x, TRANSFORM(RECORDOF(Distances),SELF := RIGHT));
subset_distances := JOIN(surviving_split, subset_distances_1, LEFT.id = RIGHT.y, TRANSFORM(RECORDOF(Distances),SELF := RIGHT));
subset_distances;
*/