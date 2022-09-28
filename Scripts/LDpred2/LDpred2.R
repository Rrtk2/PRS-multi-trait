#-----------------------------------------------------------------------------------------------------#
# 							GENERAL INFORMATION
#-----------------------------------------------------------------------------------------------------#
# File description:
#	Name
#		LDpred2.R
#
#	Purpose 
#		This code was made as sub-master level regulation script.
#
# Author comment:
#	Rick A. Reijnders 
#	ra.reijnders@maastrichtuniversity.nl
#
#	Personal comment:
#		from https://choishingwan.github.io/PRS-Tutorial/ldpred/
#
#-----------------------------------------------------------------------------------------------------#
#							Main settings or load
#-----------------------------------------------------------------------------------------------------#
source("C:/DATA_STORAGE/Projects/PRS/Scripts/.Main/Settings.R")

s_post_qc_location = "C:/DATA_STORAGE/Projects/PRS/Data_RAW/post-qc/"
#-----------------------------------------------------------------------------------------------------#
#							Libraries of this script
#-----------------------------------------------------------------------------------------------------#
# load libraries
library(data.table)
library(magrittr)
# install.packages("remotes") ; remotes::install_github("https://github.com/privefl/bigsnpr.git")
library(bigsnpr)
library(runonce)

#-----------------------------------------------------------------------------------------------------#
#							Input
#-----------------------------------------------------------------------------------------------------#
# load(paste0(s_ROOT_dir,s_out_folder,"LDpred2/Pheno.Rdata"))



#-----------------------------------------------------------------------------------------------------#
#							Main algorithm
#-----------------------------------------------------------------------------------------------------#
# lib options for parallel computing
options(bigstatsr.check.parallel.blas = FALSE)
options(default.nproc.blas = NULL)

# get data
phenotype <- fread(paste0(s_post_qc_location,"EUR.height"))
covariate <-  fread(paste0(s_post_qc_location,"EUR.cov"))
pcs <- fread(paste0(s_post_qc_location,"EUR.eigenvec"))
# rename columns
colnames(pcs) <- c("FID","IID", paste0("PC",1:6))
# generate required table
pheno <- merge(phenotype, covariate) %>%
    merge(., pcs)
	
info <- readRDS(runonce::download_file(
"https://ndownloader.figshare.com/files/25503788",
fname = "map_hm3_ldpred2.rds"))

# Read in the summary statistic file
sumstats <- bigreadr::fread2(paste0(s_post_qc_location,"Height.QC.gz")) 
# LDpred 2 require the header to follow the exact naming
names(sumstats) <-
    c("chr",
    "pos",
    "rsid",
    "a1",
    "a0",
    "n_eff",
    "beta_se",
    "p",
    "OR",
    "INFO",
    "MAF")
# Transform the OR into log(OR)
sumstats$beta <- log(sumstats$OR)
# Filter out hapmap SNPs
sumstats <- sumstats[sumstats$rsid%in% info$rsid,]

# Get maximum amount of cores
NCORES <- nb_cores()
# Open a temporary file
tmp <- tempfile(tmpdir = "tmp-data")
on.exit(file.remove(paste0(tmp, ".sbk")), add = TRUE)
# Initialize variables for storing the LD score and LD matrix
corr <- NULL
ld <- NULL
# We want to know the ordering of samples in the bed file 
fam.order <- NULL
# preprocess the bed file (only need to do once for each data set)
snp_readBed(paste0(s_post_qc_location,"EUR.QC.bed"))
# now attach the genotype object
obj.bigSNP <- snp_attach(paste0(s_post_qc_location,"EUR.QC.rds"))
# extract the SNP information from the genotype
map <- obj.bigSNP$map[-3]
names(map) <- c("chr", "rsid", "pos", "a1", "a0")
# perform SNP matching
info_snp <- snp_match(sumstats, map)
# Assign the genotype to a variable for easier downstream analysis
genotype <- obj.bigSNP$genotypes
# Rename the data structures
CHR <- map$chr
POS <- map$pos
# get the CM information from 1000 Genome
# will download the 1000G file to the current directory (".")
POS2 <- snp_asGeneticPos(CHR, POS, dir = paste0(s_post_qc_location))
# calculate LD
for (chr in 1:22) {
    # Extract SNPs that are included in the chromosome
    ind.chr <- which(info_snp$chr == chr)
    ind.chr2 <- info_snp$`_NUM_ID_`[ind.chr]
    # Calculate the LD
    corr0 <- snp_cor(
            genotype,
            ind.col = ind.chr2,
            ncores = NCORES,
            infos.pos = POS2[ind.chr2],
            size = 3 / 1000
        )
    if (chr == 1) {
        ld <- Matrix::colSums(corr0^2)
        corr <- as_SFBM(corr0, tmp)
    } else {
        ld <- c(ld, Matrix::colSums(corr0^2))
        corr$add_columns(corr0, nrow(corr))
    }
}
# We assume the fam order is the same across different chromosomes
fam.order <- as.data.table(obj.bigSNP$fam)
# Rename fam order
setnames(fam.order,
        c("family.ID", "sample.ID"),
        c("FID", "IID"))
		
		
df_beta <- info_snp[,c("beta", "beta_se", "n_eff", "_NUM_ID_")]
ldsc <- snp_ldsc(   ld, 
                    length(ld), 
                    chi2 = (df_beta$beta / df_beta$beta_se)^2,
                    sample_size = df_beta$n_eff, 
                    blocks = NULL)
h2_est <- ldsc[["h2"]]

# Reformat the phenotype file such that y is of the same order as the 
# sample ordering in the genotype file
y <- pheno[fam.order, on = c("FID", "IID")]
# Calculate the null R2
# use glm for binary trait 
# (will also need the fmsb package to calculate the pseudo R2)
null.model <- paste("PC", 1:6, sep = "", collapse = "+") %>%
    paste0("Height~Sex+", .) %>%
    as.formula %>%
    lm(., data = y) %>%
    summary
null.r2 <- null.model$r.squared

beta_inf <- snp_ldpred2_inf(corr, df_beta, h2 = h2_est)

if(is.null(obj.bigSNP)){
    obj.bigSNP <- snp_attach("EUR.QC.rds")
}
genotype <- obj.bigSNP$genotypes
# calculate PRS for all samples (genome wide)
ind.test <- 1:nrow(genotype)
pred_inf <- big_prodVec(    genotype,
                            beta_inf,
                            ind.row = ind.test,
                            ind.col = info_snp$`_NUM_ID_`)
							
# chr separarted model 		
#pred_inf <- NULL
#for(chr in 1:22){
#    obj.bigSNP <- snp_attach(paste0("EUR_chr",chr,".rds"))
#    genotype <- obj.bigSNP$genotypes
#    # calculate PRS for all samples
#    ind.test <- 1:nrow(genotype)
#    # Extract SNPs in this chromosome
#    chr.idx <- which(info_snp$chr == chr)
#    ind.chr <- info_snp$`_NUM_ID_`[chr.idx]
#    tmp <- big_prodVec(genotype,
#                            beta_inf,
#                            ind.row = ind.test,
#                            ind.col = ind.chr)
#    if(is.null(pred_inf)){
#        pred_inf <- tmp
#    }else{
#        pred_inf <- pred_inf + tmp
#    }
#}

reg.formula <- paste("PC", 1:6, sep = "", collapse = "+") %>%
    paste0("Height~PRS+Sex+", .) %>%
    as.formula
reg.dat <- y
reg.dat$PRS <- pred_inf
inf.model <- lm(reg.formula, dat=reg.dat) %>%
    summary
(result <- data.table(
    infinitesimal = inf.model$r.squared,
    null = null.r2,
	delta = inf.model$r.squared - null.r2
	
))

#-----------------------------------------------------------------------------------------------------#
#							Plotting
#-----------------------------------------------------------------------------------------------------#
# ggplot2 is a handy package for plotting
library(ggplot2)
# generate a pretty format for p-value output
prs.result$print.p <- round(prs.result$P, digits = 3)
prs.result$print.p[!is.na(prs.result$print.p) &
                    prs.result$print.p == 0] <-
    format(prs.result$P[!is.na(prs.result$print.p) &
                            prs.result$print.p == 0], digits = 2)
prs.result$print.p <- sub("e", "*x*10^", prs.result$print.p)
# Initialize ggplot, requiring the threshold as the x-axis (use factor so that it is uniformly distributed)
ggplot(data = prs.result, aes(x = factor(Threshold), y = R2)) +
    # Specify that we want to print p-value on top of the bars
    geom_text(
        aes(label = paste(print.p)),
        vjust = -1.5,
        hjust = 0,
        angle = 45,
        cex = 4,
        parse = T
    )  +
    # Specify the range of the plot, *1.25 to provide enough space for the p-values
    scale_y_continuous(limits = c(0, max(prs.result$R2) * 1.25)) +
    # Specify the axis labels
    xlab(expression(italic(P) - value ~ threshold ~ (italic(P)[T]))) +
    ylab(expression(paste("PRS model fit:  ", R ^ 2))) +
    # Draw a bar plot
    geom_bar(aes(fill = -log10(P)), stat = "identity") +
    # Specify the colors
    scale_fill_gradient2(
        low = "dodgerblue",
        high = "firebrick",
        mid = "dodgerblue",
        midpoint = 1e-4,
        name = bquote(atop(-log[10] ~ model, italic(P) - value),)
    ) +
    # Some beautification of the plot
    theme_classic() + theme(
        axis.title = element_text(face = "bold", size = 18),
        axis.text = element_text(size = 14),
        legend.title = element_text(face = "bold", size =
                                        18),
        legend.text = element_text(size = 14),
        axis.text.x = element_text(angle = 45, hjust =
                                    1)
)
	
#-----------------------------------------------------------------------------------------------------#
#							output
#-----------------------------------------------------------------------------------------------------#
# save(Result,file = paste0(s_ROOT_dir,s_out_folder,"LDpred2/Result.Rdata"))  # save in same folder, with name matching object

# save.image(paste0(s_ROOT_dir,s_out_folder,"DE/IMAGE_workspace.Rdata")) # save image

#-----------------------------------------------------------------------------------------------------#
#							Cleanup
#-----------------------------------------------------------------------------------------------------#
Rclean() # remove all temp_ prefix variables