# PathwayAnalysisBlauBook

[HOME](https://bigcat-um.github.io/PathwayAnalysisBlauBook/)

## 1. Pathway analysis

**Example A: Pathway visualization**
* Visualizes gene expression data from Lesch Nyhan Disease patient on the Purine metabolism pathway from WikiPathways 
* Dataset: [GSE24345](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE24345)
* Pathway: https://www.wikipathways.org/instance/WP4792
* [R script](https://github.com/BiGCAT-UM/PathwayAnalysisBlauBook/blob/master/PathwayAnalysis/PathwayVisualization.R)

**Example B: Pathway enrichment analysis**
* Identifies affected pathways in dataset
* Dataset: [GSE24345](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE24345)
* Pathway collection: [WikiPathways human pathway collection](https://www.wikipathways.org/index.php/Download_Pathways)
* [R script](https://github.com/BiGCAT-UM/PathwayAnalysisBlauBook/blob/master/PathwayAnalysis/PathwayAnalysis.R)

## 2. Network analysis

**Example A: Network Extension**
* Extends the Purine metabolism pathway from WikiPathways with known drug-target interactions from DrugBank
* Pathway: https://www.wikipathways.org/instance/WP4792
* Drug-target database: DrugBank (https://www.drugbank.ca/)
* [R script](https://github.com/BiGCAT-UM/PathwayAnalysisBlauBook/blob/master/NetworkAnalysis/PathwayExtension.R)

## 3. Linking chemical (biomarker) data with RDF

**Prerequisits: Beginners tutorial on SPARQL**
* Provides basic explanation on RDF, SPARQL and building queries.
* Follow the tutorial [here](https://bigcat-um.github.io/SPARQLTutorialBioSB2019/).

**Example A: Mapping chemical IDs with BridgeDb**

**Example B: Performing SPARQL query with InChIKey**

**Example C: Performing SPARQL query with neutralised InChIKey**

**Example D: Additiona; SPARQL queries for chemical compounds**
