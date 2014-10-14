#!/usr/bin/perl -p -i

# this is to convert the matlab output of G (p1a) to latex format for the report.

s/^ *//;
s/ +/\&/g;
s/\.0000e\+000//g;
s/\.0000e\+006/ \\times 10^6/g;
s/\.(.)000e-006/.$1 \\times 10^{-6}/g;
s/$/ \\\\/;
