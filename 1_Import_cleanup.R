# installing epubr
# devtools::install_github("ropensci/epubr")


library(stringr)
library(dplyr)
library(tidyr)



#list all files inside epub folder
all_epubs <- list.files(path = "epub_expanse/")
all_epubs <- paste0("epub_expanse/", all_epubs)



#importing all
expanse_series_epub <- epubr::epub(all_epubs, fields = c("creator", "title", "date", "data"))





# ---------------------
# Cleaning expanse text
# ---------------------

#adding book numbers, correcting titles, abbreviating year
expanse_epub_2 <- expanse_series_epub %>% 
  mutate(book = 1:7,
         launch_year = str_extract(date, "[0-9]{4}"),
         title = str_remove(title, ":.*"),
         title = str_remove(title, "Expanse 03 - "),
         title = forcats::fct_reorder(title, book)) %>% 
  select(book, title, launch_year, data)



#keep only the secions that start with Prologue, Chapter, Epilogue, Interlude and THOTH station
expanse_epub_unnested <- expanse_epub_2 %>% 
  unnest() %>% 
  
  #fix chapter that got accidentally split
  mutate(text = str_replace(text, "^THOTH", "Chapter Thirty-Five: Holden \n THOTH")) %>% 
  
  #extract first word and get rid of any section that is not amongst these. rest are intro or extra pages that don't belong to the story
  mutate(firstword = str_extract(text, "[[:alpha:]]*")) %>% 
  filter(firstword %in% c("Prologue", "Chapter", "Epilogue", "Interlude"))


#split chapter header off
chapter_split <- str_split(expanse_epub_unnested$text, ":", n = 2)
chapter_split_tr <- purrr::transpose(chapter_split)

#extract header
chapter_firstpart <- unlist(chapter_split_tr[1])
chapter_number <- str_remove(chapter_firstpart, "[[:alpha:]]+") %>% str_trim()

#extract text 
chapter_secondpart <- unlist(chapter_split_tr[2])
chapter_pov <- str_extract(chapter_secondpart, "[[:alpha:]]+")
chapter_text <- str_remove(chapter_secondpart, "[[:alpha:]]+") %>% str_trim()




#back to one dataframe
expanse <- expanse_epub_unnested %>% 
  select(book, launch_year, title, chapter_type = firstword) %>% 
  mutate(chapter_number = chapter_number,
         chapter_pov = chapter_pov,
         chapter_text = chapter_text,
         section = 1:nrow(.))



saveRDS(expanse, "expanse_series.RDS")
