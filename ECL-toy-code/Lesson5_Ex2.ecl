IMPORT TrainingVivekNair as X;

lb_ex2 := RECORD
	X.File_Persons.File.Gender;
	gender_count := COUNT(GROUP);
END;

tbl_lb_ex2 := TABLE(X.File_Persons.File, lb_ex2, Gender);
OUTPUT(SORT(tbl_lb_ex2, -gender_count));