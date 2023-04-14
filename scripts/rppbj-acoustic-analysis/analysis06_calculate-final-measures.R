# setwd("/Users/kasia/Documents/Research/nu/rppbj-automatic-acoustic-analysis/scripts")

# Rainbow Passage
lsr <- read.csv("../rp-speech-measures/phrase-speech-rates.csv")
vowels <- read.csv("../rp-speech-measures/final-vowels.csv")
vots <- read.csv("../rp-speech-measures/final-vots.csv")

# Procedural PBJ
# lsr <- read.csv("../pbj-speech-measures/phrase-speech-rates.csv")
# vowels <- read.csv("../pbj-speech-measures/final-vowels.csv")
# vots <- read.csv("../pbj-speech-measures/final-vots.csv")

file <- unique(lsr$file)
data_summary <- data.frame(file)

# Calculate segment measures
for (i in 1:nrow(data_summary)) {
  # VOT
  part_subset_vots <- subset(vots, file == data_summary[i,'file'])
  voiceless_vots <- subset(part_subset_vots, seg_type %in% c('P', 'T', 'K'))
  voiced_vots <- subset(part_subset_vots, seg_type %in% c('B', 'D', 'G'))
  data_summary[i, 'avg_vot_voiceless_duration'] <- mean(voiceless_vots$seg_duration)
  data_summary[i, 'var_vot_voiceless_duration'] <- var(voiceless_vots$seg_duration)
  data_summary[i, 'coeffvar_vot_voiceless_duration'] <- sd(voiceless_vots$seg_duration) / data_summary[i,'avg_vot_voiceless_duration']
  data_summary[i, 'avg_vot_voiced_duration'] <- mean(voiced_vots$seg_duration)
  data_summary[i, 'var_vot_voiced_duration'] <- var(voiced_vots$seg_duration)
  data_summary[i, 'coeffvar_vot_voiced_duration'] <- sd(voiced_vots$seg_duration) / data_summary[i,'avg_vot_voiced_duration']
  data_summary[i, 'log_avg_vot_voiceless_duration'] <- log(mean(voiceless_vots$seg_duration))
  data_summary[i, 'log_var_vot_voiceless_duration'] <- log(var(voiceless_vots$seg_duration))
  data_summary[i, 'log_coeffvar_vot_voiceless_duration'] <- log(sd(voiceless_vots$seg_duration) / data_summary[i,'avg_vot_voiceless_duration'])
  data_summary[i, 'log_avg_vot_voiced_duration'] <- log(mean(voiced_vots$seg_duration))
  data_summary[i, 'log_var_vot_voiced_duration'] <- log(var(voiced_vots$seg_duration))
  data_summary[i, 'log_coeffvar_vot_voiced_duration'] <- log(sd(voiced_vots$seg_duration) / data_summary[i,'avg_vot_voiced_duration'])
  
   
  # Vowel duration
  part_subset_vowels <- subset(vowels, file == data_summary[i,'file'])
  data_summary[i, 'avg_vowel_duration'] <- mean(part_subset_vowels$seg_duration)
  data_summary[i, 'var_vowel_duration'] <- var(part_subset_vowels$seg_duration)
  data_summary[i, 'coeffvar_vowel_duration'] <- sd(part_subset_vowels$seg_duration) / data_summary[i, 'avg_vowel_duration']
  data_summary[i, 'log_avg_vowel_duration'] <- log(mean(part_subset_vowels$seg_duration))
  data_summary[i, 'log_var_vowel_duration'] <- log(var(part_subset_vowels$seg_duration))
  data_summary[i, 'log_coeffvar_vowel_duration'] <- log(sd(part_subset_vowels$seg_duration) / data_summary[i, 'avg_vowel_duration'])
  
   
  # Local speech rate
  part_subset_lsrs <- subset(lsr, file == data_summary[i, 'file'])
  data_summary[i,'avg_local_speech_rate'] <- mean(part_subset_lsrs$local_speech_rate)
  data_summary[i,'var_local_speech_rate'] <- var(part_subset_lsrs$local_speech_rate)
  data_summary[i,'coeffvar_local_speech_rate'] <- sd(part_subset_lsrs$local_speech_rate) / data_summary[i,'avg_local_speech_rate']
  data_summary[i,'log_avg_local_speech_rate'] <- log(mean(part_subset_lsrs$local_speech_rate))
  data_summary[i,'log_var_local_speech_rate'] <- log(var(part_subset_lsrs$local_speech_rate))
  data_summary[i,'log_coeffvar_local_speech_rate'] <- log(sd(part_subset_lsrs$local_speech_rate) / data_summary[i,'avg_local_speech_rate'])
  
    
  # Pausing
  if (max(part_subset_lsrs$phrase_num) != nrow(part_subset_lsrs)) {
    print("Problem: mismatch in number of phrases!")
  }
  data_summary[i,'n_pauses'] <- max(part_subset_lsrs$phrase_num)-1
  data_summary[i,'n_pauses_per_word'] <- (max(part_subset_lsrs$phrase_num)-1)/part_subset_lsrs[1,'nwords_in_paragraph']
  data_summary[i,'log_n_pauses'] <- log(max(part_subset_lsrs$phrase_num)-1)
  data_summary[i,'log_n_pauses_per_word'] <- log((max(part_subset_lsrs$phrase_num)-1)/part_subset_lsrs[1,'nwords_in_paragraph'])
}

# Calculate formant measures
# https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8048105/pdf/nihms-1689837.pdf (and citations within)
# https://journals.sagepub.com/doi/pdf/10.1177/0023830914559234?casa_token=wpCkwcNGaugAAAAA:Sz8o7WphCBBljAYQ9lgJCWv4QA4prFfnlo_6z43s7uPQX8ZszUEvJch8lLoONmDPXz8s4vQYXlSc
for (i in 1:nrow(data_summary)) {
  part_subset_vowels <- subset(vowels, file == data_summary[i,'file'])
  part_subset_vowels <- subset(part_subset_vowels, !is.na(f1.50) & !is.na(f2.50))
  sum_inverse_distance <- 0
  counter <- 0
  if (nrow(part_subset_vowels) > 1) {
    for (j in 1:(nrow(part_subset_vowels)-1)) {
      for (k in (j+1):(nrow(part_subset_vowels))) {
        if (part_subset_vowels[j,'seg_type'] != part_subset_vowels[k,'seg_type']) {
          this_distance <- (part_subset_vowels[j,'f2.50'] - part_subset_vowels[k,'f2.50'])**2 + (part_subset_vowels[j,'f1.50'] - part_subset_vowels[k,'f1.50'])**2
          sum_inverse_distance <- sum_inverse_distance + (1.0/(this_distance+0.000001))
          counter <- counter + 1
        }
      }
    }
    data_summary[i,'formant_phonetic_competition'] <- sum_inverse_distance/counter
    data_summary[i,'log_formant_phonetic_competition'] <- log(sum_inverse_distance/counter)
  }
  else {
    data_summary[i,'formant_phonetic_competition'] <- NA
    data_summary[i,'log_formant_phonetic_competition'] <- NA
  }
}

# Calculate formant dispersion methods (and change)
for (i in 1:nrow(data_summary)) {
  sub <- subset(vowels, file == data_summary[i, 'file'])
  sub <- subset(sub, !is.na(f1.50) & !is.na(f2.50))
  data_summary[i, 'median.f1.20'] <- median(sub$f1.20, na.rm = TRUE)
  data_summary[i, 'median.f2.20'] <- median(sub$f2.20, na.rm = TRUE)
  data_summary[i, 'median.f1.50'] <- median(sub$f1.50, na.rm = TRUE)
  data_summary[i, 'median.f2.50'] <- median(sub$f2.50, na.rm = TRUE)
  
  sub$f1.20distsq <- (sub$f1.20 - data_summary[i,'median.f1.20'])**2
  sub$f2.20distsq <- (sub$f2.20 - data_summary[i,'median.f2.20'])**2
  sub$f1.50distsq <- (sub$f1.50 - data_summary[i,'median.f1.50'])**2
  sub$f2.50distsq <- (sub$f2.50 - data_summary[i,'median.f2.50'])**2
  
  data_summary[i,'formant_dispersion.50'] <- mean(sqrt(sub$f1.50distsq + sub$f2.50distsq), na.rm = TRUE)
  data_summary[i,'formant_dispersion.20'] <- mean(sqrt(sub$f1.20distsq + sub$f2.20distsq), na.rm = TRUE)
  data_summary[i,'formant_delta_var'] <- data_summary[i,'formant_dispersion.20'] - data_summary[i,'formant_dispersion.50']
  
}

data_summary[sapply(data_summary, is.nan)] <- NA

write.csv(data_summary, '../rp-speech-measures/final-rp-speech-measures.csv', row.names = FALSE, quote = FALSE)
  