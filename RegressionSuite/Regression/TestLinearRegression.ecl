IMPORT Std;
IMPORT * FROM ML;
IMPORT ML.Tests.Explanatory as TE;
IMPORT * FROM ML.Types;
IMPORT * FROM TestingSuite.Utils;
IMPORT TestingSuite.Regression as Regression;

EXPORT TestLinearRegression(raw_dataset_name, ground_truth) := FUNCTIONMACRO
        AnyDataSet := raw_dataset_name;
        AnyDataSetGT:= ground_truth;

        RunLinearRegression(DATASET(NumericField) IndepData, DATASET(NumericField) DepData) := FUNCTION
                        model := ML.Regression.sparse.OLS_LU(IndepData, DepData);
                        return model.Betas;
        END;

        WrapperRunLinearRegression(DATASET(RECORDOF(AnyDataSet)) AnyDataSet, DATASET(RECORDOF(AnyDataSetGT)) AnyDataSetGT):= FUNCTION

                // Splitting data into train and test	
                ToTraining(AnyDataSet, data_independent);
                ToTesting(AnyDataSet, data_dependent);

                ToField(data_independent, pr_indep);
                ToField(data_dependent, pr_dep);
                
                
                result := RunLinearRegression(pr_indep, pr_dep);
                acc_data_rec := RECORD
                        INTEGER id;
                        REAL ecl_value;
                        REAL scikit_value;
                        INTEGER result;
                END;

                acc_data := JOIN(result(number>0), 
                                AnyDataSetGT, 
                                LEFT.number = RIGHT.number,
                                TRANSFORM(acc_data_rec,                        
                                        SELF.id := LEFT.number,
                                        SELF.ecl_value := LEFT.value,
                                        SELF.scikit_value := RIGHT.value,
                                        SELF.result := IF(LEFT.value - RIGHT.value < 0.000001, 1, 0))
                                );
                RETURN IF(SUM(acc_data, result) = COUNT(acc_data), '1', '0');
        END;

        RETURN WrapperRunLinearRegression(AnyDataSet, AnyDataSetGT);
ENDMACRO;
// OUTPUT(AnyDataSet);
// WrapperRunLinearRegression(
// EXPORT TestLinearRegression := 'todo';