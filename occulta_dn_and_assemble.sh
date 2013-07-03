cd /mnt/occulta
normalize-by-median.py -C 20 -k 20 -N 4 -x 2e9 *.fq.gz
wait
velveth output 19,37,2 -fastq -short 62GAWAAXX_3_trim.paired.fq.gz.keep 62GAWAAXX_3_trim.single.fq.gz.keep Mocc-F3.trim.fq.gz.keep Mocc-F4.trim.fq.gz.keep Mocc-F5.trim.fq.gz.keep Mocc-F6.trim.fq.gz.keep
wait
for((n=19;n<37;n=n+2));do velvetg output_"$n" -cov_cutoff auto -exp_cov auto -read_trkg yes -scaffolding no; done
wait
for((n=19;n<37;n=n+2));do oases output_"$n"; done

