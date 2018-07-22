# installing epubr
# devtools::install_github("ropensci/epubr")


library(stringr)
library(dplyr)



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

chapter_header <- unlist(split_header_from_text[1])
chapter_text <- unlist(split_header_from_text[2])
#chapter_number <- c("Prologue", 1:36, "Interlude", 36:55, "Epilogue")
chapter_number2 <- c(NA, 1:36, NA, 36:55, NA)

chapter_pov <- str_extract(chapter_header, "[[:alpha:]]+$")
chapter_pov <- na_if(chapter_pov, "STATION")


#cleaning chapter text




#back to dataframe
expanse1 <- tibble(chapter = chapter_number2,
                   pov = chapter_pov,
                   text = chapter_text)



expanse1$text