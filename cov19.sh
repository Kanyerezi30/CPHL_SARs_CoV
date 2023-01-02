#!/usr/bin/env bash

. "$CONDA_PREFIX/etc/profile.d/conda.sh" # enable activation of the conda environment within script

conda activate sarscov

# Quality assessment
for i in $(ls *fastq*gz | cut -f1 -d"_" | sort -u)
do
        forward=$(ls ${i}*_R1_*)
        reverse=$(ls ${i}*_R2_*)
        trim_galore --paired $forward $reverse
done

bwa index ref/sequence.fasta # index reference

# Perform alignment
for i in $(ls *val*gz | cut -f1 -d"_" | sort -u)
do
        forward=$(ls ${i}*_R1_*val_1*)
        reverse=$(ls ${i}*_R2_*val_2*)
        bwa mem -t 20 ref/sequence.fasta $forward $reverse | \
        samtools sort -o ${i}.sorted.bam
done
