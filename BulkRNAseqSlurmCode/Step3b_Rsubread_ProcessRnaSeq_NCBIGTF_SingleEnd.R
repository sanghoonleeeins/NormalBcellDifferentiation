#source("https://bioconductor.org/biocLite.R")
#biocLite("Rsubread")

library(Rsubread)
library(limma)   # bioconductor. 
library(edgeR)   # bioconductor   
library(tools)   # This is basic package provided by R. You don't need to install. 
# library(XML)     # CRAN
options(digits=2)

#setwd("/ocean/projects/mcb180025p/biotech/S83_MycobacteriumAbscessus_MBA")
getwd()

inFilePath1 = commandArgs()[7]
inFilePath2 = "NULL" # commandArgs()[8] # NULL for single-end analyses or when a BAM file has been specified
referenceGenomeFastaFilePath = commandArgs()[9]
gtfFilePath = commandArgs()[10]
outFilePrefix = commandArgs()[11]
outDirectory = commandArgs()[12]

#inFilePath1="../1_RNA-seq_RawFiles/YH10_3_USR17009410L_HFKL3DMXX_L2_1.fq.gz"
#inFilePath2="../1_RNA-seq_RawFiles/YH10_3_USR17009410L_HFKL3DMXX_L2_2.fq.gz" # NULL for single-end analyses or when a BAM file has been specified
#referenceGenomeFastaFilePath = "../3_Rsubread_Normalization/GRCh38.primary_assembly.genome_Release28.fa"
#gtfFilePath = "GCF_000001405.38_GRCh38.p12_NCBI_geneid_transcriptid.gtf"
#gtfFilePath = "GCF_000001405.38_GRCh38.p12_Example_NCBI_ENSG_transcriptid.gff" # this works
#gtfFilePath = "Gencode.Release28_PrimaryAnnotation_20Line.gtf" # this works. 
#outFilePrefix = "YH10_3_L2_NCBI_geneid_transcriptid"

print (paste("inFilePath1: ", inFilePath1, sep=""))
print (paste("inFilePath2: ", inFilePath2, sep=""))
print (paste("referenceGenomeFastaFilePath: ", referenceGenomeFastaFilePath, sep=""))
print (paste("gtfFilePath: ", gtfFilePath, sep=""))
print (paste("outFilePrefix: ", outFilePrefix, sep=""))

memory = 16000
nthreads = 6

input_format = "gzFASTQ"
#if (file_ext(inFilePath1) == "bam")  
 #   input_format = "BAM"

outBamFilePath = paste(outDirectory, "/", outFilePrefix, ".bam", sep="") 
outCountsFilePath = paste(outDirectory,"/", outFilePrefix, ".featureCounts", sep="")
outRpkmFilePath = paste(outDirectory,"/", outFilePrefix, ".rpkm", sep="")  
outRpkmLogFilePath = paste(outDirectory,"/", outFilePrefix, ".rpkmlog", sep="") 
outCpmFilePath = paste(outDirectory,"/", outFilePrefix, ".cpm", sep="")  
outCpmLogFilePath = paste(outDirectory,"/", outFilePrefix, ".cpmlog", sep="")  
outTpmFilePath = paste(outDirectory,"/", outFilePrefix, ".tpm", sep="")   
outTpmLogFilePath = paste(outDirectory,"/", outFilePrefix, ".tpmlog", sep="")  
outStatsFilePath = paste(outDirectory,"/", outFilePrefix, ".stats", sep="") 

print ("line 38 is working")
referenceGenomeIndexFilePrefix = paste(referenceGenomeFastaFilePath, "__reference_index", sep="")

print ("line 41 is working")
if (!file.exists(paste(referenceGenomeIndexFilePrefix, ".reads", sep="")))
  buildindex(basename=referenceGenomeIndexFilePrefix, reference=referenceGenomeFastaFilePath, memory=memory)

print ("line 45 is working")

if (inFilePath2 == "NULL")
  inFilePath2 = NULL
print (paste("inFilePath1: ", inFilePath1, sep=""))
print (paste("inFilePath2: ", inFilePath2, sep=""))
if (!file.exists(outBamFilePath))
#  align(index=referenceGenomeIndexFilePrefix, readfile1=inFilePath1, readfile2=inFilePath2, output_file=outBamFilePath, nthreads=nthreads, input_format=input_format, tieBreakHamming=TRUE, unique=TRUE, indels=5)
  align(index=referenceGenomeIndexFilePrefix, readfile1=inFilePath1, readfile2=inFilePath2, output_file=outBamFilePath, nthreads=nthreads, input_format=input_format, unique=TRUE, indels=5)

print ("line 54 is working")
fCountsList = featureCounts(outBamFilePath, annot.ext=gtfFilePath, isGTFAnnotationFile=TRUE,GTF.featureType="gene",GTF.attrType = "gene", nthreads=nthreads, isPairedEnd=!is.null(inFilePath2))
dgeList = DGEList(counts=fCountsList$counts, genes=fCountsList$annotation)
rpkm = rpkm(dgeList, dgeList$genes$Length)
#cpm = cpm(dgeList, dgeList$genes$Length) # This is old in R 3.2.0
cpm <- cpm(dgeList, log = FALSE, normalized.lib.sizes=TRUE)
tpm = exp(log(rpkm) - log(sum(rpkm)) + log(1e6))

#write.table(fCountsList$stat, outStatsFilePath, sep="\t", col.names=FALSE, row.names=FALSE, quote=FALSE)

featureCounts = cbind(fCountsList$annotation[,1], fCountsList$counts)
write.table(featureCounts, outCountsFilePath, sep="\t", col.names=FALSE, row.names=FALSE, quote=FALSE)
print(paste("Saved feature count data to", outCountsFilePath))

#write.table(cbind(fCountsList$annotation[,1], rpkm), outRpkmFilePath, sep="\t", col.names=FALSE, row.names=FALSE, quote=FALSE)
#print(paste("Saved RPKM data to", outRpkmFilePath))
#write.table(cbind(fCountsList$annotation[,1], log2(rpkm + 1)), outRpkmLogFilePath, sep="\t", col.names=FALSE, row.names=FALSE, quote=FALSE)
#print(paste("Saved RPKMlog data to", outRpkmLogFilePath))

write.table(cbind(fCountsList$annotation[,1], cpm), outCpmFilePath, sep="\t", col.names=FALSE, row.names=FALSE, quote=FALSE)
print(paste("Saved CPM data to", outCpmFilePath))
write.table(cbind(fCountsList$annotation[,1], log2(cpm + 1)), outCpmLogFilePath, sep="\t", col.names=FALSE, row.names=FALSE, quote=FALSE)
print(paste("Saved CPMlog data to", outCpmLogFilePath))

write.table(cbind(fCountsList$annotation[,1], tpm), outTpmFilePath, sep="\t", col.names=FALSE, row.names=FALSE, quote=FALSE)
print(paste("Saved TPM data to", outTpmFilePath))
write.table(cbind(fCountsList$annotation[,1], log2(tpm + 1)), outTpmLogFilePath, sep="\t", col.names=FALSE, row.names=FALSE, quote=FALSE)
print(paste("Saved TPMlog data to", outTpmLogFilePath))



### remove .bam file
bamFile<-paste(outDirectory,"/",outFilePrefix,".bam",sep="")
if(file.exists(bamFile)) {
	file.remove(bamFile)
}
bam.indel.vcf.File<-paste(outDirectory,"/",outFilePrefix,".bam.indel.vcf",sep="")
if(file.exists(bam.indel.vcf.File)) {
	file.remove(bam.indel.vcf.File)
}
bam.summary.File<-paste(outDirectory,"/",outFilePrefix,".bam.summary",sep="")
if(file.exists(bam.summary.File)) {
	file.remove(bam.summary.File)
}


