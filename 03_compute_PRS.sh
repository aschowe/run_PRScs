#!/bin/bash

#======================
# compute PRS after PRScs
# alicia_schowe@psych.mpg.de
#=====================

# best guess ----------------------------------------
#merge all chromosome files
cd ${1}
cat ${2}_pst_eff_a1_b0.5_phiauto_chr*.txt > ${2}.txt

#compute score: By default, if a genotype in the score is missing for a particular individual, then the expected value is imputed, i.e. based on the sample allele frequency. To change this behavior, add the flag
#--score-no-mean-imputation
plink --score ${2}.txt 2 4 6 --out ${2}_PRS --bfile ${3};
