MyRec := RECORD
	INTEGER2 Value1;
	INTEGER2 Value2;
END;

SomeFile := DATASET([
										{10, 0},
										{20, 0},
										{30, 0},
										{40, 0},
										{50, 0}
										], MyRec);
										
SomeFile AddThem(SomeFile L, SomeFile R) := TRANSFORM
	SELF.Value2 := L.Value2 + R.Value1;
	SELF := R;
END;

AddedRecs := ITERATE(SomeFile, AddThem(LEFT, RIGHT));
OUTPUT(AddedRecs);