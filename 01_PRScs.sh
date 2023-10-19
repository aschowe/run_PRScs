#!/bin/bash

#==================================
# Author: alicia_schowe@psych.mpg.de
# Script to execute PRScs for a given phenotype, use run_PRS.sh to specify  array job
#==================================

#case-specific parameter
GENOTYPES=${1}
SUM_STATS_FILE=${2}
GWAS_SAMPLE_SIZE=${3}
OUTPUT_DIR=${4}

#execute PRScs
module load anaconda/anaconda3
python ./PRScs/PRScs.py \
	--ref_dir=/binder/common/PRS-CS/ldblk_1kg_eur \
	--bim_prefix=${GENOTYPES} \
	--sst_file=${SUM_STATS_FILE} \
	--n_gwas=${GWAS_SAMPLE_SIZE} \
	--n_iter=10000 \
	--n_burnin=5000 \
	--out_dir=${OUTPUT_DIR} \
	--chrom=${SLURM_ARRAY_TASK_ID}
