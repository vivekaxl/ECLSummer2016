Layout_People := RECORD
    STRING field1;
    STRING field2;
    STRING field3;
    STRING field4;
    STRING field5;
    STRING field6;
    STRING field7;
    STRING field8;
    STRING field9;
    STRING field10;
    STRING field11;
    STRING field12;
    STRING field13;
    STRING field14;
    STRING field15;
    STRING field16;
    STRING field17;
    STRING field18;
    STRING field19;
    STRING field20;
    STRING field21;
    STRING field22;
    STRING field23;
    STRING field24;
    STRING field25;
END;
set_data := DATASET('~vivek::classification_german.csv',Layout_People, CSV)[1..100];
new_data_set := TABLE(set_data, {set_data, select_number:= RANDOM() & (128 - 1)});
dsTraining := new_data_set(select_number <= 50 * 1.28);
dsTesting := new_data_set(select_number > 50 * 1.28);

dsTraining;
dsTesting;

tdsTraining := PROJECT(new_data_set, TRANSFORM({RECORDOF(LEFT) AND NOT {new_data_set.select_number}}, SELF:= LEFT));
// tdsTraining := TABLE(dsTraining, Layout_People);
// tdsTesting := TABLE(dsTesting, Layout_People);

tdsTraining;
// tdsTesting;