#' saveManifest
#' @return
#' @examples
#' @export
saveManifest = function(){
	#save(Manifest_env$Ref_gwas_manifest,file = paste0(Settings_env$s_ROOT_dir,Settings_env$s_out_folder,"DATA/manifest/Ref_gwas_manifest.Rdata"))  # save in same folder, with name matching object

	save(Ref_gwas_manifest, file = paste0(Settings_env$s_manifest_path,"/Ref_gwas_manifest.rda"),envir = Manifest_env) 
}
