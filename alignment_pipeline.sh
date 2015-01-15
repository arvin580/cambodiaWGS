### This is a BWA-MEM alignment pipeline
### Modified for Pv whole-genome sequencing
### Started August, 2014
### Features:
###	Paired-end alignments using BWA-MEM    
###	Variant-calling using GATK


##########################################################################
###################### REFERENCE GENOME PREPARATION ######################
##########################################################################

## INDEX REFERENCE SEQUENCE FOR BWA
#bwa 

## INDEX REFERENCE SEQUENCE FOR BOWTIE2
#bowtie2-build PvSal1_v10.0.fasta PvSal1_10.0

## INDEX REFERENCE SEQUENCE FOR SAMTOOLS... necessary for the mpileup step
#samtools faidx PvSal1_v10.0.fasta

## INDEX REFERENCE SEQUENCE FOR GATK
#

##########################################################################
###################### SAMPLE ALIGNMENT & CLEANING #######################
##########################################################################

# Aligning so many files in an automated way will be tricky.
# Will put files from all runs (lanes) into a single dir.

ref=/proj/julianog/refs/PvSAL1_v10.0/PlasmoDB-10.0_PvivaxSal1_Genome.fasta
picard=/nas02/apps/picard-1.88/picard-tools-1.88
gatk=/nas02/apps/biojars-1.0/GenomeAnalysisTK-3.3-0/GenomeAnalysisTK.jar
neafsey=/proj/julianog/sequence_reads/previously_published/natgen_neafsey_2012/
chan=/proj/julianog/sequence_reads/previously_published/pntd_chan_2012/
threads=4

#for name in `cat names/BB-KP_names.txt`
#do

### ALIGN PAIRED-END READS WITH BWA_MEM
#	for rgid in `cat names/rgidnames.txt`
#	do
#		if test -f reads/$name$rgid\_R1.fastq.gz
#		then
#			bwa mem -M \
#			-t $threads \
#			-v 2 \
#			-A 2 \
#			-L 15 \
#			-U 9 \
#			-T 75 \
#			-k 19 \
#			-w 100 \
#			-d 100 \
#			-r 1.5 \
#			-c 10000 \
#			-B 4 \
#			-O 6 \
#			-E 1 \
#			-R "@RG\tID:$name$rgid\tPL:illumina\tLB:$name\tSM:$name" \
#			$ref \
#			reads/$name$rgid\_R1.fastq.gz \
#			reads/$name$rgid\_R2.fastq.gz \
#			> aln/$name$rgid.sam
#				# -M marks shorter split hits as secondary
#				# -t indicates number of threads
#				# -v 2 is verbosity ... warnings and errors only
#		fi
#	done

# MERGE, SORT, AND COMPRESS SAM FILES
#	Need to merge the correct number of files for each sample
#	Construct conditionals to test number of SAM files, then merge

#array=(`ls aln/ | grep $name`)

#	## One sample run on two lanes 
#	if test ${#array[*]} = 2
#	then
#		java -jar $picard/MergeSamFiles.jar \
#		I=aln/${array[0]} \
#		I=aln/${array[1]} \
#		O=aln/$name.merged.bam \
#		SORT_ORDER=coordinate \
#		MERGE_SEQUENCE_DICTIONARIES=true
#	fi

#	## One sample run on four lanes 
#	if test ${#array[*]} = 4
#	then
#		java -jar $picard/MergeSamFiles.jar \
#		I=aln/${array[0]} \
#		I=aln/${array[1]} \
#		I=aln/${array[2]} \
#		I=aln/${array[3]} \
#		O=aln/$name.merged.bam \
#		SORT_ORDER=coordinate \
#		MERGE_SEQUENCE_DICTIONARIES=true
#	fi

### ALIGN PAIRED-END READS WITH BWA_MEM FOR CHAN AND NEAFSEY GENOMES
#bwa mem -M \
#	-t $threads \
#	-v 2 \
#	-A 2 \
#	-L 15 \
#	-U 9 \
#	-T 75 \
#	-k 19 \
#	-w 100 \
#	-d 100 \
#	-r 1.5 \
#	-c 10000 \
#	-B 4 \
#	-O 6 \
#	-E 1 \
#	-R "@RG\tID:$name\tPL:illumina\tLB:$name\tSM:$name" \
#	$ref \
#	$neafsey/$name\_1.fastq.gz \
#	$neafsey/$name\_2.fastq.gz \
#	> aln/$name.sam
#		# -M marks shorter split hits as secondary
#		# -t indicates number of threads
#		# -v 2 is verbosity ... warnings and errors only

### SORT SAM FILE AND OUTPUT AS BAM
#java -jar /nas02/apps/picard-1.88/picard-tools-1.88/SortSam.jar \
#	I=aln/$name$rgid.sam \
#	O=aln/$name.bam \
#	SO=coordinate \
#	TMP_DIR=/netscr/prchrist/tmp_for_picard/

### MARK DUPLICATES
#java -jar $picard/MarkDuplicates.jar \
#	I=aln/$name.bam \
#	O=aln/$name.dedup.bam \
#	METRICS_FILE=aln/$name.dedup.metrics \
#	TMP_DIR=/netscr/prchrist/tmp_for_picard/ \
#	REMOVE_DUPLICATES=False

### INDEX BAM FILE PRIOR TO REALIGNMENT
#java -jar $picard/BuildBamIndex.jar \
#	INPUT=aln/$name.dedup.bam
#	TMP_DIR=/netscr/prchrist/tmp_for_picard/

### IDENTIFY WHAT REGIONS NEED TO BE REALIGNED 
#java -jar $gatk \
#	-T RealignerTargetCreator \
#	-R $ref \
#	-L intervals/gatk.intervals \
#	-I aln/$name.dedup.bam \
#	-o aln/$name.realigner.intervals \
#	-nt $threads
#		# gatk.intervals includes just the chromosomes and mitochondria

### PERFORM THE ACTUAL REALIGNMENT
#java -jar $gatk \
#	-T IndelRealigner \
#	-R $ref \
#	-L intervals/gatk.intervals \
#	-I aln/$name.dedup.bam \
#	-targetIntervals \
#	aln/$name.realigner.intervals \
#	-o aln/$name.realn.bam
#		# gatk.intervals includes just the chromosomes and mitochondria

### CLEANUP
#rm aln/*dedup.bam
#rm aln/*dedup.bai
#rm aln/*.sam
#rm aln/*.intervals
#rm aln/*.merged.bam

#done

##########################################################################
############################ VARIANT CALLING #############################
##########################################################################

### MULTIPLE-SAMPLE VARIANT CALLING
#java -jar $gatk \
#	-T UnifiedGenotyper \
#	-R $ref \
#	-L intervals/gatk.intervals \
#	-I names/testBams.list \
#	-o variants/test.vcf \
#	-ploidy 1 \
#	-nt $threads
#		# gatk.intervals includes just the chromosomes and mitochondria

### TRYING OUT HAPLOTYPE CALLER
#java -jar $gatk \
#	-T HaplotypeCaller \
#	-R $ref \
#	-L intervals/gatk.intervals \
#	-I names/testBams.list \
#	-o variants/test.vcf \
#	-ploidy 1
#		# gatk.intervals includes just the chromosomes and mitochondria

##########################################################################
########################### VARIANT FILTERING ############################
##########################################################################

### FILTER BY DEPTH IN PERCENTAGE OF SAMPLES
#java -Xmx2g -jar $gatk \
#	-T CoveredByNSamplesSites \
#	-R $ref \
#	-V variants/good69.vcf \
#	-out variants/05xAT100%.intervals \
#	-minCov 05 \
#	-percentage 0.99999
#		# Output interval file contains sites that passed
#		# Would be more elegant to use 1.0 instad of 0.99999, but that doesn't work

### FILTER VCF BY NEAFSEY PARALOGS, TANDEM REPEATS, SUBTELOMERES, AND QUALITY SCORES
#java -jar $gatk \
#	-T VariantFiltration \
#	-R $ref \
#	-V variants/good69.vcf \
#	-L variants/05xAT100%.intervals \
#	-XL intervals/neafseyExclude.intervals \
#	-XL intervals/trfExclude.intervals \
#	-XL intervals/subtelomeres.intervals \
#	--filterExpression "QD < 5.0" \
#	--filterName "QD" \
#	--filterExpression "MQ < 60.0" \
#	--filterName "MQ" \
#	--filterExpression "FS > 10.0" \
#	--filterName "FS" \
#	--filterExpression "MQRankSum < -5.0" \
#	--filterName "MQRankSum" \
#	--filterExpression "ReadPosRankSum < -5.0" \
#	--filterName "ReadPosRankSum" \
#	--logging_level ERROR \
#	-o variants/good69.qual.vcf
#		# --logging_level ERROR suppresses any unwanted messages
#		# The three .intervals files contain intervals that should be excluded

### SELECT ONLY THE RECORDS THAT PASSED ALL QUALITY FILTERS
#java -jar $gatk \
#	-T SelectVariants \
#	-R $ref \
#	-V variants/good69.qual.vcf \
#	-select 'vc.isNotFiltered()' \
#	-restrictAllelesTo BIALLELIC \
#	-o variants/good69.pass.vcf


##########################################################################
################# GETTING MULTIFASTA FOR SPECIFIC GENES ##################
##########################################################################

for name in `cat names/good42.txt`
do

## SPLIT VCF INTO INDIVIDUAL VCFs
java -Xmx2g -jar $gatk \
	-T SelectVariants \
	-R $ref \
	--variant variants/good42.5xAT100%.vcf \
	-sn $name \
	-o variants/indivs/$name.vcf

## VCF TO FASTA
java -Xmx2g -jar $gatk \
	-T FastaAlternateReferenceMaker \
	-R $ref \
	--variant variants/indivs/$name.vcf \
	-o variants/indivs/$name.fa
		## --rawOnelineSeq prints only sequence

## CREATING THE MULTIFASTA
echo ">"$name >> variants/good42.fa
tail -n +2 variants/indivs/$name.fa >> variants/good42.fa
	# The tail command removes the fasta header line

done

##########################################################################
############################## EXTRA TOOLS ###############################
##########################################################################

## CALCULATE COVERAGE
#bedtools genomecov -ibam aln/$name.realn.bam -max 10 | grep genome > coverage/$name.cov10

### PERCENT ALIGNED
#for name in `cat samplenames.txt`
#do

#echo $name >> percentAln.dedup.txt
#samtools flagstat aln/$name.dedup.bam >> percentAln.dedup.txt

#done


### GATK DEPTH OF COVERAGE CALCUALTOR
#java -Xmx10g -jar /nas02/apps/biojars-1.0/GenomeAnalysisTK-3.2-2/GenomeAnalysisTK.jar \
#	-T DepthOfCoverage \
#	-R /proj/julianog/refs/PvSAL1_v10.0/PlasmoDB-10.0_PvivaxSal1_Genome.fasta \
#	-I bamnames.list \
#	-o coverage/allExons.cov \
#	-geneList coverage/PvSal1_v10.0_exons.refseq \
#	-L coverage/PvSal1_v10.0_exons.intervals \
#	-omitBaseOutput \
#	--minMappingQuality 20 \
#	--minBaseQuality 20
#		#-omitBaseOutput gets rid of the large by-sample-by-base output file
#		# Apparently, we can provide a refseq file of features in the genome for site-by-site analysis
#		# http://gatkforums.broadinstitute.org/discussion/1329/using-refseq-data

## COUNT READS
#java -jar /nas02/apps/biojars-1.0/GenomeAnalysisTK-3.2-2/GenomeAnalysisTK.jar -T CountReads -R $ref -I aln/$name.merged.bam -rf MappingQualityZero

## SORT SAM FILE AND OUTPUT AS BAM
#java -jar /nas02/apps/picard-1.88/picard-tools-1.88/SortSam.jar I=aln/$name-lane1.sam O=aln/$name-lane1.sorted.bam SO=coordinate
#java -jar /nas02/apps/picard-1.88/picard-tools-1.88/SortSam.jar I=aln/$name-lane2.sam O=aln/$name-lane2.sorted.bam SO=coordinate

## INDEX BAM FILE
#java -jar /nas02/apps/picard-1.88/picard-tools-1.88/BuildBamIndex.jar INPUT=aln/1737Pv.sorted.bam

## VALIDATE VCF FORMAT FOR GATK
#java -Xmx2g -jar /nas02/apps/biojars-1.0/GenomeAnalysisTK-3.2-2/GenomeAnalysisTK.jar -R $ref -T ValidateVariants --validationTypeToExclude ALL --variant plasmoDB_vivax_snps.vcf

### COMPARE VCF FILES
#vcftools \
#	--vcf bwa_vs_bt2/OM012-BiooBarcode1_CGATGT-bt2.vcf \
#	--diff bwa_vs_bt2/OM012-BiooBarcode1_CGATGT-bwa.vcf \
#	--out bwa_vs_bt2/compare.txt

### TRYING OUT HAPLOTYPE CALLER
#java -jar $gatk \
#	-T HaplotypeCaller \
#	-R $ref \
#	-L intervals/gatk.intervals \
#	-I aln/OM015.realn.bam \
#	-o variants/HC_om015_ploidy1.vcf \
#	-ploidy 1 \
#		# gatk.intervals includes just the chromosomes and mitochondria

### MAKE IGV BATCH FILES
#echo "## Batch script to take pictures of the pvmsp1 intervening region
#new
#genome Pvivax_Sal1_v10.0
#snapshotDirectory /proj/julianog/users/ChristianP/cambodiaWGS/bwa-sensitivity
#load /proj/julianog/users/ChristianP/cambodiaWGS/bwa-sensitivity/BB012-$LValue.realn.bam
#goto Pv_Sal1_chr07:1,161,402-1,163,140
#snapshot L$LValue.png
#exit" > bwa-sensitivity/BB012-$LValue.batch

#igv -b bwa-sensitivity/BB012-$LValue.batch
