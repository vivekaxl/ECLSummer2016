Word := RECORD
	UNSIGNED Id;
	STRING Alphabet;
END;

INTEGER NO_OF_WORDS := 100;
INTEGER ALPHA_MAX := 26;
INTEGER ASCII_MIN := 65;
INTEGER LENGTH_OF_WORD := 30;

Word Generate_Alphabet(Word L, INTEGER C) := TRANSFORM
	SELF.Id := C;
	SELF.Alphabet := '';
END;

Word Generate_More_Alphabet(Word L):= TRANSFORM
	SELF.Id := L.Id;
	SELF.Alphabet := TRIM((>STRING1<)(RANDOM() % ALPHA_MAX + ASCII_MIN));
END;

Word Merge_Alphabets(Word L, Word R):= TRANSFORM
	SELF.Id := L.Id;
	SELF.Alphabet := L.Alphabet + R.Alphabet;
END;

Words1 := NORMALIZE(DATASET([{1, 0}], Word), NO_OF_WORDS, Generate_Alphabet(LEFT, COUNTER));
OUTPUT(Words1, NAMED('Words1'));
Words2 := NORMALIZE(Words1, RANDOM()%LENGTH_OF_WORD + 1, Generate_More_Alphabet(LEFT));
OUTPUT(Words2, NAMED('Words2'));
Words3 := ROLLUP(Words2, LEFT.Id = RIGHT.Id, Merge_Alphabets(LEFT, RIGHT));
OUTPUT(Words3, NAMED('Words3'));

