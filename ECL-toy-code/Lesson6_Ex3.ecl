IMPORT TrainingVivekNair as X;

vertical_slice := RECORD
	X.File_Persons.File.BureauCode;
END;

tbl := TABLE(X.File_Persons.File, vertical_slice);
OUTPUT(tbl, NAMED('vertical_slice'), ALL);
tbl_d := DISTRIBUTE(tbl, HASH32(BureauCode));

tbl_s := SORT(tbl_d, BureauCode, LOCAL);
OUTPUT(tbl_s,NAMED('SORTED'), ALL);

tbl_c := DEDUP(tbl_s, BureauCode, LOCAL);
OUTPUT(COUNT(tbl_c));