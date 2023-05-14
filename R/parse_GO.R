#setwd("~/Desktop/SonData/WebDev/netzen/raw_data")

# Parsing Ontology file


#' Title parse Gene Ontology
#'
#'Extract gene ontology from gene ontology annotation file and gene ontology classification file to produce table with GO name, definition and list of genes belong to this GO
#'
#' @param annotation_file a gene annotation file in the gaf format. Download
#' download goa-human.gaf from  http://geneontology.org/gene-associations/goa_human.gaf.gz
#' mouse: http://current.geneontology.org/annotations/mgi.gaf.gz

#' @param gene_ontology_classification_file Gene Ontology Classification Definition in .obo format.
#' download Gene Ontology Classification Definition  http://purl.obolibrary.org/obo/go.obo
#'
#' @param outfile output file in the table with four columns: id,	name, 	namespace, 	genes, where id is GO id, name is the name of GO, namespace: biological process, molecular function,.., genes: list of genes, comma separated
#' @import data.table
#' @return a data frame   with four columns: id,	name, 	namespace, 	genes, where id is GO id, name is the name of GO, namespace: biological process, molecular function,.., genes: list of genes, comma separated
#' @export
#'
#' @examples
#' parse_GO(annotation_file="goa_human.gaf",
#' gene_ontology_classification_file="go.obo",
#' outfile=  "Human_GO_annotation.csv")

parse_GO = function(organism,
                    annotation_file = "goa_human.gaf",
                    gene_ontology_classification_file = "go.obo",
                    outfile =  "Human_GO_annotation.csv")
{
  # parsing annotation file

  con  <- file(annotation_file, open = "r")

  GO_table = read.delim(annotation_file,
                        comment.char = "!",
                        header = FALSE)
  #GO_table = data.frame(gene=GO_table, GO=GO)
  GO_table = GO_table[, c(3, 5)]
  colnames(GO_table) = c("gene", "GO")
  GO_table = as.data.table(GO_table)
  GO_summarized = GO_table[, .N, by = .(gene, GO)]
  GO_list = unique(GO_table$GO)


  GO_definition_filtered = go_def.dataframe[go_def.dataframe$id %in% GO_list, ]
  GO_definition_filtered$def = as.character(GO_definition_filtered$def)

  for (i in c(1:nrow(GO_definition_filtered)))
  {
    GO_id = GO_definition_filtered[i, "id"]
    print(paste(i, GO_id))
    genes = GO_summarized[GO == GO_id, .(gene, N)]
    genes = genes[order(-N)]
    genes  = as.character(as.data.frame(genes)$gene)
    if (is.null(go_def_dict[[GO_id]][["direct_genes"]]))
    {
      go_def_dict[[GO_id]][["direct_genes"]] <<- list()
    }
    go_def_dict[[GO_id]][["direct_genes"]][[organism]] <<- genes
    genes = paste(genes, collapse = ",")
    GO_definition_filtered[i, "genes"] = genes
    GO_definition_filtered[i, "def"] = strsplit(GO_definition_filtered[i, "def"] , '"')[[1]][2]
  }

  for (i in c(1:nrow(GO_definition_filtered)))
  {

    GO_id = GO_definition_filtered[i, "id"]
    print(paste(i, GO_id))
    go_def = go_def_dict[[GO_id]]
    descendants_genes = c()
    descendants_GO = go_def[["descendants"]]
    for (descent in c(GO_id, descendants_GO))
    {
      descent_genes = go_def_dict[[descent]][["direct_genes"]][[organism]]
      descendants_genes = c(descendants_genes, descent_genes)
      descendants_genes = unique(descendants_genes)

    }
    if (is.null(go_def_dict[[GO_id]][["descendants_genes"]]))
    {
      go_def_dict[[GO_id]][["descendants_genes"]] = list()
    }
    go_def_dict[[GO_id]][["descendants_genes"]][[organism]] <<- descendants_genes

  }



  GO_definition_filtered$def  = as.character(GO_definition_filtered$def)

  GO_definition_filtered_def = gsub("(", "_", GO_definition_filtered$def, fixed = TRUE)
  GO_definition_filtered_def = gsub(")", "_", GO_definition_filtered_def, fixed = TRUE)
  GO_definition_filtered_def = gsub("'", " ", GO_definition_filtered_def, fixed = TRUE)
  GO_definition_filtered_def = trimws(GO_definition_filtered_def)
  GO_definition_filtered$def = GO_definition_filtered_def
  GO_definition_filtered$name = gsub("'", " ", GO_definition_filtered$name, fixed = TRUE)

  write.table(
    GO_definition_filtered[, c(1, 2, 3, 5)],
    outfile,
    sep = "\t",
    row.names = FALSE,
    quote = FALSE
  )

  return(GO_definition_filtered[, c(1, 2, 3, 5)])

}
