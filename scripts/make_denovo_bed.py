import screed, sys

infile = sys.argv[1]

for n, record in enumerate(screed.open(infile)):
    print record['name']+"\t0\t",len(record['sequence'])
