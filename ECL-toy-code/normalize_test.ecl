rNumbers := RECORD
	INTEGER number;
END;
	N := 20;
	origSize := 5;
	seed := DATASET([{0},{0},{0}], rNumbers);
	PerCluster := ROUNDUP(N*origSize/CLUSTERSIZE);
	rNumbers addOffsetId(rNumbers L, INTEGER c) := TRANSFORM
			SELF.number := (c-1)*PerCluster ;
		END;
	OUTPUT(PerCluster);
	OUTPUT(CLUSTERSIZE);	
	OUTPUT(NORMALIZE(seed, CLUSTERSIZE, addOffsetId(LEFT, COUNTER)));