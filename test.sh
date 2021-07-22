#!/bin/bash
#starting assetfinder
assetfinder --subs-only $1 | tee -a domains.txt
#starting amass
amass enum --passive -d $1 -o domains
#starting subfinder
subfinder -d $1 -o domains
#removing duplicate entries
sort -u domains -o domains
#filtering the domains
cat domains > domain.txt

for i in `cat domain.txt`; do nslookup -type=txt $i 2>/dev/null | grep "spf" | awk '{print $4 $5$6}';  done > spf.txt

for i in `head domain.txt`; do nslookup -type=mx $i 2>/dev/null | grep "mail" | awk '{print $5 " " $6}';  done > mx.txt

for i in `cat domain.txt`; do nslookup  $i 2>/dev/null | grep "Address" | awk 'FNR==2 {print $2}';  done > ip.txt

cat domain.txt  > domain.csv && cat spf.txt > spf.csv && cat mx.txt > mx.csv && cat ip.txt > ip.csv

paste -d ',' domain.csv ip.csv mx.csv spf.csv > temp0.csv

echo -e "Domains\tIP\tMX\tSPF" | cat - temp0.csv > output.csv

cat output.csv
