typeA := RECORD
		UNSIGNED id;
		STRING firstName;
		STRING lastName;
		UNSIGNED cellPhone;
END;

typeB := RECORD
		UNSIGNED id;
		STRING Address;
END;

typeC := RECORD(typeA)
		STRING Address;
END;

phoneBook := DATASET([
{1, 'a', 'b', 1231252},
{2, 'c', 'd', 8709832},
{3, 'e', 'f', 6756723},
{4, 'g', 'h', 2349872},
{5, 'i', 'j', 7823234}
], typeA);

addressBook := DATASET([
{1, 'sadaqweasasd'},
{2, 'asdxzcasdf'},
{3, 'wrwerwerwe'},
{4, 'yrtretwdf'},
{5, 'wfscxzxsdf'}
], typeB);

typeC combine1(typeA l, typeB r) := TRANSFORM
		SELF.address := r.address;
		SELF := l;
END;

typeC combine2(typeB r, typeA l) := TRANSFORM
		SELF.address := r.address;
		SELF := l;
END;

combined := JOIN(phoneBook, addressBook, LEFT.id = RIGHT.id, combine1(LEFT, RIGHT));
combined2 := JOIN(addressBook, phoneBook, RIGHT.id = LEFT.id, combine2(LEFT, RIGHT));

OUTPUT(combined, NAMED('combined1'));
OUTPUT(combined2, NAMED('combined2'));