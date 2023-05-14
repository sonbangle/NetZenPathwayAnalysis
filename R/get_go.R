

#' Title
#'
#' @param go_id Gene Ontology Accession number, such as "GO:0001773"
#' @param organism Species : either mouse or human
#'
#' @return genes a vector of genes in this gene ontology for this organism
#' @export
#'
#' @examples
get_genes_for_go = function(go_id, organism)
{

  genes = go[go$id == go_id, organism]
  genes = as.vector(strsplit(genes,","))
  return(genes)
}


get_gene_ontology = function()
{
  return(gene_ontology)
}

