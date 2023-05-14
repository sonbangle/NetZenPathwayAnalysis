## code to prepare `parse_go_def` dataset goes here
get_do_def_dict = function()
{
  gene_ontology_classification_file = "inst/extdata/go.obo"
  go = read_def(gene_ontology_classification_file = gene_ontology_classification_file)
  go_with_children = get_direct_children(go)
  go_def_dict = get_all_descendants(go_with_children)
  return(go_def_dict)
}

## code to prepare `go_def.dataframe` dataset goes here
get_go_def_data_frame = function()
{
  go_names = names(go_def_dict)
  header = c("id", "name", "namespace", "def")
  go_def_data_frame = matrix(nrow = length(go_names), ncol = length(header))
  go_def_data_frame = as.data.frame(go_def_data_frame)
  colnames(go_def_data_frame) = header
  for (col in header)
  {
    val = lapply(go_def_dict, function(x) {
      return(x[[col]][[1]])
    })
    go_def_data_frame[, col] = unlist(val)
  }
  return(go_def_data_frame)
}

parse_annotation= function()
{
human_go = parse_GO(
  organism = "human",
  annotation_file = "/home/sonle/Downloads/NetZenPathwayAnalysis/inst/extdata/goa_human.gaf",
  gene_ontology_classification_file = "/home/sonle/Downloads/NetZenPathwayAnalysis/inst/extdata/go.obo",
  outfile =  "/home/sonle/Downloads/NetZenPathwayAnalysis/inst/extdata/Human_GO_annotation.csv"
)
mouse_go = parse_GO(
  organism = "mouse",
  annotation_file = "/home/sonle/Downloads/NetZenPathwayAnalysis/inst/extdata/mgi.gaf",
  gene_ontology_classification_file = "/home/sonle/Downloads/NetZenPathwayAnalysis/inst/extdata/go.obo",
  outfile =  "/home/sonle/Downloads/NetZenPathwayAnalysis/inst/extdata/Mouse_GO_annotation.csv"
)

}


get_go_def_with_genes_data_frame = function(organisms = c("human", "mouse"))
{
  go_names = names(go_def_dict)
  header = c("id", "name", "namespace", "def", "mouse", "human")
  go_def_data_frame = matrix(nrow = length(go_names), ncol = length(header))
  go_def_data_frame = as.data.frame(go_def_data_frame)
  colnames(go_def_data_frame) = header
  for (col in header)
  {
    val = lapply(go_def_dict, function(x) {
      return(x[[col]][[1]])
    })
    go_def_data_frame[, col] = unlist(val)
  }
  for (i in c(1:nrow(go_def_data_frame)))
  {
    go_id = go_def_data_frame[i, "id"]
    print(paste(i, go_id))
    for (organism in organisms)
    {
      descendant_genes = go_def_dict[[go_id]][["descendants_genes"]][[organism]]
      descendant_genes = paste(descendant_genes, collapse = ",")
      go_def_data_frame[i, organism] = descendant_genes
    }

  }
  rownames(go_def_data_frame) = go_def_data_frame[, "id"]
  return(go_def_data_frame)
}

go_def_dict = get_do_def_dict()
go_def.dataframe = get_go_def_data_frame()
parse_annotation()
go_def_df_with_genes = get_go_def_with_genes_data_frame()


usethis::use_data(go_def_dict, overwrite = TRUE)
usethis::use_data(go_def.dataframe, overwrite = TRUE)
usethis::use_data(go_def_df_with_genes, overwrite = TRUE)




