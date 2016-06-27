EXPORT Types := MODULE

        EXPORT tuning_range_rec := RECORD
                Types.t_FieldNumber parameter_id;
                Types.t_FieldReal minimun_value;
                Types.t_FieldReal maximum_value;
                Types.t_FieldReal step_size;
        END;
END;