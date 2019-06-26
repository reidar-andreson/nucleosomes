# Tools for analysis of restriction enzyme cutting sites

List of restriction enzymes:
```
- AluI    AGCT                                         
- SaqAI   TTAA 
- MvaI    CCWGG (where W is A or T)
- HinfI   GANTC (where N can be any nucleotide)
```

## Usage
```shell
$ perl genome-cutter.pl /path/to/chr/fasta/files/
```

## Input        
chromosome sequence file in FASTA format

## Output
```
chr  start  end  enzyme  motif
Chr5	11895	11898	SaqAI	TTAA
Chr5	12072	12076	HinfI	gattc
Chr5	12287	12290	AluI	agct
Chr5	12306	12310	MvaI	cctgg
```

## Citation
Org *et al.* (2019) **Genome-wide histone modification profiling of inner cell mass and trophectoderm of bovine blastocysts by RAT-ChIP**
