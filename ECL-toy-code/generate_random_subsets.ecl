rNumber := RECORD
INTEGER old;
INTEGER new;
END;

rNumber tNumber(rNumber L, INTEGER c) := TRANSFORM
SELF.old := c;
SELF.new := 0;
END;

C := 100;
seed := DATASET([{0,0}], rNumber);
dNumber := NORMALIZE(seed, C, tNumber(seed, COUNTER));
OUTPUT(dNumber, NAMED('BEFORE'));

rNumber ttNumber(rNumber L, INTEGER size):= TRANSFORM
SELF.old := L.old;
SELF.new := RANDOM()%size + 1;
END;

cNumber := PROJECT(dNumber, ttNumber(LEFT, C));
OUTPUT(cNumber, NAMED('After'));