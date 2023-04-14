# setwd("/Users/kasia/Documents/Research/nu/rppbj-automatic-acoustic-analysis/scripts")

# Note the figures always save in ..figures/. I've just been manually moving them
# to the rainbow passage + procedural folders afterwards

# Read in raw phrases and get rid of extra white space
# RAINBOW PASSAGE
# lsr <- read.csv("../rp-speech-measures/phrase-speech-rates.csv")
# vowels <- read.csv("../rp-speech-measures/vowels-raw.csv")
# vots <- read.csv("../rp-speech-measures/vots-raw.csv")
# formants <- read.csv("../rp-speech-measures/fasttrack_raw.csv")

### NOTE YOU NEED TO RESET THIS BELOW AS WELL

# PROCEDURAL PBJ
lsr <- read.csv("../pbj-speech-measures/phrase-speech-rates.csv")
vowels <- read.csv("../pbj-speech-measures/vowels-raw.csv")
vots <- read.csv("../pbj-speech-measures/vots-raw.csv")
formants <- read.csv("../pbj-speech-measures/fasttrack_raw.csv")

# TODO: what's in formants, but not vowels?
vowels <- merge(vowels, formants, by.x = c('file', 'seg_start'), by.y = c('inputfile', 'start'), all.x = TRUE)
vowels$outputfile = vowels$vowel = vowels$duration = vowels$end <- NULL 
vowels$seg_type <- trimws(vowels$seg_type)
vowels$word <- trimws(vowels$word)
vots$seg_type <- trimws(vots$seg_type)
vots$word <- trimws(vots$word)

# Implement exclusions - this doesn't need to be done for vowels, since
# vowels and phrases both come from MFA
nrow(vots) # 6141 for rp; 5012 for pbj
vots <- subset(vots, seg_duration >= 0.005 & seg_duration < 0.120) # 5234; 4459 for pbj
vots$exclude <- (vots$seg_start > vots$word_end) | (vots$seg_end < vots$word_start)
vots <- subset(vots, !exclude) # 5103; 4245 for pbj
vots$exclude <- (vots$seg_start + 0.5*vots$seg_duration < vots$word_start)
vots <- subset(vots, !exclude) # 4201 for pbj
vots$exclude <- NULL

# Get local speech rate information
for (i in 1:nrow(vots)) {
  midsound <- (vots$seg_end[i]+vots$seg_start[i])/2
  relevant_phrase <- subset(lsr, file == vots$file[i] & phrase_start <= midsound & phrase_end >= midsound)
  vots[i,'phrase_num'] <- relevant_phrase$phrase_num
  vots[i,'local_speech_rate'] <- relevant_phrase$local_speech_rate
}

for (i in 1:nrow(vowels)) {
  relevant_phrase <- subset(lsr, file == vowels$file[i] & phrase_start <= vowels$seg_start[i] & phrase_end >= vowels$seg_end[i])
  vowels[i,'phrase_num'] <- relevant_phrase$phrase_num
  vowels[i,'local_speech_rate'] <- relevant_phrase$local_speech_rate
}

### NOTE YOU NEED TO RESET THIS TOO!
write.csv(vots, "../pbj-speech-measures/final-vots.csv", row.names = FALSE, quote = FALSE)
write.csv(vowels, "../pbj-speech-measures/final-vowels.csv", row.names = FALSE, quote = FALSE)