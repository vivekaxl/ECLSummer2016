
EXPORT PLTypes := MODULE
        EXPORT tuning_range_rec := RECORD
                UNSIGNED4 parameter_id;
                REAL8 minimun_value;
                REAL8 maximum_value;
                REAL8 step_size;
        END;
        EXPORT indep_de_rec := RECORD
                UNSIGNED4 id;
                INTEGER generation_id;
                REAL8 indep1;
                REAL8 indep2;
                REAL8 indep3;
                REAL8 indep4;
        END;
        EXPORT indep_sway_rec := RECORD
                UNSIGNED4 id;
                REAL8 indep1;
                REAL8 indep2;
                REAL8 indep3;
                REAL8 indep4;
        END;
        EXPORT de_rec := RECORD(indep_de_rec)
                REAL8 objective;
        END;
END;

