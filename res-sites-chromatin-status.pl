#!/usr/bin/perl
#
# Find intersections of 15 regions vs restriction site coordinates
# 
# Copyright (C) Reidar Andreson and University of Tartu
# You can modify and distribute this script and derivateive works freely
#

# INPUT 1:
# K562_ChromHMM_chr1.dms
# Chromatin status file
# bin    chrom   chromStart      chromEnd        name    score   strand  thickStart      thickEnd        itemRgb
# 0       chr1    67100212        67139412        13_Heterochrom/lo       0       .       67100212        67139412        245,245,245

# INPUT 2: (genome_cutter.pl output)
# chr1_sites.bed
# Full genome restriction site locations
# chr    start    end    enz    motif
# Chr10   60132   60135   SaqAI   TTAA

# OUTPUT:
#
# region    chr    regionStart    regionEnd    siteStart    siteEnd
# 11_Weak_Txn	chr1	60200	61000	60218	60221
# 11_Weak_Txn	chr1	60200	61000	60246	60249
# 11_Weak_Txn	chr1	60200	61000	60345	60348
# 11_Weak_Txn	chr1	60200	61000	60460	60464

use strict;

my @col; my @chr; my @start; my @end; my @name;
my $i;

open CHROM, $ARGV[0] or die and print "Cannot open CHROM file!\n";
open RES, $ARGV[1] or die and print "Cannot open RES file!\n";
open OUT, ">", $ARGV[2] or die;

while(my $line = <CHROM>){
    chomp($line);
    @col = split(/\s+/,$line);
    push(@chr, $col[1]);
    push(@start, $col[2]);
    push(@end, $col[3]);
    push(@name, $col[4]);    
}

printf STDERR ("Read file: $ARGV[0]\n");

while(my $line = <RES>){
    chomp($line);
    @col = split(/\s+/,$line);
    for($i = 0; $i < scalar(@chr); $i++){
        next if($chr[$i] ne lcfirst($col[0]));
        next if($start[$i] > $col[2]);
        next if($end[$i] < $col[1]);
        printf OUT ("%s\t%s\t%d\t%d\t%d\t%d\n",$name[$i],$chr[$i],$start[$i],$end[$i],$col[1],$col[2]);
    }
}

printf STDERR ("\Read file: $ARGV[1]\n");

