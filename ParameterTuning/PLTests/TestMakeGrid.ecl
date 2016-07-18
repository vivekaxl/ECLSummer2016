IMPORT ML;
IMPORT ParameterTuning AS PL;
tuning_range := DATASET([
                        {1, 40, 80, 40},
                        {2, 3, 4, 1},
                        {3, 0.9, 1.0, 0.1},
                        {4, 28, 29, 1}
                        ],
                        PL.PLTypes.tuning_range_rec);

grid := PL.PLUtils.MakeGrid(tuning_range);

// Since grid is of ML.Types.NumericField
OUTPUT(COUNT(grid)/COUNT(tuning_range));

OUTPUT(grid, ALL);