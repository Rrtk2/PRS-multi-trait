ui <- tagList(
  
  tags$head(tags$style(HTML("
                           .navbar-nav {
                           float: none !important;
                           }
                           .navbar-nav > li:nth-child(4) {
                           float: right;
                           }
                            .navbar-nav > li:nth-child(3) {
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
               
               #  Calculate PGS: Home tab    
               
               ###################################################################
               tabPanel("Home", 
                        value = "input_panel", 
                        icon = icon("fas fa-home"), class = "my_style_1",
                        
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        br(),
                        
                        #******************************************************#
                        # Title and welcome message
                        #******************************************************#
                        fluidRow(
                          column(6, offset = 3,
                                 align = "center", 
                                 style = "background-color:#F5F5F5;",
                                 
                                 br(),
                                 br(),
                                 h1(strong(span(style = "color:#000000", "Welcome to PRS Multi-Trait!"))),
                                 
                                 h5(span(style = "color:#000000", "Get started by uploading your PLINK files *.")),
                                 
                                 br()
                          )
                        ),
                        
                        #******************************************************#
                        # File upload
                        #******************************************************#
                        fluidRow(
                          column(6, offset = 3, 
                                 align = "center", 
                                 style = "background-color:#F5F5F5;",
                                 
                                 shinyFilesButton(id = "bfile", 
                                                  label = "Click here to select .bim; .bed; or .fam file *",
                                                  title = "Please select a file:",
                                                  multiple = FALSE,
                                                  icon = icon("fas fa-mouse-pointer")),
                                 htmlOutput("bfile_status")
                                 
                          )
                          
                        ),
                        
                        #******************************************************#
                        # Start analysis
                        #******************************************************#
                        fluidRow(
                          
                          column(6, offset = 3, 
                                 align = "center", 
                                 style = "background-color:#F5F5F5;",
                                 br(),
                                 
                                 
                                 #Use example data
                                 actionBttn(inputId = "example", 
                                            label = "Example",
                                            style = "jelly",
                                            color = "danger",
                                            size = "md",
                                            icon = icon("refresh")),
                                 
                                 #Start the analysis
                                 actionBttn(inputId = "startAnalysis",
                                            label = "Start",
                                            style = "jelly",
                                            color = "danger",
                                            size = "md",
                                            icon = icon("arrow-right")),
                                 
                                 #Get information
                                 actionBttn(inputId = "infopanel1", 
                                            label = NULL,
                                            color = "danger",
                                            style = "simple",
                                            icon = icon("info")),
                                 
                                 
                                 br(),
                                 br()
                                 
                          )
                        ),
                        
                        #******************************************************#
                        # Select traits
                        #******************************************************#
                        fluidRow(
                          column(6, offset = 3, align = "center",
                                 style = "background-color:#F5F5F5;",
                                 
                                 awesomeCheckbox(inputId = "all_traits",
                                                 label = "Calculate PRS for all available traits",
                                                 value = TRUE,
                                                 status = "danger"),
                                 
                                 conditionalPanel(
                                   condition = "input.all_traits==false",
                                   
                                   uiOutput("traits_input_ui")
                                 )
                          )
                          
                        ),
                        
                        #******************************************************#
                        # Advanced settings
                        #******************************************************#
                        fluidRow(
                          column(6, offset= 3,
                                 align = "center",
                                 style = "background-color:#F5F5F5;",
                                 br(),
                                 dropdownButton(
                                   
                                   tags$h3(strong("Advanced Settings")),
                                   
                                   selectInput(inputId = 'selectedModel',
                                               label = 'Model',
                                               choices = Manifest_env$Models,
                                               selected = "bayesr"),
                                   
                                   materialSwitch(
                                     inputId = "OverlapSNPsOnly",
                                     label = "Overlap SNPs Only",
                                     value = TRUE, 
                                     status = "danger"
                                   ),
                                   
                                   materialSwitch(
                                     inputId = "Force",
                                     label = "Force",
                                     value = TRUE, 
                                     status = "danger"
                                   ),
                                   
                                   circle = FALSE,  label = "Advanced Settings",
                                   icon = icon("gear"), width = "300px",
                                   
                                   tooltip = tooltipOptions(title = "Click to change settings!")
                                 ),
                                 br(),
                                 br(),
                          )
                        ),
                        
                        fluidRow(
                          column(6, offset = 3,
                                 align = "center",
                                 style = "background-color:#F5F5F5;",
                                 span("* You can select either the .bim, .bed, or .fam file. 
                                    However, be aware that all three files should be in the same
                                    folder and share the same name!"),
                                 br(),
                                 br()
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
                                            style = "simple",
                                            color = "warning",
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
                        
                        
                        
               ), # End of home tab
               
               
               
               ###################################################################
               
               #  Outputs
               
               ###################################################################
               
               tabPanel("Output", value = "output_panel", 
                        icon = icon("fas fa-layer-group"),
                        
                        navlistPanel(id = "tabs_output",
                                     
                                     # Output table
                                     tabPanel("Table", value = "PRS_table",
                                              h1(strong("PRS Data Table")),
                                              hr(),
                                              dataTableOutput("PRS_table"),
                                              downloadButton("downloadPRS", 
                                                             "Download Table (csv)"),
                                              downloadButton("downloadPRStsv", 
                                                             "Download Table (tsv)")),
                                     
                                     # Heatmap
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
                                                )
                                                
                                              ),
                                              hr(),
                                              plotOutput("heatmap_plot",
                                                         width = 1000,
                                                         height = 800,
                                                         click = NULL)%>% 
                                                withSpinner(color="red")
                                     ),
                                     
                                     # Correlations
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
                                     
                                     
                                     
                                     
                                     
                        ) # navlist panel
               ), # outputs
               
               ###################################################################
               
               #  Remove PGS model       
               
               ###################################################################
               tabPanel(
                 "Remove PRS Model", 
                 value = "removePGS_panel", 
                 icon = icon("fa-solid fa-square-minus"),
                 
                 sidebarPanel(
                   
                   h1(strong("Remove PGS Model")),
                   hr(),
                   uiOutput("remove_input_ui"),
                   hr(),
                   #start button
                   actionBttn(inputId = "removeGWAS_button", 
                              label = "Remove PRS Model!",
                              style = "simple",
                              color = "danger",
                              size = "md",
                              icon = icon("fa-solid fa-square-minus"))
                   
                 ),
                 
                 mainPanel(
                   h1(strong("Available Models")),
                   hr(),
                   dataTableOutput("Manifest_table1")
                 )
                 
                 
                 
               ), # End Remove PGS Model
               
               ###################################################################
               
               #  Add PGS model       
               
               ###################################################################
               tabPanel(
                 "Add PRS Model", 
                 value = "addPGS_panel", 
                 icon = icon("fa-solid fa-square-plus"),
                 
                 # Side panel
                 sidebarPanel(
                   
                   h1(strong("Add PGS Model")),
                   hr(),
                   #Upload summary statistics
                   h5(strong("Upload Summary Statistics")),
                   shinyFilesButton(id = "summary", 
                                    label = "Click here to select summary statistics file",
                                    title = "Please select a file:",
                                    multiple = FALSE,
                                    icon = icon("fas fa-mouse-pointer")),
                   htmlOutput("summaryfile_status"),
                   br(),
                   br(),
                   
                   textInput(inputId = "GWAS_name",
                             label = "Name"),
                   
                   textInput(inputId = "GWAS_year",
                             label = "Year"),
                   
                   textInput(inputId = "GWAS_description",
                             label = "Description"),
                   
                   textInput(inputId = "GWAS_doi",
                             label = "DOI"),
                   
                   prettyRadioButtons(
                     inputId = "GWAS_build",
                     label = "Genome Build", 
                     choices = c("GRCh38/hg38", "GRCh37/hg19", "GRCh36/hg18"),
                     selected = "GRCh37/hg19"
                   ),
                   
                   prettyRadioButtons(
                     inputId = "GWAS_CatCont",
                     label = "Categorical or Continous Variable", 
                     choices = c("CAT", "CONT")
                   ),
                   hr(),
                   #start button
                   actionBttn(inputId = "addGWAS_button", 
                              label = "Add PRS Model!",
                              style = "simple",
                              color = "danger",
                              size = "md",
                              icon = icon("fa-solid fa-square-plus"))
                   
                 ),
                 
                 # Main panel
                 mainPanel(
                   h1(strong("Available Models")),
                   hr(),
                   dataTableOutput("Manifest_table")
                 )
                 
                 
                 
               ) # End Add PGS Model
               
               
    ) #navbarpage
  ) # fluidpage
) # taglist
