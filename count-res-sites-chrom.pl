#!/usr/bin/perl
#
# Count ChromHMM regions and get average # of restriction sites per 1 kbp
# 
# Copyright (C) Reidar Andreson and University of Tartu
# You can modify and distribute this script and derivateive works freely
#

# INPUT: (output of res-sites-chromatin-status.pl)
# 
# region    regStart    regEnd    siteStart    siteEnd
# 13_Heterochrom/lo	chr1	16050000	16062800	16050014	16050018

# OUTPUT:
# region    # of sites
# 1_Active_Promoter	12
# 2_Weak_Promoter	8
# 3_Poised_Promoter	9
# 4_Strong_Enhancer	11

use strict;

open INPUT, $ARGV[0] or die;

my @col;
my $count = 0;
my $last_col = "";
my $last_name = "";
my $start_pos = "";
my $key;
my %region;
my %region_sum;
my %average;
my %average_sum;
my $window = 1000; # 1kb window for restriction site counts

while(my $line = <INPUT>){
    chomp($line);
    @col = split(/\s+/,$line);
    $count++;
    if($col[2] != $last_col && $last_col){        
        $average{$last_name}++;
        $average_sum{$last_name} += $count;
        $region{$last_name}++;
        $region_sum{$last_name} += int($average_sum{$last_name}/$average{$last_name});
        %average = ();
        %average_sum = ();
        #$region{$col[0]}++;
        #$region_sum{$col[0]} +=  $count;
        $count = 1;
        $start_pos = "";
    }
    
    # get start position for 1kb window
    if(!$start_pos){
        $start_pos = $col[4];
    }
    elsif($col[4] - $start_pos > $window){
        $start_pos = $col[4];
        $average{$col[0]}++;
        $average_sum{$col[0]} += $count;
        $count = 1;
    }        
    $last_col = $col[2];
    $last_name = $col[0];
}

# last line
$average{$last_name}++;
$average_sum{$last_name} += $count;
$region{$last_name}++;
$region_sum{$last_name} += int($average_sum{$last_name}/$average{$last_name});

foreach $key (keys(%region)){
    printf ("%s\t%d\n",$key,($region_sum{$key}/$region{$key}));
}