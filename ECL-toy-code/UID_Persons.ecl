IMPORT TrainingVivekNair as X;

Layout2 := RECORD(X.File_Persons.Layout)
	INTEGER UID_Persons;
END;

Layout2 add_uid(X.File_Persons.Layout L, INTEGER counter_value):= TRANSFORM
	SELF.UID_Persons := counter_value;
	SELF := L;
END;

EXPORT UID_Persons := PROJECT(X.File_Persons.File, add_uid(LEFT, COUNTER)): PERSIST('~ONLINE::VN::PERSIST::UID_People');