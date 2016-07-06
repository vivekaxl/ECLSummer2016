rStudent := RECORD
	STRING25 name;
	INTEGER age;
	STRING25 moms_name;
	STRING25 dads_name;
END;

dStudent := DATASET([{'a', 12, 'aa', 'aaa'}, {'b', 23, 'bb', 'bbb'}, {'c', 13, 'cc', 'ccc'}, {'ab', 23, 'abb', 'abbb'}], rStudent);

N := MAX(dStudent, dStudent.age);
OUTPUT(N, NAMED('N'));
Instances := COUNT(dStudent);
OUTPUT(Instances, NAMED('Instances'));
Fields := COUNT(dStudent(age=N));
OUTPUT(Fields, NAMED('Fields'));