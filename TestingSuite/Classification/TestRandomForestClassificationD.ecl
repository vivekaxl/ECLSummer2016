//RandomForest.ecl
IMPORT Std;
IMPORT * FROM ML;
IMPORT ML.Tests.Explanatory as TE;
IMPORT * FROM ML.Types;
IMPORT * FROM TestingSuite.Utils;
IMPORT TestingSuite.Classification as Classification;

EXPORT TestRandomForestClassificationD(raw_dataset_name, repeats) := FUNCTIONMACRO
	//STRING dataset_name := 'Classification.Datasets.' + raw_dataset_name + '.content';
	AnyDataSet :=  TABLE(raw_dataset_name);

	RunRandomForestClassfier(DATASET(DiscreteField) trainIndepData, DATASET(DiscreteField) trainDepData, DATASET(DiscreteField) testIndepData, DATASET(DiscreteField) testDepData,t_Count treeNum, t_Count fsNum, REAL Purity=1.0, t_level maxLevel=32) := FUNCTION
			learner := Classify.RandomForest(treeNum, fsNum, Purity, maxLevel);  
			result := learner.LearnD(trainIndepData, trainDepData); 
			model:= learner.model(result);  
			class:= learner.classifyD(testIndepData, result); 
			performance:= Classify.Compare(testDepData, class);
			return performance.Accuracy[1].accuracy;
		END;



	WrapperRunRandomForestClassfier(DATASET(RECORDOF(AnyDataSet)) AnyDataSet):= FUNCTION

		// To create training and testing sets
		new_data_set := TABLE(AnyDataSet, {AnyDataSet, select_number := RANDOM()%100});


		raw_train_data := new_data_set(select_number <= 40);
		raw_test_data := new_data_set(select_number > 40);

		// Splitting data into train and test	
		ToTraining(raw_train_data, train_data_independent);
		ToTesting(raw_train_data, train_data_dependent);
		ToTraining(raw_test_data, test_data_independent);
		ToTesting(raw_test_data, test_data_dependent);

		ToField(train_data_independent, pr_indep);
		trainIndepData := ML.Discretize.ByRounding(pr_indep);
		ToField(train_data_dependent, pr_dep);
		trainDepData := ML.Discretize.ByRounding(pr_dep);

		ToField(test_data_independent, tr_indep);
		testIndepData := ML.Discretize.ByRounding(tr_indep);
		ToField(test_data_dependent, tr_dep);
		testDepData := ML.Discretize.ByRounding(tr_dep);
		
		result := RunRandomForestClassfier(trainIndepData, trainDepData, testIndepData, testDepData, 100, 7, 1.0, 100);
		return result;
	END;


	numberFormat := RECORD
		INTEGER run_id;
		REAL result;
	END;
	IMPORT Std;

	results := DATASET(#EXPAND(repeats),
							TRANSFORM(numberFormat,
							SELF.run_id := COUNTER;
							SELF.result := WrapperRunRandomForestClassfier(AnyDataSet);
							));


	RETURN (REAL)AVE(results, results.result); 
ENDMACRO;

//OUTPUT(TestRandomForestClassification(Classification.Datasets.ecoliDS.content, 3));
