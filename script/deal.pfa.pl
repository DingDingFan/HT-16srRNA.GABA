#!/usr/bin/perl 
use strict;
#use FindBin qw($Bin/fdd_package/);
die "Usage: <readLen	blast.aln>!\n"
unless @ARGV ;
my ($list_file,$source)=@ARGV;
my %list;
######################################
&index(\%list,$list_file);

my %dat;
open I,"$source";
while(<I>){
	chomp;
	my @a=split /\t/;
	my @b=split /_/,$a[1];
	my $tag=$a[1];
	$tag=~ s/\d+$//;
	if($a[3]>35 and $a[2] > 90  and $list{$a[0]} >1400 and $list{$a[0]} <1800 ){
		push @{$dat{ $a[0] }{ $tag }} , $a[1] unless $dat{ $a[0] }{ $tag };
	#	print "$a[0]\t$b[-1]\t$a[1]\n";
	}
}
close I;

foreach my $read( keys %dat){
	if(exists $dat{$read}{'LF'} and exists $dat{$read}{'LR'} ){
		print join "," , @{$dat{$read}{'LF'}};
		print "\t";
		print join "," , @{$dat{$read}{'LR'}};
		print "\t$read\n";
	}	
}
##############################################################################
sub index{
	my ($hash,$file)=@_;
	open I,"$file";
	while(<I>){
		chomp;
		my @a=(split /\t/,);
		$$hash{$a[0]}= $a[1];
	}
	close I;
}
