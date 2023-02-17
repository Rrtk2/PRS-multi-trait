ui <- tagList(
  
  tags$head(tags$style(HTML("
                           .navbar-nav {
                           float: none !important;
                           }
                           .navbar-nav > li:nth-child(6) {
                           float: right;
                           }
                           .my_style_1{ 
                             background-image: url(Background1.jpg);
                           }
                           .my_style_1 { margin-top: -20px; }
                           
                           .my_style_1 { width: 100%; }
                           
                           .container-fluid { padding-left: 0; padding-right: 0; }
                           
                           .my_style_1 { position: absolute; top: 0; }
                           
                           "))),
  
  
  fluidPage(
    
    useSweetAlert(),
    
    navbarPage(title = "I PRS Multi-Trait", id = "navbar",
               
			   ###################################################################
               #  prepareGWAS                                                  
               ###################################################################
				tabPanel(
					"Prepare GWAS", 
					value = "GWAS_panel", 
					icon = icon("fas fa-home"), 
					class = "my_style_1",

					br(),
					br(),
					br(),
					br(),
					br(),
					br(),
					
					fluidRow(
                          
                          column(4, offset = 4, 
                                 align = "center", 
                                 style = "background-color:#FFFFFF;",
                                 
                                 br(),
                                 
                                 h1(strong(span(style = "color:#000000", "Prepare GWAS!"))),
                                 
                                 h2(span(style = "color:#FF0000", "This page should be hidden in some menu.")),
                                 br(),
                                 
                                 
                                 
                                 br(),
                                 br()
                          )
                        ),
					
					fluidRow(

						column(
							4, 
							offset = 4, 
							align = "center", 
							style = "background-color:#FFFFFF;",

							#Start the analysis
							actionBttn(
								inputId = "startGWASprep",
								label = "Start",
								style = "jelly",
								color = "primary",
								icon = icon("arrow-right")
							),



							br(),
							br(),

						)
					),

					fluidRow(
						column(4, 
							offset = 4, 
							align = "center",
							style = "background-color:#FFFFFF;",

							br(),
																   
							awesomeCheckbox(
								inputId = "GWAS_traits_input",
								label = "Select all GWAS traits to be prepared",
								value = TRUE,
								status = "success"
							),

							conditionalPanel(
								condition = "input.GWAS_traits_input==false",

								selectInput(
									inputId = "GWAS_traits_input_dropdown",
									label = "Select GWASes to be prepared",
									choices = Manifest_env$Traits_PRE,
									multiple = TRUE,
									#status = "danger" @RRR Need something like this!
								),
							),

						)

					),




					br(),
					br(),
					br(),
					br(),
					br(),
					br(),
					br(),
					br(),
					br(),
					br(),
					br(),
					br(),
					br(),
					br(),
					br(),
					br()

											

				), # End prepareGWAS
               
			    ###################################################################
               #  Generate PGM                                                   
               ###################################################################
               tabPanel("Generate PGM", 
                        value = "PGM_panel", 
                        icon = icon("fas fa-home"), class = "my_style_1",
                        
                       
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        
                        fluidRow(
                          
                          column(4, offset = 4, 
                                 align = "center", 
                                 style = "background-color:#FFFFFF;",
                                 
                                 br(),
                                 
                                 h1(strong(span(style = "color:#000000", "Generate PGM"))),
                                 h2(span(style = "color:#FF0000", "This page should be hidden in some menu.")),
                              
                                 
                                 br(),
                                 

                                 br(),
                                 br()
                          )
                        ),
                        
                        
                        fluidRow(
                          
                          column(4, offset = 4, 
                                 align = "center", 
                                 style = "background-color:#FFFFFF;",
                                 
                              
                                 #Start the analysis
                                 actionBttn(inputId = "startPGM",
                                            label = "Start",
                                            style = "jelly",
                                            color = "primary",
                                            icon = icon("arrow-right")),
                                 
                                 
                                 
                                 br(),
                                 br(),
                                 
                          )
                        ),
                        
                        fluidRow(
                          column(4, offset = 4, align = "center",
                                 style = "background-color:#FFFFFF;",
                                 
                                 br(),
                                  
							awesomeCheckbox(
								inputId = "PGM_traits_input",
								label = "Select all traits to calculate PGM for",
								value = TRUE,
								status = "success"
							),

							conditionalPanel(
								condition = "input.PGM_traits_input==false",

								selectInput(
									inputId = "PGM_traits_input_dropdown",
									label = "Select traits to calculate PGM for",
									choices = Manifest_env$Traits_PGM,
									multiple = TRUE,
									#status = "danger" @RRR Need something like this!
								),
							),
								  
                                  
                                 
                          )
                          
                        ),
						
						fluidRow(
                          column(4, offset = 4, align = "center",
                                 style = "background-color:#FFFFFF;",
                                 
                                 br(),
                                 awesomeCheckbox(inputId = "PGM_all_models",
                                                 label = "Calculate PGM using all models",
                                                 value = TRUE,
                                                 status = "success"),
                                 
                                 conditionalPanel(
                                   condition = "input.PGM_all_models==false",
                                   
                                   selectInput(inputId = "PGM_models_input",
                                               label = "Select models",
                                               choices = Manifest_env$Models,
                                               multiple = TRUE),
                                 )
                          )
                          
                        ),
						
                       
                    
                        
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br()
                        
                        
                       
                        
               ), # end Generate PGM 
               
               ###################################################################
               #  Data selection                                                   
               ###################################################################
               tabPanel("Data accession", 
                        value = "input_panel", 
                        icon = icon("fas fa-home"), class = "my_style_1",
                        
                        

                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        
                        fluidRow(
                          
                          column(4, offset = 4, 
                                 align = "center", 
                                 style = "background-color:#FFFFFF;",
                                 
                                 br(),
                                 
                                 h1(strong(span(style = "color:#000000", "Welcome to PRS Multi-Trait!"))),
                                 
                                 h5(span(style = "color:#000000", "Get started by uploading your PLINK files.")),
                                 
                                 br(),
                                 
                                 
                                 #Upload CELs
                                 shinyFilesButton(id = "bfile", 
                                                  label = "Click here to select data file",
                                                  title = "Please select a file:",
                                                  multiple = FALSE,
                                                  icon = icon("fas fa-mouse-pointer")),
                                 br(),
                                 br()
                          )
                        ),
                        
                        
                        fluidRow(
                          
                          column(4, offset = 4, 
                                 align = "center", 
                                 style = "background-color:#FFFFFF;",
                                 
                                 #Use example data
                                 actionBttn(inputId = "example", 
                                            label = "Example",
                                            style = "jelly",
                                            color = "default",
                                            icon = icon("fas fa-mouse-pointer")),
                                 
                                 #Start the analysis
                                 actionBttn(inputId = "startAnalysis",
                                            label = "Start",
                                            style = "jelly",
                                            color = "primary",
                                            icon = icon("arrow-right")),
                                 
                                 
                                 
                                 br(),
                                 br(),
                                 
                          )
                        ),
                        
                        fluidRow(
                          column(4, offset = 4, align = "center",
                                 style = "background-color:#FFFFFF;",
                                 
                                 br(),
                                 awesomeCheckbox(inputId = "all_traits",
                                                 label = "Calculate PRS for all available traits",
                                                 value = TRUE,
                                                 status = "danger"),
                                 
                                 conditionalPanel(
                                   condition = "input.all_traits==false",
                                   
                                   selectInput(inputId = "traits_input",
                                               label = "Select traits",
                                               choices = Manifest_env$Traits_PGS,
                                               multiple = TRUE),
                                 )
                          )
                          
                        ),
						
						 fluidRow(
                          column(4, offset = 4, align = "center",
                                 style = "background-color:#FFFFFF;",
                                 
                                 br(),
                                 awesomeCheckbox(inputId = "all_models",
                                                 label = "Calculate PRS using default model (bayesr)",
                                                 value = TRUE,
                                                 status = "success"),
                                 
                                 conditionalPanel(
                                   condition = "input.all_models==false",
                                   
                                   selectInput(inputId = "models_input",
                                               label = "Select models",
                                               choices = Manifest_env$Models,
                                               multiple = TRUE),
                                 )
                          )
                          
                        ),
                        
                        fluidRow(
                          column(4, offset = 4, align = "center",
                                 style = "background-color:#FFFFFF;",
                                 hr(),
                                 #column(4, align = "center",
                                       #img(src = "MHENS_logo.png", width = "100%")),
                                 column(4, align = "center",
                                        img(src = "UM_logo.png", width = "100%")),
                                 column(4, align = "center",
                                        img(src = "EXETER_logo.png", width = "100%")),
                                 
                          )
                          
                        ),
                        
                        
                        #********************************************************#
                        #   Continue with saved data
                        #********************************************************#
                        
                        fluidRow(
                          column(4, offset = 4, align = "center",
                                 br(),
                                 
                                 #Continue with saved data
                                 actionBttn(inputId = "continue", 
                                            label = "Continue with saved data",
                                            style = "jelly",
                                            color = "default",
                                            icon = icon("fas fa-sign-in-alt"))
                          )
                          
                        ),
                        
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br()
                        
                        
                        #********************************************************#
                        
               ), #Data selection
			   
			   
               ###################################################################
               #  Outputs
               ###################################################################
               
               tabPanel("Output", value = "output_panel", 
                        icon = icon("fas fa-layer-group"),
                        
                        navlistPanel(id = "tabs_output",
                                     tabPanel("Table", value = "PRS_table",
                                              h1(strong("PRS Data Table")),
                                              hr(),
                                              dataTableOutput("PRS_table"),
                                              downloadButton("downloadPRS", 
                                                             "Download Table (csv)"),
											  downloadButton("downloadPRStsv", 
                                                             "Download Table (tsv)")),
                                     
                                     tabPanel("Heatmap", value = "PRS_heatmap",
                                              fluidRow(
                                                column(3,
                                                       selectInput(inputId = "cor_method",
                                                                   label = "Correlation Method",
                                                                   choices = c("pearson",
                                                                               "spearman",
                                                                               "kendall"),
                                                                   selected = "pearson")
                                                       ),
                                                column(3,
                                                       selectInput(inputId = "link_method",
                                                                   label = "Linkage Method",
                                                                   choices = c("ward.D2",
                                                                               "ward.D",
                                                                               "average",
                                                                               "complete",
                                                                               "centroid",
                                                                               "median", 
                                                                               "mcquitty"),
                                                                   selected = "ward.D2")
                                                ),
                                                
                                              ),
                                              hr(),
                                              plotOutput("heatmap_plot",
                                                         width = 1000,
                                                         height = 800,
                                                         click = NULL)%>% 
                                                withSpinner(color="red")
                                              ),
                                     tabPanel("Correlations", value = "PRS_correlation",
                                              fluidRow(
                                                column(3,
                                                       selectInput(inputId = "cor_method2",
                                                                   label = "Correlation Method",
                                                                   choices = c("pearson",
                                                                               "spearman",
                                                                               "kendall"),
                                                                   selected = "pearson")
                                                ),
                                                column(3,
                                                       uiOutput("ui_X")
                                                ),
                                                column(3,
                                                       uiOutput("ui_Y")
                                                )
                                                
                                              ),
                                              hr(),
                                              plotOutput("correlation_plot",
                                                         width = 1000,
                                                         height = 600,
                                                         click = NULL)%>% 
                                                withSpinner(color="red")
                                     )
                                     
                                     
                                     
                                     
                                     
                        )
               ) # outputs
    ) #navbarpage
  ) # fluidpage
) # taglist
