#This is a file to assemble transcriptomes
include occ_species.mk
#READ=

output*/transcripts.fa: output*/contigs.fa
	for((i=19;i<=35;i=i+2));do velvetg output_"$i" -cov_cutoff auto -exp_cov auto -read_trkg yes -scaffolding no -ins_length 250; done
#	velvetg output_21 -cov_cutoff auto -exp_cov auto -read_trkg yes -scaffolding no -ins_length 250

output*/contigs.fa: *.pe 
#	velveth output 19,37,2 -shortPaired ${PAIRED}
	if test -e *.se.keep; \
	then velveth output 19,37,2 -fastq -shortPaired *.pe.keep -short *.se.keep; \
	else velveth output 19,37,2 -fastq -shortPaired *.pe.keep; \
	fi

*.pe: *.fq
	python /usr/local/share/khmer/scripts/extract-paired-reads.py ${READ}
	find . -type f -empty -exec rm {} \;
	python /usr/local/share/khmer/scripts/normalize-by-median.py -p -C 20 -k 20 -N 4 -x 1e9 --savehash C20k20.kh *.pe
	wait
	if test -e *.se; \
	then python /usr/local/share/khmer/scripts/normalize-by-median.py -C 20 -k 20 -N 4 -x 1e9 --loadhash C20k20.kh *.se; \
	fi

