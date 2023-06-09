% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parse_GO.R
\name{parse_GO}
\alias{parse_GO}
\title{Title parse Gene Ontology}
\usage{
parse_GO(
  organism,
  annotation_file = "goa_human.gaf",
  gene_ontology_classification_file = "go.obo",
  outfile = "Human_GO_annotation.csv"
)
}
\arguments{
\item{annotation_file}{a gene annotation file in the gaf format. Download
download goa-human.gaf from  http://geneontology.org/gene-associations/goa_human.gaf.gz
mouse: http://current.geneontology.org/annotations/mgi.gaf.gz}

\item{gene_ontology_classification_file}{Gene Ontology Classification Definition in .obo format.
download Gene Ontology Classification Definition  http://purl.obolibrary.org/obo/go.obo}

\item{outfile}{output file in the table with four columns: id,    name,     namespace,     genes, where id is GO id, name is the name of GO, namespace: biological process, molecular function,.., genes: list of genes, comma separated}
}
\value{
a data frame   with four columns: id,	name, 	namespace, 	genes, where id is GO id, name is the name of GO, namespace: biological process, molecular function,.., genes: list of genes, comma separated
}
\description{
Extract gene ontology from gene ontology annotation file and gene ontology classification file to produce table with GO name, definition and list of genes belong to this GO
}
\examples{
parse_GO(annotation_file="goa_human.gaf",
gene_ontology_classification_file="go.obo",
outfile=  "Human_GO_annotation.csv")
}
