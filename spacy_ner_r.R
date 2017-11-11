###############################################################################
### Extracts Named Entities via Spacy from text in dataframe ##################
### allows for counts of total named entities and unique occurrences ##########
###############################################################################

require(spacyr)

get_entity_count = function(df_identifier, df_textcol, unique_extr = F, entity_type){

  sapply(seq(df_identifier), function(i){
    parsedtxt = spacy_parse(as.character(df_textcol[i]), dependency = FALSE, lemma = FALSE, pos = FALSE)
    entities = entity_extract(parsedtxt, type = "all")
    entities_unique = entities[!(duplicated((entities$entity))),]
    entity_type_mod = toupper(entity_type)

    print(df_identifier[i])
    if(unique_extr == T){
      if(entity_type_mod == 'ALL'){
        extracted_count = length(unique(entities$entity))
      } else {
        extracted_count = sum(entities_unique$entity_type == entity_type_mod)
      }
    } else if(unique_extr == F){
      if(entity_type_mod == 'ALL'){
        extracted_count = length(entities$entity)
      } else {
        extracted_count = sum(entities$entity_type == entity_type_mod)
      }
    }
    return(extracted_count)
  })

}

#usage example
# spacy_initialize(python_executable = '/Library/Frameworks/Python.framework/Versions/3.5/bin/python3')
# get_entity_count(test_data$unid, test_data$statement1_content, F, 'date')
# for unique occurrence of NEs set 'unique_extr = T'
# 'entity_type' argument must be any of the spacy named entity types, to be found here https://spacy.io/usage/linguistic-features#entity-types (lower/upper-case possible)
# spacy_finalize()

#load as:
# source('./get_entity_count.R')