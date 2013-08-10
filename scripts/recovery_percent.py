import screed
import blastparser
import sys

infile = sys.argv[1]
blast_file = sys.argv[0]

lengths={}
for n, record in enumerate(screed.open(infile)):
    lengths[record['name']]=len(record['sequence'])

idn, cnt, num = 0,0,0
for hits in blastparser.parse_fp(blast_file):
    hit_len=0
    hit_idn=0
    for match in hits[0].matches:
        hit_len=len(match.query_sequence)+hit_len
        hit_idn=match.identity+hit_idn
    hit_idn=hit_idn/float(hits[0])
    covered = hit_len/float(lengths[hits.query_name])
    if covered >= 1:
        idn = hit_idn + idn
    else:
        idn = hit_idn*covered +idn
