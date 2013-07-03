#!/bin/bash

cd /occulta/
gunzip 62GAWAAXX_3_trim.single.fq.gz
wait
python /root/khmer/sandbox/fastq-to-fasta.py 62GAWAAXX_3_trim.single.fq > 62GAWAAXX_3_trim.single.fa
python /root/khmer/sandbox/split-pe.py /reads/occulta/round1/62GAWAAXX_3_trim.paired.fq.gz
wait
python ~/khmer/sandbox/split-pe.py occulta/round2/Mocc-F6.trim.fq.gz.pe
cd /mnt
bowtie2-build ocu_dn_transcriptome.fa occu-bowtie

bowtie2 -f -p 8 occu-bowtie -1 62GAWAAXX_3_trim.paired.fq.gz.1 -2 62GAWAAXX_3_trim.paired.fq.gz.2 -U 62GAWAAXX_3_trim.single.fa -S occu-f3.1.sam

gunzip -c /reads/occulta/round2/Mocc-F3.trim.fq.gz > Mocc-F3.trim.fq
wait
gunzip -c /reads/occulta/round2/Mocc-F4.trim.fq.gz > Mocc-F4.trim.fq
wait
gunzip -c /occulta/round2/Mocc-F5.trim.fq.gz > Mocc-F5.trim.fq
wait
gunzip -c /reads/occulta/round2/Mocc-F6.trim.fq.gz > Mocc-F6.trim.fq
wait
bowtie2 -f -p 8 occu-bowtie -1 Mocc-F3.trim.fq.pe.1 -2 Mocc-F3.trim.fq.pe.2 -U Mocc-F3.trim.fq.se -S occu-f3.2.sam > bowtie.log
wait
bowtie2 -f -p 8 occu-bowtie -1 Mocc-F4.trim.fq.gz.pe.1 -2 Mocc-F4.trim.fq.gz.pe.2 -U Mocc-F4.trim.fq.gz.se -S occu-f4.sam >> bowtie.log
wait
bowtie2 -f -p 8 occu-bowtie -1 Mocc-F5.trim.fq.gz.pe.1 -2 Mocc-F5.trim.fq.gz.pe.2 -U Mocc-F5.trim.fq.gz.se -S occu-f5.sam >> bowtie.log
wait
bowtie2 -f -p 8 occu-bowtie -1 Mocc-F6.trim.fq.gz.pe.1 -2 Mocc-F6.trim.fq.gz.pe.2 -U Mocc-F6.trim.fq.gz.se -S occu-f6.sam >> bowtie.log

#gunzip -c /reads/hybrids/round1/62GAWAAXX_2_trim.single.fq.gz > 62GAWAAXX_2_trim.single.fq
#gunzip -c /reads/hybrids/round1/62GAWAAXX_6_trim.single.fq.gz > 62GAWAAXX_6_trim.single.fq
#gunzip -c /reads/hybrids/round1/62GAWAAXX_8_trim.single.fq.gz > 62GAWAAXX_8_trim.single.fq
#wait
#python /root/khmer/sandbox/fastq-to-fasta.py 62GAWAAXX_2_trim.single.fq > 62GAWAAXX_2_trim.single.fa
#python /root/khmer/sandbox/fastq-to-fasta.py 62GAWAAXX_6_trim.single.fq > 62GAWAAXX_6_trim.single.fa
#python /root/khmer/sandbox/fastq-to-fasta.py 62GAWAAXX_8_trim.single.fq > 62GAWAAXX_8_trim.single.fa
#wait
#python /root/khmer/sandbox/split-pe.py /reads/hybrids/round1/62GAWAAXX_2_trim.paired.fq.gz
#wait
#python /root/khmer/sandbox/split-pe.py /reads/hybrids/round1/62GAWAAXX_6_trim.paired.fq.gz
#wait
#python /root/khmer/sandbox/split-pe.py /reads/hybrids/round1/62GAWAAXX_8_trim.paired.fq.gz
wait
bowtie2 -f -p 8 occu-bowtie -1 62GAWAAXX_2_trim.paired.fq.gz.1 -2 62GAWAAXX_2_trim.paired.fq.gz.2 -U 62GAWAAXX_2_trim.single.fa -S hyb_occu-f3.sam | tee bowtie.log
wait
bowtie2 -f -p 8 occu-bowtie -1 62GAWAAXX_6_trim.paired.fq.gz.1 -2 62GAWAAXX_6_trim.paired.fq.gz.2 -U 62GAWAAXX_6_trim.single.fa -S hyb_occu-f4.sam | tee bowtie.log
wait
bowtie2 -f -p 8 occu-bowtie -1 62GAWAAXX_8_trim.paired.fq.gz.1 -2 62GAWAAXX_8_trim.paired.fq.gz.2 -U 62GAWAAXX_8_trim.single.fa -S hyb_occu-f6.sam | tee bowtie.log
wait
bowtie2 -f -p 8 ocu-bowtie -1 62GAWAAXX_2_trim.paired.fq.gz.1 -2 62GAWAAXX_2_trim.paired.fq.gz.2 -U 62GAWAAXX_2_trim.single.fa -S hyb_ocu-f3.sam | tee bowtie.log
wait
bowtie2 -f -p 8 ocu-bowtie -1 62GAWAAXX_6_trim.paired.fq.gz.1 -2 62GAWAAXX_6_trim.paired.fq.gz.2 -U 62GAWAAXX_6_trim.single.fa -S hyb_ocu-f4.sam | tee bowtie.log
wait
bowtie2 -f -p 8 ocu-bowtie -1 62GAWAAXX_8_trim.paired.fq.gz.1 -2 62GAWAAXX_8_trim.paired.fq.gz.2 -U 62GAWAAXX_8_trim.single.fa -S hyb_ocu-f6.sam | tee bowtie.log

for i in *.sam;do samtools view -bS $i > ${i/.sam/.bam};done

for i in *.bam;do samtools sort $i $i.sorted;done

for i in *.bam.sorted.bam; do samtools index $i;done

python make_denovo_bed.py occu_dn_transcriptome.fa > occu.bed

multiBamCov -bams occu-f3.1.bam.sorted.bam  occu-f3.2.bam.sorted.bam  occu-f4.bam.sorted.bam  occu-f5.bam.sorted.bam  occu-f6.bam.sorted.bam -bed occu.bed > occu.counts