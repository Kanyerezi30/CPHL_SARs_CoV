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
