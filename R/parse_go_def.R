read_def = function(gene_ontology_classification_file = "inst/extdata/go.obo")
{
  con  <- file(gene_ontology_classification_file, open = "r")

  go = new.env()
  go_def = NULL
  while (length(oneLine <-
                readLines(con, n = 1, warn = FALSE)) > 0) {
    if (nchar(oneLine) == 0)
    {
      next
    }
    if (startsWith(oneLine, "[Typedef]"))
    {
      break # skip the last lines of file
    }

    if (startsWith(oneLine, "[Term]"))
    {
      if (!(is.null(go_def)))
      {
        old_id = go_def[["id"]]
        go[[old_id]] = go_def
      }
      go_def = new.env() # new def
      next
    }

    if (!is.null(go_def))
    {
      if (startsWith(oneLine, "id: GO"))
      {
        go_id = substr(oneLine, nchar("id:") + 2, nchar(oneLine))
        go_def[["id"]] = go_id
        print(go_id)


      } else
      {
        sep_pos = regexec('\\:', oneLine)[[1]]
        if (sep_pos > 0)
        {
          field = substr(oneLine, 1, sep_pos - 1)
          value =  substr(oneLine, sep_pos + 2, nchar(oneLine))
          if (is.null(go_def[[field]]))
          {
            go_def[[field]] = list(value)
          }
          else{
            go_def[[field]] = c(go_def[[field]] , value)
          }
        }
      }
    }
  }
  # add the last definition:
  old_id = go_def[["id"]]
  go[[old_id]] = go_def
  close(con)
  return(go)

}

get_fields_name = function(go)
{
  fields_vector = c()
  defs = ls(go)
  for (def in defs)
  {
    go_def = go[[def]]
    fields = names(go_def)
    fields_vector = c(fields_vector, fields)
    fields_vector = unique(fields_vector)

  }
  return((fields_vector))
}

get_relationship_type = function(go)
{
  defs = ls(go)
  relationship = c()
  for (def in defs)
  {
    go_def = go[[def]]
    rels = go_def[["relationship"]]
    if (!is.null(rels))
    {
      for (rel in rels)
      {
        print(rel)
        rel = strsplit(rel, ":")[[1]][[1]]
        relationship = c(relationship, rel)
        relationship = unique(relationship)
      }
    }

  }
  return(relationship)
}

get_direct_children = function(go)
{
  for (go_id in names(go))
  {
    go_def = go[[go_id]]
    go_parents = go_def[["is_a"]]
    if (!(is.null(go_parents)))
    {
      parents = list()
      for (parent in go_parents)
      {
        parent = strsplit(parent, "!")[[1]][[1]]
        parent = substr(parent, 1, nchar(parent) - 1)

        if (is.null(go[[parent]][["direct_children"]]))
        {
          go[[parent]][["direct_children"]] = list(go_id)
        } else
        {
          go[[parent]][["direct_children"]] = c(go[[parent]][["direct_children"]] , go_id)
        }
        parents = c(parents, parent)
      }

      go_def[["parents"]] = parents

    }

    relationship =  go_def[["relationship"]] # Mining if relationship has part of relationship
    relationship_parents = list()
    for (rel in relationship)
    {

        parent = get_GO_from_relationship(rel)
        if (is.null(parent))
        {
          next
        }
        if (is.null(go[[parent]][["direct_children"]]))
        {
          go[[parent]][["direct_children"]] = list(go_id)
        } else
        {

          go[[parent]][["direct_children"]] = c(go[[parent]][["direct_children"]] , go_id)
        }
        relationship_parents = c(relationship_parents, parent)


    }

    if (length(relationship_parents) > 0)
    {
      if (!is.null(go_def[["parents"]]))
      {
        go_def[["parents"]] = c(go_def[["parents"]], relationship_parents)
      } else
      {
        go_def[["parents"]] = relationship_parents
      }


    }
  }
  return(go)
}



get_GO_from_relationship = function(rel = "part_of GO:0002397 ! MHC class I protein complex assembly")
{
  if (startsWith(rel, "part_of") | startsWith(rel, "regulate") |startsWith(rel, "negatively_regulate") | startsWith(rel, "positively_regulate"))
  {
    rel_parsed = strsplit(rel, "!")[[1]][[1]]
    GO = substr(rel_parsed, regexec("GO", rel_parsed), nchar(rel_parsed) - 1)
    return(GO)
  }
}



get_all_descendants = function(go_with_children)
{
  descendants = new.env() # a dictionary  where key is go_id, values is a list of all descendants.

  get_descendants = function(go_id)
  {
    if (!is.null(descendants[[go_id]]))
    {
      return(descendants[[go_id]]) # descendants already exists
    }
    go_def = go_with_children[[go_id]]
    direct_children = go_def[["direct_children"]]
    if (is.null(direct_children))
    {
      descendants[[go_id]] <<- NULL
      return(NULL)
    }
    this_go_descendants = c()
    for (child in direct_children)
    {
      this_go_descendants = c(this_go_descendants, child)
      this_go_descendants = c(this_go_descendants, get_descendants(child)) # recursive call
      this_go_descendants = unique(this_go_descendants)
    }
    #this_go_descendants = unique(this_go_descendants)
    # add to dictionary
    descendants[[go_id]] <<-
      this_go_descendants # not sure if it can update the outside environment
    return(this_go_descendants)
  }

  for (def in names(go_with_children))
  {
    this_go_descendants = get_descendants(def)
    go_with_children[[def]][["descendants"]] <- this_go_descendants
  }

  return(go_with_children)

}


print_descendant = function(go_id = "GO:0019882")
{
  descendants = go_def_dict[[go_id]][["descendants"]]
  for (kid in descendants)
  {
    print(paste(kid, go_def_dict[[kid]][["name"]][[1]]))
  }
  return(descendants)
}

get_descendants = function(go_id)
{
  descendants = go_def_dict[[go_id]][["descendants"]]
  descendants = unlist(descendants)
  return(descendants)
}


get_def = function(go_id)
{
  def = as.list(go_def_dict[[go_id]])
  class(def) = "gene_ontology_def"
  return(def)
}


