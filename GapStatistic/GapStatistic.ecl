IMPORT ML;
IMPORT ML.Types;


INTEGER Find_K(DATASET(Types.NumericField) data_p):= FUNCTION
    no_of_points := COUNT(data_p)/ MAX(data_p, number);
    no_of_fields := MAX(data_p, number);
    
    // Temp Records
    index_rec := {INTEGER id, INTEGER index_no};
    gap_statistic_rec := {INTEGER no_of_centroids, REAL actual_wk, REAL mean_wkb, REAL std_wkb};
    record_docs := {INTEGER field_no, REAL min_value, REAL max_value,};
    
    // Calculate the log of normalized intra-cluster sums of squares
    REAL CalculateLogWK(DATASET(ML.Mat.Types.Element) allegiances) := FUNCTION
        RETURN LN(SUM(allegiances, value));
    /*
        // summation of (x_i - mu_i)^2
        t_allegiances := PROJECT(allegiances, TRANSFORM(ML.Mat.Types.Element, SELF.value := POWER(LEFT.value, 2), SELF:= LEFT));
        t_dk := ROLLUP(SORT(t_allegiances, t_allegiances.y), LEFT.y=RIGHT.y, TRANSFORM(RECORDOF(t_allegiances), 
                                                                                        SELF.x:=LEFT.x;
                                                                                        SELF.value := LEFT.value + RIGHT.value;
                                                                                        SELF.y := LEFT.y;
                                                                                    ));
        // count the value of n_k
        rec := {t_allegiances.y, REAL value := COUNT(GROUP)};
        count_dk := TABLE(t_allegiances, rec, y); 
        dk := JOIN(count_dk, t_dk, LEFT.y=RIGHT.y, TRANSFORM(rec, SELF.value := RIGHT.value/ (2* LEFT.value), SELF := LEFT));
        wk := SUM(dk, value);
        RETURN LN(wk);
    */
    END;
    
    // Find the enclosing boundary of the datasets
    DATASET(record_docs) FindBoundary(DATASET(Types.NumericField) ds):= FUNCTION 
        record_docs := {INTEGER field_no, REAL min_value, REAL max_value,};
        no_fields := MAX(ds, number);
        record_docs extract_boundary(DATASET(Types.NumericField) ds, field_no):= TRANSFORM
            SELF.field_no := field_no;
            SELF.min_value := MIN(ds(number=field_no), value);
            SELF.max_value := MAX(ds(number=field_no), value);
        END;
        RETURN NORMALIZE(DATASET([{0, 0, 0}], record_docs), no_fields, extract_boundary(ds, COUNTER));
    END;
    
    // Generate points inside the boundary
    DATASET(Types.NumericField) PointsInBoundary(INTEGER no_of_points, DATASET(record_docs)  boundary, UNSIGNED4 id) := FUNCTION
        // INTEGER length_of_return_list := COUNT(boundary) * no_of_points;
        Types.NumericField generate_child(Types.NumericField R, INTEGER c) := TRANSFORM
            SELF.id := c;
            SELF.number := COUNT(boundary);
            SELF := R;
        END;
        raw_ds := NORMALIZE(DATASET([{0, 0, 0}], Types.NumericField),  no_of_points,  generate_child(LEFT, COUNTER));
        Types.NumericField generate_number(Types.NumericField  R, INTEGER field_no):= TRANSFORM
            SELF.id := R.id;
            SELF.number := field_no;
            SELF.value := boundary[field_no].min_value + (id+Random()%100/100) * (boundary[field_no].max_value - boundary[field_no].min_value);
        END;
        ds := NORMALIZE(raw_ds, LEFT.number, generate_number(LEFT,  COUNTER));
        RETURN ds;
    END;
    
    // Find the log of normalized intra-cluster sums of squares of randomly generated points
    DATASET(Types.NumericField) FindReferencePointWk(DATASET(record_docs) boundary, DATASET(Types.NumericField) ds, INTEGER B, INTEGER no_cen) := FUNCTION
        REAL WrapperFunction(DATASET(Types.NumericField) within_boundary):= FUNCTION
            randNum := Random();
            for_random_points := DATASET(no_of_points, TRANSFORM(index_rec, SELF.id := COUNTER, SELF.index_no := randNum));
            t_centroids := TOPN(for_random_points, no_cen, index_no);
            t_indexes := PROJECT(t_centroids, TRANSFORM(recordof(t_centroids), self.index_no:= counter, self:= left));
            within_centroids := JOIN(within_boundary, t_indexes, LEFT.id=RIGHT.id, TRANSFORM(Types.NumericField,SELF.id:= RIGHT.index_no,SELF:=LEFT;));
            boundary_KMeans:=ML.Cluster.KMeans(within_boundary,within_centroids,30,0);
            RETURN CalculateLogWK(boundary_KMeans.Allegiances());
        END;
        within_boundary1 := PointsInBoundary(no_of_points, boundary, RANDOM());
        within_boundary2 := PointsInBoundary(no_of_points, boundary, RANDOM());
        within_boundary3 := PointsInBoundary(no_of_points, boundary, RANDOM());
        within_boundary4 := PointsInBoundary(no_of_points, boundary, RANDOM());
        within_boundary5 := PointsInBoundary(no_of_points, boundary, RANDOM());
        within_boundary6 := PointsInBoundary(no_of_points, boundary, RANDOM());
        within_boundary7 := PointsInBoundary(no_of_points, boundary, RANDOM());
        within_boundary8 := PointsInBoundary(no_of_points, boundary, RANDOM());
        within_boundary9 := PointsInBoundary(no_of_points, boundary, RANDOM());
        within_boundary10 := PointsInBoundary(no_of_points, boundary, RANDOM());
        within_boundary11 := PointsInBoundary(no_of_points, boundary, RANDOM());
        within_boundary12 := PointsInBoundary(no_of_points, boundary, RANDOM());
        within_boundary13 := PointsInBoundary(no_of_points, boundary, RANDOM());
        within_boundary14 := PointsInBoundary(no_of_points, boundary, RANDOM());
        within_boundary15 := PointsInBoundary(no_of_points, boundary, RANDOM());
        within_boundary16 := PointsInBoundary(no_of_points, boundary, RANDOM());
        within_boundary17 := PointsInBoundary(no_of_points, boundary, RANDOM());
        within_boundary18 := PointsInBoundary(no_of_points, boundary, RANDOM());
        within_boundary19 := PointsInBoundary(no_of_points, boundary, RANDOM());
        within_boundary20 := PointsInBoundary(no_of_points, boundary, RANDOM());
        output_ds := DATASET([
            {1, 1, WrapperFunction(within_boundary1)},
            {2, 1, WrapperFunction(within_boundary2)},
            {3, 1, WrapperFunction(within_boundary3)},
            {4, 1, WrapperFunction(within_boundary4)},
            {5, 1, WrapperFunction(within_boundary5)},
            {6, 1, WrapperFunction(within_boundary6)},
            {7, 1, WrapperFunction(within_boundary7)},
            {8, 1, WrapperFunction(within_boundary8)},
            {9, 1, WrapperFunction(within_boundary9)},
            {10, 1, WrapperFunction(within_boundary10)},
            {11, 1, WrapperFunction(within_boundary11)},
            {12, 1, WrapperFunction(within_boundary12)},
            {13, 1, WrapperFunction(within_boundary13)},
            {14, 1, WrapperFunction(within_boundary14)},
            {15, 1, WrapperFunction(within_boundary15)},
            {16, 1, WrapperFunction(within_boundary16)},
            {17, 1, WrapperFunction(within_boundary17)},
            {18, 1, WrapperFunction(within_boundary18)},
            {19, 1, WrapperFunction(within_boundary19)},
            {20, 1, WrapperFunction(within_boundary20)}
        ], Types.NumericField);
        o := OUTPUT(output_ds, NAMED('output_ds'));
        RETURN WHEN(output_ds, o);
    END;

    // Calculate gap value for single value of k
    gap_statistic_rec RunForOneK(INTEGER no_centroids, DATASET(Types.NumericField) data_points) := FUNCTION
        BootStrap := 20;
        // Making sure two distinct points are chosen
        for_random_points := DATASET(no_of_points, TRANSFORM(index_rec, SELF.id := COUNTER, SELF.index_no := RANDOM()));
        t_centroids := TOPN(for_random_points, no_centroids, index_no);
        indexes := PROJECT(t_centroids, TRANSFORM(recordof(t_centroids), self.index_no:= counter, self:= left));
        
        cluster_centers := JOIN(data_points, indexes, LEFT.id=RIGHT.id, TRANSFORM(Types.NumericField, SELF.id:= RIGHT.index_no, SELF:=LEFT;));
        
        kmeans_object := ML.Cluster.KMeans(data_points,cluster_centers,30,0);  
        raw_allegiances := kmeans_object.Allegiances();
        actual_wk := CalculateLogWK(raw_allegiances);
        boundary := FindBoundary(data_points);
        repeated_runs := FindReferencePointWk(boundary, data_points, BootStrap, no_centroids);
        std_rec := {Types.NumericField, REAL variation};
        mean_value := AVE(repeated_runs, value);
        std_value := SQRT(AVE(PROJECT(repeated_runs, TRANSFORM(std_rec, SELF.variation := POWER(LEFT.value - mean_value, 2); SELF:= LEFT)), variation)) * SQRT(1+(1/BootStrap));
        RETURN DATASET([{no_centroids, actual_wk, mean_value, std_value}],gap_statistic_rec)[1];
    END;
    
    result := NORMALIZE(DATASET([{0,0,0,0}],gap_statistic_rec), 10, TRANSFORM(gap_statistic_rec, SELF := RunForOneK(COUNTER, data_p)));
    gap := PROJECT(result, TRANSFORM({result, REAL gap}, SELF.gap:= LEFT.mean_wkb - LEFT.actual_wk, SELF := LEFT));
    gapstatistic := JOIN(gap, gap, LEFT.no_of_centroids + 1 = RIGHT.no_of_centroids, TRANSFORM({INTEGER centroids, REAL value},
                                                                                        SELF.centroids := LEFT.no_of_centroids;
                                                                                        SELF.value := LEFT.gap - RIGHT.gap + RIGHT.std_wkb;
                                                                                        ));
    // Choose the lowest centroid with gap statistic  greater than 0                                                                                        
    chosen_k := TOPN(gapstatistic(value>=0), 1, centroids)[1];
    o := OUTPUT(gap, NAMED('gap'));
    RETURN WHEN(chosen_k.centroids, o);
END;

IMPORT GapStatistic.Datasets;
content := Datasets.spherical_1000_features_2_cluster_4DS.content;
//remove the class field
filtered_document := TABLE(content, {id, features_1, features_2});
ML.ToField(filtered_document, data_p);
OUTPUT(Find_K(data_p), NAMED('for3'));