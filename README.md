# HT-16srRNA.GABA
```
conda activate /home/wuliu/raid6/conda/envs/emu #首先本地运行这个命令，激活环境

>1 seqkit fq2fa pass.fq.gz  > pass.fq.fasta 
   samtools faidx pass.fq.fasta

#Reads 和barcode 序列比对
>2 nohup sh  /home/wuliu/bin/blast/blastn.single.sh pass.fq.fasta /home/wuliu/raid6/Project/Omixs.sequence/TC23-201/20230906/50X50barcode.fasta aln &

#拆分并加入样品信息，建立文件夹，并且给出seq.i
>3 nohup perl ~/bin/meta/deal.pfa.pl pass.fq.fasta.fai   aln.blast  > aln.blast.deplex  &
>4 perl ~/bin/meta/add.sample.pl dual_barcode_pair.txt  aln.blast.deplex > aln.blast.demultiplex.add.sample.xls
>5 #got sequences for each sample
for i in deplex/*/seq.id
    echo "head -1000 $i | perl ~/bin/commom_bin/fishInWinter.pl --ff fasta /dev/stdin pass.fq.fasta >$i.fas  "
end > batch.getseq.sh    
 nohup perl ~/bin/commom_bin/multi-process.pl  -cpu 20 batch.getseq.sh  & 
 
#Reads taxa assign
>6 
for i in $PWD/deplex/*                                                                             echo "cd $i; sh /home/wuliu/raid6/Project/Omixs.sequence/TC23-201/20230613/nanopore/ATMGR10/nano.emu.sh "
end  >batch.sh

>7 nohup perl ~/bin/commom_bin/multi-process.pl  -cpu 10  batch.sh &

>8
#merge all result and formate                                                             
for i in deplex/*/seq.id_rel-abundance.tsv                                                                  perl ~/bin/meta/got.emu.result.pl $i 
end >Nanopore.assign.xls
```
                               
