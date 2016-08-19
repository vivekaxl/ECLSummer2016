dictionary_rec := RECORD
        INTEGER id;
        STRING macro_location;
END;
dictionaryDS := DATASET([
        {1, 'MacroHome.first_macro'},
        {2, 'MacroHome.second_macro'},
        {3, 'MacroHome.third_macro'}
], dictionary_rec);

execute_code(code) := FUNCTIONMACRO
        retrive_macro := #EXPAND(code.macro_location)
        result := retrive_macro();
        RETURN  result;
ENDMACRO;

OUTPUT(dictionaryDS);
execute_code(dictionaryDS[1]);