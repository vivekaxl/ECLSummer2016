rNumbers := RECORD
	INTEGER num;
END;

rNumbers add_two(rNumbers numbers) := TRANSFORM
	SELF.num := numbers.num + 2;
END;

dNumbers := DATASET([{1},{2},{3},{4},{5},{6},{7},{8},{9}], rNumbers);
OUTPUT(dNumbers, NAMED('BEFORE'));
OUTPUT(PROJECT(dNumbers, add_two(LEFT)), NAMED('AFTER'));