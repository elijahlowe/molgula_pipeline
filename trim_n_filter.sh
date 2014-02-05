cd /usr/local/share
git clone https://github.com/ged-lab/screed.git -b protocols-v0.8.3
cd screed
python setup.py install

cd /usr/local/share
git clone https://github.com/ged-lab/khmer.git -b protocols-v0.8.5
cd khmer
make install

pip install git+https://github.com/ged-lab/khmer.git@protocols-v0.8.3#egg=khmer

cd /root
curl -O http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.30.zip
unzip Trimmomatic-0.30.zip
cd Trimmomatic-0.30/
cp trimmomatic-0.30.jar /usr/local/bin
cp -r adapters /usr/local/share/adapters

cd /root
curl -O http://hannonlab.cshl.edu/fastx_toolkit/libgtextutils-0.6.1.tar.bz2
tar xjf libgtextutils-0.6.1.tar.bz2
cd libgtextutils-0.6.1/
./configure && make && make install

cd /root
curl -O http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit-0.0.13.2.tar.bz2
tar xjf fastx_toolkit-0.0.13.2.tar.bz2
cd fastx_toolkit-0.0.13.2/
./configure && make && make install

mkdir /mnt/work
cd /mnt/work
mkdir trim
cd trim
for i in /round1/molgula/62GAWAAXX_*;do gunzip -c $i | head -400000 | gzip > $(basename $i);done
for i in /round2/*fq.gz;do gunzip -c $i | head -400000 | gzip > $(basename $i);done

gunzip *.gz

for i in Mocc-F*; do python /mnt/molgula_pipeline/scripts/split_unlabeled_fastq.py $i;done
for i in *.pe; do split-paired-reads.py $i;done

for i in 62GAWAAXX_*_1_pf.fastq
do 
    java -jar /usr/local/bin/trimmomatic-0.30.jar PE $i  ${i/_1_p/_2_p} s1_pe s1_se s2_pe s2_se ILLUMINACLIP:/usr/local/share/adapters/TruSeq3-PE.fa:2:30:10
    interleave-reads.py s1_pe s2_pe | gzip -9c > ${i/_1_pf/_interleaved}.pe.fq.gz
    cat s1_se s2_se | gzip -9c > ${i/_1_pf/_interleaved}.se.fq.gz
done

for i in Mocc-F*.1
do
    java -jar /usr/local/bin/trimmomatic-0.30.jar PE $i  ${i/.1/.2} s1_pe s1_se s2_pe s2_se ILLUMINACLIP:/usr/local/share/adapters/TruSeq3-PE.fa:2:30:10
    interleave-reads.py s1_pe s2_pe | gzip -9c > ${i/.1/.interleaved}.pe.fq.gz
    cat s1_se s2_se | gzip -9c > ${i/.1/.interleaved}.se.fq.gz
done

for i in *.pe.fq.gz *.se.fq.gz
do
     echo working with $i
     newfile="$(basename $i .fq.gz)"
     gunzip -c $i | fastq_quality_filter -Q33 -q 30 -p 50 | gzip -9c > ../"${newfile}.qc.fq.gz"
done

cd ..

for i in *.pe.qc.fq.gz
do
   extract-paired-reads.py $i
done

mkdir /mnt/occulta /mnt/oculata /mnt/hybrid
mv Mocc*qc.fq.gz.*e /mnt/occulta/.
mv 62GAWAAXX_3*qc.fq.gz.*e /mnt/occulta/.
mv Mocc*se.qc.fq.gz /mnt/occulta/.
mv 62GAWAAXX_3*se.qc.fq.gz /mnt/occulta/.

mv 62GAWAAXX_[147]*qc.fq.gz.*e /mnt/oculata/.
mv 62GAWAAXX_[147]*se.qc.fq.gz /mnt/oculata/.

mv 62GAWAAXX_[268]*qc.fq.gz.*e /mnt/hybrid/.
mv 62GAWAAXX_[268]*se.qc.fq.gz /mnt/hybrid/.