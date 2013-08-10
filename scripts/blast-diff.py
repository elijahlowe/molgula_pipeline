#! /usr/bin/env python
import sys
import csv
import blastparser

# get the filename as the first argument on the command line
blast1, blast2  = sys.argv[1], sys.argv[2]

# parse BLAST records
def read_blast(file_name):
    hit_names=[]
    for record in blastparser.parse_fp(open(file_name)):
        for hit in record:
            for match in hit.matches:
                # output each match as a separate row
                hit_names.append(record.query_name)
    return hit_names

list1 = read_blast(blast1)
list2 = read_blast(blast2)
notinfile1,notinfile2=[],[]

for items in list1:
    if items in list2:
        continue #matches=matches+1
    else:
        notinfile2.append(items)

for items in list2:
    if items in list1:
        continue
    else:
        notinfile1.append(items)

notinfile1=list(set(notinfile1))
tmp = notinfile2
notinfile2=list(set(tmp))

print "Number of transcripts not in "+sys.argv[1]+" : "+str(len(notinfile1))
for items in notinfile1:
    print items
print "Number of transcripts not in "+sys.argv[2]+" : "+str(len(notinfile2))
for items in notinfile2:
    print items
