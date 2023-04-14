# setwd("/Users/kasia/Documents/Research/nu/ddk-automatic-acoustic-analysis/scripts")

df <- read.csv("../ddk-speech-measures/ddktor_raw.csv")
label <- unique(df$seg_type)
vowels_to_extract <- data.frame(label)
vowels_to_extract <- subset(vowels_to_extract, grepl('Vowel', label, fixed = TRUE))
label <- gsub(' ', '', vowels_to_extract$label)
group <- 1:length(label)
vowels_to_extract <- data.frame(group, label)
vowels_to_extract$color <- 'Red'
write.csv(vowels_to_extract, '../FastTrack/Fast Track/dat/vowelstoextract_including-vowel-short.csv', row.names = FALSE, quote = FALSE)