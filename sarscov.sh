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

#for i in $(ls tmp/*gz | cut -f1 -d"_" | cut -f2 -d"/" | sort -u)
#do
#	R1=$(ls tmp/${i}*R1*gz)
#	R2=$(ls tmp/${i}*R2*gz)
#	bowtie2 -p 40 -x reference/sarscovReference -1 $R1 -2 $R2 > ${i}.sam
#done

printf "\e[4mProcessing sam...\n\e[0m"

#for i in $(ls *sam)
#do
#	output=$(echo $i | cut -f1 -d".")
#	samtools sort -n -O bam -o ${output}_namesort.bam $i -@ 40
#	samtools fixmate -m ${output}_namesort.bam ${output}_fixmate.bam -@ 40
#	samtools sort -O bam -o ${output}_sorted.bam -T${output}_temp.txt ${output}_fixmate.bam -@ 40
#	samtools markdup -r -s ${output}_sorted.bam ${output}_markdup.bam -@ 40
#	samtools index ${output}_markdup.bam -@ 40
#done

printf "\e[4mCall variants...\n\e[0m"

#for i in $(ls *markdup.bam)
#do
#	output=$(echo $i | cut -f1 -d"_")
#	lofreq indelqual $i --dindel -f reference/sequence.fasta -o ${output}_indel.bam
#	samtools index ${output}_indel.bam -@ 40
#	lofreq call --call-indels -f reference/sequence.fasta -o ${output}_indel.vcf ${output}_indel.bam
#done

printf "\e[4mBuild consensus genome...\n\e[0m"

#for i in $(ls *indel.vcf)
#do
#	output=$(echo $i | cut -f1 -d"_")
	#bgzip -c $i 1> ${output}_indel.vcf.gz
	#tabix ${output}_indel.vcf.gz
#	bcftools consensus -f reference/sequence.fasta ${output}_indel.vcf.gz -o ${output}_consensus.fa
#done

printf "\e[4mCalculate coverage...\n\e[0m"

for i in $(ls *markdup.bam)
do
	output=$(echo $i | cut -f1 -d"_")
	cov=$(samtools depth $i |  awk '{sum+=$3} END { print sum/NR}')
	echo "$output,$cov" >> coverage.txt
done
