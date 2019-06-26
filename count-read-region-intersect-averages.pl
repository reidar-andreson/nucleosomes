#!/usr/bin/perl
#
# A Perl script for counting the results for each 15 ChromHMM regions
# 
# Copyright (C) Reidar Andreson and University of Tartu
# You can modify and distribute this script and derivateive works freely
#

# Before running this script, find intersections of all ChromHMM regions and mapped reads:
# 
# bedtools coverage -b K562_ChromHMM.bed -a mapped_reads.bed > reads_list.txt
# chr1	67100212	67139412	13_Heterochrom/lo	0	.	67100212	67139412	245,245,245	1331	25499	39200	0.6504847

# last 4 numbers of the input: 
# 1. total # of overlapping reads
# 2. # of bases having at least 1 overlapping read 
# 3. length of the region
# 4. the fraction of bases having at least 1 overlapping read

# Usage:
# perl count-read-region-intersect-averages.pl reads_list.txt | sort -k1n > results.txt

# Output:
# 1_Active_Promoter   246.54
# 2_Weak_Promoter      77.24
# 3_Poised_Promoter    99.23
# 4_Strong_Enhancer   116.66

use strict;

my $window = 1000;
my @line;
my %reads;
my %reads_c;
my $region;
my $norm;

open BED, $ARGV[0] or die;

while(<BED>){
    chomp;
    @line = split(/\s+/);
    if($line[11] > $window){
        $norm = $line[11]/$window;
        $reads{$line[3]} += ($line[9]/$norm);
    }
    else{
        $reads{$line[3]} += $line[9];
    }
    $reads_c{$line[3]}++;
}

foreach $region (keys (%reads)){
    printf ("%s\t%.2f\n",$region,($reads{$region}/$reads_c{$region}));
}
