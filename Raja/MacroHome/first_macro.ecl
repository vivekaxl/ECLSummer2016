EXPORT first_macro(ds) := FUNCTIONMACRO
        recordof(ds) transformStr(recordof(ds) L) := transform
                SELF.name := if(L.gender = 'M', 'Mr.' + L.name, 'Miss.' + L.name);
                SELF := L;
        end;
       RETURN Project(ds, transformStr(LEFT));
ENDMACRO;