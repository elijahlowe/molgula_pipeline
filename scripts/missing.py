import screed
import blastparser
import sys

infile = sys.argv[1]
blast_file = sys.argv[2]

lengths={}

print blast_file

recov=[]
cnt=0
for hits in blastparser.parse_file(blast_file):
    recov.append(hits.query_name)
    cnt=cnt+1

for n, record in enumerate(screed.open(infile)):
    if record['name'] not in recov:
        '>%s/2\n%s' % (record['name'], record['sequence'])

