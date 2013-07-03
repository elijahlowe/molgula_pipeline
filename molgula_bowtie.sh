#!/bin/bash

cd /mnt/occulta/
echo "Unzip occulta files for bowtie2 mapping"
gunzip 62GAWAAXX_3_trim.single.fq.gz
wait
python /root/khmer/sandbox/fastq-to-fasta.py 62GAWAAXX_3_trim.single.fq > 62GAWAAXX_3_trim.single.fa
gunzip Mocc-F3.trim.fq.gz
gunzip Mocc-F4.trim.fq.gz
gunzip Mocc-F5.trim.fq.gz
gunzip Mocc-F6.trim.fq.gz
echo "All occulta files unzipped"

python /root/khmer/sandbox/split-pe.py 62GAWAAXX_3_trim.paired.fq.gz
echo "Building bowtie index and mapping reads"
bowtie2-build /mnt/occu_dn_transcriptome.fa occu-bowtie

bowtie2 -q -p 8 occu-bowtie -1 62GAWAAXX_3_trim.paired.fq.1 -262GAWAAXX_3_trim.paired.fq.2 -f 62GAWAAXX_3_trim.single.fq -S occu-f3.1.sam
bowtie2 -q -p 8 occu-bowtie -f Mocc-F3.trim.fq -S /mnt/occu-f3.2.sam
bowtie2 -q -p 8 occu-bowtie -f Mocc-F4.trim.fq -S /mnt/occu-f4.sam
bowtie2 -q -p 8 occu-bowtie -f Mocc-F5.trim.fq -S /mnt/occu-f5.sam
bowtie2 -q -p 8 occu-bowtie -f Mocc-F6.trim.fq -S /mnt/occu-f6.sam

cd /mnt/oculata
echo "Unzipping M. oculata reads in prep for mapping"
gunzip /mnt/oculata/62GAWAAXX_1_trim.single.fq.gz
gunzip /mnt/oculata/62GAWAAXX_4_trim.single.fq.gz
gunzip /mnt/oculata/62GAWAAXX_7_trim.single.fq.gz

python /root/khmer/sandbox/fastq-to-fasta.py /mnt/oculata/62GAWAAXX_1_trim.single.fq > /mnt/oculata/62GAWAAXX_1_trim.single.fa
python /root/khmer/sandbox/fastq-to-fasta.py /mnt/oculata/62GAWAAXX_4_trim.single.fq > /mnt/oculata/62GAWAAXX_4_trim.single.fa
python /root/khmer/sandbox/fastq-to-fasta.py /mnt/oculata/62GAWAAXX_7_trim.single.fq > /mnt/oculata/62GAWAAXX_7_trim.single.fa
python /root/khmer/sandbox/split-pe.py /mnt/oculata/62GAWAAXX_1_trim.paired.fq.gz
python /root/khmer/sandbox/split-pe.py /mnt/oculata/62GAWAAXX_4_trim.paired.fq.gz
python /root/khmer/sandbox/split-pe.py /mnt/oculata/62GAWAAXX_7_trim.paired.fq.gz

echo "Building bowtie index and mapping reads"
bowtie2-build /mnt/ocu_dn_transcriptome.fa ocu-bowtie

bowtie2 -f -p 8 ocu-bowtie -1 /mnt/oculata/62GAWAAXX_1_trim.paired.fq.gz.1 -2 /mnt/oculata/62GAWAAXX_1_trim.paired.fq.gz.2 -U /mnt/oculata/62GAWAAXX_1_trim.single.fa -S /mnt/ocu-f3.sam
bowtie2 -f -p 8 ocu-bowtie -1 /mnt/oculata/62GAWAAXX_4_trim.paired.fq.gz.1 -2 /mnt/oculata/62GAWAAXX_4_trim.paired.fq.gz.2 -U /mnt/oculata/62GAWAAXX_4_trim.single.fa -S /mnt/ocu-f4.sam
bowtie2 -f -p 8 ocu-bowtie -1 /mnt/oculata/62GAWAAXX_7_trim.paired.fq.gz.1 -2 /mnt/oculata/62GAWAAXX_7_trim.paired.fq.gz.2 -U /mnt/oculata/62GAWAAXX_7_trim.single.fa -S /mnt/ocu-f6.sam

echo "Unzipping hybrid reads in prep for mapping"
gunzip /hybrids/62GAWAAXX_2_trim.single.fq.gz
gunzip /hybrids/62GAWAAXX_6_trim.single.fq.gz
gunzip /hybrids/62GAWAAXX_8_trim.single.fq.gz

python /root/khmer/sandbox/fastq-to-fasta.py /mnt/hybrids/62GAWAAXX_2_trim.single.fq > /mnt/hybrids/62GAWAAXX_2_trim.single.fa
python /root/khmer/sandbox/fastq-to-fasta.py /mnt/hybrids/62GAWAAXX_6_trim.single.fq > /mnt/hybrids/62GAWAAXX_6_trim.single.fa
python /root/khmer/sandbox/fastq-to-fasta.py /mnt/hybrids/62GAWAAXX_8_trim.single.fq > /mnt/hybrids/62GAWAAXX_8_trim.single.fa
python /root/khmer/sandbox/split-pe.py /mnt/hybrids/62GAWAAXX_2_trim.paired.fq.gz
python /root/khmer/sandbox/split-pe.py /mnt/hybrids/62GAWAAXX_6_trim.paired.fq.gz
python /root/khmer/sandbox/split-pe.py /mnt/hybrids/62GAWAAXX_8_trim.paired.fq.gz

echo "mapping hybrids"
bowtie2 -f -p 8 occu-bowtie -1 /mnt/hybrids/62GAWAAXX_2_trim.paired.fq.gz.1 -2 /mnt/hybrids/62GAWAAXX_2_trim.paired.fq.gz.2 -U /mnt/hybrids/62GAWAAXX_2_trim.single.fa -S /mnt/hyb_occu-f3.sam 
bowtie2 -f -p 8 occu-bowtie -1 /mnt/hybrids/62GAWAAXX_6_trim.paired.fq.gz.1 -2 /mnt/hybrids/62GAWAAXX_6_trim.paired.fq.gz.2 -U /mnt/hybrids/62GAWAAXX_6_trim.single.fa -S /mnt/hyb_occu-f4.sam
bowtie2 -f -p 8 occu-bowtie -1 /mnt/hybrids/62GAWAAXX_8_trim.paired.fq.gz.1 -2 /mnt/hybrids/62GAWAAXX_8_trim.paired.fq.gz.2 -U /mnt/hybrids/62GAWAAXX_8_trim.single.fa -S /mnt/hyb_occu-f6.sam
bowtie2 -f -p 8 ocu-bowtie -1 /mnt/hybrids/62GAWAAXX_2_trim.paired.fq.gz.1 -2 /mnt/hybrids/62GAWAAXX_2_trim.paired.fq.gz.2 -U /mnt/hybrids/62GAWAAXX_2_trim.single.fa -S /mnt/hyb_ocu-f3.sam
bowtie2 -f -p 8 ocu-bowtie -1 /mnt/hybrids/62GAWAAXX_6_trim.paired.fq.gz.1 -2 /mnt/hybrids/62GAWAAXX_6_trim.paired.fq.gz.2 -U /mnt/hybrids/62GAWAAXX_6_trim.single.fa -S /mnt/hyb_ocu-f4.sam
bowtie2 -f -p 8 ocu-bowtie -1 /mnt/hybrids/62GAWAAXX_8_trim.paired.fq.gz.1 -2 /mnt/hybrids/62GAWAAXX_8_trim.paired.fq.gz.2 -U /mnt/hybrids/62GAWAAXX_8_trim.single.fa -S /mnt/hyb_ocu-f6.sam 

cd /mnt/
echo "converting sam to bam and sorting"
for i in *.sam;do samtools view -bS $i > ${i/.sam/.bam};done
for i in *.bam;do samtools sort $i $i.sorted;done
for i in *.bam.sorted.bam; do samtools index $i;done

python make_denovo_bed.py /mnt/occu_dn_transcriptome.fa > /mnt/occu.bed
python make_denovo_bed.py /mnt/occu_dn_transcriptome.fa > /mnt/occu.bed

echo "counting mapped reads"
cd /mnt/
multiBamCov -bams ocu-f3.bam.sorted.bam ocu-f4.bam.sorted.bam  ocu-f6.bam.sorted.bam -bed ocu.bed > /mnt/ocu.counts
multiBamCov -bams occu-f3.1.bam.sorted.bam  occu-f3.2.bam.sorted.bam  occu-f4.bam.sorted.bam  occu-f5.bam.sorted.bam  occu-f6.bam.sorted.bam -bed occu.bed > /mnt/occu.counts
multiBamCov -bams hyb_ocu-f3.bam.sorted.bam hyb_ocu-f4.bam.sorted.bam hyb_ocu-f6.bam.sorted.bam  hyb_occu-f3.bam.sorted.bam  hyb_occu-f4.bam.sorted.bam  hyb_occu-f6.bam.sorted.bam -bed occu.bed > /mnt/hyb.counts