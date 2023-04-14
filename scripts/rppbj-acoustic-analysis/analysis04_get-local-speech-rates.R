# setwd("/Users/kasia/Documents/Research/nu/rppbj-automatic-acoustic-analysis/scripts")

# Read in raw phrases and get rid of extra white space
phrases <- read.csv("../pbj-speech-measures/phrases-raw.csv")
phrases$seg_type <- trimws(phrases$seg_type)

# Define a new data frame to include compressed info
merged_phrases <- data.frame(file=rep("", nrow(phrases)), 
                 phrase_num=rep(NA, nrow(phrases)), 
                 words=rep(NA,nrow(phrases)),
                 phrase_start=rep(NA,nrow(phrases)),
                 phrase_end=rep(NA,nrow(phrases)),
                 phrase_dur=rep(NA,nrow(phrases)),
                 nsylls=rep(NA,nrow(phrases)),
                 nwords_in_paragraph=rep(NA,nrow(phrases)),
                 local_speech_rate=rep(NA,nrow(phrases)),
                 stringsAsFactors=FALSE)

curr <- 1 # which row of merged_phrases we should add to
files <- unique(phrases$file)
for (i in 1:length(files)) {
  tmp <- subset(phrases, file == files[i])
  
  # Get rid of the first "XXXXX"
  if (tmp[1,"seg_type"] != "XXXXX") {
    print("This file does not start with XXXXX")
  }
  nwords <- max(tmp$word_num)
  
  starting_idx <- 2
  phrasenumber <- 1
  for (j in 2:nrow(tmp)) {
    if (tmp[j,'seg_type'] == "XXXXX" & tmp[j,'seg_duration'] > 0.15) {
      words <- paste(tmp$seg_type[(starting_idx):(j-1)], collapse = ';')
      nsylls <- sum(tmp$nsylls[starting_idx:(j-1)])
      start <- tmp[starting_idx,"seg_start"]
      end <- tmp[j-1,"seg_end"]
      duration <- end - start
      lsr <- nsylls/duration
      merged_phrases[curr,] <- c(files[i], phrasenumber, words, start, end, duration, nsylls, nwords, lsr)
      starting_idx <- j+1
      phrasenumber <- phrasenumber + 1
      curr <- curr + 1
    }
  }
}

merged_phrases <- subset(merged_phrases, file != '')
write.csv(merged_phrases, "../pbj-speech-measures/phrase-speech-rates.csv", row.names = FALSE, quote = FALSE)
  
