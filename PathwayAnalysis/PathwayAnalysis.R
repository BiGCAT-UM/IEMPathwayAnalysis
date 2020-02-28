## ---------------------------
##
## Script name: PathwayVisualization.R
## Based on: https://bioconductor.org/packages/release/bioc/vignettes/rWikiPathways/inst/doc/Pathway-Analysis.html
##
## Purpose of script: Pathway enrichment analysis
## Dataset: GSE24345 (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE24345)
## Disease: Lesch Nyhan Disease
## Pathways: WikiPathways human pathway collection
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
## Packages: rWikiPathways_1.4.1, clusterProfiler_3.12.0, dplyr_0.8.3, tidyr_1.0.2
## rstudioapi_0.10, readxl_1.3.1, DOSE_3.10.2, org.Hs.eg.db_3.8.2
##
## ---------------------------

# required R packages
library(rWikiPathways)
library(clusterProfiler)
library(tidyr)
library(dplyr)
library(readxl)
library(DOSE)
library(org.Hs.eg.db)
library(rstudioapi)

# set working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# load and format gene set file for human WikiPathways collection
wp.hs.gmt <- rWikiPathways::downloadPathwayArchive(organism="Homo sapiens", format = "gmt")
wp2gene <- clusterProfiler::read.gmt(wp.hs.gmt)
wp2gene <- wp2gene %>% tidyr::separate(ont, c("name","version","wpid","org"), "%")
wpid2gene <- wp2gene %>% dplyr::select(wpid,gene) #TERM2GENE
wpid2name <- wp2gene %>% dplyr::select(wpid,name) #TERM2NAME

# read in dataset
data <- read_excel("GSE24345.xlsx")

# filte up- and down-regulated genes
up.genes.entrez <- data[data$logFC > 0.26 & data$P.Value < 0.05, 1] 
down.genes.entrez <- data[data$logFC < -0.58 & data$P.Value < 0.05, 1]
changed.genes.entrez <- data[(data$logFC < -0.26 | data$logFC > 0.26) & data$P.Value < 0.05,1]
all.genes.entrez <- unique(data[,1])

# run overrepresentation analysis with clusterProfiler
ewp.up <- clusterProfiler::enricher(
  as.character(down.genes.entrez$Gene.ID),
  universe = as.character(all.genes.entrez$Gene.ID),
  pAdjustMethod = "fdr",
  pvalueCutoff = 0.1,
  TERM2GENE = wpid2gene,
  TERM2NAME = wpid2name)

# list results
head(ewp.up,10)

# visualize results
barplot(ewp.up, showCategory = 20)
