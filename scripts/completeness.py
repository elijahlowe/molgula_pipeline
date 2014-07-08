import screed
import blastparser
import sys

infile = sys.argv[1]
blast_file = sys.argv[2]

lengths={}
for n, record in enumerate(screed.open(infile)):
    lengths[record['name']]=len(record['sequence'])
print blast_file
recov=[]
cnt=0
for hits in blastparser.parse_file(blast_file):
    hit_len = 0
    for i in range(len(hits[0].matches)):
        hit_len = abs(hits[0].matches[i].query_end - hits[0].matches[i].query_start)+hit_len
    cov_precent = hit_len/float(lengths[hits.query_name])
    recov.append(cov_precent)
    cnt=cnt+1

print sum(recov)/float(len(recov))
#print "Num hits", cnt
