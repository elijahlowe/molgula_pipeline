#! /usr/bin/env python
import sys
import csv
import blastparser

# get the filename as the first argument on the command line
filename = sys.argv[1]

# open it for reading
fp = open(filename)

# send output as comma-separated values to stdout
output = csv.writer(sys.stdout)

# parse BLAST records
idn,cnt,num,score = 0,0,0,0
num_hits = 0
for record in blastparser.parse_file(filename):
    for hit in range(len(record[0].matches)):
        idn = record[0].matches[hit].identity + idn
        score= record[0].matches[0].score + score
        cnt = cnt + 1
    num_hits = num_hits + 1
    if record[0].matches[0].identity >= 50:
        num = num+1
print cnt
print filename
print "avg idn", idn/float(cnt)
print "total hits", num_hits
print "percent > 0.5", num/float(cnt)
print "avg bit score", score/float(cnt)

#        for match in hit.matches:
            # output each match as a separate row
            #row = [record.query_name, hit.subject_name, match.identity,
         #          match.expect]
            #output.writerow(row)
 #           idn = match.identity
