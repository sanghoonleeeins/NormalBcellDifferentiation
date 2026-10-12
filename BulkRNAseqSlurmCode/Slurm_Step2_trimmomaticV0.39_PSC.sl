#!/bin/bash
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=16
## #SBATCH -p RM-shared
###SBATCH --mem=64GB
#SBATCH --time=24:00:00


###SBATCH --job-name=trim
###SBATCH --output=trimmomatic.log

###SBATCH --qos=normal   # max is 3 days
###SBATCH -p RM-shared

date
module purge
#module load gcc/8.2.0 trimmomatic/0.38  # CRC
# module load Trimmomatic/0.39  # PSC
module load trimmomatic/0.40  # Bigpurple 

## module show trimmomatic


#lecture, http://www.usadellab.org/cms/?page=trimmomatic



### Double-end
# echo $1 $2  # $1, fastq_r1, $2, fastq_r2
# echo $3 $4 # filename of fastq1 and fastq2.

##java -jar /ihome/crc/install/trimmomatic/Trimmomatic-0.38/trimmomatic-0.38.jar PE -phred33 \  # CRC
# trimmomatic PE -phred33 \
# $1 $2 $3.paired.fastq.gz $3.unpaired.fastq.gz $4.paired.fastq.gz $4.unpaired.fastq.gz \
# ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36



## ## Single-End
echo $1 $2  # $1, fastq_r1, $2, Output filename. 

java -jar /gpfs/share/apps/trimmomatic/0.40/trimmomatic-0.40.jar SE -phred33 \
$1 $2.trimmed.fastq.gz \
ILLUMINACLIP:/gpfs/share/apps/trimmomatic/0.40/adapters/TruSeq3-SE.fa:2:30:10 \
LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36





#G28034.MDA-MB-361.1_r1.fastq.gz G28034.MDA-MB-361.1_r2.fastq.gz \
#G28034.MDA-MB-361.1_r1.paired.fq.gz G28034.MDA-MB-361.1_r1.unpaired.fq.gz G28034.MDA-MB-361.1_r2.paired.fq.gz G28034.MDA-MB-361.1_r2.unpaired.fq.gz \
#ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

#fastq_pair G28034.MDA-MB-361.1_r1.fastq G28034.MDA-MB-361.1_r2.fastq

date