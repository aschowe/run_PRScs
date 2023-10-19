#!/bin/bash

#usage: PRS.sh path_to_GWAS_sumstats GWAS_n output_dir
#sumstats file need to fit the following format: SNP|A1|A2|Beta/OR|P
GENOTYPES=${1}
GWAS=${2}
GWAS_N=${3}
OUTDIR=${4}
PHENO=${5}
OUTPUT=${OUTDIR}"/"${PHENO}
PARTITION=${6}
NODE=${7}

# create output directory
mkdir ${OUTDIR}

# run PRScs per chromosome
jid=$(sbatch --parsable \
	--export ALL \
	-p ${PARTITION} -w ${NODE} -J PRScs --output="./"${OUTDIR}"/slurm-"%A_%a.out \
       --time=68:00:00 \
       --array 1-22 \
       --wrap="bash 01_PRScs.sh ${GENOTYPES} ${GWAS} ${GWAS_N} ${OUTPUT}");

# tidy up directory and summarise error reports
sbatch  -p ${PARTITION} -w ${NODE} --dependency=afterok:${jid} 02_slurm_reports.sh ${OUTDIR}"/slurm" ${OUTDIR}"/slurm/"

# use plink to compute PRSas sumscore across all chromosomes
sbatch  -p ${PARTITION} -w ${NODE} --dependency=afterok:${jid} 03_compute_PRS.sh ${OUTDIR} ${PHENO} ${GENOTYPES}
