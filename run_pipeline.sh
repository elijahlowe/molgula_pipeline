echo "Y Y Y" | bash install.sh

cd /mnt/
mkdir occulta oculata hybrid

echo "copying raw read files from snapshot"
ln -fs /data/occulta/round*/*.fq.gz /mnt/occulta/.
ln -fs /data/oculata/round*/*.fq.gz /mnt/oculata/.
ln -fs /data/hybrid/round*/*.fq.gz /mnt/hybrid/.

echo "starting digi norm and assembly for M. occulta"
bash occulta_dn_and_assemble.sh
echo "starting digi norm and assembly for M. oculata"
bash oculata_dn_and_assemble.sh

echo "joining all k's, cd-hit to 0.99 and removing reads shorter than 1000 bp"
cat /mnt/occulta/output*/transcripts.fa > all_occu.fa
cd-hit-est -c 0.99 -i all_occu.fa -o all_occu.cdhit.fa
python ~/khmer/sandbox/extract-long-sequences.py 1000 all_occu.cdhit.fa > /mnt/occu_dn_transcriptome.fa
python /mnt/molgula_pipeline/scripts/rename.py /mnt/occu_dn_transcriptome.fa Locus occulta > tmp 
mv tmp occu_dn_transcriptome.fa

cat /mnt/oculata/output*/transcripts.fa> all_ocu.fa
cd-hit-est -c 0.99 -i all_ocu.fa -o all_ocu.cdhit.fa
python ~/khmer/sandbox/extract-long-sequences.py 1000 all_ocu.cdhit.fa > /mnt/ocu_dn_transcriptome.fa
python /mnt/molgula_pipeline/scripts/rename.py /mnt/ocu_dn_transcriptome.fa Locus oculata > tmp
mv tmp ocu_dn_transcriptome.fa

rm tmp

python 

echo "Running blast"
blast_and_filter.sh

echo "Plotting with R"
mkdir
/mnt/graphs
R molgula_de_analysis.R