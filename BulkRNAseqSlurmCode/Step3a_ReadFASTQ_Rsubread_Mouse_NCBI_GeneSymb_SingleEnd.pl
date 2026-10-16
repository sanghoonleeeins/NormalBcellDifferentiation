#/usr/bash/perl

use warnings;
use strict;

#########################################
my $dataDir="/gpfs/scratch/lees130/S48_HematocyticStemCell_Ewha/64_KAI1_BulkRNAseqRaw/02_KAI1_RNAseq_TrimmomaticFASTQ";

my $refGenomeHomo="/gpfs/scratch/lees130/0b_CodeCollection/00a_ReferenceGenome_HomoSapiens/GCF_000001405.40_GRCh38.p14_genomic.fna";  #"GRCh38.primary_assembly.genome.fa";
my $gtfFileHomo="/gpfs/scratch/lees130/0b_CodeCollection/00a_ReferenceGenome_HomoSapiens/GCF_000001405.40_GRCh38.p14_genomic.gtf";    #"GCF_000001405.38_GRCh38.p12_NCBI_geneid_transcriptid.gtf";
my $outDirHomo="/gpfs/scratch/lees130/S48_HematocyticStemCell_Ewha/64_KAI1_BulkRNAseqRaw/05_RsubreadOut_GRCh38_6s";
my $genoTypeHomo="GRCh38NCBIGTF_SingleEnd";

# my $refGenomeMus="/ocean/projects/bio210057p/biotech/S0_ReferenceGenome/02_MusMusculus/GCF_000001635.27_GRCm39_genomic.fna";  #"GRCh38.primary_assembly.genome.fa";
# my $gtfFileMus="/ocean/projects/bio210057p/biotech/S0_ReferenceGenome/02_MusMusculus/GCF_000001635.27_GRCm39_genomic.gtf";    #"GCF_000001405.38_GRCh38.p12_NCBI_geneid_transcriptid.gtf";
# my $outDirMus="/ocean/projects/bio210057p/biotech/N17_Incretins_Semaglutide_KernHast/05b_RsubreadOut_GRCm39_12s";
# my $genoTypeMus="GRCm39NCBIGTF";

# my $MetadataFile="/ocean/projects/bio210057p/biotech/N17_Incretins_Semaglutide_KernHast/03_Metadata_Incretins/sample_metadata_28s.txt";
#########################################

unless (-e $outDirHomo or mkdir $outDirHomo) {	
	die "output directory is wrong specified"
}
die "output directory is wrong specified" unless -d $outDirHomo;

my ($subDirectory, $dirCount);
#my @allSubDir = grep {-d} glob ("$dataDir/");

$dirCount=0;
#foreach $subDirectory (@allSubDir) {
	#$subDirectory=$dataDir;
	#print "each sub directory: $subDirectory \n";
	#$dirCount++;

	$subDirectory=$dataDir;
	my @FASTQFILE = grep {-f} glob ($subDirectory."/*.fastq.gz");
	#print "files: $FASTQFILE[0]\n";
	my $count=0;

	my $r1_count=0;
	# my $r2_count=1;

	foreach my $fqgzFile (@FASTQFILE) {
		if($fqgzFile=~/(.+)\.fastq\.gz$/) {
			#print "fq.gz file: $fqgzFile\n";
			$count++;
			#print "R1 fastq.gz: $FASTQFILE[$r1_count]\n";
			#print "R2 fastq.gz: $FASTQFILE[$r2_count]\n";

			my $fileName1=$FASTQFILE[$r1_count];
			$fileName1=~ s/$subDirectory\///g;	
			# my $fileName2=$FASTQFILE[$r2_count];
			# $fileName2=~ s/$subDirectory\///g;	

			#my $dataID=$fileName1;
			my $dataID=$FASTQFILE[$r1_count];
			#$dataID=~ s/\_1.(.*)$//g;
			#$dataID=~s/_1.fastq.gz//g;
			$dataID=~s/$subDirectory\///g;
			# $dataID=~s/\/(.*)$//g;
			$dataID=~s/\.trimmed.fastq.gz//g;
			print "Data ID: $dataID\n";
	
			#my $laneNum=$fileName1;
			#$laneNum=~ s/(.+)3DMXX\_//g;
			#$laneNum=~ s/\_\d\.fq.gz//g;
			#print "lane Number: $laneNum\n";

			#if($count==17 | $count==23){
			# if($r1_count >=1) {
				# print "sbatch --job-name=RsG$count --output=Rsubread\_$dataID.log Slurm_Step4_Rsubread_ProcessRnaSeq_NCBIgeneSymb_SingleEnd.sl $FASTQFILE[$r1_count] $FASTQFILE[$r2_count] $fileName1 $fileName2 $refGenomeHomo $gtfFileHomo $dataID\_$genoTypeHomo $outDirHomo\n";
				 system "sbatch --job-name=RsG$count --output=Rsubread\_$dataID.log Slurm_Step4_Rsubread_ProcessRnaSeq_NCBIgeneSymb_SingleEnd.sl $FASTQFILE[$r1_count] $FASTQFILE[$r2_count] $fileName1 $fileName2 $refGenomeHomo $gtfFileHomo $dataID\_$genoTypeHomo $outDirHomo";
			#}
		
			#print "Rscript --vanilla Rsubread_ProcessRnaSeq_v10.R $FASTQFILE[$r1_count] $FASTQFILE[$r2_count] GRCh38.primary_assembly.genome_Release28.fa Gencode.Release28.primary_assembly.annotation.gtf $dataID \n";
			#system "Rscript --vanilla Rsubread_ProcessRnaSeq_v10.R $FASTQFILE[$r1_count] $FASTQFILE[$r2_count] GRCh38.primary_assembly.genome_Release28.fa Gencode.Release28.primary_assembly.annotation.gtf $dataID &";

			$r1_count+=1;
			# $r2_count+=2;
			print "total file count: $dirCount\n";
			#last if $r1_count==1;
			# last if $r2_count==33;   #end is 47
		} # end of if phrase
	} # end of 2nd foreach

	#last if $dirCount==1;
#} # end of 1st foreach


