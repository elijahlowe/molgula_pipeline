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

tracking_hits=[]
# parse BLAST records
for record in blastparser.parse_fp(fp):
    for hit in record:
        if hit.subject_name in tracking_hits:
            continue
        else:
            tracking_hits.append(hit.subject_name)
            row=[hit.subject_name]
#        hit[0].matches[0].su
#        for match in hit.matches:
#            row=[hit.subject_name]
#            if match.subject_name in tracking_hits:
#               break
#            else:
#                tracking_hits.append(match)
#                row=[hit.subject_name]
            output.writerow(row)
