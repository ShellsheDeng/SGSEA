library(shiny)
library(BiocManager)
library(waiter)
library(SGSEA)
library(limma)
library(fgsea)
library(DT)
library(readxl)

# change repository from CRAN to biocconductor
#options(repos = BiocManager::repositories())
#library(httr)
#set_config(use_proxy(url="10.3.100.207",port=8080))
#library(reactome.db)
#library(org.Hs.eg.db)
#library(annotate)

#library(survival)






##################### Define UI  ###################
ui <- fluidPage(

  # Application title
  titlePanel(HTML("<center>Survival-based Gene Set Enrichment Analysis App</center>")),

  # UI layout
  sidebarLayout(

    # Sidebar for guiding steps
    sidebarPanel(
      # NEW: Download Example Dataset Button
      downloadButton("download_example_data", "Download Example Dataset (KIRC)"),
      helpText("Click the button to download an example dataset (KIRC) to understand the expected input format."),

      # NEW: Download Example R Script Button
      downloadButton("download_example_script", "Download Example Script"),
      helpText("Click the button to download an R script that demonstrates how to use the SGSEA package."),

      # step 1 upload gene file
      fileInput(inputId = "upload_file_gene",label=h5("Step 1: Input your gene expression file")),
      helpText("Note: The 1st column must be ID and other columns must be gene expressions in numeric with gene symbols
                   as their column names. Please click on the right panel Gene Data to see if your file uploads correctly or go to next step"),
      radioButtons(inputId = "data_type_gene", label = h5("select file type you are uploading"),
                   choices = c(".csv",".txt",".xlsx"),selected = ".csv"),


      # step 2 upload survival file
      fileInput(inputId = "upload_file_surv",label=h5("Step 2: Input your survival file")),
      helpText("Note: The 1st column must be ID, 2nd column must be time, and 3rd column must be
                   survival status, where the last two columns must be numeric. All columns must have column names.Please click on the right panel Survival Data to see if your file uploads correctly or go to next step"),
      radioButtons(inputId = "data_type_surv", label = h5("select file type you are uploading"),
                   choices = c(".csv",".txt",".xlsx"),selected = character(0)),


      # step 3 filtering
      radioButtons(inputId = "filtering", label = h5("Step 3: Do you need to filter the data? If yes, please click on the right panel Filtering to see if your file filters correctly. Otherwise go to next step"),
                   choices = c("Yes"=1,"No"=2),selected = character(0)),
      # step 4 normalization
      radioButtons(inputId = "normalization", label = h5("Step 4: Do you need to normalize the data? If yes, please click on the right panel Normalization to see if your file normalizes correctly. Otherwise go to next step"),
                   choices = c("Yes"=1,"No"=2),selected=character(0)),



      # Action button to start analysis
      waiter::use_waiter(),
      actionButton(inputId = "gobutton",label="Go!"),
      h5("Please go to SGSEA Results on the right panel")
    ),





    # main panel for output display
    mainPanel(tabsetPanel(type = "tabs",
                          tabPanel("Gene Data",DT::dataTableOutput("output_file_gene")),
                          tabPanel("Survival Data",DT::dataTableOutput("output_file_surv")),
                          tabPanel("Filtering",DT::dataTableOutput("output_filtering1"),textOutput("output_filtering2")),
                          tabPanel("Normalization",DT::dataTableOutput("output_normalization1"),textOutput("output_normalization2")),
                          tabPanel("SGSEA Results",DT::dataTableOutput("output_file_sgsea")),
                          tabPanel("Top10 SGSEA Pathways",plotOutput("output_sgsea_top10",width = "80%"))

  )
  )
  )
)











################ Define server  ##################
server <- function(input, output) {

  options(shiny.maxRequestSize=100*1024^2)

  # NEW: Function to Download Example Dataset (KIRC)
  output$download_example_data <- downloadHandler(
    filename = function() {
      "KIRC_example.csv"
    },
    content = function(file) {
      data("KIRC", package = "SGSEA")
      write.csv(KIRC, file, row.names = FALSE)
    }
  )


  output$download_example_script <- downloadHandler(
    filename = function() {
      "SGSEA_example_script.R"
    },
    content = function(file) {
      script_path <- system.file("scripts", "SGSEA_example_script.R", package = "SGSEA")
      file.copy(script_path, file)
    }
  )



  # step1 gene data output
  upload_file_gene_reac<-reactive({
    if(is.null(input$upload_file_gene)) {return()}
    else{
      getpath_gene <- input$upload_file_gene
      if(input$data_type_gene==".xlsx"){
        gene_data <-readxl::read_xlsx(getpath_gene$datapath)}
      else {
        gene_data<-data.table::fread(getpath_gene$datapath,
                                     header=T,verbose=F,data.table = F)}
    }
    gene_data
  })
  # if not choosing any file, show blank; otherwise, show data table
  output$output_file_gene <- DT::renderDataTable({
    if(is.null(input$upload_file_gene)) {return()}
    else if(sum(sapply(upload_file_gene_reac(), is.numeric)) != ncol(upload_file_gene_reac())-1){
      validate("The 1st column must be ID and other columns must be numeric
       with gene symbols as their column names")}
    else{DT::datatable(upload_file_gene_reac()[1:100,1:10],
                       options = list(lengthMenu = c(5, 30), pageLength = 8))}
  })






  # step2 survival data output
  upload_file_surv_reac<-reactive({
    if(is.null(input$upload_file_surv)) {return()}
    else{
      getpath_surv <- input$upload_file_surv
      if(input$data_type_surv==".xlsx"){
        surv_data <-readxl::read_xlsx(getpath_surv$datapath)}
      else {
        surv_data<-data.table::fread(getpath_surv$datapath,
                                     header=T,verbose=F,data.table = F)}
      return(surv_data)
    }
  })
  # if not choosing any file, show blank; otherwise, show data table
  output$output_file_surv <- DT::renderDataTable({
    if(is.null(input$upload_file_surv)) {return()}
    else{
      if(sum(sapply(upload_file_surv_reac(), is.numeric)) != ncol(upload_file_surv_reac())-1){
        validate("The 1st column must be ID and other columns must be numeric
       with gene symbols as their column names")}
      else{DT::datatable(upload_file_surv_reac(),
                         options = list(lengthMenu = c(5, 30), pageLength = 8))}
    }
  })








  # step3 filtering
  # drop genes having count < (# of samples)/10, column is gene
  filtering_reac<-reactive({
    if(input$filtering == 1) {
      filtering_temp<-upload_file_gene_reac()[,-1]
      criteria<-nrow(filtering_temp)/10
      filtering_temp<-filtering_temp[,colSums(filtering_temp) > criteria]
      # combine ID with normed data
      genes_filtered<-cbind(upload_file_gene_reac()[,1],filtering_temp)
      names(genes_filtered)[1]<-names(upload_file_gene_reac())[1]}
    else{ genes_filtered <- upload_file_gene_reac() }
    return(genes_filtered)
  })
  # if needs filtering, show data
  output$output_filtering1 <- DT::renderDataTable({
    if(is.null(input$filtering)) {return()}
    else if(input$filtering==1){
      DT::datatable(filtering_reac()[1:100,1:10],
                    options = list(lengthMenu = c(5, 30), pageLength = 8))}
  })
  # if dont need filtering, show guidance text
  output$output_filtering2 <- renderText({
    if(is.null(input$filtering)) {return()}
    else if(input$filtering==2){"Please go to Step 4"}
  })








  # step4 normalization
  normalization_reac<-reactive({
    w <- waiter::Waiter$new(html = div(style="color:green;",waiter::spin_3(),
                                       h3("Normalizing the data... This might take a while")))
    w$show()
    on.exit(w$hide())
    Sys.sleep(sample(5,1))
    if(input$normalization == 1) {
      norm_temp<-filtering_reac()[,-1]
      set.seed(123)
      norm_temp<-limma::voom(norm_temp)
      genes_normed <- as.data.frame(norm_temp$E,6)
      # combine ID with normed data
      genes_normed <- cbind(filtering_reac()[,1],genes_normed)
      names(genes_normed)[1]<-names(filtering_reac())[1]}
    else{genes_normed <- filtering_reac() }
    return(genes_normed)
  })
  # if needs normalization, show data
  output$output_normalization1 <- DT::renderDataTable({
    if(is.null(input$normalization)) {return()}
    else if(input$normalization==1){
      round_norm <- round(normalization_reac()[,-1],4)   # rounding displayed result
      DT::datatable(round_norm[1:100,1:10],
                    options = list(lengthMenu = c(5, 30), pageLength = 8, digit=3))}
  })
  # if dont need normalization, show guidance text
  output$output_normalization2 <- renderText({
    if(is.null(input$normalization)) {return()}
    else if(input$normalization==2){"Please click 'GO!' on bottom left panel"}
  })








  # step5 get log hazard ratio
  # merge two genes and survival by the same ID
  combine_reac <- reactive({
    combine_genes_surv<-merge(x=upload_file_surv_reac(),y=normalization_reac(),
                              by=names(upload_file_surv_reac())[1])
    return(combine_genes_surv)
  })


  # computing lhr with progress bar once the user hits go button
  lhr_reac <- eventReactive(input$gobutton,{
    w <- waiter::Waiter$new(html = div(style="color:red;",waiter::spin_3(),
                                       h3("Calculating Log Hazard Ratios... This might take a while")))
    w$show()
    on.exit(w$hide())
    Sys.sleep(sample(5,1))
    set.seed(123)
    lhr_list<-SGSEA::getLHR(normalizedData = combine_reac()[,-c(1:3)],
                            survTime = combine_reac()[,2],survStatus = combine_reac()[,3])
      lhr_list<-na.omit(lhr_list)
      return(lhr_list)
    })







  #step6 get pathways from reactome db with progress bar once the user hits go button

  # using getReactome function from sgsea, cost 3 mins have result table
  getReactome_reac <- eventReactive(input$gobutton,{
    # create a waiter object, add html tags for text information
    w <- waiter::Waiter$new(html = div(style="color:yellow;",waiter::spin_3(),
                                       h3("Loading Reactome Database... This might take a while")))
    w$show()
    on.exit(w$hide())
    Sys.sleep(sample(5,1)) #allows R to temporarily be given very low priority and not to interfere with more important foreground tasks
     #require("org.Hs.eg.db")
     #reactome_data<-SGSEA::getReactome(species = "human")
     #return(reactome_data)
    Dir <- system.file("extdata","spathways.rds", package = "SGSEA")
    reactome_data<-readRDS(file = Dir)
    return(reactome_data)

  })




  # step7 enrichment table
  sgsea_result_reac <- eventReactive(input$gobutton,{
    # create a waiter object, add html tags for text information
    w <- waiter::Waiter$new(html = div(style="color:green;",waiter::spin_3(),
                                       h3("Calculating Enrichment Table... This might take a while")))
    w$show()
    on.exit(w$hide())
    Sys.sleep(sample(5,1))
    set.seed(123)
    sgsea_result <-fgsea::fgsea(pathways = getReactome_reac(),stats = lhr_reac(),
                                minSize  = 5,maxSize  = 500)
    return(sgsea_result)
  })



  # show the results data or re-run if user clicks go button
  output$output_file_sgsea <- DT::renderDataTable({
    if(is.null(input$gobutton)) {return()}
    else{
      lhr_reac()          # progress for calculating lhr
      getReactome_reac()  # progress for loading reactome
      sgsea_result_table <- as.data.frame(sgsea_result_reac()) # progress for calculating sgsea
      rounding_result<-round(sgsea_result_table[,2:6],4)       # rounding displayed result
      sgsea_result_table<-cbind(sgsea_result_table[,1],rounding_result,sgsea_result_table[,7:8])
      names(sgsea_result_table)[1]<- "pathway"
      DT::datatable(sgsea_result_table,filter='top',
                    options = list(lengthMenu = c(5, 30), pageLength = 8))
    }
  })




  # show top10 SGSEA pathways with barcodeplots
  sgsea_top10_reac <- eventReactive(input$gobutton,{
    # create a waiter object, add html tags for text information
    w <- waiter::Waiter$new(html = div(style="color:green;",waiter::spin_3(),
                                       h3("Searching Top 10 and Bottom 10 pathways...")))
    w$show()
    on.exit(w$hide())
    Sys.sleep(sample(5,1))
    getTop10 <- SGSEA::getTop10(sgsea_result_reac(),getReactome_reac(),lhr_reac(),0.15)
    return(getTop10)
  })

  output$output_sgsea_top10 <- renderPlot({
    # if(is.null(input$gobutton)) {return()}
    # else{
      sgsea_top10_reac()
        #fgsea::plotGseaTable(getReactome_reac(),lhr_reac(),sgsea_result_reac(),gseaParam = 0.15)
      # }
  })










}







# Run the application
shinyApp(ui = ui, server = server)
