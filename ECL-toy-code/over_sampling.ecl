numberFormat := RECORD
	UNSIGNED id;
	INTEGER one;
	INTEGER two;
	INTEGER three;
END;

data_set := DATASET(
[{1, 1,2,3},
{2, 2,3,4},
{3, 3,4,5}],
numberFormat
);

new_data_set := DATASET(20,
						TRANSFORM(numberFormat,
						SELF.id := COUNTER;
						SELF := data_set[RANDOM() % COUNT(data_set) + 1]));
						
OUTPUT(COUNT(new_data_set));
OUTPUT(new_data_set);