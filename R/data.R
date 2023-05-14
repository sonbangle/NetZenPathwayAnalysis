#'Gene Ontology definition database
#'
#'
#' @format ## `go_def_dict`
#' An environment  of gene ontology definition, each element of the environment is an instance of gene ontology definition class, an environment containing fields.
#' Each field is a list. The minimal list of fields:
#' def: definition of gene ontology. For example: The process in which an antigen-presenting cell expresses antigen (peptide or lipid) on its cell surface in association with an MHC protein complex
#' name: short name of the ontology. Example:  "antigen processing and presentation"
#' direct_children: the sub gene ontologies that are direct children of this ontology. For example, "GO:0002468", "GO:0002450"
#' parents: the parental gene ontology of this gene ontology. For example. For the gene ontology  GO:0019882 - "antigen processing and presentation", the parental ontology is  "GO:0002376", immune system process
#' id: the id of gene ontology. Example:  GO:0019882
#' descendants_genes: The genes that belong to this gene ontology and all sub ontologies. It's a list. Each element of list is organism that the genes belong. Currently there are two organisms only: mouse and human.
#' For example go_def_dict[["GO:0019882"]][["descendants_genes"]]["human"] will give the list of all genes belonging to the antigen processing and presentation and all the sub ontology
#' direct genes: The genes that directly belong to this gene ontology, excluding sub gene ontology. It's a list. Each element of list is organism that the genes belong. Currently there are two organisms only: mouse and human.
#' For example go_def_dict[["GO:0019882"]][["direct_genes"]]["human"] will give the list of all genes belonging to the antigen processing and presentation.
#' namespace: The category of the gene ontolgy. For example: biological_process.
#' descendant: all the sub gene ontologies of this ontologies, not only direct children but also all children in the tree family.
"go_def_dict"



#' Gene ontology definition data frame
#'
#' @format ## `go_def.dataframe`
#' A data frame with  and 4 columns:
#' \describe{
#'   \item{id}{gene ontology id, such as  GO:0031330}
#'   \item{name}{name of gene ontology. Example: negative regulation of cellular catabolic process biological_process}
#'   \item{namespace}{The category of the gene ontolgy. For example: biological_process.}
#'   \item{def}{The definition  of the gene ontolgy. For example: The process in which an antigen-presenting cell expresses antigen (peptide or lipid) on its cell surface in association with an MHC protein complex.}
#' }
"go_def.dataframe"



#' Gene ontology definition data frame with descendant genes belonging to this gene ontology
#'
#' @format ## `go_def.dataframe`
#' A data frame with  and 6 columns:
#' \describe{
#'   \item{id}{gene ontology id, such as  GO:0031330}
#'   \item{name}{name of gene ontology. Example: negative regulation of cellular catabolic process biological_process}
#'   \item{namespace}{The category of the gene ontolgy. For example: biological_process.}
#'   \item{def}{The definition  of the gene ontolgy. For example: The process in which an antigen-presenting cell expresses antigen (peptide or lipid) on its cell surface in association with an MHC protein complex.}
#'   \item{human}{The human genes that belong to this gene ontology and all sub ontologies.}
#'   \item{mouse}{The mouse genes that belong to this gene ontology and all sub ontologies.}
#' }
"go_def_df_with_genes"
