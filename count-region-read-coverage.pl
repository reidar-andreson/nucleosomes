#!/usr/bin/perl
#
# Calculate read coverage (observed) for each ChromHMM region
# 
# Copyright (C) Reidar Andreson and University of Tartu
# You can modify and distribute this script and derivateive works freely
#

# INPUT 1:
# H3_mapped.bed
# chr1	9995	10044	SN358:469:H3YKKBCXY:1:1209:18673:96809/1	2	+

# INPUT 2:
# res_sites_chrom_all_chr.txt
# 11_Weak_Txn	chr10	120400	122000	121964	121967
# 11_Weak_Txn	chr10	120400	122000	121989	121993
# 6_Weak_Enhancer	chr10	122000	122200	122051	122055
# 2_Weak_Promoter	chr10	122200	122600	122219	122223

use strict;

open BED, $ARGV[0] or die;
open RES, $ARGV[1] or die;

my @line;
my $count_lines = 0;
my $i;
my %read;

while(<BED>){
    chomp;
    next if(/^@/);
    @line = split(/\t/);
    $count_lines++;
    if($count_lines == 1000000){
        $count_lines = 0;
        print STDERR ".";
    }
    for($i = $line[1]; $i <= $line[2]; $i++){
        $read{$line[0]}{$i} += 1;
    }
}

print STDERR "\n";

my $max = 0;
my %observed_count; my %observed;
my $last_reg_site_count = 0;
my $last_reg_site_sum = 0;
my $last_reg_pos = "";
my $last_reg_name = "";
my $key;

while(<RES>){
    chomp;
    @line = split(/\t/);
    
    # for each region store average read coverage over all sites
    if($line[2] != $last_reg_pos && $last_reg_pos){
        $observed_count{$last_reg_name}++;
        $observed{$last_reg_name} += $last_reg_site_sum/$last_reg_site_count;        
        $last_reg_site_count = 0;
        $last_reg_site_sum = 0;        
        #exit;
    }
    
    $max = 0;
    # getting restriction site maximum coverage
    for($i = $line[4]; $i <= $line[5]; $i++){
        if($max < $read{$line[1]}{$i}){         
            $max = $read{$line[1]}{$i};         
        }
    }
    
    $last_reg_site_count++;
    $last_reg_site_sum += $max;    
    $last_reg_pos = $line[2];
    $last_reg_name = $line[0];    
}
# getting last region
if($line[2] != $last_reg_pos && $last_reg_pos){
    $observed_count{$last_reg_name}++;
    $observed{$last_reg_name} += int($last_reg_site_sum/$last_reg_site_count);
    $last_reg_site_count = 0;
    $last_reg_site_sum = 0;
}

foreach $key (keys(%observed)){
    printf ("%s\t%d\n",$key,($observed{$key}/$observed_count{$key}));
}

