IMPORT ML;
IMPORT ParameterTuning AS PL;

AnyDataSet := PL.ecoliDS.content;

tuning_range := DATASET([
                        {1, 40, 80, 40},
                        {2, 3, 4, 1},
                        {3, 0.9, 1.0, 0.1},
                        {4, 28, 29, 1}
                        ],
                        PL.PLTypes.tuning_range_rec);

INTEGER c_parameters := COUNT(tuning_range);
/*
        Due to the current implementation of GridSearch, user need to explicitly mention the number of grid points even 
        though this information can be retrieved from the grid produced. GridSearch is implemented using the ECL template 
        language which throws an error asking the value of c_tuning_range to be constant.
*/
INTEGER c_tuning_range := 16;

new_data_set := TABLE(AnyDataSet, {AnyDataSet, select_number := RANDOM()%100});
raw_train_data := new_data_set(select_number <= 40);
raw_tune_data := new_data_set(select_number > 40 AND select_number < 60);
raw_test_data := new_data_set(select_number > 60);

PL.PLUtils.ToTraining(raw_train_data, train_data_independent);
PL.PLUtils.ToTesting(raw_train_data, train_data_dependent);
PL.PLUtils.ToTraining(raw_tune_data, tune_data_independent);
PL.PLUtils.ToTesting(raw_tune_data, tune_data_dependent);
PL.PLUtils.ToTraining(raw_test_data, test_data_independent);
PL.PLUtils.ToTesting(raw_test_data, test_data_dependent);


ML.ToField(train_data_independent, pr_indep);
trainIndepData := ML.Discretize.ByRounding(pr_indep);
ML.ToField(train_data_dependent, pr_dep);
trainDepData := ML.Discretize.ByRounding(pr_dep);

ML.ToField(tune_data_independent, tu_indep);
tuneIndepData := ML.Discretize.ByRounding(tu_indep);
ML.ToField(tune_data_dependent, tu_dep);
tuneDepData := ML.Discretize.ByRounding(tu_dep);

ML.ToField(test_data_independent, tr_indep);
testIndepData := ML.Discretize.ByRounding(tr_indep);
ML.ToField(test_data_dependent, tr_dep);
testDepData := ML.Discretize.ByRounding(tr_dep);


Tuner := PL.PLAlgorithms.GridSearch(trainIndepData, trainDepData, tuneIndepData, tuneDepData);
chosen_parameter := Tuner.RunGrid('PL.PLhelper.RunRandomForestClassfier', tuning_range, c_tuning_range, c_parameters);
OUTPUT(chosen_parameter, NAMED('ChosenParameter'));
OUTPUT(chosen_parameter(number=1)[1].value);
OUTPUT(chosen_parameter(number=2)[1].value);
OUTPUT(chosen_parameter(number=3)[1].value);
OUTPUT(chosen_parameter(number=4)[1].value);

// default_rfd := PL.PLhelper.RunRandomForestClassfier(trainIndepData, trainDepData, testIndepData, testDepData, 100, 4, 1.0, 100);
default_rfd := 0.6;
// chosen_parameter := DATASET([
// {3,1,40.0},
// {3,2,3.0},
// {3,3,1.0},
// {3,4,28.0}
// ], ML.Types.NumericField);
tuning_rfd := PL.PLhelper.RunRandomForestClassfier(trainIndepData, trainDepData, testIndepData, testDepData, 
                                                chosen_parameter(number=1)[1].value, chosen_parameter(number=2)[1].value, 
                                                chosen_parameter(number=3)[1].value, chosen_parameter(number=4)[1].value);
improvement := default_rfd - tuning_rfd;

OUTPUT(improvement, NAMED('Improvement'));
