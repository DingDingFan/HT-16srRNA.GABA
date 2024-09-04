base=$2
query=$1
ln -s $query  ./query.fas
ln -s $base ./base.fas;
makeblastdb  -in base.fas  -input_type  fasta  -dbtype nucl
i=$3
blastn  -db ./base.fas  -out $i.blast -evalue 1e-10 -num_threads 20  -query query.fas   -outfmt 6 
