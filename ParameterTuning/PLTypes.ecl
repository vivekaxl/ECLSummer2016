
EXPORT PLTypes := MODULE
        EXPORT tuning_range_rec := RECORD
                UNSIGNED4 parameter_id;
                REAL8 minimun_value;
                REAL8 maximum_value;
                REAL8 step_size;
        END;
END;