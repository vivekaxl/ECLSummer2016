IMPORT * FROM ML;
IMPORT ML.Tests.Explanatory as TE;
IMPORT * FROM ML.Types;

//Tiny dataset for tests
weatherRecord := RECORD
	Types.t_RecordID id;
	Types.t_FieldNumber outlook;
	Types.t_FieldNumber temperature;
	Types.t_FieldNumber humidity;
	Types.t_FieldNumber windy;
	Types.t_FieldNumber play;
END;
weather_Data := DATASET([
{1,0,0,1,0,0},
{2,0,0,1,1,0},
{3,1,0,1,0,1},
{4,2,1,1,0,1},
{5,2,2,0,0,1},
{6,2,2,0,1,0},
{7,1,2,0,1,1},
{8,0,1,1,0,0},
{9,0,2,0,0,1},
{10,2,1,0,0,1},
{11,0,1,0,1,1},
{12,1,1,1,1,1},
{13,1,0,0,0,1},
{14,2,1,1,1,0}],
weatherRecord);


ToTraining(Resdata, dOut) := MACRO
    IMPORT Std;
    LOADXML('<xml/>');
    #EXPORTXML(fields, RECORDOF(Resdata));
		
		#DECLARE(OutStr);
		#SET(OutStr,'{');

		#FOR(fields)
				#FOR(Field)
					#IF ((%'{@name}'% <> 'play') AND (%'{@name}'% <> 'select_number'))
						#APPEND(OutStr, %'{@name}'%);
						#APPEND(OutStr, ',');
					#END
				#END
		#END
		#APPEND(OutStr, '}');
		dOut := TABLE(Resdata, #EXPAND(%'OutStr'%));
ENDMACRO;


EXPORT ToTesting(Resdata, dOut) := MACRO
    IMPORT Std;
    LOADXML('<xml/>');
    #EXPORTXML(fields, RECORDOF(Resdata));
		
		#DECLARE(OutStr);
		#SET(OutStr,'{');

		#FOR(fields)
				#FOR(Field)
					#IF (%'{@name}'% = 'id')
						#APPEND(OutStr, %'{@name}'%);
						#APPEND(OutStr, ',');
					#ELSEIF (%'{@name}'% = 'play')
						#APPEND(OutStr, %'{@name}'%);
						#APPEND(OutStr, ',');
					#END
				#END
		#END
		#APPEND(OutStr, '}');
		dOut := TABLE(Resdata, #EXPAND(%'OutStr'%));
ENDMACRO;


// To create training and testing sets
new_data_set := TABLE(weather_data, {weather_data, select_number := RANDOM()%100});
raw_train_data := new_data_set(select_number <= 40);
raw_test_data := new_data_set(select_number > 40);
OUTPUT(raw_train_data);


ToTraining(raw_train_data, train_data_independent);
ToTesting(raw_train_data, train_data_dependent);

ToTraining(raw_test_data, test_data_independent);
ToTesting(raw_test_data, test_data_dependent);
OUTPUT(train_data_independent);
OUTPUT(train_data_dependent);
OUTPUT(test_data_independent);
OUTPUT(test_data_dependent);