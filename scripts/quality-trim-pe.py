#!/usr/bin/env python

import sys
import screed
import itertools

def do_trim(sequence, acc):
    trim = acc.find('B')
    if trim > MINLENGTH or (trim == -1 and len(sequence) > MINLENGTH):
        if trim != -1:
            sequence = sequence[:trim]
            acc = acc[:trim]
        return sequence, acc
    return None, None

# python quality-trim.py <input fastq file> <output filtered fastq file>
# MINLENGTH is the minimum lenth of read desired.  NCALLS is the percentage of a read with 'N' base calls for which if read has greater, it will be removed. 

MINLENGTH = 30

file1in = sys.argv[1]
file2in = sys.argv[2]
prefix = sys.argv[3]

peout = open(prefix + '.paired.fq', 'w')
seout = open(prefix + '.single.fq', 'w')

count=0
it = itertools.izip(screed.open(file1in), screed.open(file2in))
for n, (record1, record2) in enumerate(it):
    name1 = record1['name']
    sequence1 = record1['sequence']
    accuracy1 = record1['accuracy']

    name2 = record2['name']
    sequence2 = record2['sequence']
    accuracy2 = record2['accuracy']

    sequence1 = sequence1.rstrip('N')
    accuracy1 = accuracy1[:len(sequence1)]

    sequence2 = sequence2.rstrip('N')
    accuracy2 = accuracy2[:len(sequence2)]

    keep_sequence1 = True
    keep_sequence2 = True

    if 'N' in sequence1:
        keep_sequence1 = False
    if 'N' in sequence2:
        keep_sequence2 = False

    sequence1, accuracy1 = do_trim(sequence1, accuracy1)
    if sequence1 is None:
        keep_sequence1 = False

    sequence2, accuracy2 = do_trim(sequence2, accuracy2)
    if sequence2 is None:
        keep_sequence2 = False

    if not keep_sequence1 and not keep_sequence2:
        continue
    else:
        if keep_sequence1 and not keep_sequence2:
            seout.write('@%s\n%s\n+\n%s\n' % (name1, sequence1, accuracy1))
        elif not keep_sequence1 and keep_sequence2:
            seout.write('@%s\n%s\n+\n%s\n' % (name2, sequence2, accuracy2))
        else:
            peout.write('@%s\n%s\n+\n%s\n' % (name1, sequence1, accuracy1))
            peout.write('@%s\n%s\n+\n%s\n' % (name2, sequence2, accuracy2))

    if n % 1000 == 0:
        print 'scanning', n

