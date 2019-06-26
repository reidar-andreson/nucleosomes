# Tools for analysis of restriction enzyme cutting sites

## Genome Cutter

Used for creating a list of all restriction site positions in human genome.

Used restriction enzymes and their consensus sequences:
```
- AluI    AGCT                                         
- SaqAI   TTAA 
- MvaI    CCWGG (where W is A or T)
- HinfI   GANTC (where N can be any nucleotide)
```

### Usage
```shell
$ perl genome-cutter.pl /path/to/chr/fasta/files/
```

### Input        
chromosome sequence file in FASTA format

### Output
```
chr  start  end  enzyme  motif
Chr5	11895	11898	SaqAI	TTAA
Chr5	12072	12076	HinfI	gattc
Chr5	12287	12290	AluI	agct
Chr5	12306	12310	MvaI	cctgg
```

## Count Intersections

Pipeline for finding theoretical fragment sizes.

### Usage
```
# extract only mapped reads
samtools view -b -F 4 aligned_reads.bam > mapped_reads.bam

# convert bam to bed format
bedtools bamtobed -i mapped_reads.bam > mapped_reads.bed

# find intersections of all ChromHMM regions and mapped reads
bedtools coverage -b K562_ChromHMM.bed -a mapped_reads.bed > reads_list.txt

# count the results for each 15 ChromHMM regions in 1kbp window
perl count-read-region-intersect-averages.pl reads_list.txt | sort -k1n > results.txt
```

### Output
```
1_Active_Promoter   246.54
2_Weak_Promoter      77.24
3_Poised_Promoter    99.23
4_Strong_Enhancer   116.66
5_Strong_Enhancer    55.50
6_Weak_Enhancer      52.38
7_Weak_Enhancer      48.25
```

## Citation
Org *et al.* (2019) **Genome-wide histone modification profiling of inner cell mass and trophectoderm of bovine blastocysts by RAT-ChIP**
