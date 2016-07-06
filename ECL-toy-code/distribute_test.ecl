EXPORT rNumber := RECORD
	INTEGER number;
END;


	EXPORT idListRec := RECORD
		UNSIGNED id;
		UNSIGNED oldId;
	END;

idListGroupRec := RECORD(idListRec)
		UNSIGNED gNum := 0;
END;
N := 25;
origSize := 100;
		seed := DATASET([{0,0,0}], idListGroupRec);
		PerCluster := ROUNDUP(N*origSize/CLUSTERSIZE);
		idListGroupRec addOffsetId(idListGroupRec L, INTEGER c) := TRANSFORM
			SELF.id := (c-1)*PerCluster ;
			SELF.oldid:= 0;
		END;
		// Create and distribute one seed per node
		one_per_node := DISTRIBUTE(NORMALIZE(seed, CLUSTERSIZE, addOffsetId(LEFT, COUNTER)), id DIV PerCluster);
		idListGroupRec fillRec(idListGroupRec L, UNSIGNED4 c) := TRANSFORM
			SELF.id := l.id + c;
			SELF.oldId := RANDOM()%origSize + 1;
			SELF.gNum  := (l.id + c -1) DIV origSize + 1;
		END;
		// Generate records on each node
		// Filter extra nodes generated: (PerCluster * CLUSTERSIZE >= N*origSize) 
		m := NORMALIZE(one_per_node, PerCluster, fillRec(LEFT,COUNTER))(gNum <= N);
		//OUTPUT is generally truncated to 100 entries. Need to pass ALL as a parameter for it to work.
		OUTPUT(m, NAMED('m'),ALL);