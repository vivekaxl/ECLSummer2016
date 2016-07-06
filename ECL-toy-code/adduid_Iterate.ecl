IMPORT TrainingVivekNair as X;

Layout2 := RECORD(X.File_Persons.Layout)
	UNSIGNED UID := 0;
END;

Layout2 add_field(X.File_Persons.Layout L):= TRANSFORM
	SELF.UID := 0;
	SELF := L;
END;

Layout2 add_fieldno(Layout2 L, Layout2 R, INTEGER num = 1) := TRANSFORM
	SELF.UID := L.UID + num;
	SELF := R;
END;

tbl := PROJECT(X.File_Persons.File, add_field(LEFT));
tbl1 := ITERATE(tbl, add_fieldno(LEFT, RIGHT));
OUTPUT(SORT(tbl1, UID));