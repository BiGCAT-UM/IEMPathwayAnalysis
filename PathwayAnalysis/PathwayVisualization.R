## ---------------------------
##
## Script name: PathwayVisualization.R
##
## Purpose of script: Visualize transcriptomics data on WikiPathways pathway
## Dataset: GSE24345 (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE24345)
## Disease: Lesch Nyhan Disease
## Pathway: Purine metabolism pathway (https://www.wikipathways.org/instance/WP4792)
##
## Author: Martina Kutmon
##
## Date Created: 2020-02-28
##
## Copyright (c) Martina Kutmon, 2020
##
## Session info:
## R version 3.6.2 (2019-12-12)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows 10 x64 (build 17763)
## Packages: readxl_1.3.1, rstudioapi_0.10, RColorBrewer_1.1-2, RCy3_2.4.1
##
## ---------------------------

# required R packages
library(rstudioapi)
library(RCy3)
library(readxl)
library(RColorBrewer)

# set working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# read data (subset of large dataset, contains data for measured genes in pathway)
data <- read_excel("GSE24345-selection.xlsx")
data <- as.data.frame(data)

# check connection to Cytoscape (needs to be started and WikiPathways app needs to be installed)
RCy3::cytoscapePing()
RCy3::getAppStatus("wikipathways")

# Open pathway in Cytoscape and load data
RCy3::commandsRun('wikipathways import-as-pathway id=WP4792') 
RCy3::loadTableData(data, data.key.column='GeneID', table.key.column='Ensembl')
toggleGraphicsDetails()

# create intuitive visualization of gene expression data
data.values = c(-1,0,1)
display.brewer.all(length(data.values), colorblindFriendly=TRUE, type="div") # div,qual,seq,all
node.colors <- c(rev(brewer.pal(length(data.values), "RdBu")))
setNodeColorMapping("logFC", data.values, node.colors, default.color = "#FFFFFF", style.name = "WikiPathways")

min.expr = min(data$logFC,na.rm=TRUE)
max.expr = max(data$logFC,na.rm=TRUE)
setNodeBorderWidthMapping("logFC",c(min.expr,max.expr), c(4,4), default.width = 1, style.name="WikiPathways")
setNodeComboOpacityMapping("logFC",c(min.expr,max.expr), c(255,255), default.opacity = 180, style.name="WikiPathways")

# save session and images (png and pdf)
full.path=paste(getwd(),'purine-metabolism-LND',sep='/')
saveSession(filename=full.path) 

full.path=paste(getwd(),'purine-metabolism-LND',sep='/')
exportImage(filename=full.path, type='PDF') #.pdf
exportImage(filename=full.path, type='PNG', zoom=200)
