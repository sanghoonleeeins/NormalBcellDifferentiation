#!/bin/bash
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=16
##SBATCH -p RM-shared
##SBATCH -A mcb180025p
###SBATCH --mem=64G
#SBATCH --time=24:00:00

date
# Unlimited stack size
#ulimit -s unlimited

module purge
#module load R/3.4.1-mkl  # this is in PSC
# module load gcc/8.2.0 r/3.5.2   # this is in SaM    PSC doesn't need to load R. default is R4.0.0
# module load gcc/12.2.0 r/4.3.0
module load r/4.4.1 ### Bigpurple , don't use r/4.5.0  edgeR can't be installed in this version. 

echo $1 $2 $3 $4 $5 $6 $7 $8
# $1, dir/R1.fastq.gz
# $2, dir/R2.fastq.gz
# $3, R1.fastq.gz name
# $4, R2.fastq.gz name
# $5, Ref Genome fasta
# $6, GTF file
# $7,  dataID_ENSG
# $8, outDirecotry


# rsync -azvh $1 $LOCAL &
# rsync -azvh $2 $LOCAL &
# wait

#/ocean/projects/mcb180025p/biotech/1_Shell_SLURM_R_Perl_codes/28_R_install_v4.2.2/R-4.2.2/bin/Rscript --vanilla Step4_2_Rsubread_ProcessRnaSeq_NCBIGTF.R $LOCAL/$3 $LOCAL/$4 $5 $6 $7 $8
Rscript --vanilla Step4_2_Rsubread_ProcessRnaSeq_NCBIGTF_SingleEnd.R $1 $2 $5 $6 $7 $8




date