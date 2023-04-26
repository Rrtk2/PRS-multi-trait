Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 2)

server <- function(input, output, session){
  options(shiny.maxRequestSize=1000000*1024^2)
  
  #****************************************************************************#
  # Data selection
  #****************************************************************************#
  
  # Reactive values
  v <- reactiveValues()
  v$Manifest <- Manifest_env$Ref_gwas_manifest
  
  #Hide tabs
  hideTab("navbar", target = "output_panel")
  
  volumes = getVolumes()
  observe({
    shinyFileChoose(input, "bfile", roots = volumes, session = session, filetypes = c("bim", "bed", "fam"))
  })
  observe({
    shinyFileChoose(input, "summary", roots = volumes, session = session, filetypes = c("summaries"))
  })
  
  observe({
    output$traits_input_ui <- renderUI({
      selectInput(inputId = "traits_input",
                  label = "Select trait(s)",
                  choices = v$Manifest[v$Manifest$processed == 2,1],
                  multiple = TRUE)
    })
    output$remove_input_ui <- renderUI({
      selectInput(inputId = "remove_input",
                  label = "Select trait(s) to be removed",
                  choices = v$Manifest[,1],
                  multiple = TRUE)
    })
  })

  # Show uploaded bfile
  observe({
    output$bfile_status <- renderText({
      file <- as.character(parseFilePaths(volumes, input$bfile)$datapath)
      if (length(file) > 0){
        output <- paste0("<i>Selected file: ", file, "</i>")
      }
      if (length(file) == 0){
        output <- "<i>No file selected</i>"
      }
      return(output)
    }) 
  })
  
  # Show uploaded summary file
  observe({
    output$summaryfile_status <- renderText({
      file <- as.character(parseFilePaths(volumes, input$summary)$datapath)
      if (length(file) > 0){
        output <- paste0("<i>Selected file: ", file, "</i>")
      }
      if (length(file) == 0){
        output <- "<i>No file selected</i>"
      }
      return(output)
    }) 
  })

  #Info panel
  observeEvent(input$infopanel1, {
    sendSweetAlert(
      session = session,
      title = "Information",
      text = tags$span("Full documentation can be found",
                       tags$a(href = "https://www.youtube.com/watch?v=dQw4w9WgXcQ", 
                              "here")),
      type = "info"
    )
  })
  
  #****************************************************************************#
  # Continue with saved data
  #****************************************************************************#
  
  
  observeEvent(input$continue, {
    
    # Enter cohort name
    inputSweetAlert(
      session = session,
      inputId = "idcontinue",
      title = "Continue",
      text = "Enter the cohort name (i.e., the name of the PLINK file without .bim/.bed/.fam extension) 
      to continue.",
      input = "select",
      inputOptions = cohort,
      btn_labels = c("Continue", "Cancel")
    )
    
    # Cohort name
    cohortName <- reactive({
      req(input$idcontinue)
      cohortName <- str_split(input$idcontinue, ": ")[[1]][1]
      return(cohortName)
    })
    
    # Cohort name
    modelName <- reactive({
      req(input$idcontinue)
      modelName <- str_split(input$idcontinue, ": ")[[1]][2]
      return(modelName)
    })
    
    # Get PRS results
    PRS_result <- reactive({
      req(cohortName())
      req(modelName())
      PRS_result <-  collect_all_PRS(cohort = cohortName(),
                                     Model = modelName())
      
      if ((modelName() != "bayesr-shrink") & (modelName() != "lasso-sparse")){
        colnames(PRS_result) <- str_remove(colnames(PRS_result), paste0("_",modelName()))
      } else{
        colnames(PRS_result) <- str_remove(colnames(PRS_result), "_bayesr.shrink")
        colnames(PRS_result) <- str_remove(colnames(PRS_result), "_lasso.sparse")
      }
      
      return(PRS_result)
    })
    
    
    # Go the next step
    observeEvent(if (length(PRS_result()) > 0){input$idcontinue}, {
      
      # Success message
      sendSweetAlert(
        session = session,
        title = "Success!",
        text = "Data successfully selected!",
        type = "success")
      
      # Go to next tab
      updateTabsetPanel(session, "navbar",
                        selected = "output_panel")
      
      # Show next tab
      showTab("navbar", target = "output_panel")
      
    })
    
    # Output table
    output$PRS_table <- DT::renderDataTable({
      return(PRS_result())
    }, server=TRUE,
    options = list(pageLength = 10), rownames= TRUE)
    
    
    #download table of meta data
    output$downloadPRS <- downloadHandler(
      filename = "PRS_results.csv",
      content = function(file){
        #write.csv(PRS_result(), file)
		write.table(PRS_result(),file,col.names = NA,row.names = TRUE,sep = ",",quote = FALSE)
      }
    )
	
	#download table of meta data
    output$downloadPRStsv <- downloadHandler(
      filename = "PRS_results.tsv",
      content = function(file){
        #write.csv(PRS_result(), file)
		write.table(PRS_result(),file,col.names = NA,row.names = TRUE,sep = "\t",quote = FALSE)
      }
    )
    
    # Heatmap
    output$heatmap_plot <- renderPlot({
      req(input$cor_method)
      req(input$link_method)
      
      # Calculate correlations
      corrDF <- as.data.frame(correlate(PRS_result(), diagonal = 1, method = input$cor_method))
      rownames(corrDF) <- corrDF$term
      corrDF <- corrDF[,-1]
      
      # Format data for plotting
      plotCor <- gather(corrDF)
      plotCor$key1 <- rep(rownames(corrDF), ncol(corrDF))
      
      # Perform clustering to get sample order
      model <- hclust(as.dist(1-abs(corrDF)), input$link_method)
      order <- model$labels[model$order]
      plotCor$key <- factor(plotCor$key, levels = order)
      plotCor$key1 <- factor(plotCor$key1, levels = order)
      
      # Main correlation plot
      main <- ggplot(plotCor) +
        geom_tile(aes(x = key, y = key1, fill = value)) +
        scale_fill_gradient2(low = "#000072", mid = "white", high = "red", midpoint = 0,
                             limits = c(-1,1)) +
        xlab(NULL) +
        ylab(NULL) +
        labs(fill = paste0(str_to_title(input$cor_method),"\nCorrelation"))+
        theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 15),
              axis.text.y = element_text(size = 15))
      
      # Dendrogram
      dendroPlot <- ggplot() +
        geom_tile(data = plotCor, aes(x = as.numeric(key), y = 1), fill = "white", alpha = 0) +
        geom_dendro(model,xlim = c(1,length(unique(plotCor$key)))) +
        theme_void() +
        theme(legend.position = "none") 
      
      # Combine plots
      p <- dendroPlot + main +
        plot_layout(nrow = 2, ncol = 1,
                    heights = c(1,6))
      
      # Return output
      return(p)
      
    })
    
    #x-axis
    output$ui_X <- renderUI({
      selectInput(inputId = "X",
                  label = "X-axis",
                  choices = colnames(PRS_result()),
                  selected = colnames(PRS_result())[1])
    })
    
    # y-axis
    output$ui_Y <- renderUI({
        selectInput(inputId = "Y",
                    label = "Y-axis",
                    choices = colnames(PRS_result()),
                    selected = colnames(PRS_result())[2])
      
    })
    
    # Correlation plot
    output$correlation_plot <- renderPlot({
      req(input$cor_method2)
      req(input$X)
      req(input$Y)
      
      plotScatter <- data.frame(X = PRS_result()[,input$X],
                                Y = PRS_result()[,input$Y])
      
      corrValue = cor(plotScatter$X,plotScatter$Y, method = input$cor_method2,
                      use = "pairwise.complete.obs")
      pValue = cor.test(plotScatter$X,plotScatter$Y, method = input$cor_method2,
                        use = "pairwise.complete.obs")$p.value
      p <- ggplot(plotScatter) +
        geom_point(aes(x = X, y = Y), color = "#DC3535") +
        xlab(input$X) +
        ylab(input$Y) +
        ggtitle(paste0(input$X, " vs ", input$Y),
                subtitle = paste0("Corr. coeff = ", round(corrValue,3), ", p-value = ", round(pValue,3))) +
        theme_minimal() +
        theme(plot.title = element_text(hjust = 0.5,
                                        face = "bold",
                                        size = 24),
              plot.subtitle = element_text(hjust = 0.5,
                                           size = 18,
                                           face = "italic"),
              axis.text = element_text(size = 15),
              axis.title = element_text(size = 18))
      
      return(p)
      
      
    })
  }) #observeEvent
  
  
  #****************************************************************************#
  # Start from PLINK files
  #****************************************************************************#
  
  observeEvent(input$startAnalysis, {
    
    showModal(modalDialog(title = h4(strong("Calculating PRS..."),
                                     align = "center"), 
                          footer = NULL,
                          h5("This might take a while. Please be patient.", 
                             align = "center")))
    #bfile
    bfile <- reactive({
      req(input$bfile)
      bfile <- as.character(parseFilePaths(volumes, input$bfile)$datapath)
      return(bfile)
    })

    
    # Select traits
    traits_selected <- eventReactive(input$startAnalysis,{
      if (input$all_traits == TRUE){
        traits_selected <- Manifest_env$Traits_PGS
      }
      if (input$all_traits == FALSE){
        traits_selected <- input$traits_input
      }
      
      return(traits_selected)
    })
	
	 # Select Models
    modelName <- eventReactive(input$startAnalysis,{
      req(input$selectedModel)
      return(input$selectedModel)
    })
    
    # Path to data
    path <- reactive({
      req(traits_selected())
      req(modelName())
      req(bfile())
      path <- str_remove(bfile(), ".bed")
      path <- str_remove(path, ".bim")
      path <- str_remove(path, ".fam")
      return(path)
    })
    
    # Cohort name
    cohortName <- reactive({
      req(path())
      cohortName <- str_remove(path(), ".*/")
      
      return(cohortName)
    })
    
    
    # Get PRS results
    PRS_result <- reactive({
      req(cohortName())
      req(modelName())
      
      for (t in traits_selected()){
          predPRS(bfile = wslPath(path()), 
                  Trait = t,
                  Model = modelName(),
                  OverlapSNPsOnly=TRUE,
                  Force = TRUE)

      }
      
      PRS_result <-  collect_all_PRS(cohort = cohortName(),
                                     Model = modelName())
      
      if (modelName() != "bayesr-shrink"){
        colnames(PRS_result) <- str_remove(colnames(PRS_result), paste0("_",modelName()))
      } else{
        colnames(PRS_result) <- str_remove(colnames(PRS_result), "_bayesr.shrink")
        colnames(PRS_result) <- str_remove(colnames(PRS_result), "_lasso.sparse")
      }
      
      return(PRS_result)
    })
    
    
    # Go the next step
    observeEvent(if (length(PRS_result()) > 0){input$startAnalysis}, {
      
      removeModal()
      
      # Success message
      sendSweetAlert(
        session = session,
        title = "Success!",
        text = "PGS successfully calculated!",
        type = "success")
      
      # Go to next tab
      updateTabsetPanel(session, "navbar",
                        selected = "output_panel")
      
      # Show next tab
      showTab("navbar", target = "output_panel")
      
    })
    
    # Output table
    output$PRS_table <- DT::renderDataTable({
      return(PRS_result())
    }, server=TRUE,
    options = list(pageLength = 10), rownames= TRUE)
    
    
    #download table of meta data
    output$downloadPRS <- downloadHandler(
      filename = "PRS_results.csv",
      content = function(file){
        #write.csv(PRS_result(), file)
		write.table(PRS_result(),file,col.names = NA,row.names = TRUE,sep = ",",quote = FALSE)
      }
    )
	
	#download table of meta data
    output$downloadPRStsv <- downloadHandler(
      filename = "PRS_results.tsv",
      content = function(file){
        #write.csv(PRS_result(), file)
		write.table(PRS_result(),file,col.names = NA,row.names = TRUE,sep = "\t",quote = FALSE)
      }
    )

    # Heatmap
    output$heatmap_plot <- renderPlot({
      req(input$cor_method)
      req(input$link_method)
      
      # Calculate correlations
      corrDF <- as.data.frame(correlate(PRS_result(), diagonal = 1, method = input$cor_method))
      rownames(corrDF) <- corrDF$term
      corrDF <- corrDF[,-1]
      
      # Format data for plotting
      plotCor <- gather(corrDF)
      plotCor$key1 <- rep(rownames(corrDF), ncol(corrDF))
      
      # Perform clustering to get sample order
      model <- hclust(as.dist(1-abs(corrDF)), input$link_method)
      order <- model$labels[model$order]
      plotCor$key <- factor(plotCor$key, levels = order)
      plotCor$key1 <- factor(plotCor$key1, levels = order)
      
      # Main correlation plot
      main <- ggplot(plotCor) +
        geom_tile(aes(x = key, y = key1, fill = value)) +
        scale_fill_gradient2(low = "#000072", mid = "white", high = "red", midpoint = 0,
                             limits = c(-1,1)) +
        xlab(NULL) +
        ylab(NULL) +
        labs(fill = paste0(str_to_title(input$cor_method),"\nCorrelation"))+
        theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 15),
              axis.text.y = element_text(size = 15))
      
      # Dendrogram
      dendroPlot <- ggplot() +
        geom_tile(data = plotCor, aes(x = as.numeric(key), y = 1), fill = "white", alpha = 0) +
        geom_dendro(model,xlim = c(1,length(unique(plotCor$key)))) +
        theme_void() +
        theme(legend.position = "none") 
      
      # Combine plots
      p <- dendroPlot + main +
        plot_layout(nrow = 2, ncol = 1,
                    heights = c(1,6))
      
      # Return output
      return(p)
      
    })
    
    #x-axis
    output$ui_X <- renderUI({
      selectInput(inputId = "X",
                  label = "X-axis",
                  choices = colnames(PRS_result()),
                  selected = colnames(PRS_result())[1])
    })
    
    # y-axis
    output$ui_Y <- renderUI({
      selectInput(inputId = "Y",
                  label = "Y-axis",
                  choices = colnames(PRS_result()),
                  selected = colnames(PRS_result())[2])
      
    })
    
    # Correlation plot
    output$correlation_plot <- renderPlot({
      req(input$cor_method2)
      req(input$X)
      req(input$Y)
      
      plotScatter <- data.frame(X = PRS_result()[,input$X],
                                Y = PRS_result()[,input$Y])
      
      corrValue = cor(plotScatter$X,plotScatter$Y, method = input$cor_method2,
                      use = "pairwise.complete.obs")
      pValue = cor.test(plotScatter$X,plotScatter$Y, method = input$cor_method2,
                        use = "pairwise.complete.obs")$p.value
      p <- ggplot(plotScatter) +
        geom_point(aes(x = X, y = Y), color = "#DC3535") +
        xlab(input$X) +
        ylab(input$Y) +
        ggtitle(paste0(input$X, " vs ", input$Y),
                subtitle = paste0("Corr. coeff = ", round(corrValue,3), ", p-value = ", round(pValue,3))) +
        theme_minimal() +
        theme(plot.title = element_text(hjust = 0.5,
                                        face = "bold",
                                        size = 24),
              plot.subtitle = element_text(hjust = 0.5,
                                           size = 18,
                                           face = "italic"),
              axis.text = element_text(size = 15),
              axis.title = element_text(size = 18))
      
      return(p)
      
      
    })
    
  }) #end observeEvent startAnalysis
  
  
  
  #****************************************************************************#
  # Add PGS Model
  #****************************************************************************#
  
  # Output table
  output$Manifest_table <- DT::renderDataTable({
    outputTable <- v$Manifest[,c("short", "n", "year", "trait", "DOI", 
                                 "genomeBuild", "traitType")]
    colnames(outputTable) <- c("Name", "N", "Year", "Description", "DOI",
                               "Genome Build", "Type")
    return(outputTable)
  }, server=TRUE,
  options = list(pageLength = 15), rownames= FALSE)
  
  
  # Check whether GWAS can be added
  status_addGWAS <- eventReactive(input$addGWAS_button,{
    status <- TRUE
    if (input$GWAS_name %in% Manifest_env$Traits){
      status <- "Trait name already exists, please select a different name"
    }
    if(is.integer(input$summary)){
      status <- "No file selected!"
    }
    if(input$GWAS_name == ""){
      status <- "Please give the PGS model a name!"
    }
    
    return(status)
  })
  
  #Info panel
  observeEvent(if (status_addGWAS() != TRUE){input$addGWAS_button},  {
    sendSweetAlert(
      session = session,
      title = "Error",
      text = status_addGWAS(),
      type = "error"
    )
  })
  
  # Add GWAS
  observeEvent(if (status_addGWAS() == TRUE){input$addGWAS_button}, {
    
    showModal(modalDialog(title = h4(strong("PGS Model Generation..."),
                                     align = "center"), 
                          footer = NULL,
                          h5("This might take a while. Please be patient.", 
                             align = "center")))
    
    # Get sample size
    sampleSize <- reactive({
      summaryFile <- as.character(parseFilePaths(volumes, input$summary)$datapath)
      dataObj <- fread(summaryFile)
      sampleSize <- median(dataObj$N)
      return(sampleSize)
    })
    
    # Add GWAS to Manifest
    addGWAStoManifest(short = input$GWAS_name, 
                      n = sampleSize(), 
                      filename = as.character(parseFilePaths(volumes, input$summary)$datapath), 
                      year = input$GWAS_year, 
                      trait = input$GWAS_description, 
                      DOI = input$GWAS_doi, 
                      genomeBuild = input$GWAS_build, 
                      traitType = input$GWAS_CatCont, 
                      rawSNPs = c("?"), 
                      finalModelSNPs = c("?"), 
                      modelRunningTime = c("?"),
                      usedRefSet = c("?"), 
                      processed = c(0), 
                      FORCE = TRUE) 
    
    # Prepare GWAS
    PRSMultiTrait::prepareGWAS(trait = input$GWAS_name)
    
    # PGS Mode generation
    for (m in Manifest_env$Models){
      PRSMultiTrait::calcPGS_LDAK(Trait = input$GWAS_name,
                                  Model = m)
    }
    # Update Manifest
    Manifest_env$Traits <- Manifest_env$Ref_gwas_manifest$short
    Manifest_env$Traits_PRE <- Manifest_env$Traits[Manifest_env$Ref_gwas_manifest$processed == 0]
    Manifest_env$Traits_PGM <- Manifest_env$Traits[Manifest_env$Ref_gwas_manifest$processed == 1]
    Manifest_env$Traits_PGS <- Manifest_env$Traits[Manifest_env$Ref_gwas_manifest$processed == 2]
    v$Manifest <- Manifest_env$Ref_gwas_manifest
    
    # remove message
    removeModal()
    
    
    
  }) #end observeEvent
	
  observeEvent(input$removeGWAS_button, {
    if(length(input$remove_input)>0){
      ask_confirmation(
        session = session,
        inputId = "ConfirmRemove",
        title = "Are you sure?",
        text = paste0("You are about to remove the following PGS Models: ", paste(input$remove_input, collapse = "; ")),
        type = "warning",
        btn_labels = c("Cancel", "Confirm")
      )
    }
    if(length(input$remove_input)==0){
      sendSweetAlert(
        session = session,
        title = "Error",
        text = "Select a trait to be removed!",
        type = "error"
      )
    }
  })
  
  # Remove GWAS
  observeEvent(input$ConfirmRemove,{
    if(input$ConfirmRemove == TRUE){
      print(paste0(input$remove_input, " removed from manifest"))
      
      for (r in input$remove_input){
        removeGWASfromManifest(r, FORCE = TRUE)
      }
    }
    Manifest_env$Traits <- Manifest_env$Ref_gwas_manifest$short
    Manifest_env$Traits_PRE <- Manifest_env$Traits[Manifest_env$Ref_gwas_manifest$processed == 0]
    Manifest_env$Traits_PGM <- Manifest_env$Traits[Manifest_env$Ref_gwas_manifest$processed == 1]
    Manifest_env$Traits_PGS <- Manifest_env$Traits[Manifest_env$Ref_gwas_manifest$processed == 2]
    
    v$Manifest <- Manifest_env$Ref_gwas_manifest

  })
  
  
  output$Manifest_table1 <- DT::renderDataTable({
    outputTable <- v$Manifest[,c("short", "n", "year", "trait", "DOI", 
                                 "genomeBuild", "traitType")]
    colnames(outputTable) <- c("Name", "N", "Year", "Description", "DOI",
                               "Genome Build", "Type")
    return(outputTable)
  }, server=TRUE,
  options = list(pageLength = 15), rownames= FALSE)
  

}

