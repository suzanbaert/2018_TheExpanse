# installing epubr
# devtools::install_github("ropensci/epubr")


library(epubr)

#list all files inside epub folder
all_epubs <- list.files(path = "epub_expanse/")
all_epubs <- paste0("epub_expanse/", all_epubs)


#importing data just 1
expanse1_epub <- epub(file = "epub_expanse/James SA Corey - The Expanse 01 - Leviathan Wakes.epub") 


#importing all 
expanse_series_epub <- epub(all_epubs, fields = c("creator", "title", "date", "data"))




# ---------
# EXPANSE 1
# ---------


#expanse1
expanse1_text <- expanse1_epub$data[[1]]

#cleanup: drop opening pages until prologue, and drop pages after epilogue
expanse1_text <- expanse1_text[4:61, ]

