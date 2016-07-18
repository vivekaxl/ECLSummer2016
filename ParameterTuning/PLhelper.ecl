IMPORT ML;
IMPORT ML.Types;


EXPORT PLhelper := MODULE
        EXPORT RunRandomForestClassfier(DATASET(ML.Types.DiscreteField) trainIndepData, DATASET(ML.Types.DiscreteField) trainDepData, DATASET(ML.Types.DiscreteField) testIndepData, DATASET(ML.Types.DiscreteField) testDepData,ML.Types.t_Count treeNum, ML.Types.t_Count fsNum, REAL Purity=1.0, ML.Types.t_level maxLevel=32) := FUNCTION
                learner := ML.Classify.RandomForest(treeNum, fsNum, Purity, maxLevel);  
                result := learner.LearnD(trainIndepData, trainDepData); 
                model:= learner.model(result);  
                class:= learner.classifyD(testIndepData, result); 
                performance:= ML.Classify.Compare(testDepData, class);
                return performance.Accuracy[1].accuracy;
        END;
        
        EXPORT RunDecisionTreeClassfier(DATASET(ML.Types.DiscreteField) trainIndepData, DATASET(ML.Types.DiscreteField) trainDepData, DATASET(ML.Types.DiscreteField) testIndepData, DATASET(ML.Types.DiscreteField) testDepData,ML.Types.t_Count Depth, REAL Purity=1.0) := FUNCTION
                learner := ML.Classify.DecisionTree.GiniImpurityBased(Depth, Purity);  
                result := learner.LearnD(trainIndepData, trainDepData); 
                model:= learner.model(result);  
                class:= learner.classifyD(testIndepData, result); 
                performance:= ML.Classify.Compare(testDepData, class);
                return performance.Accuracy[1].accuracy;
        END;
        
        EXPORT REAL DummyObjectiveFunction(DATASET(ML.Types.NumericField) individual) := FUNCTION
                RETURN SUM(individual, individual.number);
        END;
        
END;