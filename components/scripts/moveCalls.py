import argparse
import os
import re
import fileinput
import sys

parser = argparse.ArgumentParser(description="Copy EPICS function calls from a st.cmd file into a prebuilt, paramterized file.")
# parser.add_argument('-f', dest='config_path', help="Bypass confirmation prompts. Requires a path to a config file")
parser.add_argument('stcmd', nargs=1, default="", help="input st.cmd file")
parser.add_argument('prebuilt', nargs=1, default="", help="prebuilt st.cmd file")
parsed_args = parser.parse_args()
stcmd = parsed_args.stcmd[0]
prebuilt = parsed_args.prebuilt[0]
if not os.path.isfile(stcmd):
    print("Invalid file: " + str(stcmd))
    quit(1)
if not os.path.isfile(prebuilt):
    print("Invalid file: " + str(prebuilt))
    quit(1)

lines=[]
dirty=[]
for line in open(prebuilt):
    lines.append(line)
    dirty.append(0)

for line in open(stcmd):
    if '#' in line:
        continue
    if '(' in line and ')' in line:
        funcSearch = re.search("(.*)\(", line)
        argSearch = re.search("\((.*)\)", line)
        if argSearch is not None and funcSearch is not None:
            args = argSearch.group(1)
            func = funcSearch.group(1)
            for i,l in enumerate(lines):
                if '#' in l:
                    continue
                if func in l:
                    if dirty[i] == 1:
                        continue
                    lines[i]=line
                    dirty[i]=1

i = 0
for pbLine in fileinput.input(prebuilt, inplace=True):
    print(lines[i], end="")
    if pbLine != lines[i]:
        sys.stderr.write("Line changed: " + pbLine + " -> " + lines[i] + "\n")
    i += 1
print("donion rings")
            
            
