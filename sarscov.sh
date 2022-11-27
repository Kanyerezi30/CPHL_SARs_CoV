#!/usr/bin/env bash

printf "\e[4mRunning Timmomatic...\n\e[0m"

for i in $(ls data/ | cut -f1 -d"_" | sort -u)
do
	R1=$(ls data/${i}*R1*)
	R2=$(ls data/${i}*R2*)
	mkdir tmp
	trim_galore -q 28 --cores 40 --paired $R1 $R2 --output_dir tmp	
done
