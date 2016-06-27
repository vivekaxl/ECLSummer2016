IMPORT * FROM ML;
IMPORT * FROM ML.Types;


EXPORT PLhelper := MODULE
        EXPORT RunRandomForestClassfier(DATASET(DiscreteField) trainIndepData, DATASET(DiscreteField) trainDepData, DATASET(DiscreteField) testIndepData, DATASET(DiscreteField) testDepData,t_Count treeNum, t_Count fsNum, REAL Purity=1.0, t_level maxLevel=32) := FUNCTION
                learner := Classify.RandomForest(treeNum, fsNum, Purity, maxLevel);  
                result := learner.LearnD(trainIndepData, trainDepData); 
                model:= learner.model(result);  
                class:= learner.classifyD(testIndepData, result); 
                performance:= Classify.Compare(testDepData, class);
                return performance.Accuracy[1].accuracy;
        END;
END;