#! /usr/bin/env python
import sys
import csv
import blastparser

# get the filename as the first argument on the command line
blast1, blast2, blast3  = sys.argv[1], sys.argv[2], sys.argv[3]

# parse BLAST records
def read_blast(file_name):
    hit_names={}
    for record in blastparser.parse_fp(open(file_name)):
        for hit in record:
            for match in hit.matches:
                # output each match as a separate row
#                hit_names.append(hit.subject_name)
                hit_names[record.query_name]=hit.subject_name
    return hit_names

dict_1 = read_blast(blast1)
dict_2 = read_blast(blast2)
dict_3 = read_blast(blast3)

unmatched_item = set(dict_1.keys()) - set(dict_2.keys()) - set(dict_3.keys())
print len(unmatched_item)

#print "Number of transcripts not in "+sys.argv[1]+" : "+str(len(notinfile1))
for key in unmatched_item:
    print dict_1[key]
