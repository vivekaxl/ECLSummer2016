IMPORT TutorialVivekNair, Std;

TutorialVivekNair.Layout_People toUpperB(TutorialVivekNair.Layout_People l) := TRANSFORM
SELF.FirstName := Std.Str.ToUpperCase(l.FirstName);
SELF.LastName := Std.Str.ToUpperCase(l.LastName);
SELF.MiddleName := Std.Str.ToUpperCase(l.MiddleName);
SELF.Zip := l.Zip;
SELF.Street := l.Street;
SELF.City := l.City;
SELF.STATE := l.State;
END;

new_record_set := PROJECT(TutorialVivekNair.File_OriginalPerson, toUpperB(LEFT));
OUTPUT(new_record_set)
