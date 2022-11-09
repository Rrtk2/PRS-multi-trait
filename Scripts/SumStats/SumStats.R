#-----------------------------------------------------------------------------------------------------#
# 							GENERAL INFORMATION
#-----------------------------------------------------------------------------------------------------#
# File description:
#	Name
#		SumStats.R
#
#	Purpose 
#		This code was made as sub-master level regulation script.
#
# Author comment:
#	Rick A. Reijnders 
#	ra.reijnders@maastrichtuniversity.nl
#
#	Personal comment:
#
#
#-----------------------------------------------------------------------------------------------------#
#							Main settings or load
#-----------------------------------------------------------------------------------------------------#
source("C:/DATA_STORAGE/Projects/PRS-multi-trait/Scripts/.Main/Settings.R")

require(data.table)

#-----------------------------------------------------------------------------------------------------#
#							Temp placeholder of gwas manifest for eduYears, to get system running
#							@Josh this stuff here is non-perminent (TO SOME DEGREE!)
#							Making subset of top 1000 snps FOR SPEED AND TEST
#-----------------------------------------------------------------------------------------------------#
# first get the manifest and check processed 
f_getManifest(1)


# This part is for reading in the manifest, and checking if .summaries exist
if(length(which(Ref_gwas_manifest$processed==0))!=0){
	for(i in which(Ref_gwas_manifest$processed==0)){
		warning("(SumStats.R)    !!! This needs standardized input !!!")
		temp_manifest = Ref_gwas_manifest[i,]
		
		#temp_gwas = read.table(temp_manifest$filename,header = TRUE,sep = "\t")
		temp_gwas = data.table::fread(temp_manifest$filename,header = TRUE,sep = "\t") # waaay faster now!
		
		# @RRR fix below please
		# -temp- filter! @RRR needs to be removed
		#temp_psign = -log10(temp_gwas$Pval)
		#temp_gwas = temp_gwas[order(temp_psign,decreasing = T),][1:1000,]
		if(temp_manifest$short == "EduAtt"){
			warning("(SumStats.R)    !!! This is hardcoded EduAtt !!!")
			temp_gwas = data.frame(	Predictor=paste0(temp_gwas$Chr,":",temp_gwas$BP),
					A1=temp_gwas$Effect_allele,
					A2=temp_gwas$Other_allele,
					n=temp_manifest$n,
					Direction=sign(temp_gwas$Beta),
					P=temp_gwas$P)
					
			# remove inconsistent  @RRR this is a stupid fix, need a better version later! This removes "inconsistent allelles"
			a = data.table::fread(paste0(s_data_loc_ref,"1000G_phase3_final.bim"),header=FALSE)
			a = a[match(temp_gwas$Predictor,a$V2),]
			
			temp_gwas = temp_gwas[which(temp_gwas$A1==a$V5 & temp_gwas$A2==a$V6),]
		}
		
		if(temp_manifest$short == "Heigth"){
		warning("(SumStats.R)    !!! This is hardcoded Heigth !!!")
		temp_gwas = data.frame(	Predictor=temp_gwas$Predictor,
					A1=temp_gwas$A1,
					A2=temp_gwas$A2,
					n=temp_manifest$n,
					Direction=sign(temp_gwas$Direction),
					Stat=temp_gwas$Stat)
			# remove inconsistent  @RRR this is a stupid fix, need a better version later! This removes "inconsistent allelles"
			a = data.table::fread(paste0(s_data_loc_ref,"1000G_phase3_final.bim"),header=FALSE)
			a = a[match(temp_gwas$Predictor,a$V2),]
			
			temp_gwas = temp_gwas[which(temp_gwas$A1==a$V5 & temp_gwas$A2==a$V6),]

		}
		
		if(temp_manifest$short == "Height22"){
		warning("(SumStats.R)    !!! This is hardcoded Height22 !!!")
		temp_gwas = data.frame(	Predictor=gsub(temp_gwas$SNPID,pattern = ":.:.",replacement = ""),
					A1=temp_gwas$OTHER_ALLELE,
					A2=temp_gwas$EFFECT_ALLELE,
					n=temp_gwas$N,
					Direction=-sign(temp_gwas$BETA), # This is reversed as effect allelle is reversed!!!!
					P=as.numeric(temp_gwas$P))
			# remove inconsistent  @RRR this is a stupid fix, need a better version later! This removes "inconsistent allelles"
			a = data.table::fread(paste0(s_data_loc_ref,"gbr.hapmap.cors.bim"),header=FALSE)
			a = a[match(temp_gwas$Predictor,a$V2),]
			
			temp_gwas = temp_gwas[which(temp_gwas$A1==a$V5 & temp_gwas$A2==a$V6),]

		}
		
		if(temp_manifest$short == "AD"){
		warning("(SumStats.R)    !!! This is hardcoded AD !!")
		temp_gwas = data.table::fread(temp_manifest$filename,header = TRUE,sep = " ")
		temp_gwas = data.frame(	Predictor=temp_gwas$CHR.BP,
					A1=temp_gwas$A1,
					A2=temp_gwas$A2,
					n=100000,
					Direction=sign(temp_gwas$Beta),
					P=temp_gwas$P)
			# remove inconsistent  @RRR this is a stupid fix, need a better version later! This removes "inconsistent allelles"
			a = data.table::fread(paste0(s_data_loc_ref,"1000G_phase3_final.bim"),header=FALSE)
			a = a[match(temp_gwas$Predictor,a$V2),]
			
			temp_gwas = temp_gwas[which(temp_gwas$A1==a$V5 & temp_gwas$A2==a$V6),]

		}
		
		if(temp_manifest$short == "AD_jans"){
		warning("(SumStats.R)    !!! This is hardcoded AD_jans !!!")
		# remove bulk SNPs
		#temp_index = -log10((temp_gwas$BETA / temp_gwas$SE)^2) < quantile(-log10((temp_gwas$BETA / temp_gwas$SE)^2),0.25)
		#temp_gwas = temp_gwas[temp_index,]
			
		temp_gwas = data.frame(	Predictor=gsub(temp_gwas$uniqID.a1a2,pattern = "_._.$",replacement = ""),
					A1=temp_gwas$A1,
					A2=temp_gwas$A2,
					n=temp_gwas$Neff,
					Direction=sign(temp_gwas$BETA),
					Stat=(temp_gwas$BETA / temp_gwas$SE)^2 )
					
		
			
					# remove duplicated and D/I
			temp_gwas = temp_gwas[!duplicated(temp_gwas$Predictor),]
			temp_gwas = temp_gwas[!(temp_gwas$A1 == "D" | temp_gwas$A1 == "I" | temp_gwas$A2 == "D" | temp_gwas$A2 == "I"),]
			
			# remove inconsistent  @RRR this is a stupid fix, need a better version later! This removes "inconsistent allelles"
			a = data.table::fread(paste0(s_data_loc_ref,"1000G_phase3_final.bim"),header=FALSE)
			a = a[match(temp_gwas$Predictor,a$V2),]
			
			temp_gwas = temp_gwas[which(temp_gwas$A1==a$V5 & temp_gwas$A2==a$V6),]
		}
		
		# assign to short name, then store
		assign(x=temp_manifest$short, temp_gwas)
		#save(list=c(temp_manifest$short),file = paste0(s_ROOT_dir,s_out_folder,"DATA/gwas/",temp_manifest$short,".Rdata")) # @RRR OPTIONAL. This is only for loading in R. This line should be commented out at some point
		data.table::fwrite(get(temp_manifest$short),file = paste0(s_ROOT_dir,s_out_folder,"DATA/gwas/",temp_manifest$short,".summaries"),row.names = FALSE,sep = "\t",quote = FALSE) # FASTERRRR
		
		# update settings
		Ref_gwas_manifest[i,"processed"] = 1
		Ref_gwas_manifest[i,"rawSNPs"] = dim(temp_gwas )[1]
		
	}

	# Update manifest
	f_saveManifest()
}

#-----------------------------------------------------------------------------------------------------#
#							output
#-----------------------------------------------------------------------------------------------------#
# save(Result,file = paste0(s_ROOT_dir,s_out_folder,"Example/Result.Rdata"))  # save in same folder, with name matching object

# save.image(paste0(s_ROOT_dir,s_out_folder,"DE/IMAGE_workspace.Rdata")) # save image

#-----------------------------------------------------------------------------------------------------#
#							Cleanup
#-----------------------------------------------------------------------------------------------------#
#Rclean() # remove all temp_ prefix variables