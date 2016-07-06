EXPORT ReplaceCharInDataset(inFile, oldChar, newChar) := FUNCTIONMACRO
    IMPORT Std;

    LOADXML('<xml/>');
    #EXPORTXML(fields, RECORDOF(inFile))

    RETURN PROJECT
        (
            inFile,
            TRANSFORM
                (
                    RECORDOF(inFile),
                    #FOR(fields)
                        #FOR(Field)
                            #IF(%'@type'% = 'string')
                                #EXPAND('SELF.' + %'@name'%) := Std.Str.FindReplace(#EXPAND('LEFT.' + %'@name'%), oldChar, newChar),
                            #ELSEIF(%'@type'% = 'unicode')
                                #EXPAND('SELF.' + %'@name'%) := Std.Uni.FindReplace(#EXPAND('LEFT.' + %'@name'%), oldChar, newChar),
                            #END
                        #END
                    #END
                    SELF := LEFT
                )
        );
ENDMACRO;
