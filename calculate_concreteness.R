#####################################################################
### PREPROCESS CONCRETENESS SCORES IN LANGUAGE
### - CALCULATES CONCRETENESS SCORE PER TEXT-CASE
### - RETURNS WEIGHTED TDM, DTM, TFIDFs
### FOR CONCRETENESS RATINGS SEE: Brysbaert, Warriner, Kuperman (2014) BRM
####################################################################

#needs wd with helper functions
#easiest is to use the repo on: https://github.com/ben-aaron188/r_helper_functions

#deps
source('./txt_df_from_dir.R')
source('./toNumeric.R')
require(data.table)
#read concreteness data Brysbaert
#DO NOT RUN
# files = list.files(pattern = '*.txt')
# concr = fread(files[1]
#               , header=T)
# concr = as.data.frame(concr)
# names(concr) = tolower(names(concr))
# concr_corpus_file = Corpus(VectorSource(concr$word))
# concr_stemmed = tm_map(concr_corpus_file, stemDocument, language = 'en')
# concr_stemmed_df = as.data.frame(as.matrix(concr_stemmed$content))
# names(concr_stemmed_df) = 'word'
# concr = cbind(concr, concr_stemmed_df$word)
# names(concr)[10] = 'word_stemmed'
#
#
# save(concr
#      , file = 'brysbaert_concr.RData')
#END DO NOT RUN

load('./concreteness/brysbaert_concr.RData')

get_concreteness = function(input_txt_col, stemming_global, type){

  t1 = Sys.time()
  print(paste('--- STARTING CONCRETENESS CALC. at: ', t1))
  print("-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-")

  f1 = sapply(input_txt_col, function(x){

    word_vec_for_df = unlist(tokenize_words(x))
    word_vec_for_df_length = length(word_vec_for_df)
    df = data.frame('id' = 1:word_vec_for_df_length
                    , 'word' = word_vec_for_df)
    if(stemming_global == T){
      concr_df = merge(df, concr
                       , by='word')
    } else if(stemming_global == F){
      concr_df = merge(df, concr
                       , by.x='word'
                       , by.y='word_stemmed')
    }
    concr_sum = sum(concr_df$conc.m)
    concr_avg = mean(concr_df$conc.m)
    if(type == 'sum'){
      return(concr_sum)
    } else if(type == 'mean'){
      return(concr_avg)
    }
  })


  t2 = Sys.time()
  elapsed = t2-t1
  print(paste('--- FINISHED ---'))
  print(t2-t1)

  return(f1)
}

#usage example:
# ngram_plus_1 = get_term_doc_matrix_plus(input_txt_col = data$text
#                                         , tdm_type = 'tfidf'
#                                         , sparsity = .95
#                                         , tfidf_stemming = F
#                                         , add_weights = T)
#
# data_merged = merge(data, ngram_plus_1, by='id')
# data$conc = get_concreteness(data$text[1:20], F, 'mean')

