apt-get update
apt-get -y --force-yes install libbz2-1.0 libbz2-dev libncurses5-dev openjdk-6-jre-headless zlib1g-dev

cd /mnt
wget http://downloads.sourceforge.net/project/trinityrnaseq/trinityrnaseq_r2013-02-25.tgz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Ftrinityrnaseq%2Ffiles%2Ftrinityrnaseq_r2013-02-25.tgz%2Fdownload&ts=1371471384&use_mirror=superb-dca3 
mv trinityrnaseq_r2013-02-25.tgz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Ftrinityrnaseq%2Ffiles%2Ftrinityrnaseq_r2013-02-25.tgz%2Fdownload&ts=1371471384&use_mirror=superb-dca3 trinityrnaseq_r2013-02-25.tgz 
tar xvfz trinityrnaseq_r2013-02-25.tgz 
cd trinityrnaseq_r2013-02-25 
make

cd /mnt
curl -O -L http://sourceforge.net/projects/bowtie-bio/files/bowtie/0.12.7/bowtie-0.12.7-linux-x86_64.zip
unzip bowtie-0.12.7-linux-x86_64.zip
cd bowtie-0.12.7
cp bowtie bowtie-build bowtie-inspect /usr/local/bin

cd /mnt
git clone git://github.com/dzerbino/velvet.git
cd velvet
make
make 'MAXKMERLENGTH=92'
cp velvet* /usr/local/bin

cd /mnt
git clone git://github.com/dzerbino/oases.git
cd oases
make
make 'VELVET_DIR=/path/to/velvet'
make 'MAXKMERLENGTH=92'
cp oases /usr/local/bin

cd /mnt/oculata
normalize-by-median.py -p -C 20 -k 20 -N 4 -x 2e9 -s hash *.pe 
normalize-by-median.py -C 20 -k 20 -N 4 -x 2e9 -l hash *.se *.gz
wait
velveth dn_output 19,37,2 -fastq -shortPaired *.pe.keep -short *.se.keep *.gz.keep
wait
for((n=19;n<37;n=n+2));do velvetg dn_output_"$n" -cov_cutoff auto -exp_cov auto -read_trkg yes -scaffolding no  -ins_length 150; done
wait
for((n=19;n<37;n=n+2));do oases dn_output_"$n"; done

for((i = 19;i<=35;i=i+2));do mv dn_output_"$i"/transcripts.fa Mocu_dn_k"$i"_transcripts.fa;done 

velveth raw_output 19,37,2 -fastq -shortPaired *.pe -short *.se *.gz
for((n=19;n<37;n=n+2));do velvetg raw_output_"$n" -cov_cutoff auto -exp_cov auto -read_trkg yes -scaffolding no  -ins_length 150; done
for((n=19;n<37;n=n+2));do oases raw_output_"$n"; done

for((i = 19;i<=35;i=i+2));do mv raw_output_"$i"/transcripts.fa Mocu_raw_k"$i"_transcripts.fa;done

for i in *.pe.keep; do split-paired-reads.py $i;done
cat *keep.1 > left.fq
cat *keep.2 > right.fq
cat *.se.keep *.gz.keep >> *left.fq
Trinity.pl --seqType fq --left left.fq --right right.fq --min_contig_length 200 --CPU 4 --SS_lib_type F --JM 16G --output ocu_dn_trinity

mv ocu_dn_trinity/Trinity.fasta Mocu_dn_tri_transrcipts.fa 

split-paired-reads.py *.pe
gunzip *.gz
cat *pe.1 > left_raw.fq
cat *pe.2 > right_raw.fq
cat *.se *.fq >> *left_raw.fq

Trinity.pl --seqType fq --left left_raw.fq --right right_raw.fq --min_contig_length 200 --CPU 4 --SS_lib_type F --JM 16G --output ocu_raw_trinity.fa

mv ocu_raw_trinity/Trinity.fasta Mocu_raw_tri_transcripts.fa

cd /mnt/
curl -O ftp://ftp.ncbi.nih.gov/blast/executables/release/2.2.24/blast-2.2.24-x64-linux.tar.gz 
tar xzf blast-2.2.24-x64-linux.tar.gz 
cp blast-2.2.24/bin/* /usr/local/bin 
cp -r blast-2.2.24/data /usr/local/blast-data

cd /mnt/oculata/
for i *transcripts.fa; do formatdb -i $i -p F;done

for i *transcripts.fa; do blastall -p tblastn -i /mnt/molgula_pipeline/ciona_transcriptome.fa -d $i -e -e 1-e6 -v 2 -b 2 -o ciona.x.${i/fa/txt};done