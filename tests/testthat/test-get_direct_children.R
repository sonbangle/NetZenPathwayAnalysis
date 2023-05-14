test_that("get_direct_children works", {
  gene_ontology_classification_file = "/home/sonle/Downloads/NetZenPathwayAnalysis/inst/extdata/go.obo"
  go = read_def(gene_ontology_classification_file =gene_ontology_classification_file)
  go_with_children = get_direct_children(go)
  go_id = "GO:0019882"
  def = as.list(go[[go_id]])
  children = def[["direct_children"]]
  for (child in children)
  {
    print(paste(child, go[[child]][["name"]][[1]]))
  }
  expect_true("GO:0002579" %in% children)


  go_id = "GO:0002474"
  def = as.list(go[[go_id]])
  children = def[["direct_children"]]
  for (child in children)
  {
    print(paste(child, go[[child]][["name"]][[1]]))
  }
  expect_true("GO:0002502" %in% children)

})

