rNumber := RECORD
	UNSIGNED2 num;
END;

dNumbers := DATASET([{1}, {2}, {3}, {4}], rNumber);
OUTPUT(MIN(125, dNumbers[1].num));
OUTPUT(MAX(125, dNumbers[1].num));