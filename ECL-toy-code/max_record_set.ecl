student := RECORD
	STRING name;
	INTEGER id;
END;

students := DATASET([{'a', 1},{'b', 25}, {'c', 12}, {'d', 32}],student);

OUTPUT(MAX(students, students.id));