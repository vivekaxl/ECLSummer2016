IMPORT * FROM ML;
IMPORT * FROM ML.Types;
IMPORT * FROM ParameterTuning;


tuning_range := DATASET([
        {1, 40, 80, 40}/*,
        {2, 3, 4, 1},
        {3, 0.9, 1.0, 0.1},
        {4, 28, 29, 1}*/],
        PLTypes.tuning_range_rec);
        
OUTPUT(tuning_range);




AnyDataSet := ecoliDS.content;
new_data_set := TABLE(AnyDataSet, {AnyDataSet, select_number := RANDOM()%100});
raw_train_data := new_data_set(select_number <= 40);
raw_tune_data := new_data_set(select_number > 40 AND select_number < 60);
raw_test_data := new_data_set(select_number > 60);


PLUtils.ToTraining(raw_train_data, train_data_independent);
PLUtils.ToTesting(raw_train_data, train_data_dependent);
PLUtils.ToTraining(raw_tune_data, tune_data_independent);
PLUtils.ToTesting(raw_tune_data, tune_data_dependent);
PLUtils.ToTraining(raw_test_data, test_data_independent);
PLUtils.ToTesting(raw_test_data, test_data_dependent);


ToField(train_data_independent, pr_indep);
trainIndepData := ML.Discretize.ByRounding(pr_indep);
ToField(train_data_dependent, pr_dep);
trainDepData := ML.Discretize.ByRounding(pr_dep);

ToField(tune_data_independent, tu_indep);
tuneIndepData := ML.Discretize.ByRounding(tu_indep);
ToField(tune_data_dependent, tu_dep);
tuneDepData := ML.Discretize.ByRounding(tu_dep);

ToField(test_data_independent, tr_indep);
testIndepData := ML.Discretize.ByRounding(tr_indep);
ToField(test_data_dependent, tr_dep);
testDepData := ML.Discretize.ByRounding(tr_dep);


OUTPUT(tune_data_independent);
OUTPUT(tune_data_dependent);

grid := PLUtils.MakeGrid(tuning_range);
OUTPUT(grid, ALL);
// PLhelper.RunRandomForestClassfier(trainIndepData, trainDepData, tuneIndepData, tuneDepData, 100, 7, 1.0, 100);

numberFormat := RECORD
		grid;
		REAL result;
	END;
result := PROJECT(grid, TRANSFORM(numberFormat, 
                                SELF.result := PLhelper.RunRandomForestClassfier(trainIndepData, trainDepData, tuneIndepData, tuneDepData, LEFT.v1, 3, 1.0, 100);
                                SELF := LEFT;
                        ));
OUTPUT(result);