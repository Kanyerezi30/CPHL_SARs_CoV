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
        samtools mpileup -aa -A -d 0 -B -Q 0 --reference ref/sequence.fasta $i | \
        ivar variants -r ref/sequence.fasta -p ${sample}.variants -g GCF_009858895.2_ASM985889v3_genomic.gff
        samtools mpileup -aa -A -d 0 -Q 0 $i | \
        ivar consensus -n N -p ${sample}.consensus -i $sample
done
