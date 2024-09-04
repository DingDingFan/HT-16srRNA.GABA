#!/usr/bin/perl 
use strict;
#use FindBin qw($Bin/fdd_package/);
die "Usage: <part all>!\n"
unless @ARGV ;
my ($list_file,$source)=@ARGV;
my %list;
######################################
&index(\%list,$list_file);
my %dat;
my %read;
open I,"$source";
while(<I>){
	chomp;
	my @a=split /\t/;
	if(exists $list{ $a[0] }{ $a[1] }){
		print "$_\t$list{ $a[0] }{ $a[1] }\n";
		$dat{ $list{ $a[0] }{ $a[1] } }.="$a[2]\n";
	}else{
		print "$_\tERR\n";
	}
}
close I;

mkdir "deplex";
foreach my $sam( keys %dat){
	mkdir "deplex/$sam/";
	open O,">deplex/$sam/seq.id";
	print O "$dat{$sam}";
	close O;
		
}

##############################################################################
sub index{
	my ($hash,$file)=@_;
	open I,"$file";
	while(<I>){
		chomp;
		s/\s+$//;
		my @a=(split /\t/,);
		$$hash{ $a[1] }{ $a[2] } = $a[0];
	}
	close I;
}
