# For genetic analysis of my WGS Plasmodium population(s)
# Started late 2014
# Updated 04 May 2015


###################################################
################# Load Libraries ##################
###################################################

library(PopGenome)
library(stringr)


#####################################################
################# Define Functions ##################
#####################################################

## Function to assign pop based on name
pop.namer <- function(GENOME){
  indivs <- get.individuals(GENOME)[[1]]
  pops <- set.populations(pf, list(
    indivs[grep("BB", indivs)], 
    indivs[grep("KP", indivs)], 
    indivs[grep("OM|SN|TB", indivs)]))
  return(pops)
}

## Break a GENOME object by gene and name it
get.pf.genes <- function(GENOME){
  genes <- splitting.data(GENOME, subsites="gene", whole.data = FALSE)
  ## Specify whole.data = FALSE because I don't want to concatenate regions
  ## Extracting gene IDs from the gff INFO field
  ## Need to use stringr's str_extract function to actually get the gene ID out of the big long string of INFO it returns
  id_str <- "PF3D7_[0-9, a-zA-Z, \\., -]+"
  chr01.ids <- str_extract(get_gff_info(gff.file="pf_whole_genome/gff/chr01.gff", chr="Pf3D7_01_v3", extract.gene.names=TRUE), id_str)
  chr02.ids <- str_extract(get_gff_info(gff.file="pf_whole_genome/gff/chr02.gff", chr="Pf3D7_02_v3", extract.gene.names=TRUE), id_str)
  chr03.ids <- str_extract(get_gff_info(gff.file="pf_whole_genome/gff/chr03.gff", chr="Pf3D7_03_v3", extract.gene.names=TRUE), id_str)
  chr04.ids <- str_extract(get_gff_info(gff.file="pf_whole_genome/gff/chr04.gff", chr="Pf3D7_04_v3", extract.gene.names=TRUE), id_str)
  chr05.ids <- str_extract(get_gff_info(gff.file="pf_whole_genome/gff/chr05.gff", chr="Pf3D7_05_v3", extract.gene.names=TRUE), id_str)
  chr06.ids <- str_extract(get_gff_info(gff.file="pf_whole_genome/gff/chr06.gff", chr="Pf3D7_06_v3", extract.gene.names=TRUE), id_str)
  chr07.ids <- str_extract(get_gff_info(gff.file="pf_whole_genome/gff/chr07.gff", chr="Pf3D7_07_v3", extract.gene.names=TRUE), id_str)
  chr08.ids <- str_extract(get_gff_info(gff.file="pf_whole_genome/gff/chr08.gff", chr="Pf3D7_08_v3", extract.gene.names=TRUE), id_str)
  chr09.ids <- str_extract(get_gff_info(gff.file="pf_whole_genome/gff/chr09.gff", chr="Pf3D7_09_v3", extract.gene.names=TRUE), id_str)
  chr10.ids <- str_extract(get_gff_info(gff.file="pf_whole_genome/gff/chr10.gff", chr="Pf3D7_10_v3", extract.gene.names=TRUE), id_str)
  chr11.ids <- str_extract(get_gff_info(gff.file="pf_whole_genome/gff/chr11.gff", chr="Pf3D7_11_v3", extract.gene.names=TRUE), id_str)
  chr12.ids <- str_extract(get_gff_info(gff.file="pf_whole_genome/gff/chr12.gff", chr="Pf3D7_12_v3", extract.gene.names=TRUE), id_str)
  chr13.ids <- str_extract(get_gff_info(gff.file="pf_whole_genome/gff/chr13.gff", chr="Pf3D7_13_v3", extract.gene.names=TRUE), id_str)
  chr14.ids <- str_extract(get_gff_info(gff.file="pf_whole_genome/gff/chr14.gff", chr="Pf3D7_14_v3", extract.gene.names=TRUE), id_str)
  ## Make one big list out of all the little lists of gene IDs
  ## Is there a more elegant way to do all this?
  chr.all.ids <- unlist(list(chr01.ids, chr02.ids, chr03.ids, chr04.ids, chr05.ids, chr06.ids, chr07.ids, chr08.ids, chr09.ids, chr10.ids, chr11.ids, chr12.ids, chr13.ids, chr14.ids))
  genes@region.names <- chr.all.ids
  return(genes)
}

## Break a GENOME object by gene and name it
get.pv.genes <- function(GENOME){
  genes <- splitting.data(GENOME, subsites="gene", whole.data = FALSE)
  ## Specify whole.data = FALSE because I don't want to concatenate regions
  ## Extracting gene IDs from the gff INFO field
  ## Need to use stringr's str_extract function to actually get the gene ID out of the big long string of INFO it returns
  id_str <- "PVX_[0-9, a-zA-Z, \\., -]+"
  chr01.ids <- str_extract(get_gff_info(gff.file="pv_whole_genome/gff/chr01.gff", chr="Pv_Sal1_chr01", extract.gene.names=TRUE), id_str)
  chr02.ids <- str_extract(get_gff_info(gff.file="pv_whole_genome/gff/chr02.gff", chr="Pv_Sal1_chr02", extract.gene.names=TRUE), id_str)
  chr03.ids <- str_extract(get_gff_info(gff.file="pv_whole_genome/gff/chr03.gff", chr="Pv_Sal1_chr03", extract.gene.names=TRUE), id_str)
  chr04.ids <- str_extract(get_gff_info(gff.file="pv_whole_genome/gff/chr04.gff", chr="Pv_Sal1_chr04", extract.gene.names=TRUE), id_str)
  chr05.ids <- str_extract(get_gff_info(gff.file="pv_whole_genome/gff/chr05.gff", chr="Pv_Sal1_chr05", extract.gene.names=TRUE), id_str)
  chr06.ids <- str_extract(get_gff_info(gff.file="pv_whole_genome/gff/chr06.gff", chr="Pv_Sal1_chr06", extract.gene.names=TRUE), id_str)
  chr07.ids <- str_extract(get_gff_info(gff.file="pv_whole_genome/gff/chr07.gff", chr="Pv_Sal1_chr07", extract.gene.names=TRUE), id_str)
  chr08.ids <- str_extract(get_gff_info(gff.file="pv_whole_genome/gff/chr08.gff", chr="Pv_Sal1_chr08", extract.gene.names=TRUE), id_str)
  chr09.ids <- str_extract(get_gff_info(gff.file="pv_whole_genome/gff/chr09.gff", chr="Pv_Sal1_chr09", extract.gene.names=TRUE), id_str)
  chr10.ids <- str_extract(get_gff_info(gff.file="pv_whole_genome/gff/chr10.gff", chr="Pv_Sal1_chr10", extract.gene.names=TRUE), id_str)
  chr11.ids <- str_extract(get_gff_info(gff.file="pv_whole_genome/gff/chr11.gff", chr="Pv_Sal1_chr11", extract.gene.names=TRUE), id_str)
  chr12.ids <- str_extract(get_gff_info(gff.file="pv_whole_genome/gff/chr12.gff", chr="Pv_Sal1_chr12", extract.gene.names=TRUE), id_str)
  chr13.ids <- str_extract(get_gff_info(gff.file="pv_whole_genome/gff/chr13.gff", chr="Pv_Sal1_chr13", extract.gene.names=TRUE), id_str)
  chr14.ids <- str_extract(get_gff_info(gff.file="pv_whole_genome/gff/chr14.gff", chr="Pv_Sal1_chr14", extract.gene.names=TRUE), id_str)
  ## Make one big list out of all the little lists of gene IDs
  ## Is there a more elegant way to do all this?
  chr.all.ids <- unlist(list(chr01.ids, chr02.ids, chr03.ids, chr04.ids, chr05.ids, chr06.ids, chr07.ids, chr08.ids, chr09.ids, chr10.ids, chr11.ids, chr12.ids, chr13.ids, chr14.ids))
  genes@region.names <- chr.all.ids
  return(genes)
}


#####################################################
################### Import Data #####################
#####################################################

## Read in the VCFs and GFFs
pf <- readData("pf_whole_genome/vcf/", format="VCF", gffpath = "pf_whole_genome/gff/")
pv <- readData("pv_whole_genome/vcf/", format="VCF", gffpath = "pv_whole_genome/gff/")

## Read in the ortholog key
ortho_key <- read.table("pv_pf_orthologs.txt")


#####################################################
################### Process Data ####################
#####################################################

## Split into Genes
pf_genes <- get.pf.genes(pf)
pv_genes <- get.pv.genes(pv)



#####################################################
################ Neutrality Stats ###################
#####################################################

## Calculate neutrality Stats
pf_genes <- neutrality.stats(pf_genes)
pv_genes <- neutrality.stats(pv_genes)

## Compare neutrality stats
pf_taj <- cbind(pf_genes@region.names, pf_genes@Tajima.D)
pv_taj <- cbind(pv_genes@region.names, pv_genes@Tajima.D)

## Clean up the ortholist
ortho_key <- ortho_key[!(duplicated(ortho_key[,2]) | duplicated(ortho_key[,2], fromLast = TRUE)),] # remove duplicate Pf entries # need the OR logic because duplicated() only marks second+ occurrence of duplicate
ortho_key <- ortho_key[!(duplicated(ortho_key[,1]) | duplicated(ortho_key[,1], fromLast = TRUE)),] # remove duplicate Pv entries
ortho_key <- ortho_key[ortho_key[,1] %in% pv_taj[,1],] # remove key-value pairs that are not on Pf chromosomes
ortho_key <- ortho_key[ortho_key[,2] %in% pf_taj[,1],] # remove key-value pairs that are not on Pv chromosomes

# Only keep values that are in both orthokey and the tajima stats
pf_taj <- pf_taj[pf_taj[,1] %in% ortho_key[,2],]
pv_taj <- pv_taj[pv_taj[,1] %in% ortho_key[,1],]

## Sort the Pf list by ortho_key

## A function to return a list of PV Tajima's D values
pv.taj.getter <- function(index){
  genenames <- as.character(ortho_key[,1])
  taj <- pv_taj[str_detect(pv_taj[,1], genenames[index]),2]
  return(taj)
}

## A function to return a list of PF Tajima's D values
pf.taj.getter <- function(index){
  genenames <- as.character(ortho_key[,2])
  taj <- pf_taj[str_detect(pf_taj[,1], genenames[index]),2]
  return(taj)
}


taj.getter <- function(ortho_key){
  numcols <- ncol(ortho_key)
  numrows <- nrow(ortho_key)
  ortho_key$V3 <- NA
  ortho_key$V4 <- NA
  names(ortho_key) <- c("PvID", "PfID", "PvTajD", "PfTajD")
  
  # get the Pv ID-TajD combos
  pvids <- as.character(ortho_key[,1])
  
  pfids <- as.character(ortho_key[,2])
}

testtajpv <- unlist(sapply(1:nrow(pv_taj), pv.taj.getter))
testtajpf <- unlist(sapply(1:nrow(pv_taj), pf.taj.getter))

order(testtajpv, decreasing=TRUE)[1:N]


biglist <- unlist(lapply(1:nrow(pv_taj), function(index){length(testtajpv[index])}))




x <- cbind(
  data.frame(pv_taj)[match(ortho_key[,1], pv_taj[,1]),],
  data.frame(pf_taj)[match(ortho_key[,2], pf_taj[,1]),]
)


