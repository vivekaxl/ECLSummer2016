/*
 Table: 
- generate temp recordset
- specific query is running
- Two forms of tables
-- vertical slice form
-- crosstab report form

# Vertical Slice Form:
- Explicity need to define the data type
- Local variable needs to have default values
*/

IMPORT TrainingVivekNair as X;

r := RECORD
	X.File_Persons.File.LastName;
	X.File_Persons.File.Gender;
	GrpCnt := COUNT(GROUP);
	MaxLen := MAX(GROUP, LENGTH(TRIM(X.File_Persons.File.FirstName)));
END;

tbl := TABLE(X.File_Persons.File, r, LastName, Gender);

OUTPUT(tbl);
OUTPUT(SORT(tbl, -MaxLen));

filter_table := X.File_Persons.File(LastName = 'Candella', Gender = 'F');
OUTPUT(filter_table);