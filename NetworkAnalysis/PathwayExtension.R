## ---------------------------
##
## Script name: PathwayExtension.R
##
## Purpose of script: Extension of pathways with drug-target and pathway information
## Pathway: Purine metabolism pathway (https://www.wikipathways.org/index.php/Pathway:WP4792)
##
## Author: Martina Kutmon
##
## Date Created: 2020-03-02
##
## Copyright (c) Martina Kutmon, 2020
##
## Session info:
## R version 3.6.3 (2020-02-29)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows 10 x64 (build 17763)
## Packages: readxl_1.3.1, rstudioapi_0.11, RColorBrewer_1.1-2, RCy3_2.6.3
##
## Cytoscape version 3.7.2, WikiPathways app version 3.3.7, CyTargetLinker version 4.1.0
##
## ---------------------------
# install.packages("BiocManager")
# BiocManager::install(c("rstudioapi","RCy3","readxl","RColorBrewer"))

# required R packages
library(rstudioapi)
library(RCy3)
library(RColorBrewer)

# set working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# check connection to Cytoscape (needs to be started and WikiPathways app needs to be installed)
RCy3::cytoscapePing()
RCy3::getAppStatus("wikipathways")
RCy3::getAppStatus("cytargetlinker")

# Open pathway in Cytoscape and load data
RCy3::commandsRun('wikipathways import-as-network id=WP4792') 
toggleGraphicsDetails()
renameNetwork("Purine pathway + drug-target info")
dnet <- getNetworkSuid()
#cloneNetwork()
#renameNetwork("Purine pathway + pathway info")
#pNet <- getNetworkSuid()

copyVisualStyle("WikiPathways-As-Network", "WPDrugExtension")

# Extend pathway with drug-target information
drugbank <- file.path(getwd(), "linksets", "drugbank-5.1.0.xgmml")
CTLextend.cmd = paste('cytargetlinker extend idAttribute="Ensembl" linkSetFiles="', drugbank, '" network=SUID:',dnet,' direction=SOURCES', sep="")
commandsRun(CTLextend.cmd)
layoutNetwork()

# Create visual style
setVisualStyle("WPDrugExtension")
setNodeColorMapping("CTL.Type", c("initial", "drug"), c("#FFFFFF","#7FBF7B"), "d", "#FFFFFF", "WPDrugExtension")

drug.node.table <- getTableColumns('node',c('SUID','CTL.Type','Type'))
proteins <- drug.node.table[drug.node.table$Type=="Protein" & !is.na(drug.node.table$Type),1]
drugs <- drug.node.table[drug.node.table$CTL.Type=="drug",1]

clearSelection()
selectNodes(drugs,'SUID')
fn <- selectFirstNeighbors()
selected <- fn$nodes
targets <- fn$nodes[!(fn$nodes %in% drugs)]
setNodeShapeBypass(drugs,"diamond")
setNodeColorBypass(targets, "#fc8d59")
setNodeShapeBypass(proteins, "round_rectangle")
setNodeFontSizeBypass(targets, 20)
clearSelection()

# save session and images (png and pdf)
full.path=paste(getwd(),'purine-pathway-drug-extension',sep='/')
saveSession(filename=full.path) 
exportImage(filename=full.path, type='PDF') #.pdf
exportImage(filename=full.path, type='PNG', zoom=500)
