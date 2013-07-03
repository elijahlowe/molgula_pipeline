import sys

csv = open(sys.argv[1])
counts_file = open(sys.argv[2])

counts = {}
for line in counts_file:
    counts[line.rstrip('\n').split()[0]]='\t'.join(line.rstrip('\n').split()[1:])

column1, column2 = [],[]
for line in csv:
    col1, col2 = line.rstrip('\r\n').split(',')
    if col1 in counts:
        print col1+'\t'+counts[col1]
    else:
        print col2+'\t'+counts[col2]



