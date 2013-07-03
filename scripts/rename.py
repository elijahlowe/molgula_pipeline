from sys import argv

f = open(argv[1])
n=0
for lines in f:
    if argv[2] in lines:
        print lines.replace(argv[2], argv[3]+".%s")%(str(n)),
        n=n+1
    else:
        print lines,
