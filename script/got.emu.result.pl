#!/usr/bin/perl 
use strict;
#use FindBin qw($Bin/fdd_package/);
die "Usage: <part all>!\n"
unless @ARGV ;
my ($source)=@ARGV;
my $name=(split /\//,$source)[-2];

######################################
my @infor;
open I,"$source";

my $n=0;

while(<I>){
	chomp;
	my @a=split /\t/;
	my ($taxa,$ratio,$species,$count)=@a[0..2,-1];
	$ratio = sprintf "%.2f", 100 *$ratio;
	$count = sprintf "%d", $count;
	next if /tax_id|unassigned/;
	#if($ratio >10 and $count > 5){	
		push @infor,[$taxa,$ratio,$species,$count];
		#print "$taxa,$ratio,$species,$count\n";
		$n++;
	#}
}
close I;
@infor = sort {$b->[1] <=> $a->[1] } @infor;

print "$name";
my $nsp;
for(my $i=0; $i <4;$i++){
	my $out = '';
	for(my $j=0; $j <$n ;$j++){
		#print "#$j\t $infor[$j][1] \t  $infor[$j][-1]\n";
		if($j >0 and $infor[$j][1] > 0  and $infor[$j][-1] >0  ){
			$out.="$infor[$j][$i],";
			$nsp++;
		}elsif($j <1){
			$out.="$infor[$j][$i],";
			$nsp++;
		}
	}
	$out=~ s/,$//;

	print "\t$out";
}
$nsp/=4;

print "\t$nsp\n";

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
