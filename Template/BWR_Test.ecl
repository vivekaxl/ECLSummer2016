IMPORT testing;

DataRec := RECORD
    STRING      s;
    INTEGER     n;
END;

ds := DATASET
    (
        [
            {'this,is,a,test', 1},
            {'another test', 2},
            {'to be, or not to be', 3}
        ],
        DataRec
    );

testing.ReplaceCharInDataset(ds, ',', ' ');
testing.EscapeCharInDataset(ds, ',');
