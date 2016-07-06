IMPORT TrainingVivekNair as X;

vertical_slice := RECORD
	X.File_Persons.File.DependentCount;
END;

OUTPUT(COUNT(X.File_Persons.File));

tbl_vs := TABLE(X.File_Persons.File, vertical_slice);
OUTPUT(COUNT(tbl_vs));

tbl_h := DISTRIBUTE(tbl_vs, HASH32(DependentCount));
tbl_c := tbl_h(DependentCount = 0);
OUTPUT(COUNT(tbl_c));


