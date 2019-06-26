#!/usr/bin/perl
#
# A Perl script for finding cut sites for restriction enzymes in FASTA files
# 
# Copyright (C) Reidar Andreson and University of Tartu
# You can modify and distribute this script and derivateive works freely
#

# Used restriction enzymes and their consensus sequences: 
# AluI    AGCT
# SaqAI   TTAA
# MvaI    CCWGG, where W is A or T
# HinfI   GANTC, where N can be any nucleotide

# INPUT:
# chromosome sequence file in FASTA format

# OUTPUT:
# chr  start  end  enzyme  motif
# Chr5	12072	12076	HinfI	gattc

use strict;
use Getopt::Long;

my @names = qw(AluI SaqAI MvaI MvaI HinfI HinfI HinfI HinfI);
my @sites = qw(AGCT TTAA CCAGG CCTGG GAATC GATTC GACTC GAGTC);

my $chr; my $seq; my $key;
my $i; my $j;
my $seq_len_4;
my $seq_len_5;
my %hist; 
my $last_pos = 1;
my $dist = 0;

# full path to human genome sequence fasta files
my $path_to_chr_files = $ARGV[0] or die; # /path/to/chr/

# human chromosomes
my @chromosomes = qw(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y M);

foreach $chr (@chromosomes){

    open CHR, $path_to_chr_files."chr".$chr.".fa" or die;
    open OUT, ">chr".$chr."_sites.bed" or die;
    
    printf STDERR ("Scanning chr%s...\n",$chr);
    $seq = "";
    %hist = ();
    $last_pos = 1;
    $dist = 0;
    
    while(<CHR>){
        chomp;
        next if (/^>/);
        $seq .= $_;
    }
    close(CHR);

    for($i = 0; $i < length($seq); $i++){  
        $seq_len_4 = substr($seq,$i,4);
        $seq_len_5 = substr($seq,$i,5);
        for($j = 0; $j < scalar(@sites); $j++){
            if(length($sites[$j]) == 4){
                if($sites[$j] eq uc($seq_len_4)){
                    $dist = ($i+1) - $last_pos;
                    $last_pos = $i + 1;
                    $hist{$dist}++;          
                    printf(OUT "Chr%s\t%d\t%d\t%s\t%s\n",$chr,$i+1,$i+4,$names[$j],$seq_len_4);
                } 
            }
            else{
                if($sites[$j] eq uc($seq_len_5)){
                    $dist = ($i+1) - $last_pos;
                    $last_pos = $i + 1;        
                    $hist{$dist}++;
                    printf(OUT "Chr%s\t%d\t%d\t%s\t%s\n",$chr,$i+1,$i+5,$names[$j],$seq_len_5);
                }
            }
        }     
    }
    close(OUT);
}
