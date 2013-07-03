git clone https://github.com/ngs-docs/ngs-scripts.git /root/ngs-scripts

formatdb -i /mnt/ocu_dn_transcriptome.fa -o T -p F
formatdb -i /mnt/occu_dn_transcriptome.fa -o T -p F

blastall -p blastn -i /mnt/occ_dn_transcriptome.fa -v 2 -b 2 -e 1e-12 -d /mnt/ocu_dn_transcriptome.fa -o /mnt/occVocu.output
blastall -p blastn -d /mnt/occ_dn_transcriptome.fa -v 2 -b 2 -e 1e-12 -i /mnt/ocu_dn_transcriptome.fa -o /mnt/ocuVocc.output

python ~/ngs-scripts/blast/blast-to-csv.py /mnt/occVocu.output > /mnt/occVocu.csv
python ~/ngs-scripts/blast/blast-to-csv.py /mnt/ocuVocc.output > /mnt/ocuVocc.csv

python find-reciprocal-2.py /mnt/occVocu.csv /mnt/ocuVocc.csv > mol_recipr.csv

python /mnt/molgula_pipeline/scripts/csv_to_filtered_counts.py /mnt/occu.counts > /mnt/occu_recipr.counts
python /mnt/molgula_pipeline/scripts/csv_to_filtered_counts.py /mnt/ocu.counts > /mnt/ocu_recipr.counts
python /mnt/molgula_pipeline/scripts/csv_to_filtered_counts.py /mnt/hyb.counts > /mnt/hyb_recipr.counts

paste /mnt/ocu_recipr.counts /mnt/occu_recipr.counts > /mnt/mol_recipr.counts
