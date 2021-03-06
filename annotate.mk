#cd /usr/local/share/khmer
#echo 'export PYTHONPATH=/usr/local/share/khmer/python' >> ~/.bashrc
#source ~/.bashrc

SPEICES1=Mocu
SPEICES2=Ciona
Transcriptome=/mnt/Mocu_25_dn_trans_cd.fa
Ref_Transcriptome=/mnt/ciona_transcriptome.fa

*.annot: *.homol *.ortho
	python /usr/local/share/eel-pond/annotate-seqs.py ${SPEICES1}_transcriptome.renamed.fa ${SPEICES1}.x.${SPEICES2}.ortho ${SPEICES1}.x.${SPEICES2}.homol > Log.annot

*.homol *.ortho: ${SPEICES1}.x.${SPEICES2}
	python /usr/local/share/eel-pond/make-uni-best-hits.py ${SPEICES1}.x.${SPEICES2} ${SPEICES1}.x.${SPEICES2}.homol
	python /usr/local/share/eel-pond/make-reciprocal-best-hits.py ${SPEICES1}.x.${SPEICES2} ${SPEICES2}.x.${SPEICES1} ${SPEICES1}.x.${SPEICES2}.ortho
	python /usr/local/share/eel-pond/make-namedb.py ${Ref_Transcriptome} ${SPEICES2}.namedb
	python -m screed.fadbm ${Ref_Transcriptome}

${SPEICES1}.x.${SPEICES2}: ${SPEICES1}_transcriptome.renamed.fa
	echo "Formating blast db and running blast"
	formatdb -i ${Ref_Transcriptome} -o T -p T
	formatdb -i ${SPEICES1}_transcriptome.renamed.fa -o T -p F
	blastall -i ${SPEICES1}_transcriptome.renamed.fa -d ${Ref_Transcriptome} -e 1e-3 -p blastx -o ${SPEICES1}.x.${SPEICES2} -a 8 -v 4 -b 4
	blastall -i ${Ref_Transcriptome} -d ${SPEICES1}_transcriptome.renamed.fa -e 1e-3 -p tblastn -o ${SPEICES2}.x.${SPEICES1} -a 8 -v 4 -b 4

${SPEICES1}_transcriptome.renamed.fa: ${Transcriptome}
	python /usr/local/share/khmer/sandbox/extract-long-sequences.py 200 ${Transcriptome} > ${SPEICES1}_transcriptome.fa
	python /usr/local/share/khmer/scripts/do-partition.py -x 1e9 -N 4 --threads 4 ${SPEICES1} ${SPEICES1}_transcriptome.fa
	python /usr/local/share/eel-pond/rename-with-partitions.py ${SPEICES1} ${SPEICES1}_transcriptome.fa.part
	mv ${SPEICES1}_transcriptome.fa.part.renamed.fasta.gz ${SPEICES1}_transcriptome.renamed.fa.gz
	gunzip ${SPEICES1}_transcriptome.renamed.fa.gz
