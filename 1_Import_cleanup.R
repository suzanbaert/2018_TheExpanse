# installing epubr
# devtools::install_github("ropensci/epubr")


library(stringr)
library(dplyr)
library(tidytext)



#list all files inside epub folder
all_epubs <- list.files(path = "epub_expanse/")
all_epubs <- paste0("epub_expanse/", all_epubs)


#importing data just 1
expanse1_epub <- epubr::epub(file = "epub_expanse/James SA Corey - The Expanse 01 - Leviathan Wakes.epub") 



#importing all 
expanse_series_epub <- epubr::epub(all_epubs, fields = c("creator", "title", "date", "data"))




# ---------
# EXPANSE 1
# ---------


#expanse1
expanse1_text <- expanse1_epub$data[[1]]

#cleanup: drop opening pages until prologue, and drop pages after epilogue
expanse1_text <- expanse1_text[4:61, ]



#string split to get the chapter headers split from the actual chapter text, then transpose to get the right lists.
split_header_from_text <- str_split(expanse1_text$text, "\n", n = 2)
split_header_from_text <- purrr::transpose(split_header_from_text)

chapter_text <- unlist(split_header_from_text[2])
chapter_header <- unlist(split_header_from_text[1])

#extracting point of view character from header
chapter_pov <- str_extract(chapter_header, "[[:alpha:]]+$")
chapter_pov <- na_if(chapter_pov, "STATION")

#extracting chapter number
chapter <- str_remove(chapter_header, "Chapter ")
chapter <- str_remove(chapter, ":.*")
chapter_number <- c(NA, 1:35, NA, 36:55, NA)


#fixing encoding issues
this <- c("didn’t", "he’d", "don’t")
chapter_text <- iconv(chapter_text, from="windows-1252", to="UTF-8")
chapter_text <- str_replace(chapter_text, "â€™", "'")


#back to dataframe
expanse1 <- tibble(chapter_no = chapter_number,
                   chapter = chapter,
                   pov = chapter_pov,
                   text = chapter_text)


#unnest_tokens
expanse1_tokens <- expanse1 %>% 
  unnest_tokens(word, text) %>% 
  add_count(chapter)






#word count
expanse1_tokens %>%
  anti_join(stop_words, by = "word") %>% 
  count(word, sort = TRUE) 





