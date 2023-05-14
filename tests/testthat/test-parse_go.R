test_that("parse_go works", {
  human_go =parse_GO(organism ="human", annotation_file="/home/sonle/Downloads/NetZenPathwayAnalysis/inst/extdata/goa_human.gaf",
                      gene_ontology_classification_file="/home/sonle/Downloads/NetZenPathwayAnalysis/inst/extdata/go.obo",
                      outfile=  "/home/sonle/Downloads/NetZenPathwayAnalysis/inst/extdata/Human_GO_annotation.csv")
  print(human_go[1:5,])
  expect_equal(colnames(human_go), c("id", "name", 	"namespace", 	"genes"))
  mouse_go =parse_GO(organism="mouse", annotation_file="/home/sonle/Downloads/NetZenPathwayAnalysis/inst/extdata/mgi.gaf",
                     gene_ontology_classification_file="/home/sonle/Downloads/NetZenPathwayAnalysis/inst/extdata/go.obo",
                     outfile=  "/home/sonle/Downloads/NetZenPathwayAnalysis/inst/extdata/Mouse_GO_annotation.csv")
  print(mouse_go[1:5,])
  expect_equal(colnames(mouse_go), c("id", "name", 	"namespace", 	"genes"))


})
