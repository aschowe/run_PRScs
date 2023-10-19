# run_PRScs 
- Pipeline to compute PGSs using PRScs 
- contact: alicia_schowe@psych.mpg.de 
- This PRS Pipeline based on:  https://github.com/getian107/PRScs (please cite PRScs when using this pipeline)

# Getting started
- clone this repository (git clone https://github.molgen.mpg.de/mpip/run_PRScs.git)
- clone the newest version of PRScs (git clone https://github.com/getian107/PRScs.git) into run_PRScs directory

## Requirements: 
- 1000G reference panel 
- GWAS summary statistics
- target genotype file 
- PRScs, python, R, plink 

# Instructions 
[0. I recommend checking https://github.com/getian107/PRScs on a regular basis for PRScs updates] 
1. Prepare all GWAS summary statistics => including the header line, format into: SNP|A1|A2|BETA|SE or SNP|A1|A2|BETA|P (instead of BETA you can also supply OR)   
- Note1: When preparing GWAS summary statistics, check for matching genome build (reference panel is based on hg37), ancestry and column of the effect allele! 
- Note2: When using BETA/OR + P as the input, p-values smaller than 1e-323 are truncated, which may reduce the prediction accuracy for traits that have highly significant loci.
- Note3: the beta/OR column is only used for direction of the effect (+/-) so also z statistics can be used. 
- Note4: Please note that this pipeline by default uses the European reference panel!! You can change this by editing the following line in the 01_PRScs.sh script from: "--ref_dir=/binder/common/PRS-CS/ldblk_1kg_eur \" to "--ref_dir=/binder/common/PRS-CS/NEW_REF_HERE \"

2. Execute PRScs with this command: (note: it is called single PRS because in the future I hope I can make this run consecutively over multiple GWASes from text file so that not each individual PGS computation requires manual initiation) 
- cd run_PRScs
- bash 00_run_single_PRS.sh PATH_TO_GENOTYPE PATH_TO_GWAS GWAS_N NAME_OUTDIR NAME_PGS PARTITION NODE 

How it works: 
- 00_run_single_PRS.sh will call upon 01_PRScs.sh which will execute PRScs.py as an array job, running parallel continuous shrinkage on each chromosome. The output of this first step will be 22 chromosome files with their respective weights after applying continuous shrinkage based on reference dataset and GWAS.
- If all 22 jobs run successfully, 02_slurm_reports.sh tidies up the slurm reports and 03_compute_PRS.sh sums up the weighted effect sizes of across all chromosomes into a single score per individual.  

3. If it does not run through completly, check the slurm file of the last chromosome it completed. 
In general, it is best to go through the slurm files once to check any error messages and whether the number of included SNPs is plausible! (in the future I will see whether i can automate summarising errors from all slurm files) 

## Example of an output folder: 
- {NAME_PGS}.txt => weights of all chromosomes
- {NAME_PGS}_PRS.log => plink log file 
- {NAME_PGS}_PRS.profile => Final weighted PGS for each individual 
- {NAME_PGS}_pst_eff_a1_b0.5_phiauto_chr1.txt => 22 files including the PRScs computed weights for each genetic variant per chromosome

# Methods template
PGS were computed using PRS-CS (Ge et al., 2019) and PLINK 1.9 (Purcell et al., 2007). 
PRS-CS was applied to infer posterior mean effects by chromosome for autosomal single nucleotide polymorphisms (SNPs) 
that overlap between the given discovery genome-wide association study (GWAS) 
and the European 1000 Genomes linkage disequilibrium (LD) panel. 
To ensure convergence of the underlying Gibbs sampler algorithm, 
we set Markov chain Monte Carlo (MCMC) iteration to 10,000 and the first 5,000 MCMC iterations as burn-in (Schultz et al., 2022).  
For all other PRS-CS parameter the default settings were used. Using the PLINK 1.9 score function, 
raw PGSs were then calculated for each participant as a sum of the risk allele count weighted by 
the posterior means effects returned by PRS-CS. 

## References
Auton A, Abecasis GR, Altshuler DM, et al. A global reference for human genetic variation. Nature. 2015;526(7571):68-74. doi:10.1038/nature15393

Ge T, Chen CY, Ni Y, Feng YCA, Smoller JW. Polygenic prediction via Bayesian regression and continuous shrinkage priors. 
Nat Commun. 2019;10(1):1776. doi:10.1038/s41467-019-09718-5

Schultz LM, Merikangas AK, Ruparel K, et al. 
Stability of polygenic scores across discovery genome-wide association studies.
Hum Genet Genomics Adv. 2022;3(2):100091. doi:10.1016/j.xhgg.2022.100091

Purcell S, Neale B, Todd-Brown K, et al. PLINK: A Tool Set for Whole-Genome Association and Population-Based Linkage Analyses. Am J Hum Genet. 2007;81(3):559-575.
