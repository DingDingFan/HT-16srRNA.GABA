# HT-16srRNA.GABA
This bioinformatics pipeline is designed for high-throughput strain identification. It includes several key steps: duplex sequencing, taxonomic identification, and generation of abundance profiles.
## 1. install dependencies
```
#create a environment with conda
conda create --name emu
#install emu seqkit blast 
conda install -c bioconda emu seqkit blast samtools
```

## 2. How to run
### step 1: activate environment
```
conda activate emu
```

### step 2: covert fastq to fasta formate
```
seqkit fq2fa pass.fq.gz  > pass.fq.fasta 
samtools faidx pass.fq.fasta
```

### step 3: Reads aligend to barcode database 
```
sh  script/blastn.single.sh pass.fq.fasta  script/50X50barcode.fasta aln # the database is custom
```
### step 4: Duplex and add sample information
```
perl script/deal.pfa.pl pass.fq.fasta.fai   aln.blast  > aln.blast.deplex
perl script/add.sample.pl dual_barcode_pair.txt  aln.blast.deplex > aln.blast.demultiplex.add.sample.xls
 # "dual_barcode_pair.txt" is a file that contains a mapping of samples to their corresponding barcodes in a sheet format
for i in deplex/*/seq.id
    echo "head -1000 $i | perl ~/bin/commom_bin/fishInWinter.pl --ff fasta /dev/stdin pass.fq.fasta >$i.fas  "
end > batch.getseq.sh    
perl ~/bin/commom_bin/multi-process.pl  -cpu 20 batch.getseq.sh 
```

### step 5: taxonomic identification and generation of abundance profiles
```
for i in $PWD/deplex/*
do
echo "cd $i; sh script/nano.emu.sh "
done
end  >batch.sh
perl ~/bin/commom_bin/multi-process.pl  -cpu 10  batch.sh 

```
### step 6 Merge all result
```                                                      
for i in deplex/*/seq.id_rel-abundance.tsv
do
perl ~/bin/meta/got.emu.result.pl $i 
done > Nanopore.assign.xls

```
                               
