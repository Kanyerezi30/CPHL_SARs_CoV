#!/usr/bin/env bash

. "$CONDA_PREFIX/etc/profile.d/conda.sh" # enable activation of the conda environment within script

conda activate sarscov

input=$(echo $1 | sed 's;/$;;') # provide path for the fastq files
output=$(echo $2 | sed 's;/$;;') # provide path for output results

# Quality assessment
for i in $(ls ${input}/*gz | awk -F"/" '{print $NF}' | cut -f1 -d"_" | sort -u)
do
        forward=$(ls ${input}/${i}*_R1_*)
        reverse=$(ls ${input}/${i}*_R2_*)
        trim_galore --paired $forward $reverse
done

#bwa index ref/sequence.fasta # index reference

# Perform alignment
for i in $(ls *val*gz | cut -f1 -d"_" | sort -u)
do
        forward=$(ls ${i}*_R1_*val_1*)
        reverse=$(ls ${i}*_R2_*val_2*)
        bwa mem -t 20 reference/sequence.fasta $forward $reverse | \
        samtools sort -o ${i}.sorted.bam
done

# process bam file
for i in $(ls *sorted.bam)
do
        sample=$(echo $i | cut -f1 -d".")
        samtools view -F4 $i -o ${sample}.mapped.bam
        samtools sort -o ${sample}.mapped.sorted.bam ${sample}.mapped.bam
        samtools index ${sample}.mapped.sorted.bam
done

# call variants with ivar
for i in $(ls *.mapped.sorted.bam)
do
        sample=$(echo $i | cut -f1 -d".")
        samtools mpileup -aa -A -d 0 -B -Q 0 --reference reference/sequence.fasta $i | \
        ivar variants -r reference/sequence.fasta -p ${sample}.variants -g GCF_009858895.2_ASM985889v3_genomic.gff
        samtools mpileup -aa -A -d 0 -Q 0 $i | \
        ivar consensus -n N -p ${sample}.consensus -i $sample
done

# count percentage of Ns
for i in $(ls *fa)
do
        sample=$(echo $i | cut -f1 -d".")
        lines=$(cat $i | grep -vc ">")
        chars=$(grep -v ">" $i | wc -m)
        t_len=$(echo "$chars-$lines" | bc)
        n_lines=$(cat $i | grep -v ">" | grep -o "N" | wc -l)
        nchars=$(cat $i | grep -v ">" | grep -o "N" | wc -m)
        n_len=$(echo "$nchars-$n_lines" | bc)
        nper=$(echo "scale=2; $n_len/$t_len" | bc)
        echo "$sample,$nper" >> per.csv
done

# create multifasta file for sequences with N contente below 50%
for i in $(awk -F"," '$2 < 0.5 {print $1}' per.csv)
do
        output=$(echo $i | cut -f2 -d"-")
        echo ">hCoV-19/Uganda/$output/2022" >> all_sequences.fasta
        cat ${i}.consensus.fa | grep -v ">" >> all_sequences.fasta
done

# calculate coverage 
for i in $(ls *mapped.sorted.bam)
do
        output=$(echo $i | cut -f1 -d"_")
        cov=$(samtools depth $i |  awk '{sum+=$3} END { print sum/NR}')
        echo "$output,$cov" >> coverage.txt
done

nextclade dataset get --name 'sars-cov-2' --output-dir 'data/sars-cov-2' # download and update nextclade dataset

# run nextclade
nextclade run --input-dataset=data/sars-cov-2 --output-csv=nextclade.csv all_sequences.fasta


# pangolin lineage assignment
conda deactivate

conda activate pangolin

pangolin all_sequences.fasta --outfile pangolin.csv
