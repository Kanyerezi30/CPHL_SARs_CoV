#!/usr/bin/env bash

printf "\e[4mTrimming poor quality reads...\n\e[0m"

#for i in $(ls data/ | cut -f1 -d"_" | sort -u)
#do
#	R1=$(ls data/${i}*R1*)
#	R2=$(ls data/${i}*R2*)
#	mkdir tmp
#	trim_galore -q 28 --cores 40 --paired $R1 $R2 --output_dir tmp	
#done

printf "\e[4mIndex the reference genome...\n\e[0m"

#bowtie2-build -q --threads 40 -f reference/sequence.fasta reference/sarscovReference

printf "\e[4mAlign the reads to the reference genome...\n\e[0m"

for i in $(ls tmp/*gz | cut -f1 -d"_" | cut -f2 -d"/" | sort -u)
do
	R1=$(ls tmp/${i}*R1*gz)
	R2=$(ls tmp/${i}*R2*gz)
	bowtie2 -p 40 -x reference/sarscovReference -1 $R1 -2 $R2 > ${i}.sam
done
