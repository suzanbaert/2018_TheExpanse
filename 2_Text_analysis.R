library(stringr)
library(dplyr)
library(tidyr)
library(tidytext)
library(ggplot2)


#import
expanse <- readRDS("expanse_series.RDS")


#unnest_tokens
expanse_tokens <- expanse %>% 
  unnest_tokens(word, chapter_text)


expanse_tokens %>% 
  add_count(section) %>% rename("nwords_chapter" = "n") %>% 
  add_count(book) %>% rename("nwords_book" = "n")





# who talks the most
# ------------------

top10_speakers <- expanse_tokens %>% 
  count(chapter_pov, sort = TRUE) %>% 
  top_n(10) %>% 
  mutate(chapter_pov = reorder(chapter_pov, n))


ggplot(top10_speakers) +
  geom_col(aes(x = chapter_pov, y = n )) +
  coord_flip()



#i want to colour this by book
expanse_tokens %>% 
  count(book, title, chapter_pov, sort = TRUE) %>% 
  filter(chapter_pov %in% top10_speakers$chapter_pov) %>% 
  mutate(chapter_pov = ordered(chapter_pov, levels = levels(top10_speakers$chapter_pov))) %>% 
  ggplot() +
  geom_col(aes(x = chapter_pov, y = n, fill = title)) +
  coord_flip() + 
  
  labs(x = "Point of View character", "", 
       title = "Who talks the most?",
       subtitle = "Number of words per Point of View Character")





# WORD OCCURENCE
# ---------------





#words


windows_stop_words <- data.frame(word = c("didn’t", "he’d", "i’m", "it’s", "don’t", "wasn’t"))
people <- data.frame(word = c("holden", "amos", "naomi", "alex", "miller", "bobbie"))


#word count
expanse_tokens %>%
  anti_join(stop_words, by = "word") %>% 
  anti_join(windows_stop_words, by = "word") %>% 
  count(word, sort = TRUE)  


