'''
    Remove blank and comments (lines that start with #)
    Remove all white space at BOL and EOL
    Called from update_packages.cmd
'''
import re, sys, os

assert len(sys.argv) == 2, "Usage: {}<txt_file>".format(sys.argv[0])
    
for line in open(sys.argv[1]):
    line = line.strip()
    if len(line) == 0 or line[0] == '#':
        continue
    print(line)
