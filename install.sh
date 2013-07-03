cd /root
apt-get update; y
sudo apt-get build-dep r-base --fix-missing
cd /mnt
wget http://cran.r-project.org/src/base/R-2/R-2.15.3.tar.gz
tar xvfz R-2.15.3.tar.gz
cd R-2.15.3/
./configure
make
make install

cd /root
curl -L -O 'http://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.1.0/bowtie2-2.1.0-source.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fbowtie-bio%2Ffiles%2Fbowtie2%2F2.1.0%2F&ts=1365392377&use_mirror=superb-dca3'
mv bowtie2-2.1.0-source.zip* bowtie2-2.1.0-source.zip
unzip bowtie2-2.1.0-source
cd bowtie2-2.1.0
make
cp bowtie2* /usr/local/bin

cd /root
git clone git://github.com/samtools/samtools.git
cd samtools
make
cp samtools /usr/local/bin
cd misc
cp *.pl maq2sam-long maq2sam-short md5fa md5sum-lite wgsim /usr/local/bin/
cd ../bcftools
cp *.pl bcftools /usr/local/bin/

cd /mnt
wget http://tophat.cbcb.umd.edu/downloads/tophat-2.0.8b.Linux_x86_64.tar.gz
tar xvfz tophat-2.0.8b.Linux_x86_64.tar.gz
cd /bin
ln -s /mnt/tophat-2.0.8b.Linux_x86_64/tophat2 .

cd /mnt
wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.3.2-5/sratoolkit.2.3.2-5-ubuntu64.tar.gz
tar xvfz sratoolkit.2.3.2-5-ubuntu64.tar.gz
cd sratoolkit.2.3.2-5-ubuntu64/bin/
apt-get install x11-xserver-utils
sudo aptitude install yum

cd /root
git clone https://github.com/ctb/screed.git
cd screed
python setup.py install

cd /root
git clone https://github.com/ctb/khmer.git
cd khmer
make
export PYTHONPATH=/root/khmer/python/

cd /mnt
git clone git://github.com/dzerbino/velvet.git
cd velvet/
make
make 'MAXKMERLENGTH=92' 'OPENMP=2'
cp velvet* /usr/local/bin/.

cd /mnt
git clone git://github.com/dzerbino/oases.git
cd oases
make 
make 'VELVET_DIR=/mnt/velvet'
make 'MAXKMERLENGTH=92'
cp oases /usr/local/bin/.

cd /mnt
wget https://cdhit.googlecode.com/files/cd-hit-v4.6.1-2012-08-27.tgz
tar xvfz cd-hit-v4.6.1-2012-08-27.tgz
cd cd-hit-v4.6.1-2012-08-27/
make 
cp cd-hit-est /usr/local/bin/.

cd /mnt
wget http://bedtools.googlecode.com/files/BEDTools.v2.17.0.tar.gz
tar xvfz BEDTools.v2.17.0.tar.gz
cd bedtools-2.17.0/
make
cp bin/multiBamCov bin/bedtools /usr/local/bin/.